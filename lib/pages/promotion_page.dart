import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/cart_provider.dart';

class PromotionPage extends StatelessWidget {
  const PromotionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final hasPaidReservation = cartProvider.hasPaidReservation();

    // Obtener los tipos de servicios pagados
    final List<String> paidServices = cartProvider.getPaidServices();

    // Promociones basadas en el tipo de servicio
    final Map<String, List<Map<String, String>>> promotions = {
      'Corte': [
        {
          'title': 'Descuento del 20%',
          'description': '20% de descuento en tu próximo corte de cabello.*',
          'color': '0xFFFFD1DC',
        },
        {
          'title': '2x1 en cortes',
          'description': '¡Paga uno y llévate dos cortes de cabello!*',
          'color': '0xFFFFC1E3',
        },
      ],
      'Manicura': [
        {
          'title': 'Descuento del 15%',
          'description': '15% de descuento en tu próxima manicura.*',
          'color': '0xFFFFC1E3',
        },
        {
          'title': '2x1 en manicura',
          'description': '¡Paga uno y llévate dos sesiones de manicura!*',
          'color': '0xFFFFD1DC',
        },
      ],
      'Maquillaje': [
        {
          'title': 'Descuento del 10%',
          'description': '10% de descuento en tu próximo maquillaje.*',
          'color': '0xFFFFC8E6',
        },
        {
          'title': '2x1 en maquillaje',
          'description': '¡Paga uno y llévate dos sesiones de maquillaje!*',
          'color': '0xFFFFCEF2',
        },
      ],
    };

    // Filtrar promociones basadas en los servicios pagados
    final List<Map<String, String>> filteredPromotions = [];

    paidServices.forEach((service) {
      if (promotions.containsKey(service)) {
        filteredPromotions.addAll(promotions[service]!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Promociones',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: hasPaidReservation
          ? ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Presenta la promoción que deseas al pagar el servicio completo en el salón.\nSolo puedes usar una promoción por servicio.',
                    style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                ),
                ...filteredPromotions.map((promo) {
                  return PromotionCard(
                    title: promo['title']!,
                    description: promo['description']!,
                    backgroundColor: Color(int.parse(promo['color']!)),
                  );
                }).toList(),
              ],
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Reserva y paga a través de la app para obtener promociones exclusivas!',
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }
}

class PromotionCard extends StatelessWidget {
  final String title;
  final String description;
  final Color backgroundColor;

  const PromotionCard({
    Key? key,
    required this.title,
    required this.description,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontSize: 18, // Reduce the font size for bold text
                ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
