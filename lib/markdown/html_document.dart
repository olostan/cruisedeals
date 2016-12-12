class Document {
  List<Node> parse(String data) {
    var r = _parse("<div>${data}</div>");
    return [r.e];
  }
}

class _ParseRes {
  Element e;
  int pos;
}


/*String _attrValue(String v) {
  if (v[0]=="'" || v[0]=='"') return v.substring(1,v.length-1);
  return v;
}*/
String _highLight(String s,int pos) {
  return "${s.substring((pos-10).clamp(0,s.length-1),(pos-1).clamp(0,s.length-1))}-->${s[pos.clamp(0,s.length-1)]}<--${s.substring((pos+1).clamp(0,s.length-1),(pos+10).clamp(0,s.length-1))}";
}
bool strict = false;

_ParseRes _parse(String s,[int pos=0, List<String> opened]) {
  var text = "";
  var startPos = pos;
  List<Node> children = [];
  Map<String, String> attributes = {};

  if (s[pos++]!='<') throw "no start tag!";
  var tag = '';
  while (pos<s.length&&s[pos]!='>') tag +=s[pos++];
  if (tag.contains(" ")) {
    var attribs = tag.substring(tag.indexOf(" "));
    tag = tag.substring(0,tag.length-attribs.length);
    final attrRegEx = new RegExp("(\\w+?)=['\"](.+?)['\"]");
    attrRegEx.allMatches(attribs).forEach( (m) => attributes[m.group(1)]=m.group(2));
    if (attribs[attribs.length-1]=='/') {
      var e = new Element.empty(tag);
      e.attributes.addAll(attributes);
      return new _ParseRes()..e=e..pos=pos;
    }
  }
  var startTagEnds = pos;
  pos++;
  while (pos<s.length) {
    var ch = s[pos];
    if (ch=='<') {
      if (s[pos+1]!='/') {
        var res = _parse(s,pos, opened==null?[tag]:opened..add(tag));
        if (text!="") { children.add(new Text(text));text="";}
        children.add(res.e);
        pos=res.pos+1;
      } else {
        var epos = pos;
        while (pos<s.length&&s[pos]!='>') pos++;
        var endTag = s.substring(epos+2,pos);
        if (endTag!=tag) {
          if (tag == 'img') {
            text = "";
            children = [];
            pos = startTagEnds;
          }
          else
          if (strict) {
            throw "Element '${tag}' (pos ${startPos}) is not closed. Element '${endTag}' (${pos}) was closed instead.";
          } else {
            // check if we have opened tag that match this closing
            if (opened!=null && opened.contains(endTag)) {
              // if we found - we've done with current tag
              pos = epos-1;
            } else {
              pos++;
              //pos = epos;
              continue;
            }
          }
        }
        var element = new Element(tag, children);
        if (attributes.length>0) element.attributes.addAll(attributes);
        if (text!="") element.children.add(new Text(text));
        opened?.removeLast();
        return new _ParseRes()..e=element..pos = pos;
      }
    } else {
      text+=ch;
      pos++;
    }
  }
  if (strict)
    throw "There is unterminating tag <${tag}>: ${_highLight(s,pos)} started here: ${_highLight(s,startPos)}";
  var element = new Element(tag, children);
  if (attributes.length>0) element.attributes.addAll(attributes);
  if (text!="") element.children.add(new Text(text));
  opened?.removeLast();

  return new _ParseRes()..e=element..pos = pos;

}

typedef Node Resolver(String name);

/// Base class for any AST item.
///
/// Roughly corresponds to Node in the DOM. Will be either an Element or Text.
abstract class Node {
  void accept(NodeVisitor visitor);

  String get textContent;
}

/// A named tag that can contain other nodes.
class Element implements Node {
  final String tag;
  final List<Node> children;
  final Map<String, String> attributes;
  String generatedId;

  /// Instantiates a [tag] Element with [children].
  Element(this.tag, this.children) : attributes = <String, String>{};

  /// Instantiates an empty, self-closing [tag] Element.
  Element.empty(this.tag)
      : children = null,
        attributes = {};

  /// Instantiates a [tag] Element with no [children].
  Element.withTag(this.tag)
      : children = [],
        attributes = {};

  /// Instantiates a [tag] Element with a single Text child.
  Element.text(this.tag, String text)
      : children = [new Text(text)],
        attributes = {};

  /// Whether this element is self-closing.
  bool get isEmpty => children == null;

  void accept(NodeVisitor visitor) {
    if (visitor.visitElementBefore(this)) {
      if (children!=null) for (var child in children) child.accept(visitor);
      visitor.visitElementAfter(this);
    }
  }

  String get textContent => children == null
      ? ''
      : children.map((Node child) => child.textContent).join('');
}

/// A plain text element.
class Text implements Node {
  final String text;
  Text(this.text);

  void accept(NodeVisitor visitor) => visitor.visitText(this);

  String get textContent => text;
}

/// Inline content that has not been parsed into inline nodes (strong, links,
/// etc).
///
/// These placeholder nodes should only remain in place while the block nodes
/// of a document are still being parsed, in order to gather all reference link
/// definitions.
class UnparsedContent implements Node {
  final String textContent;
  UnparsedContent(this.textContent);

  void accept(NodeVisitor visitor) => null;
}

/// Visitor pattern for the AST.
///
/// Renderers or other AST transformers should implement this.
abstract class NodeVisitor {
  /// Called when a Text node has been reached.
  void visitText(Text text);

  /// Called when an Element has been reached, before its children have been
  /// visited.
  ///
  /// Returns `false` to skip its children.
  bool visitElementBefore(Element element);

  /// Called when an Element has been reached, after its children have been
  /// visited.
  ///
  /// Will not be called if [visitElementBefore] returns `false`.
  void visitElementAfter(Element element);
}
