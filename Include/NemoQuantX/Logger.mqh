#ifndef __LOGGER_MQH__
#define __LOGGER_MQH__

void Log(string msg) {
   Print(TimeToString(TimeCurrent(), TIME_DATE | TIME_SECONDS) + " | " + msg);
}

#endif
