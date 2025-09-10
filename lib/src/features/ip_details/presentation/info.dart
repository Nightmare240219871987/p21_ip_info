import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:world_flags/world_flags.dart' as world_flags;

// ignore: must_be_immutable
class Info extends StatefulWidget {
  final String ip;

  const Info({super.key, required this.ip});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  late Future<Map<dynamic, dynamic>> _future;

  Future<String> _getIp(String ip) async {
    final addrs = await InternetAddress.lookup(Uri.parse(ip).host);
    return addrs[0].address;
  }

  world_flags.WorldCountry _getFlag(String code) {
    late world_flags.WorldCountry wc;
    for (world_flags.WorldCountry w in world_flags.WorldCountry.list) {
      if (w.codeShort == code) {
        wc = w;
        break;
      }
    }
    return wc;
  }

  Future<Map<dynamic, dynamic>> _getIPInformation() async {
    String resolvedIp = await _getIp(widget.ip);
    if (resolvedIp == "") {
      resolvedIp = widget.ip;
    }
    Uri url = Uri.https("api.ipquery.io", "/$resolvedIp");
    Response response = await get(url);
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _future = _getIPInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: FutureBuilder<Map<dynamic, dynamic>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text("Lade IP-Informationen..."),
                      ],
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final double lat =
                      ((snapshot.data!["location"]["latitude"] ?? 0.0) as num)
                          .toDouble();
                  final double lon =
                      ((snapshot.data!["location"]["longitude"] ?? 0.0) as num)
                          .toDouble();

                  return Column(
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
                              Text(Uri.parse(widget.ip).host),
                              Text(snapshot.data!["ip"] ?? ""),
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
                                "Map",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 300,
                                child: FlutterMap(
                                  options: MapOptions(
                                    initialCenter: LatLng(lat, lon),
                                    initialZoom: 8.0,
                                    keepAlive: true,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point: LatLng(lat, lon),
                                          width: 80,
                                          height: 80,
                                          child: Icon(
                                            Icons.location_pin,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
                              Row(
                                spacing: 12,
                                children: [
                                  Text(
                                    snapshot.data!["location"]["country"] ?? "",
                                  ),
                                  world_flags.CountryFlag.simplified(
                                    _getFlag(
                                      snapshot
                                          .data!["location"]["country_code"],
                                    ),
                                    height: 14,
                                  ),
                                ],
                              ),
                              Text(
                                snapshot.data!["location"]["country_code"] ??
                                    "",
                              ),
                              Text(snapshot.data!["location"]["city"] ?? ""),
                              Text(snapshot.data!["location"]["state"] ?? ""),
                              Text(snapshot.data!["location"]["zipcode"] ?? ""),
                              Text(
                                snapshot.data!["location"]["timezone"] ?? "",
                              ),
                              Text(
                                snapshot.data!["location"]["localtime"] ?? "",
                              ),
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
                              Text(
                                "ASN : ${snapshot.data!["isp"]["asn"] ?? ""}",
                              ),
                              Text(
                                "Org : ${snapshot.data!["isp"]["org"] ?? ""}",
                              ),
                              Text(
                                "ISP : ${snapshot.data!["isp"]["isp"] ?? ""}",
                              ),
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
                                "Risk",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Mobilfunk : ${snapshot.data!["risk"]["is_mobile"] ?? ""}",
                              ),
                              Text(
                                "VPN : ${snapshot.data!["risk"]["is_vpn"] ?? ""}",
                              ),
                              Text(
                                "Tor Netzwerk : ${snapshot.data!["risk"]["is_tor"] ?? ""}",
                              ),
                              Text(
                                "Proxy : ${snapshot.data!["risk"]["is_proxy"] ?? ""}",
                              ),
                              Text(
                                "Datacenter : ${snapshot.data!["risk"]["is_datacenter"] ?? ""}",
                              ),
                              Text(
                                "Risikolevel : ${snapshot.data!["risk"]["risk_score"] ?? ""}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasError) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Es ist ein Fehler aufgetreten :(${snapshot.error})",
                      ),
                    ],
                  );
                }
                return Text("Es wurden keine Werte ermittelt.");
              },
            ),
          ),
        ),
      ),
    );
  }
}
