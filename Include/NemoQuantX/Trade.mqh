#ifndef __TRADE_MQH__
#define __TRADE_MQH__

#include "Logger.mqh"
#include "Risk.mqh"
#include "Strategy.mqh"
#include "ErrorHelper.mqh"

void ExecuteTrade() {
   if (!EntrySignal()) return;

   double stopLossPips = 30; // yoki strategiyaga qarab hisoblanadi
   double lot = CalculateLot(stopLossPips);

   double sl = Bid - stopLossPips * Point;
   double tp1 = Bid + 50 * Point;
   double tp2 = Bid + 76 * Point;

   int ticket1 = OrderSend(Symbol(), OP_BUY, lot, Ask, 3, sl, tp1, "TP1", 0, 0, clrBlue);
   int ticket2 = OrderSend(Symbol(), OP_BUY, lot, Ask, 3, sl, tp2, "TP2", 0, 0, clrGreen);

   if (ticket1 < 0 || ticket2 < 0) {
      Log("Buy order error: " + ErrorDescription(GetLastError()));
   } else {
      Log("Buy orders sent: " + IntegerToString(ticket1) + ", " + IntegerToString(ticket2));
   }
}

#endif
