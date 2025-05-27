//+------------------------------------------------------------------+
//|                      Yordamchi funksiyalar                       |
//+------------------------------------------------------------------+
extern string ChatID, TelegramToken;
#include <NemoQuantX/Functions.mqh>
//+------------------------------------------------------------------+
//|                  Savdo operatsiyalari uchun yordamchi funksiyalar|
//+------------------------------------------------------------------+
/*
 * Savdo operatsiyalarini qayta urinishlar bilan bajarish
 * @param operation - "MODIFY" yoki "CLOSE"
 * @param ticket - Order ticket raqami
 * @param price - Yangi narx (modify uchun) yoki yopish narxi (close uchun)
 * @param sl - Stop Loss qiymati (faqat modify uchun)
 * @param tp - Take Profit qiymati (faqat modify uchun)
 * @param lots - Lot hajmi (faqat close uchun)
 * @return bool - Operatsiya muvaffaqiyatli bo'lsa true
 */
bool TradeOperationWithRetry(string operation, int ticket, double price=0, double sl=0, double tp=0, double lots=0)
{
    int attempts = 3; // Maksimal urinishlar soni
    int lastError = 0;

    while(attempts > 0)
    {
        bool result = false;
        lastError = 0;

        // Operatsiya turini tekshirish
        if(operation == "MODIFY")
        {
            result = OrderModify(ticket, price, sl, tp, 0, clrNONE);
        }
        else if(operation == "CLOSE")
        {
            result = OrderClose(ticket, lots, price, 3, clrNONE);
        }
        else
        {
            Print("Noto'g'ri operatsiya turi: ", operation);
            return false;
        }

        // Natijani tekshirish
        if(result)
        {
            return true;
        }

        // Xatoni qayd etish
        lastError = GetLastError();

        // Qayta urinish uchun tegishli xatolarni tekshirish
        if(lastError == ERR_TRADE_CONTEXT_BUSY ||
           lastError == ERR_SERVER_BUSY ||
           lastError == ERR_TRADE_TIMEOUT)
        {
            Print(operation, " operatsiyasi uchun qayta urinish (#", ticket, "). Xato: ", lastError);
            Sleep(500);             // 500 ms kutish
            RefreshRates();         // Kurslarni yangilash
            attempts--;             // Urinishlar sonini kamaytirish
        }
        else
        {
            // Qayta urinish kerak bo'lmagan xatolar
            Print(operation, " operatsiyasi muvaffaqiyatsiz (#", ticket, "). Xato: ", lastError);
            break;
        }
    }

    // Maxsus xatolarni qayta ishlash
    if(lastError == ERR_INVALID_STOPS)
    {
        Print("Xato: Noto'g'ri SL/TP qiymatlari (#", ticket, ")");
    }
    else if(lastError == ERR_TRADE_DISABLED)
    {
        Print("Xato: Savdo faol emas (#", ticket, ")");
    }

    return false;
}

//+------------------------------------------------------------------+
//|                  Boshqa yordamchi funksiyalar                    |
//+------------------------------------------------------------------+

bool LoadConfiguration()
{
    // Indikatorlarni yuklash
    zigzagHandle = (int)iCustom(NULL, 0, "ZigZag", ZigZagDepth, 5, 3);
    if(zigzagHandle == INVALID_HANDLE)
    {
        Print("ZigZag indikatorini yuklab bo'lmadi!");
        return false;
    }

    rsiHandle = (int)iRSI(NULL, 5, 14, PRICE_CLOSE, 1);
    if(rsiHandle == INVALID_HANDLE)
    {
        Print("RSI indikatorini yuklab bo'lmadi!");
        return false;
    }

    return true;
}

bool InitializeIndicators()
{
    // Ikkala indikator ham yuklanganligini tekshiramiz
    bool success = (zigzagHandle != INVALID_HANDLE && rsiHandle != INVALID_HANDLE);

    if(!success)
        Print("InitializeIndicators(): Ba'zi indikatorlar yuklanmadi!");

    return success;
}

void CleanUpChartObjects()
{
    // Barcha chart obyektlarini tozalash
    ObjectsDeleteAll(0);
}

bool IsTradingAllowed()
{
    // Savdo vaqtini tekshirish
    if(Hour() < StartTradingHour || Hour() >= EndTradingHour)
        return false;
        
    // Yangi bar boshlanishini kutish
    if(!IsNewBar())
        return false;
        
    return true;
}

bool IsNewBar()
{
    static datetime lastBarTime = 0;
    datetime currentBarTime = iTime(NULL, 0, 0);
    
    if(lastBarTime != currentBarTime)
    {
        lastBarTime = currentBarTime;
        return true;
    }
    
    return false;
}

void UpdateDashboard()
{
    // Dashboardni yangilash
    string text = "ZON Trading Robot\n";
    text += "Signal: " + currentSignal.type + "\n";
    text += "Impulse Candles: " + IntegerToString(currentSignal.impulseCandles) + "\n";
    text += "Flat Candles: " + IntegerToString(currentSignal.flatCandles) + "\n";
    
    Comment(text);
}

void SendTelegramNotification(string message)
{
    // Telegramga xabar yuborish
    string headers;
    string url = "https://api.telegram.org/bot" + TelegramToken + "/sendMessage?chat_id=" + ChatID + "&text=" + message;
    char post[],result[];
    if(!WebRequest("GET", url, NULL, NULL, 5000, post, 0, result, headers))
        Print("Telegram xabarini yuborishda xato: ", GetLastError());
}
