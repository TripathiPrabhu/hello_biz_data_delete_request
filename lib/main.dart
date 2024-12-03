import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello-Bizz',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  DataDeletionPage(),
    );
  }
}


class DataDeletionPage extends StatelessWidget {
  final String recipientEmail = 'prabhuveramas1@gmail.com';

  void _sendEmail(String name, String email, String mobile, String gender) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      queryParameters: {
        'subject': 'Data Deletion Request',
        'body': 'Full Name: $name\nEmail: $email\nMobile: $mobile\nGender: $gender\n\nPlease delete my data from the app server.',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      print('Could not launch email client.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    String email = '';
    String mobile = '';
    String gender = 'Male';

    return Scaffold(
      appBar: AppBar(
        title: Text('Data Deletion Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter your name' : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value == null || !RegExp(r'^\S+@\S+\.\S+$').hasMatch(value)
                    ? 'Enter a valid email'
                    : null,
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mobile'),
                validator: (value) => value == null || value.isEmpty ? 'Enter your mobile' : null,
                onSaved: (value) => mobile = value!,
              ),
              DropdownButtonFormField<String>(
                value: gender,
                onChanged: (value) => gender = value!,
                items: ['Male', 'Female', 'Other']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: InputDecoration(labelText: 'Gender'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _sendEmail(name, email, mobile, gender);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

