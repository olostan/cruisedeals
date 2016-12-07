
class CruiseLine {
  String key;
  String name;
  toJson() => key;
}

final List<CruiseLine> CruiseLines =  [
  new CruiseLine()..key="royal"..name="Royal Caribbian",
  new CruiseLine()..key="thomson"..name="Thomson",
  new CruiseLine()..key="celebrity"..name="Celebrity Cruises",
  new CruiseLine()..key="gunard"..name="Gunard",
  new CruiseLine()..key="pno"..name="PnO Cruises",
  new CruiseLine()..key="norwegian"..name="Norwegian",
];

class Destination {
  String key,name;
  toJson() => key;
}

final List<Destination> Destinations =  [
  new Destination()..key="medi"..name="Mediterranean",
  new Destination()..key="carribbean"..name="Carribbean",
];

class TimeOfYear {
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
  bool onBoarded = false;

  UserConfig.FromMap(map) {
    this.email = map["email"];
    this.name = map["name"];
    this.lines = map["lines"];
    this.destinations = map["destinations"];
    this.times = map["times"];
    this.onBoarded = map["onBoarded"];
  }
  toJson() => {"name":name,"email":email,"lines":lines,"destinations":destinations, "times":times, "onBoarded": onBoarded};
  toString() => "UserConfig(${toJson()})";
}

typedef void UserConfigUpdate(UserConfig newConfig);