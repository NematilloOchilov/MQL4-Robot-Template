//+------------------------------------------------------------------+
//|                      Savdo logikasi                              |
//+------------------------------------------------------------------+

void CheckForNewSignals()
{
    // Yangi signalni tekshirish
    if(FindZigZagPattern())
    {
        if(ValidateSignal())
        {
            ExecuteTrades();
        }
    }
}

bool FindZigZagPattern()
{
    // ZigZag naqshini topish
    double zigzag0 = iCustom(NULL, 0, "ZigZag", ZigZagDepth, 5, 3, 0, 0);
    
    if(zigzag0 == 0) return false;
    
    int numZigZags = 0;
    for(int i = 1; i < 200; i++)
    {
        double zz = iCustom(NULL, 0, "ZigZag", ZigZagDepth, 5, 3, 0, i);
        if(zz != 0)
        {
            numZigZags++;
            
            if(numZigZags == 1)
            {
                currentSignal.zigzag1 = zz;
                currentSignal.time1 = iTime(NULL, 0, i);
                currentSignal.impulseCandles = i;
            }
            else if(numZigZags == 2)
            {
                currentSignal.zigzag2 = zz;
                currentSignal.time2 = iTime(NULL, 0, i);
                currentSignal.impulseCandles = i - currentSignal.impulseCandles;
                break;
            }
        }
    }
    
    // 3-chi zigzag nuqtasini topish
    for(int i = 1; i < 200; i++)
    {
        double zz = iCustom(NULL, 0, "ZigZag", ZigZagDepth, 5, 3, 0, i);
        if(zz != 0 && iTime(NULL, 0, i) < currentSignal.time2)
        {
            currentSignal.zigzag3 = zz;
            currentSignal.time3 = iTime(NULL, 0, i);
            break;
        }
    }
    
    // Signal turini aniqlash
    if(zigzag0 < currentSignal.zigzag1 && currentSignal.zigzag3 < currentSignal.zigzag1)
    {
        currentSignal.type = "BUY";
        currentSignal.flatCandles = Bars(NULL, 0, TimeCurrent(), currentSignal.time1);
        return true;
    }
    else if(zigzag0 > currentSignal.zigzag1 && currentSignal.zigzag3 > currentSignal.zigzag1)
    {
        currentSignal.type = "SELL";
        currentSignal.flatCandles = Bars(NULL, 0, TimeCurrent(), currentSignal.time1);
        return true;
    }
    
    return false;
}

bool ValidateSignal()
{

    // Signalni tasdiqlash
    currentSignal.fibLength = MathAbs(currentSignal.zigzag1 - currentSignal.zigzag2);
    
    // 1. Fibo uzunligi tekshirish
    currentSignal.fibLength = MathAbs(currentSignal.zigzag1 - currentSignal.zigzag2);

    if(currentSignal.fibLength < MinFibLength * _Point)
        return false;
    
    // 2. Impuls shamlar soni tekshirish
    if(currentSignal.impulseCandles < MinImpulseCandles || 
       currentSignal.impulseCandles > MaxImpulseCandles)
        return false;
    
    // 3. Flet/Impuls nisbati tekshirish
    if(currentSignal.flatCandles < currentSignal.impulseCandles * FlatToImpulseRatio)
        return false;
    
    // 4. RSI tekshirish
    double rsi = iRSI(NULL, RSITimeframe, RSIPeriod, PRICE_CLOSE, 0);
    if(currentSignal.type == "BUY" && rsi < 65) return false;
    if(currentSignal.type == "SELL" && rsi > 35) return false;

    // 5. <-- Structda saqlaymiz
    currentSignal.fibLength = MathAbs(currentSignal.zigzag1 - currentSignal.zigzag2);
    if(currentSignal.fibLength < MinFibLength * _Point)
        return false;

    return true;
}

