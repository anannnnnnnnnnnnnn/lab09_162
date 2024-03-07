import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // Perform login action here
      String email = _emailController.text;
      String password = _passwordController.text;

      print(email);
      print(password);

      var url = Uri.parse(
          "https://642021154.pungpingcoding.online/api/login"); // URL ของเว็บไซต์ที่ใช้สำหรับการเรียกข้อมูล
      var response = await http.post(
        url,
        body: jsonEncode(
            {"email": email, "password": password}), // ส่งข้อมูลในรูปแบบ JSON
        headers: {
          HttpHeaders.contentTypeHeader:
              "application/json", // ระบุประเภทข้อมูลที่ส่ง
        },
      );

      // ตรวจสอบสถานะของการเรียก API
      if (response.statusCode == 200) {
        // ทำสิ่งที่คุณต้องการเมื่อ Login สำเร็จ
        print(response.body);
        var jsonStr = jsonDecode(response.body);
        print(jsonStr['user']);
        print(jsonStr['token']);
        SharedPreferences _pref = await pref;
        _pref.setString('username', jsonStr['user']['name']);
      } else {
        // ทำสิ่งที่คุณต้องการเมื่อ Login ไม่สำเร็จ
        print("ล็อคอินไม่สำเร็จ: ${response.statusCode}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login, // เรียกใช้งานฟังก์ชัน _login เมื่อกดปุ่ม
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
