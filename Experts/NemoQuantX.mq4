//+------------------------------------------------------------------+
//|                                                  NemoQuantX.mq4  |
//|                                      Strategiya muallifi: Jamoa  |
//|                                    Dasturchi: Nematillo Ochilov  |
//+------------------------------------------------------------------+
#property copyright "NemoQuantX MT4 savdoni avtomatlashtiruvchi roboti"
#property link      "https://t.me/MQLUZ"
#property strict

//--- Testerda o'zgartirish mumkin bo'lgan parametrlar
//input group "=== Risk Management ==="
//input double RiskPerTrade    = 0.5;    // Har bir savdoda risk (%)
input int    StopLoss        = 200;    // Stop-loss (punkt)
input int    TakeProfit      = 400;    // Take-profit (punkt)

//input group "=== Strategy Settings ==="
input int    MAPeriod        = 14;  // Moving Average period
input bool   UseRSIFilter = true;  // RSI filtri ishlatilsinmi??
input double RSIThreshold    = 30.0;  // RSI chegarasi

#include <NemoQuantX/Defines.mqh>
#include <NemoQuantX/Config.mqh>
#include <NemoQuantX/Functions.mqh>
#include <NemoQuantX/Trading.mqh>
#include <NemoQuantX/Logger.mqh>
#include <NemoQuantX/ErrorHelper.mqh>  // Log("Buy order error: " + ErrorDescription(GetLastError()));

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Dastur boshlang'ich sozlamalari
    if(!LoadConfiguration()) return(INIT_FAILED);
    if(!InitializeIndicators()) return(INIT_FAILED);
    
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    CleanUpChartObjects();
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    if(!IsTradingAllowed()) return;
    
    ManageOpenPositions();
    CheckForNewSignals();
    UpdateDashboard();
}
