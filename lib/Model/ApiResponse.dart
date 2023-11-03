class ApiResponse<T> {
  final T payload;

  final dynamic? error;
  // ResponseError
  ApiResponse(this.payload, {this.error});

  toJson() => {
    "data": payload,
  };
  get items => payload;
}