class AppData {
  static final AppData _appData = new AppData._internal();

  String studID, studName, studCamp, studProg, studSubj, studPass;

  String deviceToken;

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}

final appData = AppData();
