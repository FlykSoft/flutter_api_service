class ServerFailure {
  final String message;

  ServerFailure({
    required this.message,
  });

  factory ServerFailure.fromJson(final Map<String, dynamic> json) {
    final failure = json['error'];
    return ServerFailure(
      message: (failure is int ? failure.toString() : failure),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = message;

    return data;
  }
}
