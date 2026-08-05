//+------------------------------------------------------------------+
//|                       Indicators.mqh                              |
//|                    AI XAU M1 Scalper                              |
//|                 Technical Analysis Engine                         |
//+------------------------------------------------------------------+

#ifndef INDICATORS_MQH
#define INDICATORS_MQH


class CIndicators
{

private:

   int EMA20;
   int EMA50;
   int RSI;
   int ATR;
   int MACD;


   double ema20Buffer[];
   double ema50Buffer[];
   double rsiBuffer[];
   double atrBuffer[];
   double macdMain[];
   double macdSignal[];



public:


//====================================================
// INITIALIZE INDICATORS
//====================================================

bool Initialize()
{

   EMA20 =
   iMA(
      _Symbol,
      PERIOD_M1,
      20,
      0,
      MODE_EMA,
      PRICE_CLOSE
   );


   EMA50 =
   iMA(
      _Symbol,
      PERIOD_M1,
      50,
      0,
      MODE_EMA,
      PRICE_CLOSE
   );



   RSI =
   iRSI(
      _Symbol,
      PERIOD_M1,
      14,
      PRICE_CLOSE
   );



   ATR =
   iATR(
      _Symbol,
      PERIOD_M1,
      14
   );



   MACD =
   iMACD(
      _Symbol,
      PERIOD_M1,
      12,
      26,
      9,
      PRICE_CLOSE
   );



   if(
      EMA20==INVALID_HANDLE ||
      EMA50==INVALID_HANDLE ||
      RSI==INVALID_HANDLE ||
      ATR==INVALID_HANDLE ||
      MACD==INVALID_HANDLE
   )
   {
      return false;
   }



   ArraySetAsSeries(ema20Buffer,true);
   ArraySetAsSeries(ema50Buffer,true);
   ArraySetAsSeries(rsiBuffer,true);
   ArraySetAsSeries(atrBuffer,true);
   ArraySetAsSeries(macdMain,true);
   ArraySetAsSeries(macdSignal,true);


   return true;

}



//====================================================
// RELEASE INDICATORS
//====================================================

void Release()
{

   if(EMA20!=INVALID_HANDLE)
      IndicatorRelease(EMA20);


   if(EMA50!=INVALID_HANDLE)
      IndicatorRelease(EMA50);


   if(RSI!=INVALID_HANDLE)
      IndicatorRelease(RSI);


   if(ATR!=INVALID_HANDLE)
      IndicatorRelease(ATR);


   if(MACD!=INVALID_HANDLE)
      IndicatorRelease(MACD);

}



//====================================================
// UPDATE DATA
//====================================================

void Update()
{


   CopyBuffer(
      EMA20,
      0,
      0,
      5,
      ema20Buffer
   );


   CopyBuffer(
      EMA50,
      0,
      0,
      5,
      ema50Buffer
   );


   CopyBuffer(
      RSI,
      0,
      0,
      5,
      rsiBuffer
   );


   CopyBuffer(
      ATR,
      0,
      0,
      5,
      atrBuffer
   );


   CopyBuffer(
      MACD,
      0,
      0,
      5,
      macdMain
   );


   CopyBuffer(
      MACD,
      1,
      0,
      5,
      macdSignal
   );

}



//====================================================
// TREND DIRECTION
//====================================================

ENUM_DIRECTION Trend()
{

   if(
      ema20Buffer[1]
      >
      ema50Buffer[1]
   )
      return DIRECTION_BULLISH;



   if(
      ema20Buffer[1]
      <
      ema50Buffer[1]
   )
      return DIRECTION_BEARISH;



   return DIRECTION_NONE;

}



//====================================================
// EMA DISTANCE
//====================================================

double EMASeparation()
{

   return MathAbs(
      ema20Buffer[1]
      -
      ema50Buffer[1]
   );

}



//====================================================
// RSI VALUE
//====================================================

double RSIValue()
{

   return rsiBuffer[1];

}



//====================================================
// RSI BUY MOMENTUM
//====================================================

bool RSIBullish()
{

   return
   (
      rsiBuffer[1]>50 &&
      rsiBuffer[1]<75
   );

}



//====================================================
// RSI SELL MOMENTUM
//====================================================

bool RSIBearish()
{

   return
   (
      rsiBuffer[1]<50 &&
      rsiBuffer[1]>25
   );

}



//====================================================
// ATR VALUE
//====================================================

double ATRValue()
{

   return atrBuffer[1];

}



//====================================================
// VOLATILITY CHECK
//====================================================

bool HighVolatility()
{

   double atr=
   atrBuffer[1];


   if(
      atr >
      atrBuffer[3]
   )
      return true;



   return false;

}



//====================================================
// MACD CONFIRMATION
//====================================================

bool MACDBullish()
{

   return
   (
      macdMain[1]
      >
      macdSignal[1]
   );

}



bool MACDBearish()
{

   return
   (
      macdMain[1]
      <
      macdSignal[1]
   );

}



//====================================================
// TICK VOLUME ANALYSIS
//====================================================

bool VolumeIncrease()
{

   long current=
   iVolume(
      _Symbol,
      PERIOD_M1,
      1
   );


   long previous=
   iVolume(
      _Symbol,
      PERIOD_M1,
      2
   );


   if(current>previous)
      return true;


   return false;

}



//====================================================
// VWAP CALCULATION
//====================================================

double VWAP()
{

   double totalPriceVolume=0;

   double totalVolume=0;



   for(int i=1;i<=50;i++)
   {

      double high=
      iHigh(
         _Symbol,
         PERIOD_M1,
         i
      );


      double low=
      iLow(
         _Symbol,
         PERIOD_M1,
         i
      );


      double close=
      iClose(
         _Symbol,
         PERIOD_M1,
         i
      );


      long volume=
      iVolume(
         _Symbol,
         PERIOD_M1,
         i
      );



      double typical=
      (high+low+close)/3.0;



      totalPriceVolume +=
      typical*volume;


      totalVolume += volume;

   }



   if(totalVolume==0)
      return 0;



   return
   totalPriceVolume/
   totalVolume;

}



//====================================================
// PRICE ABOVE VWAP
//====================================================

bool AboveVWAP()
{

   return
   (
      iClose(
      _Symbol,
      PERIOD_M1,
      1
      )
      >
      VWAP()
   );

}



//====================================================
// PRICE BELOW VWAP
//====================================================

bool BelowVWAP()
{

   return
   (
      iClose(
      _Symbol,
      PERIOD_M1,
      1
      )
      <
      VWAP()
   );

}


};


#endif
