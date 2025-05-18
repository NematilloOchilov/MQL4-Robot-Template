#ifndef __LOGGER_MQH__
#define __LOGGER_MQH__

class Logger {
public:
    void Log(string message) {
        Print("[NemoQuantX] ", message);
    }
};

#endif

// Fayl: Risk.mqh
#ifndef __RISK_MQH__
#define __RISK_MQH__

class RiskManager {
private:
    double riskPercent;

public:
    RiskManager(double risk = 1.0) {
        riskPercent = risk;
    }

    void SetRiskPercent(double risk) {
        riskPercent = risk;
    }

    double LotSize(string symbol) {
        double accEquity = AccountEquity();
        double riskAmount = accEquity * riskPercent / 100.0;
        double slPoints = 100; // default, can be dynamic
        double tickValue = MarketInfo(symbol, MODE_TICKVALUE);
        double lot = riskAmount / (slPoints * tickValue / MarketInfo(symbol, MODE_TICKSIZE));
        lot = NormalizeDouble(lot, 2);
        return lot;
    }
};

#endif
