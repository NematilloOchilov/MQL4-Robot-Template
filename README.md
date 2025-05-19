# NemoQuantX — MQL4 Algorithmic Trading Robot

- **Muallif:** Ne'matillo Ochilov Strategist, MQL4 developer va algoritmik savdo bo‘yicha mustaqil tadqiqotchi.
- **Dasturchi:** Ne'matillo Ochilov
- **Loyiha turi:** Shaxsiy (barcha huquqlar himoyalangan)
- **Status:** Faol ishlab chiqilmoqda

---

## 🧠 Loyiha haqida

`NemoQuantX` — bu ko‘p valyuta juftliklarda ishlay oladigan, risk va money menejmentni o‘z ichiga olgan va foydalanuvchi sozlashlariga moslashadigan kuchli algoritmik robot.

Loyiha quyidagi bloklarga ajratilgan:

- 🔹 **Money Management** – Lot hajmini balans va risk asosida avtomatik hisoblaydi
- 🔹 **Risk Management** – Har bir bitimda foizli riskni belgilaydi (masalan, 1%)
- 🔹 **Strategy** – Narx haftalik maksimumni yorib o‘tib, 23.6% Fib retest qilganda RSI asosida bitim ochiladi
- 🔹 **Logger** – Xatoliklar va muhim voqealarni yozib boradi
- 🔹 **ErrorHelper** – Xatoliklar mazmuni majmui

---

## ⚙️ Texnik tafsilotlar

- **Tillar:** MQL4 (.mq4, .mqh, .ini, .md)
- **Platforma:** MetaTrader 4
- **Juftliklar:** XAU/USD, EUR/USD, USD/JPY, GBP/USD, USD/CHF, AUD/USD, USD/CAD, NZD/USD
- **Tayanch indikatorlar:** Fibonacci retracement, RSI(14)
- **Bitim chastotasi:** Har bir valyuta juftligida 2-3 ta savdo / hafta

---

## 📌 Ishlash mexanizmi
**Sotib olish**
1. Narx haftalik maksimumni yuqoriga yorib o‘tsa
2. Fibonacci 0% dan 100% ga (kunlik max → min) tortiladi
3. Narx 23.6% darajaga qaytadi (retest)
4. RSI(14) = 30 ga tegsa 2 ta bir xil hajmli *buy* ochiladi
    - 1-chi TP = Fib 50%
    - 2-chi TP = Fib 76%
    - SL = Fib -11%
    - Agar 1-TP yopilsa, 2-TP’ning SL = 23% ga ko‘chiriladi (breakeven)
  
**Sotish**
1. Narx haftalik minium pastga yorib o‘tsa
2. Fibonacci 0% dan 100% ga (kunlik min → max) tortiladi
3. Narx 23.6% darajaga qaytadi (retest)
4. RSI(14) = 70 ga tegsa 2 ta bir xil hajmli *sell* ochiladi
    - 1-chi TP = Fib 50%
    - 2-chi TP = Fib 76%
    - SL = Fib -11%
    - Agar 1-TP yopilsa, 2-TP’ning SL = 23% ga ko‘chiriladi (breakeven)

---

## 🔒 Litsenziya

---

## 📬 Bog‘lanish
- **NemoQuantX robotining to‘liq funksional `.ex4` versiyasi sotilmaydi!**
- Agar siz alohida strategiya/robot buyurtma bermoqchi bo‘lsangiz:
- 📈 **Telegram:** [@Nematillo_Ochilov](https://t.me/Nematillo_Ochilov)
- 🌐 **GitHub:** [github.com/NematilloOchilov](https://github.com/NematilloOchilov)

---

> 💡 Ushbu loyiha algoritmik savdo sohasida professional, barqaror, nazoratli va xavfsiz bitimlarni amalga oshirish uchun yaratilmoqda.
****