void ExecuteTrades()
{
    if(!ValidateSignal()) return;

    // O'zgaruvchilarni funksiya boshida e'lon qilamiz
    double entry1 = 0, entry2 = 0;
    string signalType = currentSignal.type;

    if(signalType == "BUY")
    {
        // Buy uchun narxlarni hisoblash
        entry1 = NormalizeDouble(currentSignal.zigzag2 + (currentSignal.fibLength * EntryLevel1/100), _Digits);
        entry2 = NormalizeDouble(currentSignal.zigzag2 + (currentSignal.fibLength * EntryLevel2/100), _Digits);

        // Buy orderlarini joylashtirish
        SendTradeOrder(OP_BUYLIMIT, entry1, CalculateSL(true, 38), CalculateTP(true, 38, 1), "ZON Buy 1");
        SendTradeOrder(OP_BUYLIMIT, entry2, CalculateSL(true, 23), CalculateTP(true, 23, 1), "ZON Buy 2");
    }
    else if(signalType == "SELL")
    {
        // Sell uchun narxlarni hisoblash
        entry1 = NormalizeDouble(currentSignal.zigzag2 - (currentSignal.fibLength * EntryLevel1/100), _Digits);
        entry2 = NormalizeDouble(currentSignal.zigzag2 - (currentSignal.fibLength * EntryLevel2/100), _Digits);

        // Sell orderlarini joylashtirish
        SendTradeOrder(OP_SELLLIMIT, entry1, CalculateSL(false, 38), CalculateTP(false, 38, 1), "ZON Sell 1");
        SendTradeOrder(OP_SELLLIMIT, entry2, CalculateSL(false, 23), CalculateTP(false, 23, 1), "ZON Sell 2");
    }

    // Fibo chizmalarini yaratish
    DrawFibonacciLevels();

    // Bildirishnoma yuborish
    if(SendNotifications)
    {
        string message = StringFormat("ZON: New %s signal\nEntry1: %.4f\nEntry2: %.4f",
                                    signalType,
                                    entry1,
                                    entry2);
        SendTelegramNotification(message);
    }
}

//+------------------------------------------------------------------+
//|                  Yordamchi funksiyalar                           |
//+------------------------------------------------------------------+

double CalculateEntryPrice(bool isBuy, int fibLevel)
{
    double levelPercent = (fibLevel == 38) ? EntryLevel1 : EntryLevel2;
    double adjustment = currentSignal.fibLength * levelPercent / 100.0;

    return NormalizeDouble(
        isBuy
            ? currentSignal.zigzag2 + adjustment
            : currentSignal.zigzag2 - adjustment,
        _Digits
    );
}

double CalculateSL(bool isBuy, int fibLevel)
{
    double slPercent = (fibLevel == 38) ? SL_38 : SL_23;
    double adjustment = currentSignal.fibLength * slPercent / 100.0;

    return NormalizeDouble(
        isBuy
            ? currentSignal.zigzag2 + adjustment
            : currentSignal.zigzag2 - adjustment,
        _Digits
    );
}

double CalculateTP(bool isBuy, int fibLevel, int tpLevel)
{
    double tpPercent;
    if(fibLevel == 38) {
        tpPercent = (tpLevel == 1) ? TP1_38 : TP2_38;
    } else {
        tpPercent = (tpLevel == 1) ? TP1_23 : TP2_23;
    }

    double adjustment = currentSignal.fibLength * tpPercent / 100.0;

    return NormalizeDouble(
        isBuy
            ? currentSignal.zigzag2 + adjustment
            : currentSignal.zigzag2 - adjustment,
        _Digits
    );
}

void SendTradeOrder(int orderType, double price, double sl, double tp, string comment)
{
    double lotSize = CalculateLotSize();
    int slippage = 3;
    color arrowColor = (orderType == OP_BUYLIMIT) ? clrBlue : clrRed;

    if(!OrderSend(Symbol(), orderType, lotSize, price, slippage, sl, tp, comment, MagicNumber, 0, arrowColor))
    {
        Print("OrderSend xatosi: ", GetLastError());
    }
}


//+------------------------------------------------------------------+
//|                  Asosiy savdo funksiyalari                       |
//+------------------------------------------------------------------+

void PlaceBuyOrders()
{
    // 38.2% darajadagi buy order
    SendTradeOrder(
        OP_BUYLIMIT,
        CalculateEntryPrice(true, 38),
        CalculateSL(true, 38),
        CalculateTP(true, 38, 1),
        "ZON Buy 38.2%"
    );

    // 23.6% darajadagi buy order
    SendTradeOrder(
        OP_BUYLIMIT,
        CalculateEntryPrice(true, 23),
        CalculateSL(true, 23),
        CalculateTP(true, 23, 1),
        "ZON Buy 23.6%"
    );

    // Fibo chizmalarini yaratish
    DrawFibonacciLevels();
}

void PlaceSellOrders()
{
    // 38.2% darajadagi sell order
    SendTradeOrder(
        OP_SELLLIMIT,
        CalculateEntryPrice(false, 38),
        CalculateSL(false, 38),
        CalculateTP(false, 38, 1),
        "ZON Sell 38.2%"
    );

    // 23.6% darajadagi sell order
    SendTradeOrder(
        OP_SELLLIMIT,
        CalculateEntryPrice(false, 23),
        CalculateSL(false, 23),
        CalculateTP(false, 23, 1),
        "ZON Sell 23.6%"
    );

    // Fibo chizmalarini yaratish
    DrawFibonacciLevels();
}

