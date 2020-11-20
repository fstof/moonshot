import 'package:ads/ads.dart';

import '../cubit/game_cubit.dart';
import 'flavor_config.dart';

class AppAds {
  static Ads _ads;
  static GameCubit _gameCubit;
  static final String _appId = FlavorConfig.instance.values.adAppId;
  static final String _bannerUnitId = FlavorConfig.instance.values.adBannerUnitId;

  static void showBanner() => _ads?.showBannerAd();

  static void hideBanner() => _ads?.closeBannerAd();

  static void init(GameCubit cubit) {
    _gameCubit = cubit;
    _ads ??= Ads(
      _appId,
      bannerUnitId: _bannerUnitId,
      keywords: <String>['games', 'casual', 'moon', 'cat'],
      childDirected: false,
      testing: false,
      listener: (MobileAdEvent event) {
        print('_eventListener: ${event.toString()} happened');
        if (event == MobileAdEvent.clicked) {
          _gameCubit.firebaseAnalytics.logSelectContent(contentType: 'ad', itemId: 'banner');
        }
        if (event == MobileAdEvent.leftApplication) {
          _gameCubit.pauseGameToggle(true);
        }
      },
      anchorType: AnchorType.top,
    );
  }

  static void dispose() => _ads?.dispose();
}
