#include <NemoQuantX/Logger.mqh>
#include <NemoQuantX/Risk.mqh>
#include <NemoQuantX/Strategy.mqh>
#include <NemoQuantX/Trade.mqh>

int OnInit() {
   Log("NemoQuantX robot ishga tushdi");
   return(INIT_SUCCEEDED);
}

void OnTick() {
   static datetime lastTradeTime = 0;
   if (TimeCurrent() - lastTradeTime > 3600 * 4) { // har 4 soatda faqat bitta tekshiruv
      ExecuteTrade();
      lastTradeTime = TimeCurrent();
   }
}

void OnDeinit(const int reason) {
   Log("NemoQuantX robot to‘xtatildi");
}
