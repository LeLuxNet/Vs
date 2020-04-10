class Settings {
  bool wakeLock;

  Settings(this.wakeLock);

  Settings.fromMap(Map map) : this(map["wakeLock"]);

  Settings.simple() : this(true);

  Map<String, dynamic> toMap() {
    return {"wakeLock": wakeLock};
  }
}
