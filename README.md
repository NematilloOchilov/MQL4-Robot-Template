# MyExpert — MQL4 Algorithmic Trading Robot

**Muallif:** Ne'matillo Ochilov  
**Loyiha turi:** Proprietary (All rights reserved)  
**Status:** Faol ishlab chiqilmoqda

---

## 🧠 Loyiha haqida

`MyExpert` — bu ko‘p valyuta juftliklarda ishlay oladigan, risk va maniy menejmentni o‘z ichiga olgan va foydalanuvchi sozlashlariga moslashadigan kuchli algoritmik robot.

Loyiha quyidagi bloklarga ajratilgan:

- 🔹 **Money Management** – Lot hajmini balans va risk asosida avtomatik hisoblaydi
- 🔹 **Risk Management** – Har bir bitimda foizli riskni belgilaydi (masalan, 1%)
- 🔹 **Strategy** – Narx haftalik maksimumni yorib o‘tib, 23.6% Fib retest qilganda RSI asosida bitim ochiladi

---

## ⚙️ Texnik tafsilotlar

- **Tillar:** MQL4 (.mq4, .mqh)
- **Platforma:** MetaTrader 4
- **Juftliklar:** EURUSD, GBPUSD va boshqa major pairs
- **Tayanch indikatorlar:** Fibonacci retracement, RSI(14)
- **Bitim chastotasi:** Har bir valyuta juftligida 2-3 ta trade / hafta

---

## 📌 Ishlash mexanizmi

1. Narx haftalik maksimumni yuqoriga yorib o‘tsa
2. Fibonacci 0% dan 100% ga (kunlik max → min) tortiladi
3. Narx 23.6% darajaga qaytadi (retest)
4. RSI(14) = 30 ga tegsa:
    - 2 ta bir xil hajmli *buy* ochiladi
    - 1-chi TP = Fib 50%
    - 2-chi TP = Fib 76%
    - SL = Fib -11%
    - Agar 1-TP yopilsa, 2-TP’ning SL = 23% ga ko‘chiriladi (breakeven)

---

## 🔒 Litsenziya

