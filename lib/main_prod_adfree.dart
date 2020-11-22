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
      showAds: false,
      testAds: false,
      adAppId: '#{admobappid}#',
      adBannerUnitId: '#{admobbannerid}#',
    ),
  );
}
