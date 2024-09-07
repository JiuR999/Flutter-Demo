import 'package:shared_preferences/shared_preferences.dart';
 
/// 管理SharedPreferences的键和值。
class SharedPreferencesManager {
  // 单例对象
  static final SharedPreferencesManager _instance = SharedPreferencesManager._internal();
  // SharedPreferences的实例
  late final Future<SharedPreferences> _prefsFuture;
 
  // 私有构造函数，用于创建类的单例实例
  SharedPreferencesManager._internal() {
    _prefsFuture = _init();
  }
 
  // 异步初始化，确保在使用SharedPreferences之前已完成初始化
  Future<SharedPreferences> _init() async {
    return await SharedPreferences.getInstance();
  }
 
  // 提供一个getter来获取单例对象
  static SharedPreferencesManager get instance => _instance;
 
  // 使用泛型方法来获取键对应的值。
  // 根据泛型参数T的类型，决定使用哪个SharedPreferences的getter方法。
  Future<T> get<T>(SharedPreferencesKey key) async {
    final SharedPreferences prefs = await _prefsFuture; // 等待初始化完成
    String keyString = key.toString();
    // 尝试获取值，如果不存在则返回null
    Object? value;
    if (T == String) {
      value = prefs.getString(keyString) ?? defaultValues[key] as T;
    } else if (T == bool) {
      value = prefs.getBool(keyString) ?? defaultValues[key] as T;
    } else if (T == int) {
      value = prefs.getInt(keyString) ?? defaultValues[key] as T;
    } else if (T == double) {
      value = prefs.getDouble(keyString) ?? defaultValues[key] as T;
    } else if (T == List) {
      // 特别注意：我们假设List类型指的是List<String>
      value = prefs.getStringList(keyString) ?? defaultValues[key] as T;
    } else {
      // 如果类型不支持，则抛出异常
      //throw Exception('Unsupported type');
    }
    // 如果找不到值，则返回null，否则返回值
    return value as T;
  }
 
  // 使用泛型方法设置值
  Future<bool> set<T>(SharedPreferencesKey key, T value) async {
    final SharedPreferences prefs = await _prefsFuture; // 等待初始化完成
    String keyString = key.toString();
    if (value is String) {
      return prefs.setString(keyString, value);
    } else if (value is bool) {
      return prefs.setBool(keyString, value);
    } else if (value is int) {
      return prefs.setInt(keyString, value);
    } else if (value is double) {
      return prefs.setDouble(keyString, value);
    } else if (value is List<String>) {
      return prefs.setStringList(keyString, value);
    } else {
      //throw Exception('Unsupported type');
      return false;
    }
  }
 
  // 这里定义所有默认值
  // 默认值一定要包含完整，要为每个key对应一个默认值
  static final Map<SharedPreferencesKey, Object> defaultValues = {
    SharedPreferencesKey.didGuide: false,
    SharedPreferencesKey.isSubscribeValid: false,
    SharedPreferencesKey.fontSizeProgress: 0.45,
    SharedPreferencesKey.theme:0,
    SharedPreferencesKey.fontColorHex: '#FFFFFFFF',
    SharedPreferencesKey.backgroundColorHex: '#7F000000',
  };
}
 
/// 定义一个枚举，包含所有keys和它们对应的类型
enum SharedPreferencesKey {
  // 引导状态的键，与布尔类型关联
  didGuide(bool),
  // 订阅是否有效
  isSubscribeValid(bool),
  //设置-选择主题
  theme(int),
  // 设置-字体大小进度（0~1乘以最大字体）
  fontSizeProgress(double),
  // 设置-字体颜色
  fontColorHex(String),
  // 设置-字体背景色
  backgroundColorHex(String);
  
  // 存储枚举值关联的类型
  final Type type;
  // 枚举构造函数
  const SharedPreferencesKey(this.type);
}