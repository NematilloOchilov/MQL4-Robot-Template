#include <NemoQuantX/Trade.mqh>

RiskManager     riskManager;
StrategyManager strategyManager;
TradeManager    tradeManager;

int OnInit() {
    tradeManager.SetRiskManager(riskManager);
    tradeManager.SetStrategy(strategyManager);
    return INIT_SUCCEEDED;
}

void OnTick() {
    tradeManager.ExecuteTrade(Symbol(), PERIOD_H1);
}
