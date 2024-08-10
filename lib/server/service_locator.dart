import 'package:get_it/get_it.dart';
import 'package:move_metrics_app/stores/user_store.dart';


final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingleton<UserStore>(UserStore());
}