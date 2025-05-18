//+------------------------------------------------------------------+
//| Strategy.mqh                                                    |
//+------------------------------------------------------------------+
#ifndef __STRATEGY_MQH__
#define __STRATEGY_MQH__

#include <NemoQuantX/Trade.mqh>

class Strategy {
private:
   TradeManager tradeManager;
public:
   Strategy(TradeManager &tm) : tradeManager(tm) {}

   void Execute() {
      double rsi = iRSI(Symbol(), 0, 14, PRICE_CLOSE, 0);
      double high = iHigh(Symbol(), PERIOD_D1, 1);
      double low = iLow(Symbol(), PERIOD_D1, 1);
      double fib23 = high - (high - low) * 0.236;
      double fib50 = high - (high - low) * 0.5;
      double fib76 = high - (high - low) * 0.764;
      double currentPrice = Ask;

      if (currentPrice <= fib23 && rsi <= 30) {
         tradeManager.OpenBuy(currentPrice, fib50, fib76);
      }
   }
};

#endif