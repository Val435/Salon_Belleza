import 'package:flutter/material.dart';
import 'package:shop_app_flutter/pages/cart_page.dart';
import 'package:shop_app_flutter/pages/dates_page.dart';
import 'package:shop_app_flutter/pages/login_page.dart';
import 'package:shop_app_flutter/pages/promotion_page.dart';
import 'package:shop_app_flutter/widgets/product_list.dart'; // Importa la página de inicio de sesión

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String username = ModalRoute.of(context)!.settings.arguments as String;
    pages = [
      ProductList(
        username: username,
      ),
      const CartPage(),
      const DatePage(),
      const PromotionPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                setState(() {
                  currentPage = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                setState(() {
                  currentPage = 1;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.event),
              onPressed: () {
                setState(() {
                  currentPage = 2;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.local_offer),
              onPressed: () {
                setState(() {
                  currentPage = 3;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginPage()), // Navega de nuevo a la página de inicio de sesión
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
