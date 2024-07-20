import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:search_app/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ProductNotifierはUserSettingsを受け取り、商品リストを管理する
final productProvider =
    StateNotifierProvider<ProductNotifier, List<String>>((ref) {
  return ProductNotifier(ref.watch(settingsProvider));
});

// ProductProviderが管理するNotifier List<String>の型
class ProductNotifier extends StateNotifier<List<String>> {
  UserSettings settings;

// superで親のStateNotifierを呼び出し、初期値を設定する
// StateNotifierはRiverpodの一部でアプリ全体の状態を管理するため一度初期化する必要がある
  ProductNotifier(this.settings) : super([]) {
    _updateProductList();
  }

  void _updateProductList() {
    List<String> productList = settings.language == "English"
        ? ["Apple", "Banana", "Cherry", "Orange", "Peach", "Grape"]
        : ["りんご", "ばなな", "さくらんぼ", "みかん", "もも", "ぶどう"];
    state = productList;
  }

  void search(String query) {
    _updateProductList();
    if (query.isNotEmpty) {
      state = state
          .where(
              (product) => product.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
