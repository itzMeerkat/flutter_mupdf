// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BBox _$BBoxFromJson(Map<String, dynamic> json) => BBox(
      json['x'] as int,
      json['y'] as int,
      json['w'] as int,
      json['h'] as int,
    );

Map<String, dynamic> _$BBoxToJson(BBox instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'w': instance.w,
      'h': instance.h,
    };

Font _$FontFromJson(Map<String, dynamic> json) => Font(
      json['name'] as String,
      json['family'] as String,
      json['weight'] as String,
      json['style'] as String,
      json['size'] as int,
    );

Map<String, dynamic> _$FontToJson(Font instance) => <String, dynamic>{
      'name': instance.name,
      'family': instance.family,
      'weight': instance.weight,
      'style': instance.style,
      'size': instance.size,
    };

Line _$LineFromJson(Map<String, dynamic> json) => Line(
      json['text'] as String,
      json['wmode'] as int,
      json['x'] as int,
      json['y'] as int,
      BBox.fromJson(json['bbox'] as Map<String, dynamic>),
      Font.fromJson(json['font'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LineToJson(Line instance) => <String, dynamic>{
      'text': instance.text,
      'wmode': instance.wmode,
      'x': instance.x,
      'y': instance.y,
      'bbox': instance.bbox,
      'font': instance.font,
    };

Block _$BlockFromJson(Map<String, dynamic> json) => Block(
      json['type'] as String,
      BBox.fromJson(json['bbox'] as Map<String, dynamic>),
    )..lines = (json['lines'] as List<dynamic>)
        .map((e) => Line.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{
      'type': instance.type,
      'bbox': instance.bbox,
      'lines': instance.lines,
    };

PdfText _$PdfTextFromJson(Map<String, dynamic> json) => PdfText()
  ..blocks = (json['blocks'] as List<dynamic>)
      .map((e) => Block.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$PdfTextToJson(PdfText instance) => <String, dynamic>{
      'blocks': instance.blocks,
    };
