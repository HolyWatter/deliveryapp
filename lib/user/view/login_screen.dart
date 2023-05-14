

import 'dart:convert';

import 'package:delivery_app/common/const/colors.dart';
import 'package:delivery_app/common/const/data.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/common/view/root_tab.dart';
import 'package:delivery_app/common/widget/custom_text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    return DefaultLayout(
      child:  SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const _Title(),
                    const SizedBox(height: 20,),
                    const _SubTitle(),
                    const SizedBox(height: 10,),
                    Image.asset(
                      'asset/img/misc/logo.png',
                      width: MediaQuery.of(context).size.width /3 *2,
                    ),
                    CustomTextField(
                      onChanged: (value) {
                        username = value;
                      },
                      hintText: "이메일을 입력해주세요"
                      ),
                      const SizedBox(height: 20,),
                      CustomTextField(
                      onChanged: (value) {
                        password = value;
                      },
                      hintText: "비밀번호를 입력해주세요",
                      isPassword: true,
                      ),
                      const SizedBox(height: 10,),
                      ElevatedButton(
                        onPressed: ()async{
                          final rawString = '$username:$password';

                          Codec<String, String> stringToBase64 = utf8.fuse(base64);
                          String token = stringToBase64.encode(rawString);
                          final res = await dio.post('http://localhost:3000/auth/login', 
                          options :Options(
                            headers: {
                              'authorization' : 'Basic $token',
                            }
                          )
                          );
                          final refreshToken = res.data['refreshToken'];
                          final accessToken = res.data['accessToken'];
                          await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                          await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);         
              
                          

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RootTab(),
                            ),
                            );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PRIMARY_COLOR
                        ),
                        child: const Text(
                          "로그인",
                          ),
                          ),
                        TextButton(
                          onPressed: (){},
                          style: TextButton.styleFrom(
                            foregroundColor: PRIMARY_COLOR
                          ),
                          child: const Text("회원가입",),),
                  ],
                ),
          ),
        ),
      ),
          );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Text("환영합니다!",
    style: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w600
    ),);
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "이메일과 비밀번호를 입력해서 로그인해주세요!\n오늘도 성공적인 주문이 되길 :)",
      style: TextStyle(
        fontSize: 16,
        color: BDOY_TEXT_COLOR
      ),);
  }
}