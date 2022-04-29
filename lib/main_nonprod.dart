import 'main.dart' as main_app;
import 'src/services/flavor_config.dart';

void main() async {
  setupNonprodFlavor();
  main_app.main();
}

void setupNonprodFlavor() {
  FlavorConfig(
    flavor: Flavor.NONPROD,
    values: FlavorValues(
      testAds: true,
      adBannerUnitId: 'ca-app-pub-3940256099942544/6300978111', // test adID
    ),
  );
}
