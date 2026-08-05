//+------------------------------------------------------------------+
//|                  AI XAU M1 Scalper EA                            |
//|                  Shedrigar AI Labs                               |
//|                  Version 1.00                                    |
//+------------------------------------------------------------------+
#property strict
#property version "1.00"

#include <Trade/Trade.mqh>

#include "Include/Helpers.mqh"
#include "Include/Indicators.mqh"
#include "Include/SMC.mqh"
#include "Include/Confidence.mqh"
#include "Include/RiskManager.mqh"
#include "Include/TradeManager.mqh"
#include "Include/Statistics.mqh"


//====================================================
// GLOBAL OBJECTS
//====================================================

CTrade trade;

CIndicators Indicators;
CSMC        SMC;
CConfidence Confidence;
CRiskManager Risk;
CTradeManager TradeManager;
CStatistics Statistics;


//====================================================
// INPUT SETTINGS
//====================================================

// Trading
input ulong MagicNumber = 777777;

input bool AllowBuy  = true;
input bool AllowSell = true;


// Confidence
input double MinimumConfidence = 75.0;


// Lot sizing
input double Lot70 = 0.01;
input double Lot80 = 0.02;
input double Lot90 = 0.05;
input double Lot95 = 0.10;


// Trade management

input double BreakEvenTrigger = 2.0;

input double BreakEvenOffset = 0.20;

input int MaximumTradeMinutes = 5;


// Risk

input bool UseAdaptiveLots = true;


// Debug

input bool EnableLogs = true;


//====================================================
// GLOBAL VARIABLES
//====================================================

datetime LastBar=0;

int CandlesWithoutTrade=0;


//====================================================
// INITIALIZATION
//====================================================

int OnInit()
{

   trade.SetExpertMagicNumber(MagicNumber);


   if(!Indicators.Initialize())
   {
      Print("Indicator initialization failed");
      return INIT_FAILED;
   }


   if(!Statistics.Initialize())
   {
      Print("Statistics module failed");
      return INIT_FAILED;
   }


   TradeManager.Initialize(
      BreakEvenTrigger,
      BreakEvenOffset,
      MaximumTradeMinutes
   );


   Print("AI XAU M1 Scalper Started");


   return INIT_SUCCEEDED;
}



//====================================================
// DEINITIALIZATION
//====================================================

void OnDeinit(const int reason)
{

   Indicators.Release();

   Print("EA stopped");

}



//====================================================
// MAIN ENGINE
//====================================================

void OnTick()
{


   // Manage existing positions first

   if(PositionSelect(_Symbol))
   {
      TradeManager.Manage();

      return;
   }



   // Only evaluate once per candle

   datetime current=iTime(
      _Symbol,
      PERIOD_M1,
      0
   );


   if(current==LastBar)
      return;


   LastBar=current;



   CandlesWithoutTrade++;



   //------------------------------------------
   // Market analysis
   //------------------------------------------

   Indicators.Update();


   SMC.Analyze();


   Confidence.Calculate(
      Indicators,
      SMC
   );



   double score=
   Confidence.GetScore();



   if(EnableLogs)
   {
      Print(
      "Confidence Score: ",
      score
      );
   }



   //------------------------------------------
   // Entry decision
   //------------------------------------------


   if(score < MinimumConfidence)
      return;



   ENUM_SIGNAL signal=
   Confidence.GetSignal();



   if(signal==SIGNAL_NONE)
      return;



   double lot=
   Risk.CalculateLot(
      score,
      Lot70,
      Lot80,
      Lot90,
      Lot95
   );



   TradeManager.Open(
      signal,
      lot
   );



   CandlesWithoutTrade=0;


}



//+------------------------------------------------------------------+
