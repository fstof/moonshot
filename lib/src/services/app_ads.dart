import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'flavor_config.dart';

class AppAds {
  static final String _bannerUnitId = FlavorConfig.instance!.values.adBannerUnitId;

  static late BannerAd myBanner;

  static void init() {
    myBanner = BannerAd(
      adUnitId: _bannerUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('##### Ad loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('##### Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('##### Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('##### Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('##### Ad impression.'),
      ),
    );
    myBanner.load();
  }
}
