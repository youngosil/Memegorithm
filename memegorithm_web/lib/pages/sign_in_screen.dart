import 'package:flutter/material.dart';
import 'package:memegorithm_web/firebase_authentication.dart';

class SignInScreen extends StatelessWidget {
  static const routeName = '/';
  final AuthenticationService _authService;

  SignInScreen({super.key, required AuthenticationService authService})
      : _authService = authService;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/memegorithm_base.png'),
                    fit: BoxFit.cover)),
            child: Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 30),
                    child: const Text(
                      '밈고리즘',
                      style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'Chanel',
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                      width: 500,
                      child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                              labelText: '이메일',
                              labelStyle: TextStyle(
                                  fontFamily: 'Gulim', color: Colors.black),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.zero,
                              )),
                          style: const TextStyle(
                              fontFamily: 'Gulim', color: Colors.black))),
                  const SizedBox(height: 7),
                  SizedBox(
                      width: 500,
                      child: TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                              labelText: '비밀번호(6자리 이상)',
                              labelStyle: TextStyle(
                                  fontFamily: 'Gulim', color: Colors.black),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.zero,
                              )),
                          obscureText: true,
                          style: const TextStyle(
                              fontFamily: 'Gulim', color: Colors.black))),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            // 회원가입 버튼을 눌렀을 때 회원가입 서비스를 사용
                            await _authService.signUpWithEmailAndPassword(
                              emailController.text,
                              passwordController.text,
                            );
                          } catch (e) {
                            print('Error during user registration: $e');
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey), // 배경색
                          elevation:
                              MaterialStateProperty.all<double>(1), // 그림자
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                          ), // 내부 여백
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black), // 테두리 색
                            ),
                          ),
                        ),
                        child: const Text('회원가입',
                            style: TextStyle(
                                fontFamily: 'Gulim',
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            // 로그인 버튼을 눌렀을 때 로그인 서비스를 사용
                            await _authService.signInWithEmailAndPassword(
                              emailController.text,
                              passwordController.text,
                            );
                          } catch (e) {
                            print('Error during user login: $e');
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey), // 배경색
                          elevation:
                              MaterialStateProperty.all<double>(1), // 그림자
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                          ), // 내부 여백
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black), // 테두리 색
                            ),
                          ),
                        ),
                        child: const Text('로그인',
                            style: TextStyle(
                                fontFamily: 'Gulim',
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}
