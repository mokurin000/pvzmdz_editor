// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'game_data.g.dart';

/// =========================
/// Error
/// =========================

class GameDataError implements Exception {
  final String message;

  const GameDataError(this.message);

  @override
  String toString() => 'GameDataError: $message';
}

/// =========================
/// ShopItem
/// =========================

@JsonEnum(alwaysCreate: true, valueField: 'value')
enum ShopItem {
  initialSun(0, '初始阳光'),
  catFood(1, '猫粮'),
  cherryBomb(2, '樱桃炸弹'),
  sunSpiritBall(3, '阳光精灵球'),
  zombieSpiritBall(4, '僵尸精灵球'),
  skyGiftBox(5, '天降礼盒'),
  investment(6, '投资'),
  currencyInvestment(7, '货币投资'),
  randomBadPack(8, '随机劣卡包'),
  brokenLeafUmbrella(9, '破烂叶子保护伞'),
  randomNormalPack(10, '随机普通卡包'),
  randomRarePack(11, '随机稀有卡包'),
  randomEpicPack(12, '随机史诗卡包');

  final int value;
  final String displayName;

  const ShopItem(this.value, this.displayName);

  static ShopItem fromValue(int value) {
    return ShopItem.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw GameDataError('无效的商店物品ID: $value'),
    );
  }
}

/// =========================
/// Difficulty
/// =========================

@JsonEnum(alwaysCreate: true, valueField: 'value')
enum DifficultyT {
  normal(0, '正常'),
  easy(1, '简单'),
  hard(2, '困难');

  final int value;
  final String displayName;

  const DifficultyT(this.value, this.displayName);

  static DifficultyT fromValue(int value) {
    return DifficultyT.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw GameDataError('无效的游戏难度值: $value'),
    );
  }
}

/// =========================
/// GameData
/// =========================

@JsonSerializable()
class GameData {
  final List<int> scores;

  @JsonKey(unknownEnumValue: null)
  final List<ShopItem> shangdian;

  final List<bool> shangdianYishou;

  final List<int> scores2;

  final double music;
  final double sf;

  @JsonKey(unknownEnumValue: null)
  final DifficultyT Difficulty;

  final int Maoxian;
  final int MaoxianIFA;
  final int MaoxianSnow;
  final int heng;
  final int shu;
  final bool quanping;
  final bool chuizhitongbu;
  final bool pingban;
  final int wujinceng;
  final int wujinceng2;
  final int wujinceng2Last;
  final int wujinceng3;
  final bool kcZheDang;
  final bool hpShow;
  final bool treeVanishOff;
  final int coin;
  final int chushisun;
  final int maoliang;
  final int coinYingtao;
  final int sunPokeCishu;
  final int zmPokeCishu;
  final int tianjianglihe;
  final int touzi;
  final int touzi2;
  final bool liekabao;
  final bool ptkabao;
  final bool xykabao;
  final bool sskabao;
  final bool canbaohusan;
  final List<int> shangdianyigong;
  final List<int> pospos;
  final List<int> dates;
  final List<String> playerNames;
  final List<int> CustomZombieList;
  final List<int> CustomSpawnNumber;

  const GameData({
    required this.scores,
    required this.shangdian,
    required this.shangdianYishou,
    required this.scores2,
    required this.music,
    required this.sf,
    required this.Difficulty,
    required this.Maoxian,
    required this.MaoxianIFA,
    required this.MaoxianSnow,
    required this.heng,
    required this.shu,
    required this.quanping,
    required this.chuizhitongbu,
    required this.pingban,
    required this.wujinceng,
    required this.wujinceng2,
    required this.wujinceng2Last,
    required this.wujinceng3,
    required this.kcZheDang,
    required this.hpShow,
    required this.treeVanishOff,
    required this.coin,
    required this.chushisun,
    required this.maoliang,
    required this.coinYingtao,
    required this.sunPokeCishu,
    required this.zmPokeCishu,
    required this.tianjianglihe,
    required this.touzi,
    required this.touzi2,
    required this.liekabao,
    required this.ptkabao,
    required this.xykabao,
    required this.sskabao,
    required this.canbaohusan,
    required this.shangdianyigong,
    required this.pospos,
    required this.dates,
    required this.playerNames,
    required this.CustomZombieList,
    required this.CustomSpawnNumber,
  });

  /// default savedata
  factory GameData.defaultData() {
    return GameData.fromJson({
      "scores": [0, 1, 5],
      "shangdian": [],
      "shangdianYishou": [],
      "shangdianyigong": [],
      "scores2": [],
      "pospos": [],
      "dates": [],
      "playerNames": ["MiaoDouziHaToTeMoIIDesu"],
      "music": 0.3,
      "sf": 0.3,
      "CustomZombieList": [0, 1],
      "CustomSpawnNumber": [1, 2, 3, 4, 8, 10],
      "Difficulty": 0,
      "Maoxian": 0,
      "MaoxianIFA": 0,
      "MaoxianSnow": 0,
      "heng": 1280,
      "shu": 720,
      "quanping": false,
      "chuizhitongbu": true,
      "pingban": false,
      "wujinceng": 0,
      "wujinceng2": 0,
      "wujinceng3": 0,
      "wujinceng2Last": 0,
      "kcZheDang": false,
      "hpShow": false,
      "treeVanishOff": false,
      "coin": 0,
      "chushisun": 0,
      "maoliang": 0,
      "coinYingtao": 0,
      "sunPokeCishu": 0,
      "zmPokeCishu": 0,
      "tianjianglihe": 0,
      "touzi": 0,
      "touzi2": 0,
      "liekabao": false,
      "ptkabao": false,
      "xykabao": false,
      "sskabao": false,
      "canbaohusan": false,
    });
  }

  factory GameData.fromJson(Map<String, dynamic> json) =>
      _$GameDataFromJson(json);

  Map<String, dynamic> toJson() => _$GameDataToJson(this);

  /// validate shop item count
  bool get isValidShop => shangdian.isEmpty || shangdian.length == 6;
}
