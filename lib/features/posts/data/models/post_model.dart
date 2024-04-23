import '../../domain/entities/post_entity.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.title,
    required super.body,
  });

  PostModel copyWith({
    int? id,
    String? title,
    String? body,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return <String, dynamic>{
      'title': title,
      'body': body,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
    );
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(id: json['id'], title: json['title'], body: json['body']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }

  PostModel.fromEntity({required Post postEntity})
      : this(
          id: postEntity.id,
          title: postEntity.title,
          body: postEntity.body,
        );
}

// class PostModel {
//   final int id;
//   final String title;
//   final String body;

//   const PostModel({
//     required this.id,
//     required this.title,
//     required this.body,

//   PostModel copyWith({
//     int? id,
//     String? title,
//     String? body,
//   }) {
//     return PostModel(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       body: body ?? this.body,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'title': title,
//       'body': body,
//     };
//   }

//   factory PostModel.fromMap(Map<String, dynamic> map) {
//     return PostModel(
//       id: map['id'] as int,
//       title: map['title'] as String,
//       body: map['body'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory PostModel.fromJson(String source) => PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() => 'PostModel(id: $id, title: $title, body: $body)';

//   @override
//   bool operator ==(covariant PostModel other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.id == id &&
//       other.title == title &&
//       other.body == body;
//   }

//   @override
//   int get hashCode => id.hashCode ^ title.hashCode ^ body.hashCode;
//   });
// }
