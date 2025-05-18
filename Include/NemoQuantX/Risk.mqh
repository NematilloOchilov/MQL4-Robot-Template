#ifndef __RISK_MQH__
#define __RISK_MQH__

extern double RiskPercent = 1.0; // 1% risk har bir bitimga

// Hisob-kitob: qancha lot ochish kerak
// SL punktlarda
// return: lot hajmi

double CalculateLot(double stopLossPips) {
   double riskMoney = AccountBalance() * RiskPercent / 100.0;
   double lotSize = (riskMoney / (stopLossPips * MarketInfo(Symbol(), MODE_TICKVALUE)));
   double minLot = MarketInfo(Symbol(), MODE_MINLOT);
   double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   double normalizedLot = MathFloor(lotSize / lotStep) * lotStep;
   if (normalizedLot < minLot) normalizedLot = minLot;
   return normalizedLot;
}

#endif
