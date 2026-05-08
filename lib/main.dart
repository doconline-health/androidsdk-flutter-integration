import 'package:flutter/material.dart';
import 'package:mental_health_module/doconline_initializer.dart';
import 'package:mental_health_module/mha_lib/uikit/ui_colors.dart';
import 'package:sdkdoconline/api_service.dart';
import 'package:sdkdoconline/doconline_sdk_launcher.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primaryColorLight: UIColor.blue,
        scaffoldBackgroundColor: UIColor.backgroundColor,
        fontFamily: 'Nunito',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//Sample Text Fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _countryIdController = TextEditingController();
  final TextEditingController _memberIdController = TextEditingController();
  final TextEditingController _serviceStartController = TextEditingController();
  final TextEditingController _serviceEndController = TextEditingController();

  bool _isLoading = false;


  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileNoController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _countryIdController.dispose();
    _memberIdController.dispose();
    _serviceStartController.dispose();
    _serviceEndController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: UIColor.white,
        appBar: AppBar(title: const Text('DocOnlineSDK'),backgroundColor: UIColor.white,),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(_firstNameController, "First name"),
              _buildTextField(_middleNameController, "Middle name"),
              _buildTextField(_lastNameController, "Last name"),
              _buildTextField(_emailController, "Email"),
              _buildTextField(_mobileNoController, "Mobile no"),
              _buildTextField(_dobController, "Date of birth"),
              _buildTextField(_genderController, "Gender"),
              _buildTextField(_countryIdController, "Country id"),
              _buildTextField(_memberIdController, "Member id"),
              _buildTextField(_serviceStartController, "Service start date"),
              _buildTextField(_serviceEndController, "Service end date"),

              const SizedBox(height: 15),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _goToDocOnlineSdk(""),
                child: const Text('Go to DocOnline SDK'),
              ),

              ElevatedButton(
                onPressed: _goToDocOnlineSdk("consultation"),
                child: const Text('Book a consultation'),
              ),

              ElevatedButton(
                onPressed: _goToDocOnlineSdk("diagnostics"),
                child: const Text('Diagnostics'),
              ),

              ElevatedButton(
                onPressed: _goToDocOnlineSdk("pharmacy"),
                child: const Text('Buy Medicine'),
              ),

              const SizedBox(height: 25),

              const Text('',
                style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }


  void _goToDocOnlineSdk(String type) async {
    setState(() {
      _isLoading = true;
    });

    // Gather all data into a Map
    final Map<String, String> requestData = {

      "first_name": _firstNameController.text.trim(),
      "middle_name": _middleNameController.text.trim(),
      "last_name": _lastNameController.text.trim(),
      "email": _emailController.text.trim(),
      "mobile_no": _mobileNoController.text.trim(),
      "date_of_birth": _dobController.text.trim(),
      "gender": _genderController.text.trim(),
      "country_id": _countryIdController.text.trim(),
      "member_id": _memberIdController.text.trim(),
      "service_starts_at": _serviceStartController.text.trim(),
      "service_ends_at": _serviceEndController.text.trim(),
    };
    debugPrint(requestData.toString());
    try {
      final apiResponse = await ApiService.getUserData(requestData);
      debugPrint("API RESPONSE: $apiResponse");
      if (apiResponse != null) {
        if (apiResponse.responseCode == 200) {
          await DocOnlineSDKLauncher.openDocOnlineSdk(requestData, apiResponse.responseBody,type);
        } else {
          final Map<String, dynamic> jsonError = apiResponse.responseBody;
          final String message = jsonError['message']?.toString() ?? "An unknown error occurred";

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),),);
          }
        }
      }

    } catch (e) {
      debugPrint("Error: $e");
    }finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

@pragma('vm:entry-point')
Future<void> docOnlineInitializer() async {
  await DocOnlineInitializer.init();
}