double CalculateLotSize()
{
    // Lot hajmini hisoblash
    double riskAmount = AccountBalance() * RiskPerTrade / 100;
    double lotSize = riskAmount / (MarketInfo(Symbol(), MODE_TICKVALUE) * TakeProfitPips);
    return NormalizeDouble(lotSize, 2);
}

void DrawFibonacciLevels()
{
    // Fibo chizmalarini yaratish
    string name = "ZON_Fibo_" + IntegerToString(fiboNameCounter++);
    
    if(!ObjectCreate(0, name, OBJ_FIBO, 0, currentSignal.time1, currentSignal.zigzag1, 
       currentSignal.time2, currentSignal.zigzag2))
    {
        Print("Fibo chizmasini yaratishda xato: ", GetLastError());
        return;
    }
    
    // Fibo darajalarini sozlash
    ObjectSetInteger(0, name, OBJPROP_LEVELS, 8);
    ObjectSetDouble(0, name, OBJPROP_LEVELVALUE, 0, SL_23/100);
    ObjectSetDouble(0, name, OBJPROP_LEVELVALUE, 1, 0);
    ObjectSetDouble(0, name, OBJPROP_LEVELVALUE, 2, EntryLevel2/100);
    ObjectSetDouble(0, name, OBJPROP_LEVELVALUE, 3, EntryLevel1/100);
    ObjectSetDouble(0, name, OBJPROP_LEVELVALUE, 4, BreakevenLevel/100);
    ObjectSetDouble(0, name, OBJPROP_LEVELVALUE, 5, TP1_38/100);
    ObjectSetDouble(0, name, OBJPROP_LEVELVALUE, 6, TP2_23/100);
    ObjectSetDouble(0, name, OBJPROP_LEVELVALUE, 7, 1);
    
    ObjectSetInteger(0, name, OBJPROP_COLOR, FiboColor);
    ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
}

void ManageOpenPositions()
{
    // Ochiq pozitsiyalarni boshqarish
    for(int i = OrdersTotal()-1; i >= 0; i--)
    {
        if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
            if(OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol())
            {
                CheckForBreakeven();
                CheckForTakeProfit();
            }
        }
    }
}

void CheckForBreakeven()
{
    for(int i = OrdersTotal()-1; i >= 0; i--)
    {
        if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) &&
           OrderMagicNumber() == MagicNumber &&
           OrderSymbol() == Symbol())
        {
            bool needModify = false;
            double newSl = 0;

            if(OrderType() == OP_BUY &&
               Bid >= OrderOpenPrice() + BreakevenLevel * _Point &&
               OrderStopLoss() < OrderOpenPrice())
            {
                newSl = OrderOpenPrice() + BreakevenSL * _Point;
                needModify = true;
            }
            else if(OrderType() == OP_SELL &&
                    Ask <= OrderOpenPrice() - BreakevenLevel * _Point &&
                    OrderStopLoss() > OrderOpenPrice())
            {
                newSl = OrderOpenPrice() - BreakevenSL * _Point;
                needModify = true;
            }

            if(needModify)
            {
                int ticket = OrderTicket();
                if(!TradeOperationWithRetry("MODIFY", ticket, OrderOpenPrice(), newSl, OrderTakeProfit()))
                {
                    Print("BreakEven o'rnatish muvaffaqiyatsiz yakunlandi #", ticket);
                }
                else
                {
                    Print("BreakEven muvaffaqiyatli o'rnatildi #", ticket);
                }
            }
        }
    }
}

void CheckForTakeProfit()
{
    for(int i = OrdersTotal()-1; i >= 0; i--)
    {
        if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) &&
           OrderMagicNumber() == MagicNumber &&
           OrderSymbol() == Symbol())
        {
            double profitInPips = OrderProfit() / (MarketInfo(OrderSymbol(), MODE_TICKVALUE) / OrderLots());

            if(profitInPips >= TakeProfitPips)
            {
                double closePrice = OrderType() == OP_BUY ? Bid : Ask;
                int ticket = OrderTicket();

                if(!TradeOperationWithRetry("CLOSE", ticket, closePrice, 0, 0, OrderLots()))
                {
                    Print("TakeProfit yopish muvaffaqiyatsiz yakunlandi #", ticket);
                }
                else
                {
                    Print("TakeProfit muvaffaqiyatli yopildi #", ticket);
                }
            }
        }
    }
}
