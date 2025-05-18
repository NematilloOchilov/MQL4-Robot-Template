#ifndef __STRATEGY_MQH__
#define __STRATEGY_MQH__

bool EntrySignal() {
   double high = iHigh(Symbol(), PERIOD_W1, 1);
   double close = iClose(Symbol(), PERIOD_D1, 0);
   double low = iLow(Symbol(), PERIOD_D1, 0);
   double fib236 = high - (high - low) * 0.236;

   double rsi = iRSI(Symbol(), PERIOD_D1, 14, PRICE_CLOSE, 0);

   if (close > high && Close[0] <= fib236 && rsi <= 30) {
      return true;
   }
   return false;
}

#endif
