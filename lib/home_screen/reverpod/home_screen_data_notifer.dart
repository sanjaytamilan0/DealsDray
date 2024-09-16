import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:taskproject/model.dart';

enum HomeStatus { loading, success, error }

class HomeState {
  final HomeStatus status;
  final List<Banner> banners;
  final List<Category> categories;
  final List<Product> products;
  final String? errorMessage;

  HomeState({
    this.status = HomeStatus.loading,
    this.banners = const [],
    this.categories = const [],
    this.products = const [],
    this.errorMessage,
  });

  factory HomeState.fromJson(Map<String, dynamic> json) {
    return HomeState(
      status: HomeStatus.success,
      banners: (json['banner_one'] as List)
          .map((item) => Banner.fromJson(item))
          .toList(),
      categories: (json['category'] as List)
          .map((item) => Category.fromJson(item))
          .toList(),
      products: (json['products'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(HomeState()) {
    fetchData();
  }

  Future<void> fetchData() async {
    state = HomeState(status: HomeStatus.loading);

    try {
      final response = await http.get(Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final homeState = HomeState.fromJson(jsonData['data']);
        state = homeState;
      } else {
        state = HomeState(status: HomeStatus.error, errorMessage: 'Failed to load data');
      }
    } catch (e) {
      state = HomeState(status: HomeStatus.error, errorMessage: e.toString());
    }
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});

