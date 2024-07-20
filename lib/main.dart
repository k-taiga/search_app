import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'product_provider.dart';
import 'settings_provider.dart';
import 'settings_page.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  ThemeData _lightTheme() {
    return ThemeData(brightness: Brightness.light, primarySwatch: Colors.blue);
  }

  ThemeData _darkTheme() {
    return ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      themeMode: settings.theme == "Light" ? ThemeMode.light : ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(settings.language == "English"
              ? "Riverpod Sample App"
              : "リバーポッドサンプルアプリ"),
          actions: [
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                })
          ],
        ),
        body: Column(
          children: [
            SearchBar(),
            Expanded(child: ProductList()),
          ],
        ));
  }
}

class SearchBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    String labelText =
        settings.language == "English" ? "Search Products" : "商品を検索";

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          onChanged: (value) =>
              ref.read(productProvider.notifier).search(value),
          decoration: InputDecoration(
            // Placeholderの文字
            labelText: labelText,
            border: const OutlineInputBorder(),
          )),
    );
  }
}

class ProductList extends ConsumerWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> products = ref.watch(productProvider);
    return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(products[index]));
        });
  }
}
