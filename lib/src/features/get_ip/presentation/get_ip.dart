import 'package:flutter/material.dart';
import 'package:p21_ip_info/src/data/shared_prefs.dart';
import 'package:p21_ip_info/src/features/ip_details/presentation/info.dart';

// ignore: must_be_immutable
class GetIp extends StatefulWidget {
  const GetIp({super.key});

  @override
  State<GetIp> createState() => _GetIpState();
}

class _GetIpState extends State<GetIp> {
  final TextEditingController _ipCtrl = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  late BuildContext context;
  bool buttonLocked = true;

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
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _ipCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "IP",
                    hintText: "Geben sie Domain oder IP Addresse ein",
                  ),
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  },
                  validator: (value) {
                    if (value == null) {
                      setState(() {
                        buttonLocked = true;
                      });

                      return "Es wurde nichts eingegeben.";
                    }
                    if (value.isEmpty) {
                      setState(() {
                        buttonLocked = true;
                      });

                      return "Es wurde nichts eingegeben.";
                    }
                    setState(() {
                      buttonLocked = false;
                    });

                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: buttonLocked == true ? null : _onGetInfoPressed,
                child: Text("Hole Informationen"),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: SharedPrefs().getHistory().length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              Info(ip: SharedPrefs().getHistory()[index]),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                      child: Text(SharedPrefs().getHistory()[index]),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    SharedPrefs().clearHistory();
                  });
                },
                child: Text("Historie Löschen"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          child: Icon(Icons.menu),
        ),
      ),
    );
  }

  void _onGetInfoPressed() async {
    setState(() {
      SharedPrefs().addToHistory(_ipCtrl.text);
    });

    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => Info(ip: _ipCtrl.text)));
    _ipCtrl.text = "";
  }
}
