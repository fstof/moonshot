import 'main.dart' as main_app;
import 'src/services/flavor_config.dart';

void main() async {
  setupProdAdfreeFlavor();
  main_app.main();
}

void setupProdAdfreeFlavor() {
  FlavorConfig(
    flavor: Flavor.PROD,
    values: FlavorValues(
      adBannerUnitId: '#{admobbannerid}#',
    ),
  );
}
