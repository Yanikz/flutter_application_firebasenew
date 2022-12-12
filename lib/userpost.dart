class UserPost {
  final String post_id;
  final String id;

  final String postimg;
  final String contentpost;
  final String contentbodypost;
  bool favorites;
  bool isLiked;

  UserPost(
      {required this.id,
      required this.post_id,
      required this.postimg,
      required this.contentpost,
      required this.contentbodypost,
      required this.isLiked,
      required this.favorites});

  Map<String, dynamic> toJson() => {
        'id': id,
        'post_id': post_id,
        'postimg': postimg,
        'contentpost': contentpost,
        'contentbodypost': contentbodypost,
        'isLiked': isLiked,
        'favorites': favorites,
      };

  static UserPost fromJson(Map<String, dynamic> json) => UserPost(
      post_id: json['post_id'],
      id: json['id'],
      postimg: json['postimg'],
      contentpost: json['contentpost'],
      contentbodypost: json['contentbodypost'],
      isLiked: json['isLiked'],
      favorites: json['favorites']);
}
