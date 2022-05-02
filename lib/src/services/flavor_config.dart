import 'package:meta/meta.dart';

import '../utils/enum_utils.dart';

enum Flavor { NONPROD, PROD }

class FlavorValues {
  FlavorValues({
    required this.adBannerUnitId,
  });
  final String adBannerUnitId;
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final FlavorValues values;

  static FlavorConfig? _instance;

  factory FlavorConfig({required Flavor flavor, required FlavorValues values}) {
    _instance ??= FlavorConfig._internal(flavor, StringUtils.enumName(flavor.toString()), values);
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.name, this.values);
  static FlavorConfig? get instance {
    return _instance;
  }

  static bool isProd() => _instance!.flavor == Flavor.PROD;
  static bool isNonprod() => _instance!.flavor == Flavor.NONPROD;
}
