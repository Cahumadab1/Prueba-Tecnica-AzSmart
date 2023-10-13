import 'package:flutter/material.dart';

class Forecast extends StatelessWidget {

  const Forecast({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pronóstico de 3 días'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pronóstico para los próximos 3 días:',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
