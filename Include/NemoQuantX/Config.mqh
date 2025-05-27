//+------------------------------------------------------------------+
//|                      Sozlama parametrlari                        |
//+------------------------------------------------------------------+

// Fibonacci sozlamalari
input group "----- Nastroyki_fibonachhi -----"
input bool   AutoRemoveFibos = true;            // Avtomatik fibo chizmalarni o'chirish
input color  FiboColor = clrYellow;             // Fibo chizmalar rangi
input int    MinFibLength = 300;                // Minimal fibo uzunligi (punkt)
input double EntryLevel1 = 38.2;                // 1-kirish darajasi (%)
input double EntryLevel2 = 23.6;                // 2-kirish darajasi (%)
input double CancelLevel = 100.0;               // Buyurtmani bekor qilish darajasi (%)
input double BreakevenLevel = 50.0;             // Break-even darajasi (%)
input double BreakevenSL = 40.0;                // Break-even SL darajasi (%)
input double TP1_38 = 61.8;                     // 38% kirish uchun 1-TP (%)
input double TP2_38 = 90.0;                     // 38% kirish uchun 2-TP (%)
input double SL_38 = -11.0;                     // 38% kirish uchun SL (%)
input double TP1_23 = 50.0;                     // 23% kirish uchun 1-TP (%)
input double TP2_23 = 74.0;                     // 23% kirish uchun 2-TP (%)
input double SL_23 = -11.0;                     // 23% kirish uchun SL (%)

// ZigZag sozlamalari
input group "----- Nastroyki_zigzag_M15 -----"
input int    ZigZagDepth = 5;                   // ZigZag chuqurligi
input int    MinImpulseCandles = 1;             // Minimal impuls shamlar soni
input int    MaxImpulseCandles = 30;            // Maksimal impuls shamlar soni
input double FlatToImpulseRatio = 1.5;          // Flet/Impuls nisbati

// RSI sozlamalari
input group "----- Nastroyki_RSI_M5 -----"
input int    RSITimeframe = 5;                  // RSI timeframe (minut)
input int    RSIPeriod = 14;                    // RSI period

// Risk boshqaruvi
input group "----- Risk menejment -----"
input int    StartTradingHour = 7;              // Savdo boshlash soati
input int    EndTradingHour = 19;               // Savdo tugash soati
input double RiskPerTrade = 0.5;                // Savdo uchun risk (%)
input int    TakeProfitPips = 50;               // Take-profit (punkt)
input int    MaxOpenPositions = 8;              // Maksimal ochiq pozitsiyalar

// Interfeys sozlamalari
input group "----- Nastroyki_fon -----"
input int    PanelX = 1;                        // Panel X pozitsiyasi
input int    PanelY = 15;                       // Panel Y pozitsiyasi
input int    PanelWidth = 300;                  // Panel kengligi
input int    PanelHeight = 300;                 // Panel balandligi
input color  PanelColor = clrDarkBlue;          // Panel rangi

// Qo'shimcha sozlamalar
input group "----- Prochie_Nastroyki -----"
input int    MagicNumber = 0;                   // Magic number
