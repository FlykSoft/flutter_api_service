class ServerFailureMessage {
  final String message;

  ServerFailureMessage({
    required this.message,
  });

  factory ServerFailureMessage.fromJson(
    final Map<String, dynamic> json, {
    String? jsonKey,
  }) {
    final failure = json[jsonKey ?? 'error'];
    return ServerFailureMessage(
      message: (failure is int ? failure.toString() : failure),
    );
  }

  Map<String, dynamic> toJson({
    String? jsonKey,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[jsonKey ?? 'error'] = message;

    return data;
  }
}
