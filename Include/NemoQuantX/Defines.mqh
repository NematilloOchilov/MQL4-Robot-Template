//+------------------------------------------------------------------+
//|                      Doimiy qiymatlar                           |
//+------------------------------------------------------------------+

// Xato kodlari
#define ERR_NO_ERROR                0
#define ERR_CHARTOBJECT_NOT_FOUND   4200

// Savdo operatsiyalari
#define OP_BUY          0
#define OP_SELL         1
#define OP_BUYLIMIT     2
#define OP_SELLLIMIT    3
#define OP_BUYSTOP      4
#define OP_SELLSTOP     5

// Ranglar
//#define CLR_NONE        clrNONE
#define CLR_LABEL       clrWhite
#define CLR_BACKGROUND  clrDarkGreen
#define CLR_TEXT        clrRed

// Vaqt oraliklari
#define PERIOD_M1       1
#define PERIOD_M5       5
#define PERIOD_M15      15
#define PERIOD_H1       60
#define PERIOD_D1       1440

// Indikator handlerlari
long zigzagHandle = INVALID_HANDLE;
long rsiHandle = INVALID_HANDLE;

// Global o'zgaruvchilar
struct Signal {
    string type;
    double zigzag1;
    double zigzag2;
    double zigzag3;
    datetime time1;
    datetime time2;
    datetime time3;
    int impulseCandles;
    int flatCandles;
    double fibLength;  // Fibonachi uzunligi
};

Signal currentSignal;
int fiboNameCounter = 1000;

// Telegram bildirishnomalarini yoqish/o'chirish
input bool SendNotifications = true;
