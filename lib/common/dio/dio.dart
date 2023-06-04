import 'package:delivery_app/common/const/data.dart';
import 'package:delivery_app/common/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref){
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(storage: storage)
  );

  return dio;
});

class CustomInterceptor extends Interceptor{
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage});

// 1. 요청 
// 요청이 보내질때마다 accessToken의 값이 true라면 실제 토큰으로 변환
@override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if(options.headers['accessToken'] == 'true'){
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({
        'authorization' :'Bearer $token'
      });
    }

    if(options.headers['refreshToken'] == 'true'){
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'authorization' : 'Bearer $token'
      });
    }
    print('[${options.method}] ${options.uri}');
    return super.onRequest(options, handler);
  }
// 2. 응답.
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(response.data);

    return super.onResponse(response, handler);
  }
// 3. 에러   

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async  {
    //401 에러 
    final refreshToken = await  storage.read(key: REFRESH_TOKEN_KEY);

    if(refreshToken == null){
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

  try{
 if(isStatus401 && !isPathRefresh){
      final dio = Dio();
      final resp = await dio.post('http://localhost:3000/auth/token',
      options: Options(
        headers: {
          'authorization' : 'Bearer $refreshToken'
        }
      ));
      final accessToken = resp.data['accessToken'];

      final options = err.requestOptions;
      options.headers.addAll({
        'authorization' : 'Bearer $accessToken'
      });
      await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

      //요청 재전송
      final response = await dio.fetch(options);
      return handler.resolve(response);
    }
  }on DioError catch (e) {
    return handler.reject(e);
  }
   

    return super.onError(err, handler);
  }
}