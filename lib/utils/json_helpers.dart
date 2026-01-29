Map<String, dynamic> normalizeResponse(Map<String, dynamic> json) {
  // If server returns envelope { status, code, data }
  if (json.containsKey('data') && json['data'] is Map) {
    return Map<String, dynamic>.from(json['data']);
  }
  return json;
}
