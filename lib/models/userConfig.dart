
abstract class KeyName {
  final String key;
  final String name;
  KeyName(this.key, this.name);
}

class CruiseLine implements KeyName {
  final String key;
  final String name;
  final String icon;

  const CruiseLine(this.key, this.name, this.icon);

  toJson() => key;
}

const List<CruiseLine> CruiseLines = const [
  const CruiseLine("royal","Royal Caribbian","royal-caribbean-logo.png"),
  const CruiseLine("thomson","Thomson","logo-thomson.png"),
  const CruiseLine("celebrity","Celebrity Cruises","celebrity-logo.png"),
  const CruiseLine("cunard","Cunard","cunard-logo.png"),
  const CruiseLine("pno","PnO Cruises","pando.png"),
  const CruiseLine("norwegian","Norwegian","logo-ncl.png"),
];

class Destination implements KeyName {
  String key,name;
  toJson() => key;
}

final List<Destination> Destinations =  [
  new Destination()..key="medi"..name="Mediterranean",
  new Destination()..key="carribbean"..name="Carribbean",
];

class TimeOfYear implements KeyName  {
  const TimeOfYear(this.key, this.name);
  final String key, name;
  toJson() => key;
}

const List<TimeOfYear> TimesOfYear = const [
  const TimeOfYear("winter","Winter"),
  const TimeOfYear("spring","Spring"),
  const TimeOfYear("summer","Summer"),
  const TimeOfYear("autumn","Autumn"),
];

const String _anonymousEmail = "anonymous";

class UserConfig {
  UserConfig.Anonymous() {
    email = _anonymousEmail;
  }
  UserConfig();
  String email;
  String name;
  List<String> lines;
  List<String> destinations;
  List<String> times;
  int lengthMin=1;
  int lengthMax=14;
  bool onBoarded = false;

  UserConfig.FromMap(map) {
    this.email = map["email"];
    this.name = map["name"];
    this.lines = map["lines"];
    this.destinations = map["destinations"];
    this.times = map["times"];
    this.onBoarded = map["onBoarded"];
    try {
      this.lengthMin = int.parse(map["lengthMin"]??"1");
      this.lengthMin = int.parse(map["lengthMin"]??"14");
    } catch(e) {

    }
  }
  toJson() => {
    "name":name,"email":email,"lines":lines,"destinations":destinations, "times":times,
    "onBoarded": onBoarded,"lengthMin":lengthMin,"lengthMax":lengthMax};
  toString() => "UserConfig(${toJson()})";
}

typedef void UserConfigUpdate(UserConfig newConfig);