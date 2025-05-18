//+------------------------------------------------------------------+
//| Risk.mqh                                                        |
//+------------------------------------------------------------------+
#ifndef __RISK_MQH__
#define __RISK_MQH__

class RiskManager {
private:
   double riskPercent;
public:
   RiskManager(double percent = 1.0) {
      riskPercent = percent;
   }

   double CalculateLot(double stopLossPips) {
      double balance = AccountBalance();
      double riskAmount = balance * riskPercent / 100.0;
      double pipValue = 10.0;
      double lot = riskAmount / (stopLossPips * pipValue);

      double minLot = MarketInfo(Symbol(), MODE_MINLOT);
      double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);
      double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);

      lot = MathMax(minLot, MathMin(maxLot, lot));
      lot = NormalizeDouble(lot / lotStep, 0) * lotStep;

      return NormalizeDouble(lot, 2);
   }
};

#endif