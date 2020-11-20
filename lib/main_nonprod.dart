import 'package:ads/ads.dart';

import 'main.dart' as main_app;
import 'src/services/flavor_config.dart';

void main() async {
  setupFlavor();
  main_app.main();
}

void setupFlavor() {
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
