//+------------------------------------------------------------------+
//|                          SMC.mqh                                 |
//|                    AI XAU M1 Scalper                              |
//|              Smart Money Concepts Engine                          |
//+------------------------------------------------------------------+

#ifndef SMC_MQH
#define SMC_MQH


class CSMC
{

private:

   bool bosBullish;
   bool bosBearish;

   bool chochBullish;
   bool chochBearish;

   bool liquidityBuy;
   bool liquiditySell;

   bool bullishFVG;
   bool bearishFVG;

   bool bullishOrderBlock;
   bool bearishOrderBlock;



//====================================================
// SWING HIGH
//====================================================

bool IsSwingHigh(int shift)
{

   double high =
   iHigh(
      _Symbol,
      PERIOD_M1,
      shift
   );


   return
   (
      high >
      iHigh(_Symbol,PERIOD_M1,shift+1)
      &&
      high >
      iHigh(_Symbol,PERIOD_M1,shift-1)
   );

}



//====================================================
// SWING LOW
//====================================================

bool IsSwingLow(int shift)
{

   double low =
   iLow(
      _Symbol,
      PERIOD_M1,
      shift
   );


   return
   (
      low <
      iLow(_Symbol,PERIOD_M1,shift+1)
      &&
      low <
      iLow(_Symbol,PERIOD_M1,shift-1)
   );

}



//====================================================
// FIND RECENT HIGH
//====================================================

double RecentHigh()
{

   double high=0;


   for(int i=2;i<=20;i++)
   {

      if(IsSwingHigh(i))
      {
         high=
         iHigh(
            _Symbol,
            PERIOD_M1,
            i
         );

         break;
      }

   }


   return high;

}



//====================================================
// FIND RECENT LOW
//====================================================

double RecentLow()
{

   double low=0;


   for(int i=2;i<=20;i++)
   {

      if(IsSwingLow(i))
      {

         low=
         iLow(
            _Symbol,
            PERIOD_M1,
            i
         );

         break;

      }

   }


   return low;

}



//====================================================
// BREAK OF STRUCTURE
//====================================================

void DetectBOS()
{

   double high=
   RecentHigh();


   double low=
   RecentLow();


   double close=
   iClose(
      _Symbol,
      PERIOD_M1,
      1
   );



   bosBullish =
   (
      close > high &&
      high>0
   );



   bosBearish =
   (
      close < low &&
      low>0
   );

}



//====================================================
// CHANGE OF CHARACTER
//====================================================

void DetectCHoCH()
{

   double previousHigh=
   iHigh(
      _Symbol,
      PERIOD_M1,
      3
   );


   double previousLow=
   iLow(
      _Symbol,
      PERIOD_M1,
      3
   );


   double close=
   iClose(
      _Symbol,
      PERIOD_M1,
      1
   );



   chochBullish =
   (
      close>previousHigh
   );



   chochBearish =
   (
      close<previousLow
   );

}



//====================================================
// LIQUIDITY SWEEP
//====================================================

void DetectLiquidity()
{

   double high1=
   iHigh(
      _Symbol,
      PERIOD_M1,
      2
   );


   double high2=
   iHigh(
      _Symbol,
      PERIOD_M1,
      5
   );



   double low1=
   iLow(
      _Symbol,
      PERIOD_M1,
      2
   );


   double low2=
   iLow(
      _Symbol,
      PERIOD_M1,
      5
   );



   double currentHigh=
   iHigh(
      _Symbol,
      PERIOD_M1,
      1
   );


   double currentLow=
   iLow(
      _Symbol,
      PERIOD_M1,
      1
   );



   liquiditySell =
   (
      currentHigh>high2 &&
      iClose(_Symbol,PERIOD_M1,1)<high2
   );



   liquidityBuy =
   (
      currentLow<low2 &&
      iClose(_Symbol,PERIOD_M1,1)>low2
   );

}



//====================================================
// FAIR VALUE GAP
//====================================================

void DetectFVG()
{


   double high3=
   iHigh(
      _Symbol,
      PERIOD_M1,
      3
   );


   double low1=
   iLow(
      _Symbol,
      PERIOD_M1,
      1
   );



   double low3=
   iLow(
      _Symbol,
      PERIOD_M1,
      3
   );


   double high1=
   iHigh(
      _Symbol,
      PERIOD_M1,
      1
   );



   bullishFVG =
   (
      low1 > high3
   );



   bearishFVG =
   (
      high1 < low3
   );

}



//====================================================
// ORDER BLOCK DETECTION
//====================================================

void DetectOrderBlocks()
{

   double open2=
   iOpen(
      _Symbol,
      PERIOD_M1,
      2
   );


   double close2=
   iClose(
      _Symbol,
      PERIOD_M1,
      2
   );


   double open1=
   iOpen(
      _Symbol,
      PERIOD_M1,
      1
   );


   double close1=
   iClose(
      _Symbol,
      PERIOD_M1,
      1
   );



   bullishOrderBlock =
   (
      close2 < open2 &&
      close1 > open1 &&
      close1 > open2
   );



   bearishOrderBlock =
   (
      close2 > open2 &&
      close1 < open1 &&
      close1 < open2
   );

}




public:



//====================================================
// ANALYZE MARKET
//====================================================

void Analyze()
{

   DetectBOS();

   DetectCHoCH();

   DetectLiquidity();

   DetectFVG();

   DetectOrderBlocks();

}



//====================================================
// GETTERS
//====================================================

bool BOSBullish()
{
   return bosBullish;
}


bool BOSBearish()
{
   return bosBearish;
}



bool CHoCHBullish()
{
   return chochBullish;
}



bool CHoCHBearish()
{
   return chochBearish;
}



bool LiquidityBuy()
{
   return liquidityBuy;
}



bool LiquiditySell()
{
   return liquiditySell;
}



bool BullishFVG()
{
   return bullishFVG;
}



bool BearishFVG()
{
   return bearishFVG;
}



bool BullishOrderBlock()
{
   return bullishOrderBlock;
}



bool BearishOrderBlock()
{
   return bearishOrderBlock;
}



};


#endif
