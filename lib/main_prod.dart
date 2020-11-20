import 'main.dart' as main_app;
import 'src/services/flavor_config.dart';

void main() async {
  FlavorConfig(
    flavor: Flavor.PROD,
    values: FlavorValues(
      showAds: true,
      testAds: false,
      adAppId: 'ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx',
      adBannerUnitId: 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx',
    ),
  );
  main_app.main();
}
