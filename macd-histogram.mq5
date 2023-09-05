//+------------------------------------------------------------------+
//|                                               macd-histogram.mq5 |
//|                                           Copyright 2023, Julio. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Julio."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Header files                                                     |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>

//+------------------------------------------------------------------+
//| Input                                                            |
//+------------------------------------------------------------------+

input double OrderLotSize = 0.01;
input int TakeProfitPoints = 20;
input int StopLossPoints = 20;

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
double TakeProfit;
double StopLoss;

//+------------------------------------------------------------------+
//| Initialize Object                                                |
//+------------------------------------------------------------------+
CTrade Trade;

//+------------------------------------------------------------------+
//| Points to Double Value Function                                  |
//+------------------------------------------------------------------+
double PointsToDouble(int points)
  {
   return points * Point();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsTradeAllowed()
  {
   return((bool)MQLInfoInteger(MQL_TRADE_ALLOWED)
          && (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)
          && (bool)AccountInfoInteger(ACCOUNT_TRADE_ALLOWED)
          && (bool)AccountInfoInteger(ACCOUNT_TRADE_EXPERT))
  }


//+------------------------------------------------------------------+
//| Checking new bar Function                                        |
//+------------------------------------------------------------------+
bool IsNewBar(bool first_call = false)
  {
   static bool result = false;
   if(!first_call)
     {
      return (result);
     }

   static datetime previous_time = 0;
   datetime current_time = iTime(Symbol(), Period(), 0);
   result = false;

   if(previous_time = current_time)
     {
      previous_time = current_time;
      result = true;
     }

   return (result);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenTrade(ENUM_ORDER_TYPE type)
  {
   double price;
   double tp;
   double sl;

   if(type == ORDER_TYPE_BUY)
     {
      price = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
      sl = price - StopLoss;
      tp = price + TakeProfit;
     }
   else
     {
      price = SymbolInfoDouble(Symbol(), SYMBOL_BID);
      sl = price + StopLoss;
      tp = price - TakeProfit;
     }

   price = NormalizeDouble(price, Digits());
   sl = NormalizeDouble(sl, Digits());
   tp = NormalizeDouble(tp, Digits());

   if(Trade.PositionOpen(Symbol(), type, OrderLotSize, price, sl, tp, NULL))
     {
      Print("Error Occurred");
     }
  }
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(!IsTradeAllowed())
     {
      return;
     }

   if(!IsNewBar(true))
     {
      return;
     }
     
     
//+------------------------------------------------------------------+
   
