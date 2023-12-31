import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NetworkDisconnected extends StatelessWidget {
  const NetworkDisconnected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.5,
              ),
              Container(
                margin: const EdgeInsets.all(50),
                child: Column(
                  children: [
                    Icon(
                      MdiIcons.connection,
                      size: 80,
                      color: const Color(0xffd3d3d3),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Check Your Internet Connection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffd3d3d3),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
