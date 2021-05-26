class CommonUtil {
  factory CommonUtil() => _getInstance();
  static CommonUtil get instance => _getInstance();
  static CommonUtil _instance;

  CommonUtil._internal() {
    // init
  }

  static CommonUtil _getInstance() {
    _instance ??= CommonUtil._internal();
    return _instance;
  }
}
