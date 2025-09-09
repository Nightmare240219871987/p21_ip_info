import 'package:flutter/material.dart';
import 'package:p21_ip_info/src/features/ip_details/presentation/info.dart';

// ignore: must_be_immutable
class GetIp extends StatelessWidget {
  final TextEditingController _ipCtrl = TextEditingController();
  late BuildContext context;

  GetIp({super.key});

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Text("Get IP", style: TextStyle(fontSize: 24)),
              TextField(
                controller: _ipCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "IP",
                  hintText: "Geben sie Domain oder IP Addresse ein",
                ),
              ),
              ElevatedButton(
                onPressed: _onGetInfoPressed,
                child: Text("Hole Informationen"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onGetInfoPressed() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => Info(ip: _ipCtrl.text)));
    _ipCtrl.text = "";
  }
}
