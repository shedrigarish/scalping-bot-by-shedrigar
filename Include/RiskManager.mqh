//+------------------------------------------------------------------+
//|                    RiskManager.mqh                               |
//|                    AI XAU M1 Scalper                              |
//|              Confidence Based Lot Engine                          |
//+------------------------------------------------------------------+

#ifndef RISKMANAGER_MQH
#define RISKMANAGER_MQH


class CRiskManager
{


private:


double NormalizeLot(double lot)
{

   double minLot =
   SymbolInfoDouble(
      _Symbol,
      SYMBOL_VOLUME_MIN
   );


   double maxLot =
   SymbolInfoDouble(
      _Symbol,
      SYMBOL_VOLUME_MAX
   );


   double step =
   SymbolInfoDouble(
      _Symbol,
      SYMBOL_VOLUME_STEP
   );



   if(lot < minLot)
      lot=minLot;


   if(lot > maxLot)
      lot=maxLot;



   lot =
   MathFloor(
      lot/step
   )
   *
   step;



   return NormalizeDouble(
      lot,
      2
   );

}




public:



//====================================================
// CALCULATE LOT SIZE
//====================================================

double CalculateLot(
   double confidence,
   double lot70,
   double lot80,
   double lot90,
   double lot95
)
{


   double lot=0;



   if(
      confidence>=95
   )
   {

      lot=lot95;

   }


   else if(
      confidence>=90
   )
   {

      lot=lot90;

   }


   else if(
      confidence>=80
   )
   {

      lot=lot80;

   }


   else if(
      confidence>=70
   )
   {

      lot=lot70;

   }


   else
   {

      lot=0;

   }



   return NormalizeLot(lot);

}



//====================================================
// ACCOUNT CHECK
//====================================================

bool AccountSafe()
{

   double balance =
   AccountInfoDouble(
      ACCOUNT_BALANCE
   );


   double equity =
   AccountInfoDouble(
      ACCOUNT_EQUITY
   );



   if(
      equity < balance*0.8
   )
   {

      return false;

   }



   return true;

}



//====================================================
// MARGIN CHECK
//====================================================

bool MarginAvailable(
   ENUM_ORDER_TYPE type,
   double volume
)
{

   double margin;



   if(
      OrderCalcMargin(
         type,
         _Symbol,
         volume,
         SymbolInfoDouble(
            _Symbol,
            SYMBOL_ASK
         ),
         margin
      )
      ==false
   )
      return false;



   if(
      margin >
      AccountInfoDouble(
         ACCOUNT_FREEMARGIN
      )
   )
      return false;



   return true;

}



};


#endif
