#include <Trade\Trade.mqh>

input double LotSize     = 0.1;
input int Distance       = 50;        // В пипсах
input int Slippage       = 3;
input int MagicNumber    = 123456;

CTrade trade;

void OnStart()
{
   double point     = _Point;
   double stopLevel = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * point;
   double distance  = Distance * point;

   if (distance < stopLevel)
   {
      Print("Ошибка: Distance меньше минимального уровня брокера (", stopLevel / point, " пипсов)");
      return;
   }

   double ask, bid;
   if (!SymbolInfoDouble(_Symbol, SYMBOL_ASK, ask) || !SymbolInfoDouble(_Symbol, SYMBOL_BID, bid))
   {
      Print("Не удалось получить цены");
      return;
   }

   double buyPrice  = NormalizeDouble(ask + distance, _Digits);
   double sellPrice = NormalizeDouble(bid - distance, _Digits);

   // BuyStop
   bool buyRes = trade.BuyStop(LotSize, buyPrice, 0, 0, "Grid BuyStop");
   if (!buyRes)
      Print("Ошибка BuyStop: ", trade.ResultRetcode(), " - ", trade.ResultRetcodeDescription());
   else
      Print("BuyStop установлен на ", buyPrice);

   // SellStop
   bool sellRes = trade.SellStop(LotSize, sellPrice, 0, 0, "Grid SellStop");
   if (!sellRes)
      Print("Ошибка SellStop: ", trade.ResultRetcode(), " - ", trade.ResultRetcodeDescription());
   else
      Print("SellStop установлен на ", sellPrice);
}
