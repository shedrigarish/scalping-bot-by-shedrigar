//+------------------------------------------------------------------+
//|                      Confidence.mqh                               |
//|                    AI XAU M1 Scalper                              |
//|              Multi-Factor Decision Engine                         |
//+------------------------------------------------------------------+

#ifndef CONFIDENCE_MQH
#define CONFIDENCE_MQH


class CConfidence
{

private:

   double score;

   ENUM_SIGNAL signal;



public:


//====================================================
// CALCULATE MARKET CONFIDENCE
//====================================================

void Calculate(
   CIndicators &ind,
   CSMC &smc
)
{

   double buyScore=0;

   double sellScore=0;



   //------------------------------------------------
   // TREND ANALYSIS
   //------------------------------------------------

   if(
      ind.Trend()==DIRECTION_BULLISH
   )
      buyScore +=15;



   if(
      ind.Trend()==DIRECTION_BEARISH
   )
      sellScore +=15;



   //------------------------------------------------
   // RSI MOMENTUM
   //------------------------------------------------

   if(
      ind.RSIBullish()
   )
      buyScore +=10;



   if(
      ind.RSIBearish()
   )
      sellScore +=10;



   //------------------------------------------------
   // MACD
   //------------------------------------------------

   if(
      ind.MACDBullish()
   )
      buyScore +=10;



   if(
      ind.MACDBearish()
   )
      sellScore +=10;



   //------------------------------------------------
   // VWAP
   //------------------------------------------------

   if(
      ind.AboveVWAP()
   )
      buyScore +=10;



   if(
      ind.BelowVWAP()
   )
      sellScore +=10;



   //------------------------------------------------
   // VOLUME
   //------------------------------------------------

   if(
      ind.VolumeIncrease()
   )
   {

      if(
         ind.Trend()==DIRECTION_BULLISH
      )
         buyScore +=5;


      if(
         ind.Trend()==DIRECTION_BEARISH
      )
         sellScore +=5;

   }



   //------------------------------------------------
   // SMC STRUCTURE
   //------------------------------------------------


   if(
      smc.BOSBullish()
   )
      buyScore +=15;



   if(
      smc.BOSBearish()
   )
      sellScore +=15;



   if(
      smc.CHoCHBullish()
   )
      buyScore +=10;



   if(
      smc.CHoCHBearish()
   )
      sellScore +=10;



   if(
      smc.LiquidityBuy()
   )
      buyScore +=10;



   if(
      smc.LiquiditySell()
   )
      sellScore +=10;



   if(
      smc.BullishFVG()
   )
      buyScore +=5;



   if(
      smc.BearishFVG()
   )
      sellScore +=5;



   if(
      smc.BullishOrderBlock()
   )
      buyScore +=5;



   if(
      smc.BearishOrderBlock()
   )
      sellScore +=5;



   //------------------------------------------------
   // PRICE ACTION
   //------------------------------------------------


   if(
      BullishEngulfing()
   )
      buyScore +=10;



   if(
      BearishEngulfing()
   )
      sellScore +=10;



   if(
      BullishPinBar()
   )
      buyScore +=5;



   if(
      BearishPinBar()
   )
      sellScore +=5;



   //------------------------------------------------
   // FINAL DECISION
   //------------------------------------------------


   if(
      buyScore>sellScore
   )
   {

      score=buyScore;

      signal=SIGNAL_BUY;

   }



   else if(
      sellScore>buyScore
   )
   {

      score=sellScore;

      signal=SIGNAL_SELL;

   }



   else
   {

      score=0;

      signal=SIGNAL_NONE;

   }



   // Limit score

   if(score>100)
      score=100;


}



//====================================================
// GET CONFIDENCE
//====================================================

double GetScore()
{

   return score;

}



//====================================================
// GET SIGNAL
//====================================================

ENUM_SIGNAL GetSignal()
{

   return signal;

}



};


#endif
