import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartProvider extends ChangeNotifier {
  late String _userId;
  List<Map<String, dynamic>> cart = [];
  List<Map<String, dynamic>> savedItems = [];
  final String cartKeyPrefix = 'cart_';
  final String savedItemsKeyPrefix = 'savedItems_';

  CartProvider() {
    final user = FirebaseAuth.instance.currentUser;
    _userId = user != null ? user.uid : '';
    if (_userId.isNotEmpty) {
      _loadCart();
      _loadSavedItems();
    }
  }

  void _loadCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cartKey = '$cartKeyPrefix$_userId';
    final String? cartData = prefs.getString(cartKey);
    if (cartData != null) {
      cart = List<Map<String, dynamic>>.from(jsonDecode(cartData));
    }
    notifyListeners();
  }

  void _loadSavedItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String savedItemsKey = '$savedItemsKeyPrefix$_userId';
    final String? savedItemsData = prefs.getString(savedItemsKey);
    if (savedItemsData != null) {
      savedItems = List<Map<String, dynamic>>.from(jsonDecode(savedItemsData));
    }
    notifyListeners();
  }

  Future<void> _saveCart() async {
    if (_userId.isNotEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String cartKey = '$cartKeyPrefix$_userId';
      await prefs.setString(cartKey, jsonEncode(cart));
    }
  }

  Future<void> _saveSavedItems() async {
    if (_userId.isNotEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String savedItemsKey = '$savedItemsKeyPrefix$_userId';
      await prefs.setString(savedItemsKey, jsonEncode(savedItems));
    }
  }

  void addProduct(Map<String, dynamic> product) {
    cart.add(product);
    _saveCart();
    notifyListeners();
  }

  void removeProduct(Map<String, dynamic> product) {
    cart.remove(product);
    _saveCart();
    notifyListeners();
  }

  void saveAndClearCart(Map<String, dynamic> cartItem) {
    if (_userId.isNotEmpty) {
      cartItem['paid'] ??= false;
      Map<String, dynamic> savedItem = Map.from(cartItem);
      savedItems.add(savedItem);
      cart.remove(cartItem);
      _saveCart();
      _saveSavedItems();
      notifyListeners();
    }
  }

  void removeSavedProduct(Map<String, dynamic> product) {
    if (_userId.isNotEmpty) {
      savedItems.remove(product);
      _saveSavedItems();
      notifyListeners();
    }
  }

  void markAsPaid(int index) {
    if (_userId.isNotEmpty && index >= 0 && index < savedItems.length) {
      savedItems[index]['paid'] = true;
      _saveSavedItems();
      notifyListeners();
    }
  }

  bool hasPaidReservation() {
    return savedItems.any((item) => item['paid'] == true);
  }

  List<String> getPaidServices() {
    return savedItems
        .where((item) => item['paid'] == true)
        .map<String>((item) => item['type'] as String)
        .toList();
  }
}
