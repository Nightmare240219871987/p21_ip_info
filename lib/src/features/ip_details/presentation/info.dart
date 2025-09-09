import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

// ignore: must_be_immutable
class Info extends StatefulWidget {
  String ip;

  Info({super.key, required this.ip});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  List<NavigationDestination> destinations = [
    NavigationDestination(icon: Icon(Icons.home), label: "Home"),
    NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
  ];

  Map<dynamic, dynamic> body = {};

  @override
  void initState() {
    super.initState();
    _getIPInformation();
  }

  Future<void> _getIPInformation() async {
    Uri url = Uri.https("api.ipquery.io", "/${widget.ip}");
    Response response = await get(url);
    setState(() {
      body = jsonDecode(response.body);
    });
  }

  String _getValue(String path, String subPath) {
    if (body[path] != null) {
      return body[path][subPath].toString();
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "IP Addresse",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(body["ip"] ?? ""),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Map", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Latitude : ${_getValue("location", "latitude")}"),
                    Text("Longitude : ${_getValue("location", "longitude")}"),
                  ],
                ),
              ),
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_getValue("location", "country")),
                    Text(_getValue("location", "country_code")),
                    Text(_getValue("location", "city")),
                    Text(_getValue("location", "state")),
                    Text(_getValue("location", "zipcode")),
                    Text(_getValue("location", "timezone")),
                    Text(_getValue("location", "localtime")),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Internet Service Provider (ISP)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("ASN : ${_getValue("isp", "asn")}"),
                    Text("Org : ${_getValue("isp", "org")}"),
                    Text("ISP : ${_getValue("isp", "isp")}"),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Risk", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Mobilfunk : ${_getValue("risk", "is_mobile")}"),
                    Text("VPN : ${_getValue("risk", "is_vpn")}"),
                    Text("Tor Netzwerk : ${_getValue("risk", "is_tor")}"),
                    Text("Proxy : ${_getValue("risk", "is_proxy")}"),
                    Text("Datacenter : ${_getValue("risk", "is_datacenter")}"),
                    Text("Risikolevel : ${_getValue("risk", "risk_score")}"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(destinations: destinations),
    );
  }
}
