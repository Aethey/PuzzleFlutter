class CommonUtil {
  factory CommonUtil() => _getInstance();
  static CommonUtil get instance => _getInstance();
  static CommonUtil _instance;

  CommonUtil._internal() {
    // init
  }

  static CommonUtil _getInstance() {
    if (_instance == null) {
      _instance = new CommonUtil._internal();
    }
    return _instance;
  }

  String getRandomTest(int x) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
  }
}
