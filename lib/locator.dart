import 'package:get_it/get_it.dart';
import 'package:project_stock_market/services/auth.dart';
import 'package:project_stock_market/services/push_notification_services.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthMethods());
  locator.registerLazySingleton(() => PushNotificationServices());
}