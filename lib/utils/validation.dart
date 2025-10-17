class Validation {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required";
    final regex = RegExp(r"^[^@]+@[^@]+\.[^@]+");
    if (!regex.hasMatch(value)) return "Enter a valid email";
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return "$fieldName cannot be empty";
    return null;
  }

  static String? validateNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return "$fieldName is required";
    if (double.tryParse(value) == null) return "$fieldName must be a number";
    return null;
  }
}
