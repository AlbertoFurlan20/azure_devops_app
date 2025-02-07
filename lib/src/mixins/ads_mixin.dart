import 'package:azure_devops/src/services/ads_service.dart';
import 'package:azure_devops/src/widgets/ad_widget.dart';
import 'package:flutter/widgets.dart';

mixin AdsMixin {
  List<AdWithKey> nativeAds = [];

  /// Load new native ads and map them to [AdWithKey] objects with a new global key to force refresh the UI.
  Future<void> getNewNativeAds(AdsService ads) async {
    final newAds = await ads.getNewNativeAds();
    nativeAds = newAds.map((ad) => (ad: ad, key: GlobalKey())).toList();
  }

  /// Whether to show a native ad at the given [index] inside [items] list.
  bool shouldShowNativeAd<T>(List<T> items, T item, int index) =>
      items.indexOf(item) % 5 == 4 && item != items.first && index < nativeAds.length;

  Future<void> showInterstitialAd(AdsService ads, {VoidCallback? onDismiss}) async {
    await ads.showInterstitialAd(onDismiss: onDismiss);
  }
}
