import 'package:dio/dio.dart';
import '../utils/injector.dart';

class DioClient{

  final Dio dio = getIt.get<Dio>();
  final _baseUrl = 'http://192.168.1.107:8000';
  
  static DioClient? _instance;

  DioClient._init();

  factory DioClient(){
    if(_instance != null) return _instance!;
    
    _instance = DioClient._init();
    return _instance!;
  }

  Future sendPostRequest(
    {
      required String endPoint,
      required Map<String, dynamic> map
    }
  ) async {
    
    final url = '$_baseUrl$endPoint';

    Response response;
    try{
      response = await dio.post(
        url,
        data: map
      );
    }on DioException catch (e){
      String errorMessage = e.message ?? "Não há mensagem de erro";
      int? statusCode = e.response?.statusCode;
      String? statusMessage = e.response?.statusMessage;
      return 'Algo de errado ocorreu. Mensagem de erro: $errorMessage. Status code da resposta: $statusCode. Mensagem do status code: $statusMessage';
    }
    

    return {
      'data': response.data,
      'statusCode': response.statusCode
    };
  }
}