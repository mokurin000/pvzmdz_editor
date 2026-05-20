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

/// 商店物品
@JsonEnum(alwaysCreate: true, valueField: 'value')
enum ShopItem {
  /// 永久增加 25 初始阳光（基础值为 50）
  initialSun(0, '初始阳光'),

  /// 增加猫豆子子弹伤害，购买第 20 次时解锁卡牌“猫豌豆射手”
  catFood(1, '猫粮'),

  /// 商店特供版：无冷却时间、0 阳光消耗的樱桃炸弹
  cherryBomb(2, '樱桃炸弹'),

  /// 开局自动种植一个阳光精灵球
  sunSpiritBall(3, '阳光精灵球'),

  /// 开局从天上掉落一个僵尸精灵球
  zombieSpiritBall(4, '僵尸精灵球'),

  /// 从第 3 轮开始时天上掉落一个礼盒
  skyGiftBox(5, '天降礼盒'),

  /// 每次关卡结算额外获得 +10 金币
  investment(6, '投资'),

  /// 每次获得货币时额外 +1
  currencyInvestment(7, '货币投资'),

  /// 抽取劣质卡牌
  randomBadPack(8, '随机劣卡包'),

  /// 特殊道具 / 卡牌解锁
  brokenLeafUmbrella(9, '破烂叶子保护伞'),

  /// 抽取普通品质卡牌
  randomNormalPack(10, '随机普通卡包'),

  /// 抽取稀有品质卡牌
  randomRarePack(11, '随机稀有卡包'),

  /// 抽取史诗品质卡牌
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

/// 游戏难度
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

/// 存档数据
@JsonSerializable()
class GameData {
  /// 玩家拥有的卡牌（卡槽中的植物卡牌ID列表）
  final List<int> scores;

  /// 商店当前上架的物品ID列表
  ///
  /// 注意：长度必须为 0（未使用商店）或正好 6 个
  @JsonKey(unknownEnumValue: null)
  final List<ShopItem> shangdian;

  /// 商店物品是否已售出，与 `shangdian` 下标一一对应
  final List<bool> shangdianYishou;

  /// 未使用字段（预留）
  final List<int> shangdianyigong;

  /// 限定抽卡卡池（特殊模式下可用的卡牌ID）
  final List<int> scores2;

  /// 未使用字段（预留）
  final List<int> pospos;

  /// 未使用字段（预留）
  final List<int> dates;

  /// 玩家名称列表（目前仅作预留，实际未使用）
  final List<String> playerNames;

  /// 音乐音量（范围 0.0 ~ 1.0）
  final double music;

  /// 音效音量（范围 0.0 ~ 1.0）
  final double sf;

  /// 游戏难度
  ///
  /// 0 = 正常，1 = 简单，2 = 困难
  @JsonKey(unknownEnumValue: null)
  final DifficultyT Difficulty;

  /// 冒险模式当前关卡序号（从 1 开始，最大通常为 50）
  final int Maoxian;

  /// IFA 模式当前关卡序号
  final int MaoxianIFA;

  /// 冰天雪地模式当前关卡序号
  final int MaoxianSnow;

  /// 游戏分辨率宽度（默认 1280）
  final int heng;

  /// 游戏分辨率高度（默认 720）
  final int shu;

  /// 是否全屏模式
  final bool quanping;

  /// 垂直同步（同时用于存档合法性校验）
  final bool chuizhitongbu;

  /// 平板模式
  final bool pingban;

  /// 普通无尽模式当前层数
  final int wujinceng;

  /// 限定抽卡无尽当前层数
  final int wujinceng2;

  /// 限定抽卡无尽历史最高层数
  final int wujinceng2Last;

  /// IFA 无尽当前层数
  final int wujinceng3;

  /// 卡槽不遮挡
  final bool kcZheDang;

  /// 显示血量
  final bool hpShow;

  /// 关闭“不安之树”特效
  final bool treeVanishOff;

  /// 当前金币数量
  final int coin;

  /// 初始阳光购买次数（每次购买 +25 初始阳光，基础值为 50）
  final int chushisun;

  /// 猫粮购买次数（第 20 次解锁“猫豌豆射手”）
  final int maoliang;

  /// 商店樱桃炸弹剩余使用次数
  final int coinYingtao;

  /// 阳光精灵球剩余使用次数
  final int sunPokeCishu;

  /// 僵尸精灵球剩余使用次数
  final int zmPokeCishu;

  /// 天降礼盒剩余使用次数
  final int tianjianglihe;

  /// 投资购买次数（每次结算额外 +10 金币）
  final int touzi;

  /// 货币投资购买次数（每次货币额外 +1）
  final int touzi2;

  /// 是否已购买劣质卡包
  final bool liekabao;

  /// 是否已购买普通卡包
  final bool ptkabao;

  /// 是否已购买稀有卡包
  final bool xykabao;

  /// 是否已购买史诗卡包
  final bool sskabao;

  /// 是否已购买残破叶子保护伞
  final bool canbaohusan;

  /// 自定义关卡僵尸ID列表
  final List<int> CustomZombieList;

  /// 自定义关卡僵尸对应生成数量
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

  /// 默认数据（与你提供的存档一致）
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
      "music": 0.30,
      "sf": 0.30,
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

  /// 商店物品数量是否合法
  bool get isValidShop => shangdian.isEmpty || shangdian.length == 6;
}
