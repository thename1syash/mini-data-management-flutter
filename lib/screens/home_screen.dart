import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini_data_management/screens/login_screen.dart';
import 'package:mini_data_management/widgets/gradient_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();

  List<Map<String, String>> addresses = [];
  String userEmail = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('loggedInUser') ?? '';

    final data = prefs.getString('addresses_$userEmail');

    if (data != null) {
      final List decoded = jsonDecode(data);
      addresses = decoded
          .map((e) => {
                'line1': e['line1'].toString(),
                'line2': e['line2'].toString(),
              })
          .toList();
    }

    setState(() => loading = false);
  }

  Future<void> addAddress() async {
    if (address1Controller.text.isEmpty || address2Controller.text.isEmpty) {
      showMessage('Both fields are required');
      return;
    }

    final newAddress = {
      'line1': address1Controller.text,
      'line2': address2Controller.text,
    };

    addresses.add(newAddress);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'addresses_$userEmail',
      jsonEncode(addresses),
    );

    address1Controller.clear();
    address2Controller.clear();

    showMessage('Address saved successfully ✅');
    setState(() {});
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('loggedInUser');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('My Addresses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Logout')),
                  ],
                ),
              );

              if (confirm == true) logout();
            },
          )
        ],
      ),
      body: GradientBackground(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// INPUT CARD
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextField(
                              controller: address1Controller,
                              decoration: const InputDecoration(
                                labelText: 'Address Line 1',
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: address2Controller,
                              decoration: const InputDecoration(
                                labelText: 'Address Line 2',
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: addAddress,
                                child: const Text('Save Address'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ADDRESS LIST / EMPTY STATE
                    Expanded(
                      child: addresses.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_off,
                                    size: 64,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'No addresses added yet',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: addresses.length,
                              itemBuilder: (_, index) {
                                final a = addresses[index];
                                return Card(
                                  child: ListTile(
                                    leading: const Icon(Icons.location_on),
                                    title: Text(a['line1']!),
                                    subtitle: Text(a['line2']!),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
