import 'main.dart' as main_app;
import 'src/services/flavor_config.dart';

void main() async {
  setupProdFlavor();
  main_app.main();
}

void setupProdFlavor() {
  FlavorConfig(
    flavor: Flavor.PROD,
    values: FlavorValues(
      testAds: false,
      adBannerUnitId: '#{admobbannerid}#',
    ),
  );
}
