//+------------------------------------------------------------------+
//|                     Statistics.mqh                               |
//|                    AI XAU M1 Scalper                             |
//|                 Trading Performance Tracker                      |
//+------------------------------------------------------------------+

#ifndef STATISTICS_MQH
#define STATISTICS_MQH


class CStatistics
{

private:

   int totalTrades;
   int winningTrades;
   int losingTrades;

   double totalProfit;
   double totalLoss;



public:


//====================================================
// INITIALIZE
//====================================================

bool Initialize()
{

   totalTrades=0;

   winningTrades=0;

   losingTrades=0;

   totalProfit=0;

   totalLoss=0;


   return true;

}



//====================================================
// RECORD CLOSED TRADE
//====================================================

void RecordTrade(
   double profit
)
{

   totalTrades++;



   if(profit>0)
   {

      winningTrades++;

      totalProfit+=profit;

   }


   else
   {

      losingTrades++;

      totalLoss+=MathAbs(profit);

   }


}



//====================================================
// TOTAL TRADES
//====================================================

int TotalTrades()
{

   return totalTrades;

}



//====================================================
// WIN RATE
//====================================================

double WinRate()
{

   if(totalTrades==0)
      return 0;



   return
   (
   (double)winningTrades /
   totalTrades
   )
   *
   100.0;

}



//====================================================
// NET PROFIT
//====================================================

double NetProfit()
{

   return
   totalProfit-totalLoss;

}



//====================================================
// DISPLAY STATS
//====================================================

void PrintStats()
{

   Print(
   "======== AI SCALPER STATS ========");


   Print(
   "Trades: ",
   totalTrades
   );


   Print(
   "Wins: ",
   winningTrades
   );


   Print(
   "Losses: ",
   losingTrades
   );


   Print(
   "Win Rate: ",
   DoubleToString(
      WinRate(),
      2
   ),
   "%"
   );


   Print(
   "Net Profit: ",
   DoubleToString(
      NetProfit(),
      2
   )
   );


}

void CheckHistory()
{

   static datetime lastCheck=0;


   if(TimeCurrent()==lastCheck)
      return;


   lastCheck=TimeCurrent();


   HistorySelect(
      0,
      TimeCurrent()
   );


}

};


#endif
