

String clearHTML(String html) {
  html = html.replaceAll(new RegExp("&amp;"),"&");
  html = html.replaceAllMapped(new RegExp("&#(\\d+);"),(m) => new String.fromCharCode(int.parse(m.group(1))));
  return html;
}

class Deal {
  final String imagePath;
  final String title;
  final String content;
  //const Deal({this.imagePath, this.title});

  Deal.fromMap(Map<String, dynamic> map):
        imagePath=map["_embedded"]["wp:featuredmedia"][0]["source_url"],
        title=clearHTML(map["title"]["rendered"]),
        content=clearHTML(map["content"]["rendered"])
  ;
}