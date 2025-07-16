// coverage: false
// coverage:ignore-file


// ENTRY POINT OF PROD APP

import 'package:unice_app/main/main_core.dart';

void main() async {
  initMainCore(enviormentPath: 'env/.env_prod');
}
