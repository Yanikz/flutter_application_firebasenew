class UserComment {
  final String commenterimg;
  final String commentername;
  final String commentime;
  final String commentcontent;

  final String post_id;

  UserComment({
    required this.commenterimg,
    required this.commentername,
    required this.commentime,
    required this.commentcontent,

    required this.post_id,
  });

  Map<String, dynamic> toJson() => {
        'commenterimg': commenterimg,
        'commentername': commentername,
        'commentime': commentime,
        'commentcontent': commentcontent,
        'post_id': post_id,
      };

  static UserComment fromJson(Map<String, dynamic> json) => UserComment(
        commenterimg: json['commenterimg'],
        commentername: json['commentername'],
        commentime: json['commentime'],
        commentcontent: json['commentcontent'],
        post_id: json['post_id'],
      );
}
