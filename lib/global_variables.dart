List<DateTime> generateDates() {
  List<DateTime> dates = [];
  DateTime now = DateTime.now();
  int daysAdded = 0;

  // Avanzar al próximo día hábil si hoy es sábado o domingo
  while (daysAdded < 5) {
    now = now.add(Duration(days: 1));
    if (now.weekday >= DateTime.monday && now.weekday <= DateTime.friday) {
      // Generar las fechas dentro del rango de 12 PM a 5 PM
      for (int hour = 12; hour <= 17; hour++) {
        dates.add(DateTime(now.year, now.month, now.day, hour));
      }
      daysAdded++;
    }
  }

  return dates;
}

final List<Map<String, Object>> products = [
  {
    'id': '0',
    'title': 'Cortes de Pelo',
    'price': 5.00,
    'imageUrl': 'assets/images/hair_cut_service.png',
    'description': 'Servicio de corte y peinado para hombres y mujeres.',
    'type': 'Corte',
    'day': generateDates()
  },
  {
    'id': '1',
    'title': 'Manicura',
    'price': 20.00,
    'imageUrl': 'assets/images/manicure_service.png',
    'description':
        'Servicio de cuidado y embellecimiento de las uñas de las manos.',
    'type': 'Manicura',
    'day': generateDates()
  },
  {
    'id': '2',
    'title': 'Maquillaje',
    'price': 25.00,
    'imageUrl': 'assets/images/makeup_service.png',
    'description':
        'Servicio de aplicación de maquillaje para ocasiones especiales o eventos.',
    'type': 'Maquillaje',
    'day': generateDates()
  },
  {
    'id': '3',
    'title': 'Depilación',
    'price': 20.00,
    'imageUrl': 'assets/images/waxing_service.png',
    'description':
        'Servicio de eliminación del vello corporal con técnicas de depilación tradicionales o láser.',
    'type': 'Otros',
    'day': generateDates()
  },
  {
    'id': '4',
    'title': 'Peinados Especiales',
    'price': 20.00,
    'imageUrl': 'assets/images/special_hairstyle_service.png',
    'description':
        'Servicio de peinado para eventos especiales como bodas, graduaciones, etc.',
    'type': 'Corte',
    'day': generateDates()
  },
  {
    'id': '5',
    'title': 'Tratamientos Faciales',
    'price': 35.00,
    'imageUrl': 'assets/images/facial_treatment_service.png',
    'description':
        'Servicio de limpieza, exfoliación y cuidado de la piel facial.',
    'type': 'Otros',
    'day': generateDates()
  },
  {
    'id': '6',
    'title': 'Pedicura',
    'price': 20.00,
    'imageUrl': 'assets/images/pedicure_service.png',
    'description':
        'Servicio de cuidado y embellecimiento de las uñas de los pies.',
    'type': 'Otros',
    'day': generateDates()
  },
  {
    'id': '7',
    'title': 'Extensiones de Pelo',
    'price': 80.00,
    'imageUrl': 'assets/images/hair_extensions_service.png',
    'description':
        'Servicio para agregar longitud y volumen al cabello mediante extensiones.',
    'type': 'Corte',
    'day': generateDates()
  },
  {
    'id': '8',
    'title': 'Masajes',
    'price': 60.00,
    'imageUrl': 'assets/images/massage_service.png',
    'description':
        'Servicio de relajación y alivio del estrés a través de diferentes técnicas de masaje.',
    'type': 'Otros',
    'day': generateDates()
  }
];
