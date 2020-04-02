import 'package:get_it/get_it.dart';
import 'package:vs/services/data_service.dart';
import 'package:vs/services/data_service_database.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<DataService>(() => DataServiceDatabase());
}