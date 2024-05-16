import 'package:api_service/api_service.dart';
import 'package:core_feature/core_feature.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiServiceImpl extends ApiService {
  final Dio dio;
  final Left<ApiFailure, Response<T>> Function<T>(
    DioException dioError,
  )? exceptionHandler;
  final String emptyErrorMessage;

  ApiServiceImpl({
    final String? baseUrl,
    final List<Interceptor> interceptors = const [],
    this.exceptionHandler,
    this.emptyErrorMessage = '',
  }) : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? '',
            connectTimeout: const Duration(milliseconds: 20000),
            receiveTimeout: const Duration(milliseconds: 20000),
          ),
        ) {
    dio.interceptors.addAll(
      [
        if (kDebugMode) LoggerInterceptor(),
        ...interceptors,
      ],
    );
  }

  @override
  Future<Either<ApiFailure, Response<T>>> get<T>(
    final String path, {
    final Map<String, dynamic>? queryParameters,
    final dynamic data,
    final Options? options,
    final CancelToken? cancelToken,
    final ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final res = await dio.get<T>(
        path,
        cancelToken: cancelToken,
        data: data,
        onReceiveProgress: onReceiveProgress,
        options: options,
        queryParameters: queryParameters,
      );

      return Right(res);
    } on DioException catch (dioError) {
      return _handleException<T>(dioError);
    }
  }

  @override
  Future<Either<ApiFailure, Response<T>>> post<T>(
    final String path, {
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final dynamic data,
    final CancelToken? cancelToken,
    final ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final res = await dio.post<T>(
        path,
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
        queryParameters: queryParameters,
      );

      return Right(res);
    } on DioException catch (dioError) {
      return _handleException<T>(dioError);
    }
  }

  @override
  Future<Either<ApiFailure, Response<T>>> put<T>(
    final String path, {
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final dynamic data,
    final CancelToken? cancelToken,
    final ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final res = await dio.put<T>(
        path,
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
        queryParameters: queryParameters,
      );

      return Right(res);
    } on DioException catch (dioError) {
      return _handleException<T>(dioError);
    }
  }

  @override
  Future<Either<ApiFailure, Response<T>>> patch<T>(
    final String path, {
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final dynamic data,
    final CancelToken? cancelToken,
    final ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final res = await dio.patch<T>(
        path,
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
        queryParameters: queryParameters,
      );

      return Right(res);
    } on DioException catch (dioError) {
      return _handleException<T>(dioError);
    }
  }

  @override
  Future<Either<ApiFailure, Response<T>>> delete<T>(
    final String path, {
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final dynamic data,
    final CancelToken? cancelToken,
  }) async {
    try {
      final res = await dio.delete<T>(
        path,
        data: data,
        cancelToken: cancelToken,
        options: options,
        queryParameters: queryParameters,
      );

      return Right(res);
    } on DioException catch (dioError) {
      return _handleException<T>(dioError);
    }
  }

  Left<ApiFailure, Response<T>> _handleException<T>(
    final DioException dioError,
  ) =>
      exceptionHandler?.call<T>(dioError) ?? _defaultExceptionHandler(dioError);

  Left<ApiFailure, Response<T>> _defaultExceptionHandler<T>(
    final DioException dioError,
  ) =>
      Left(
        dioError.response != null && dioError.response!.statusCode != null
            ? ApiFailure.fromStatusCode(
                statusCode: dioError.response!.statusCode!,
                message: dioError.response!.data ?? emptyErrorMessage,
              )
            : UnknownApiFailure(
                message: emptyErrorMessage,
              ),
      );
}
