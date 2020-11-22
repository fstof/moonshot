import 'main.dart' as main_app;
import 'src/services/flavor_config.dart';

void main() async {
  FlavorConfig(
    flavor: Flavor.PROD,
    values: FlavorValues(
      showAds: true,
      testAds: false,
      adAppId: '#{admobappid}#',
      adBannerUnitId: '#{admobbannerid}#',
    ),
  );
  main_app.main();
}
