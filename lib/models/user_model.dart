class UserProfile {
  final String? uid;
  final String? email;
  final String? profileImg;
  final String? nickname;
  final String? gender;
  final String? age;
  final String? height;
  final String? weight;
  final String? mbti;
  final String? bloodType;

  UserProfile({
    this.uid,
    this.email,
    this.profileImg,
    this.nickname,
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.mbti,
    this.bloodType,
  });

  // JSON 데이터를 UserProfile 객체로 변환하기 위한 메서드
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'],
      email: json['email'],
      profileImg: json['profile_img'],
      nickname: json['nickname'],
      gender: json['gender'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
      mbti: json['mbti'],
      bloodType: json['blood_type'],
    );
  }
}
