//+------------------------------------------------------------------+
//|                    TradeManager.mqh                              |
//|                    AI XAU M1 Scalper                              |
//|              Execution & Position Management                     |
//+------------------------------------------------------------------+

#ifndef TRADEMANAGER_MQH
#define TRADEMANAGER_MQH
extern CTrade trade;

class CTradeManager
{

private:

   double BETrigger;

   double BEOffset;

   int MaxMinutes;



//====================================================
// GET ATR STOP DISTANCE
//====================================================

double GetATRStop()
{

   int handle =
   iATR(
      _Symbol,
      PERIOD_M1,
      14
   );


   double buffer[];


   ArraySetAsSeries(
      buffer,
      true
   );


   CopyBuffer(
      handle,
      0,
      0,
      3,
      buffer
   );


   IndicatorRelease(handle);



   return buffer[1];

}



//====================================================
// BUY SL/TP
//====================================================

void CalculateBuyLevels(
   double &sl,
   double &tp
)
{

   double price =
   SymbolInfoDouble(
      _Symbol,
      SYMBOL_ASK
   );


   double atr =
   GetATRStop();



   sl =
   price -
   (atr*1.5);



   tp =
   price +
   (atr*1.0);



}



//====================================================
// SELL SL/TP
//====================================================

void CalculateSellLevels(
   double &sl,
   double &tp
)
{

   double price =
   SymbolInfoDouble(
      _Symbol,
      SYMBOL_BID
   );


   double atr =
   GetATRStop();



   sl =
   price +
   (atr*1.5);



   tp =
   price -
   (atr*1.0);



}



//====================================================
// INITIALIZE
//====================================================

public:

void Initialize(
   double trigger,
   double offset,
   int minutes
)
{

   BETrigger =
   trigger;


   BEOffset =
   offset;


   MaxMinutes =
   minutes;

}



//====================================================
// OPEN TRADE
//====================================================

bool Open(
   ENUM_SIGNAL signal,
   double lot
)
{

   if(lot<=0)
      return false;



   double sl,tp;



   if(signal==SIGNAL_BUY)
   {

      CalculateBuyLevels(
         sl,
         tp
      );


      return
      trade.Buy(
         lot,
         _Symbol,
         0,
         sl,
         tp,
         "AI BUY"
      );

   }



   if(signal==SIGNAL_SELL)
   {

      CalculateSellLevels(
         sl,
         tp
      );


      return
      trade.Sell(
         lot,
         _Symbol,
         0,
         sl,
         tp,
         "AI SELL"
      );

   }



   return false;

}



//====================================================
// BREAK EVEN MANAGEMENT
//====================================================

void BreakEven()
{


   if(!PositionSelect(_Symbol))
      return;



   double open =
   PositionGetDouble(
      POSITION_PRICE_OPEN
   );


   double profit =
   PositionGetDouble(
      POSITION_PROFIT
   );


   ulong ticket =
   PositionGetInteger(
      POSITION_TICKET
   );



   if(
      profit >= BETrigger
   )
   {


      ENUM_POSITION_TYPE type =
      (ENUM_POSITION_TYPE)
      PositionGetInteger(
         POSITION_TYPE
      );



      double newSL;



      if(type==POSITION_TYPE_BUY)
      {

         newSL =
         open +
         BEOffset;

      }


      else
      {

         newSL =
         open -
         BEOffset;

      }



      trade.PositionModify(
         ticket,
         newSL,
         PositionGetDouble(
            POSITION_TP
         )
      );


   }



}



//====================================================
// TRAILING STOP
//====================================================

void Trail()
{


   if(!PositionSelect(_Symbol))
      return;



   double atr =
   GetATRStop();



   ulong ticket =
   PositionGetInteger(
      POSITION_TICKET
   );


   ENUM_POSITION_TYPE type =
   (ENUM_POSITION_TYPE)
   PositionGetInteger(
      POSITION_TYPE
   );



   double tp =
   PositionGetDouble(
      POSITION_TP
   );



   double newSL;



   if(type==POSITION_TYPE_BUY)
   {

      newSL =
      SymbolInfoDouble(
         _Symbol,
         SYMBOL_BID
      )
      -
      atr;



      if(
         newSL >
         PositionGetDouble(
            POSITION_SL
         )
      )
      {

         trade.PositionModify(
            ticket,
            newSL,
            tp
         );

      }

   }




   if(type==POSITION_TYPE_SELL)
   {

      newSL =
      SymbolInfoDouble(
         _Symbol,
         SYMBOL_ASK
      )
      +
      atr;



      if(
         newSL <
         PositionGetDouble(
            POSITION_SL
         )
         ||
         PositionGetDouble(
            POSITION_SL
         )==0
      )
      {

         trade.PositionModify(
            ticket,
            newSL,
            tp
         );

      }

   }


}



//====================================================
// TIME EXIT
//====================================================

void TimeExit()
{

   if(!PositionSelect(_Symbol))
      return;



   datetime openTime =
   (datetime)
   PositionGetInteger(
      POSITION_TIME
   );



   int minutes =
   (int)
   (
   (TimeCurrent()-openTime)
   /60
   );



   if(
      minutes>=MaxMinutes
   )
   {

      trade.PositionClose(
         _Symbol
      );

   }


}



//====================================================
// MAIN MANAGEMENT
//====================================================

void Manage()
{

   BreakEven();

   Trail();

   TimeExit();

}


};


#endif
