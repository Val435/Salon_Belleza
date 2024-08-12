import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/cart_provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore

class DatePage extends StatefulWidget {
  const DatePage({Key? key}) : super(key: key);

  @override
  State<DatePage> createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController expirationDateController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    final savedItems = cartProvider.savedItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis citas',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Añadir una advertencia importante
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.yellow,
            child: const Text(
              'IMPORTANTE: Por cualquier cancelación o inconveniencia con la app, por favor llame al número +123456789.',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: savedItems.length,
              itemBuilder: (context, index) {
                final cartItem = savedItems[index];
                final bool paid = cartItem['paid'] ?? false;
                bool showWarning = cartItem['showWarning'] ?? true;

                final DateTime selectedDate = cartItem['day'] as DateTime;
                final DateTime now = DateTime.now();
                final Duration difference = selectedDate.difference(now);
                final bool lessThanThreeHours = difference.inHours < 3;
                bool citaEliminada = false;

                if (!paid && lessThanThreeHours) {
                  citaEliminada = true;
                  showWarning = false;
                }

                // Eliminar la cita si ya ha pasado
                if (selectedDate.isBefore(now)) {
                  cartProvider.removeSavedProduct(cartItem);
                }

                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            AssetImage(cartItem['imageUrl'] as String),
                        radius: 30,
                      ),
                      trailing: paid
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'PAGADO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'NO PAGADO',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Pagar servicio',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          content: Form(
                                            key: _formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        'Número de tarjeta',
                                                  ),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                    LengthLimitingTextInputFormatter(
                                                        16),
                                                  ],
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty ||
                                                        value.length != 16) {
                                                      return 'Número de tarjeta inválido';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                TextFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: 'Nombre',
                                                  ),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                      RegExp(r'[a-zA-Z]'),
                                                    ),
                                                  ],
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Por favor ingrese su nombre';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                TextFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: 'MM/AA',
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                    LengthLimitingTextInputFormatter(
                                                        6),
                                                  ],
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty ||
                                                        value.length != 6) {
                                                      return 'Fecha inválida';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                TextFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: 'CVC',
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                    LengthLimitingTextInputFormatter(
                                                        3),
                                                  ],
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty ||
                                                        value.length != 3) {
                                                      return 'CVC inválido';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Cancelar',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _confirmPayment(
                                                    context, index, cartItem);
                                              },
                                              child: const Text(
                                                'Confirmar',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.payment,
                                    color: Colors.green,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Eliminar servicio',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          content: const Text(
                                            '¿Estás seguro de que quieres eliminar tu cita?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'No',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                cartProvider.removeSavedProduct(
                                                    cartItem);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Sí',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                      title: Text(
                        cartItem['title'].toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      subtitle: Text('Día: ${cartItem['day']}'),
                    ),
                    if (citaEliminada)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Se eliminó la cita por no pago a tiempo',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else if (showWarning)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'ADVERTENCIA: Se cancelará la cita si no se paga',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmPayment(
      BuildContext context, int index, Map<String, dynamic> cartItem) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // Marca el item como pagado
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.markAsPaid(index);
      cartProvider.savedItems[index]['showWarning'] = false;

      // Crea la cita en Firestore
      _createAppointment(context, cartItem);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Servicio pagado'),
        ),
      );
    }
  }

  void _createAppointment(
      BuildContext context, Map<String, dynamic> cartItem) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Maneja el caso en que el usuario no está autenticado
      return;
    }

    final appointment = {
      'userEmail': user.email,
      'date': cartItem['day'],
      'title': cartItem['title'],
      // Otros detalles de la cita
    };

    await FirebaseFirestore.instance
        .collection('appointments')
        .add(appointment);
  }
}
