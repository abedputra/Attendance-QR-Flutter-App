import 'package:dio/dio.dart';
import 'package:attendancewithqrwp/core/constants/app_constants.dart';
import 'package:attendancewithqrwp/model/attendance.dart';
import 'package:attendancewithqrwp/utils/utils.dart';

/// API Service for handling attendance API calls
/// Separates API logic from UI layer
class ApiService {
  final Dio _dio = Dio();
  final Utils _utils = Utils();

  /// Send attendance data to server
  /// 
  /// [url] - Base URL of the WordPress site
  /// [key] - Security key
  /// [name] - Employee name
  /// [query] - Command ('in' for check-in, 'out' for check-out)
  /// [location] - Location string
  /// 
  /// Returns [Map] with response data or throws [DioException]
  Future<Map<String, dynamic>> sendAttendance({
    required String url,
    required String key,
    required String name,
    required String query,
    required String location,
  }) async {
    final uri = _utils.getRealUrl(url, AppConstants.apiPath);

    final Map<String, dynamic> body = {
      'location': location,
      'key': key,
      'name': name,
      'q': query,
    };

    final response = await _dio.post(
      uri,
      data: FormData.fromMap(body),
      options: Options(
        receiveTimeout: AppConstants.apiTimeout,
        sendTimeout: AppConstants.apiTimeout,
      ),
    );

    return response.data as Map<String, dynamic>;
  }

  /// Parse API response
  /// 
  /// Returns parsed response with success status and data
  Map<String, dynamic> parseResponse(Map<String, dynamic> responseData) {
    final bool isSuccess = responseData['success'] == true;
    final dynamic responseBody = responseData['data'] ?? responseData;

    return {
      'success': isSuccess,
      'data': responseBody,
    };
  }

  /// Extract attendance data from successful response
  Attendance? extractAttendanceData({
    required Map<String, dynamic> responseBody,
    required String name,
    required String location,
    required String query,
  }) {
    try {
      return Attendance(
        date: responseBody['date']?.toString() ?? '',
        time: responseBody['time']?.toString() ?? '',
        name: name,
        location: responseBody['location']?.toString() ?? location,
        type: responseBody['query']?.toString() ?? query,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get error message from response
  String getErrorMessage(dynamic responseData) {
    if (responseData is Map) {
      final data = responseData['data'] ?? responseData;
      return data['message']?.toString() ??
          responseData['message']?.toString() ??
          'Unknown error occurred';
    }
    return 'Unknown error occurred';
  }

  /// Get error message from DioException
  String getDioErrorMessage(DioException e) {
    if (e.response != null) {
      final responseData = e.response?.data;
      if (responseData is Map) {
        final data = responseData['data'] ?? responseData;
        return data['message']?.toString() ??
            responseData['message']?.toString() ??
            'Server error: ${e.response?.statusCode}';
      }
      return 'Server error: ${e.response?.statusCode}';
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection and server URL.';
      default:
        return 'Network error: ${e.message}';
    }
  }
}
