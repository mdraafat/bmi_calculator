import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import './login.dart';

void main() {
  runApp(const LoginWidget());
}

class MainApp extends StatefulWidget {
  final String username;

  const MainApp({super.key, required this.username});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentWeight = 90;
  int _currentHeight = 170;
  double _bmi = 0.0;

  void _calculateBMI() {
    double heightInMeters = _currentHeight / 100;
    setState(() {
      _bmi = _currentWeight / (heightInMeters * heightInMeters);
    });
  }

  String _getBMIMessage() {
    if (_bmi == 0.0) return "";

    if (_bmi < 18.5) {
      double diff = 18.5 - _bmi;
      return "You are below average by ${diff.toStringAsFixed(1)} points. \nGet some snacks 🥤🍔🍗🍟";
    } else if (_bmi >= 18.5 && _bmi <= 25) {
      return "You are in the healthy range! \nKeep it up! 💚✨";
    } else {
      double diff = _bmi - 25;
      return "You are above average by ${diff.toStringAsFixed(1)} points. \nDo some exercises 🏋🏽💪🏼";
    }
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              const Icon(Icons.person, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.username,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text('Cancel'),
            ),
            SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("BMI Calculator"),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle),
              iconSize: 32,
              onPressed: _showProfileDialog,
              tooltip: 'Profile',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select your current weight in kg",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(height: 16),
              NumberPicker(
                axis: Axis.horizontal,
                minValue: 40,
                maxValue: 150,
                value: _currentWeight,
                onChanged: (value) => setState(() => _currentWeight = value),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0),
                ),
              ),
              SizedBox(height: 32),
              Text(
                "Select your height in cm",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 300,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Image.asset(
                      'assets/images/man.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  NumberPicker(
                    axis: Axis.vertical,
                    minValue: 120,
                    maxValue: 220,
                    value: _currentHeight,
                    onChanged: (value) =>
                        setState(() => _currentHeight = value),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _calculateBMI,
                    child: Text(
                      "Calculate BMI",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    _bmi > 0 ? "BMI: ${_bmi.toStringAsFixed(1)}" : "",
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
              if (_bmi > 0) ...[
                SizedBox(height: 16),
                Divider(thickness: 1),
                SizedBox(height: 8),
                Text(_getBMIMessage(), textAlign: TextAlign.justify, style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
