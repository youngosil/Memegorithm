import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 이메일과 비밀번호를 사용하여 회원가입
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error during user registration: $e');
      return null;
    }
  }

  // 이메일과 비밀번호를 사용하여 로그인
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error during user login: $e');
      return null;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 로그인 상태 변화 확인
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 현재 로그인된 사용자 가져오기
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
