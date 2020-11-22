import 'package:ads/ads.dart';

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
      showAds: true,
      testAds: true,
      adAppId: FirebaseAdMob.testAppId,
      adBannerUnitId: BannerAd.testAdUnitId,
    ),
  );
}
