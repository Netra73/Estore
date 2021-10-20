String? validateName(String value,String error) {
  if (value == null || value.isEmpty) {
    return error;
  } else {
    return null;
  }
}

String? fieldRquired(String value,String error) {
  if (value == null || value.isEmpty) {
    return error;
  } else {
    return null;
  }
}

String? validateMobile(String value,String error) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(pattern);
  if (!regExp.hasMatch(value)) {
    return error;
  } else {
    return null;
  }
}

String? mobileRequired(String value,String error) {
  if (value == null || value.isEmpty) {
    return error;
  } else {
    return validateMobile(value,error);
  }
}

String? validateEmail(String value,String error) {
  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern.toString());
  if (!regex.hasMatch(value))
    return error;
  else
    return null;
}

String? emailRequired(String value,String error) {
  if (value == null || value.isEmpty) {
    return error;
  } else {
    return validateEmail(value,error);
  }
}