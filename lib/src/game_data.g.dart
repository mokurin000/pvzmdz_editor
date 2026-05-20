// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameData _$GameDataFromJson(Map<String, dynamic> json) => GameData(
  scores: (json['scores'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  shangdian: (json['shangdian'] as List<dynamic>)
      .map((e) => $enumDecode(_$ShopItemEnumMap, e))
      .toList(),
  shangdianYishou: (json['shangdianYishou'] as List<dynamic>)
      .map((e) => e as bool)
      .toList(),
  scores2: (json['scores2'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  music: (json['music'] as num).toDouble(),
  sf: (json['sf'] as num).toDouble(),
  Difficulty: $enumDecode(_$DifficultyTEnumMap, json['Difficulty']),
  Maoxian: (json['Maoxian'] as num).toInt(),
  MaoxianIFA: (json['MaoxianIFA'] as num).toInt(),
  MaoxianSnow: (json['MaoxianSnow'] as num).toInt(),
  heng: (json['heng'] as num).toInt(),
  shu: (json['shu'] as num).toInt(),
  quanping: json['quanping'] as bool,
  chuizhitongbu: json['chuizhitongbu'] as bool,
  pingban: json['pingban'] as bool,
  wujinceng: (json['wujinceng'] as num).toInt(),
  wujinceng2: (json['wujinceng2'] as num).toInt(),
  wujinceng2Last: (json['wujinceng2Last'] as num).toInt(),
  wujinceng3: (json['wujinceng3'] as num).toInt(),
  kcZheDang: json['kcZheDang'] as bool,
  hpShow: json['hpShow'] as bool,
  treeVanishOff: json['treeVanishOff'] as bool,
  coin: (json['coin'] as num).toInt(),
  chushisun: (json['chushisun'] as num).toInt(),
  maoliang: (json['maoliang'] as num).toInt(),
  coinYingtao: (json['coinYingtao'] as num).toInt(),
  sunPokeCishu: (json['sunPokeCishu'] as num).toInt(),
  zmPokeCishu: (json['zmPokeCishu'] as num).toInt(),
  tianjianglihe: (json['tianjianglihe'] as num).toInt(),
  touzi: (json['touzi'] as num).toInt(),
  touzi2: (json['touzi2'] as num).toInt(),
  liekabao: json['liekabao'] as bool,
  ptkabao: json['ptkabao'] as bool,
  xykabao: json['xykabao'] as bool,
  sskabao: json['sskabao'] as bool,
  canbaohusan: json['canbaohusan'] as bool,
  shangdianyigong: (json['shangdianyigong'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  pospos: (json['pospos'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  dates: (json['dates'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  playerNames: (json['playerNames'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  CustomZombieList: (json['CustomZombieList'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  CustomSpawnNumber: (json['CustomSpawnNumber'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$GameDataToJson(GameData instance) => <String, dynamic>{
  'scores': instance.scores,
  'shangdian': instance.shangdian.map((e) => _$ShopItemEnumMap[e]!).toList(),
  'shangdianYishou': instance.shangdianYishou,
  'scores2': instance.scores2,
  'music': instance.music,
  'sf': instance.sf,
  'Difficulty': _$DifficultyTEnumMap[instance.Difficulty]!,
  'Maoxian': instance.Maoxian,
  'MaoxianIFA': instance.MaoxianIFA,
  'MaoxianSnow': instance.MaoxianSnow,
  'heng': instance.heng,
  'shu': instance.shu,
  'quanping': instance.quanping,
  'chuizhitongbu': instance.chuizhitongbu,
  'pingban': instance.pingban,
  'wujinceng': instance.wujinceng,
  'wujinceng2': instance.wujinceng2,
  'wujinceng2Last': instance.wujinceng2Last,
  'wujinceng3': instance.wujinceng3,
  'kcZheDang': instance.kcZheDang,
  'hpShow': instance.hpShow,
  'treeVanishOff': instance.treeVanishOff,
  'coin': instance.coin,
  'chushisun': instance.chushisun,
  'maoliang': instance.maoliang,
  'coinYingtao': instance.coinYingtao,
  'sunPokeCishu': instance.sunPokeCishu,
  'zmPokeCishu': instance.zmPokeCishu,
  'tianjianglihe': instance.tianjianglihe,
  'touzi': instance.touzi,
  'touzi2': instance.touzi2,
  'liekabao': instance.liekabao,
  'ptkabao': instance.ptkabao,
  'xykabao': instance.xykabao,
  'sskabao': instance.sskabao,
  'canbaohusan': instance.canbaohusan,
  'shangdianyigong': instance.shangdianyigong,
  'pospos': instance.pospos,
  'dates': instance.dates,
  'playerNames': instance.playerNames,
  'CustomZombieList': instance.CustomZombieList,
  'CustomSpawnNumber': instance.CustomSpawnNumber,
};

const _$ShopItemEnumMap = {
  ShopItem.initialSun: 0,
  ShopItem.catFood: 1,
  ShopItem.cherryBomb: 2,
  ShopItem.sunSpiritBall: 3,
  ShopItem.zombieSpiritBall: 4,
  ShopItem.skyGiftBox: 5,
  ShopItem.investment: 6,
  ShopItem.currencyInvestment: 7,
  ShopItem.randomBadPack: 8,
  ShopItem.brokenLeafUmbrella: 9,
  ShopItem.randomNormalPack: 10,
  ShopItem.randomRarePack: 11,
  ShopItem.randomEpicPack: 12,
};

const _$DifficultyTEnumMap = {
  DifficultyT.normal: 0,
  DifficultyT.easy: 1,
  DifficultyT.hard: 2,
};
