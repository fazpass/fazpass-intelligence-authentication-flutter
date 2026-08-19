import 'package:fia_example/fia_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GatewayPage extends StatefulWidget {
  const GatewayPage({super.key});

  @override
  State<GatewayPage> createState() => _GatewayPageState();
}

class _GatewayPageState extends State<GatewayPage> {
  final _fiaService = FiaService();

  late final gateways = _fiaService.lastGatewayPromise?.gateways ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick an auth type')),
      body: ListView.builder(
        itemCount: gateways.length,
        itemBuilder: (context, index) {
          final gateway = gateways[index];
          return ListTile(
            title: Text(gateway.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pickGateway(gateway.number),
          );
        },
      ),
    );
  }

  void _pickGateway(int number) async {
    try {
      await _fiaService.pickGateway(number);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/validate');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (c) => AlertDialog(
              title: Text('Error'),
              content: Text('$e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(c),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }
  }
}
