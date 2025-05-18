#ifndef __TRADE_MQH__
#define __TRADE_MQH__

#include <NemoQuantX/Risk.mqh>
#include <NemoQuantX/Strategy.mqh>
#include <NemoQuantX/Logger.mqh>

class TradeManager {
private:
    RiskManager     *riskManager;
    StrategyManager *strategyManager;
    Logger          logger;

public:
    void SetRiskManager(RiskManager &rm) {
        riskManager = &rm;
    }

    void SetStrategy(StrategyManager &sm) {
        strategyManager = &sm;
    }

    void ExecuteTrade(string symbol, int timeframe) {
        double lot = riskManager.LotSize(symbol);
        double sl = strategyManager->GetSL(symbol, timeframe);
        double tp = strategyManager->GetTP(symbol, timeframe);
        int direction = strategyManager->GetSignal(symbol, timeframe);

        if (direction == 1) {
            int ticket = OrderSend(symbol, OP_BUY, lot, Ask, 3, sl, tp, "Buy by NemoQuantX", 0, 0, clrGreen);
            if (ticket > 0)
                logger.Log("Buy order opened: " + IntegerToString(ticket));
            else
                logger.Log("Buy order failed: " + ErrorDescription(GetLastError()));
        }
        else if (direction == -1) {
            int ticket = OrderSend(symbol, OP_SELL, lot, Bid, 3, sl, tp, "Sell by NemoQuantX", 0, 0, clrRed);
            if (ticket > 0)
                logger.Log("Sell order opened: " + IntegerToString(ticket));
            else
                logger.Log("Sell order failed: " + ErrorDescription(GetLastError()));
        }
    }
};

#endif