bool isRequiredValid(dynamic val) {
  if (val == null) return false;
  if (val is String && val.trim().isEmpty) return false;
  return true;
}
