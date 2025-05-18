//+------------------------------------------------------------------+
//| ErrorHelper.mqh                                                 |
//| Xatolik kodlarini tushunarli matnga aylantiruvchi funksiya      |
//+------------------------------------------------------------------+

#ifndef __ERROR_HELPER_MQH__
#define __ERROR_HELPER_MQH__

string ErrorDescription(int error_code) {
   switch(error_code) {
      case 0:   return "No error";
      case 1:   return "Result is unknown";
      case 2:   return "Common error";
      case 3:   return "Invalid trade parameters";
      case 4:   return "Trade server is busy";
      case 5:   return "Old client terminal version";
      case 6:   return "No connection with trade server";
      case 7:   return "Not enough rights";
      case 8:   return "Too frequent requests";
      case 9:   return "Malfunctional trade operation";
      case 64:  return "Account disabled";
      case 65:  return "Invalid account";
      case 128: return "Trade timeout";
      case 129: return "Invalid price";
      case 130: return "Invalid stops";
      case 131: return "Invalid trade volume";
      case 132: return "Market closed";
      case 133: return "Trade disabled";
      case 134: return "Not enough money";
      case 135: return "Price changed";
      case 136: return "Off quotes";
      case 137: return "Broker busy";
      case 138: return "Requote";
      case 139: return "Order is locked";
      case 140: return "Long positions only allowed";
      case 141: return "Too many requests";
      case 145: return "Modification denied because order is too close to market";
      case 146: return "Trade context is busy";
      case 147: return "Expirations are disabled by broker";
      default:  return "Unknown error: " + IntegerToString(error_code);
   }
}

#endif // __ERROR_HELPER_MQH__
