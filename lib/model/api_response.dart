class APIResponse<T> {
  var data;
  bool error;
  var message;
  // int? statusCode;

  APIResponse({
    this.data,
    this.error = false,
    this.message,
  });

  factory APIResponse.fromJson(Map<String, dynamic> data) {
    return APIResponse(
        error: data['error'] != null ||
            (data["statusCode"] != null && data["statusCode"] > 300),
        message: data['message'],
        data: data);
  }
}
// class ApiResponse<T> {
//   T? data;
//   ApiResponse({this.data});

//   factory ApiResponse.fromJson(
//     Map<String, dynamic> json, {
//     T Function(Map<String, dynamic>)? parser,
//   }) {
//     return ApiResponse(
//       data: parser != null ? parser(json) : null,
//     );
//   }
// }