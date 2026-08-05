//+------------------------------------------------------------------+
//|                         Helpers.mqh                              |
//|                    AI XAU M1 Scalper                              |
//|                    Utility Functions                             |
//+------------------------------------------------------------------+

#ifndef HELPERS_MQH
#define HELPERS_MQH


//====================================================
// SIGNAL DEFINITIONS
//====================================================

enum ENUM_SIGNAL
{
   SIGNAL_NONE = 0,
   SIGNAL_BUY,
   SIGNAL_SELL
};


//====================================================
// MARKET DIRECTION
//====================================================

enum ENUM_DIRECTION
{
   DIRECTION_NONE = 0,
   DIRECTION_BULLISH,
   DIRECTION_BEARISH
};



//====================================================
// CANDLE INFORMATION STRUCTURE
//====================================================

struct CandleData
{

   double Open;

   double High;

   double Low;

   double Close;

   double Body;

   double UpperWick;

   double LowerWick;

   bool Bullish;

   bool Bearish;

};



//====================================================
// GET CANDLE DATA
//====================================================

CandleData GetCandle(
   int shift
)
{

   CandleData c;


   c.Open =
   iOpen(
      _Symbol,
      PERIOD_M1,
      shift
   );


   c.High =
   iHigh(
      _Symbol,
      PERIOD_M1,
      shift
   );


   c.Low =
   iLow(
      _Symbol,
      PERIOD_M1,
      shift
   );


   c.Close =
   iClose(
      _Symbol,
      PERIOD_M1,
      shift
   );



   c.Body=
   MathAbs(
      c.Close-c.Open
   );


   c.Bullish=
   c.Close>c.Open;


   c.Bearish=
   c.Close<c.Open;



   c.UpperWick=
   c.High-
   MathMax(
      c.Open,
      c.Close
   );


   c.LowerWick=
   MathMin(
      c.Open,
      c.Close
   )-
   c.Low;



   return c;

}



//====================================================
// NORMALIZE PRICE
//====================================================

double NormalizePrice(
   double price
)
{

   int digits=
   (int)SymbolInfoInteger(
      _Symbol,
      SYMBOL_DIGITS
   );


   return NormalizeDouble(
      price,
      digits
   );

}



//====================================================
// POINT VALUE
//====================================================

double PointValue()
{

   return SymbolInfoDouble(
      _Symbol,
      SYMBOL_POINT
   );

}



//====================================================
// CURRENT BID
//====================================================

double BidPrice()
{

   return SymbolInfoDouble(
      _Symbol,
      SYMBOL_BID
   );

}



//====================================================
// CURRENT ASK
//====================================================

double AskPrice()
{

   return SymbolInfoDouble(
      _Symbol,
      SYMBOL_ASK
   );

}



//====================================================
// CHECK NEW BAR
//====================================================

bool NewBar()
{

   static datetime last=0;


   datetime current=
   iTime(
      _Symbol,
      PERIOD_M1,
      0
   );


   if(current!=last)
   {

      last=current;

      return true;

   }


   return false;

}



//====================================================
// CANDLE BODY STRENGTH
//====================================================

double CandleStrength(
   int shift
)
{

   CandleData c=
   GetCandle(
      shift
   );


   double range=
   c.High-c.Low;


   if(range<=0)
      return 0;



   return
   (c.Body/range)*100.0;

}



//====================================================
// ENGULFING DETECTION
//====================================================

bool BullishEngulfing()
{

   CandleData current=
   GetCandle(1);


   CandleData previous=
   GetCandle(2);



   if(
      current.Bullish &&
      previous.Bearish &&
      current.Close>previous.Open &&
      current.Open<previous.Close
   )
      return true;



   return false;

}




bool BearishEngulfing()
{

   CandleData current=
   GetCandle(1);


   CandleData previous=
   GetCandle(2);



   if(
      current.Bearish &&
      previous.Bullish &&
      current.Close<previous.Open &&
      current.Open>previous.Close
   )
      return true;



   return false;

}



//====================================================
// PIN BAR DETECTION
//====================================================

bool BullishPinBar()
{

   CandleData c=
   GetCandle(1);


   if(
      c.LowerWick > c.Body*2 &&
      c.Bullish
   )
      return true;


   return false;

}



bool BearishPinBar()
{

   CandleData c=
   GetCandle(1);


   if(
      c.UpperWick > c.Body*2 &&
      c.Bearish
   )
      return true;


   return false;

}



//====================================================
// LOG FUNCTION
//====================================================

void LogMessage(
   string message
)
{

   Print(
      "[AI XAU SCALPER] ",
      message
   );

}



#endif
