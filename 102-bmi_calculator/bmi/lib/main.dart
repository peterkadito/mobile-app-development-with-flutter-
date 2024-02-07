import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'components/image_banner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _remark = "Please enter your weight and height to calculate your BMI";
  String _bmi = "-";

  Future<void> calculateBMI() async {
    final String url = "http://127.0.0.1:5000/calculate_bmi"; // Adjust the IP address as needed

    try {
      print("Before HTTP request");
      final response = await http.post(
        Uri.parse(url),
        body: {
          "weight": _weightController.text,
          "height": _heightController.text,
        },
      );
      print("After HTTP request");

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _remark = data['remark'];
          _bmi = "Your BMI is: ${data['bmi']}";
        });
      } else {
        setState(() {
          _remark = "Error calculating BMI";
          _bmi = "-";
        });
      }
    } catch (error) {
      print("Error during HTTP request: $error");
      setState(() {
        _remark = "Error calculating BMI";
        _bmi = "-";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: <Widget>[
              const ImageBanner("images/background.png"),
              Center(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 64, 0, 0),
                      child: Text(
                        "Your BMI is:",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          vertical: 12),
                      child: Text(
                        _bmi,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 24),
                      ),
                    ),
                    Text(
                      _remark,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration:
                  const InputDecoration(labelText: "Weight (Kg)"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _heightController,
                  decoration:
                  const InputDecoration(labelText: "Height (m)"),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  onPressed: calculateBMI,
                  child: const Text("CALCULATE"),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: SizedBox(
                height: 20,
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Body mass index, or BMI, is used to determine whether "
                          "you are in a healthy weight range for your height",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "* This calculator shouldn't be used for pregnant women or children",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
