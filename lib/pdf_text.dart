import 'package:json_annotation/json_annotation.dart';
part 'pdf_text.g.dart';

@JsonSerializable()
class BBox {
  final int x, y, w, h;

  factory BBox.fromJson(Map<String, dynamic> json) => _$BBoxFromJson(json);

  BBox(this.x, this.y, this.w, this.h);
  Map<String, dynamic> toJson() => _$BBoxToJson(this);
}

@JsonSerializable()
class Font {
  final String name, family, weight, style;
  final int size;

  factory Font.fromJson(Map<String, dynamic> json) => _$FontFromJson(json);

  Font(this.name, this.family, this.weight, this.style, this.size);
  Map<String, dynamic> toJson() => _$FontToJson(this);
}

@JsonSerializable()
class Line {
  final String text;
  final int wmode, x, y;
  final BBox bbox;
  final Font font;

  factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);

  Line(this.text, this.wmode, this.x, this.y, this.bbox, this.font);
  Map<String, dynamic> toJson() => _$LineToJson(this);
}

@JsonSerializable()
class Block {
  final String type;
  final BBox bbox;
  List<Line> lines = [];

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);

  Block(this.type, this.bbox);
  Map<String, dynamic> toJson() => _$BlockToJson(this);
}

@JsonSerializable()
class PdfText {
  List<Block> blocks = [];

  factory PdfText.fromJson(Map<String, dynamic> json) =>
      _$PdfTextFromJson(json);

  PdfText();
  Map<String, dynamic> toJson() => _$PdfTextToJson(this);
}
