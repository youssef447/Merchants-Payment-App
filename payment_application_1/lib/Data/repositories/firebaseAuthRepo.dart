import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/FirebaseAuthService.dart';
import '../../core/Network/local/cach_helper.dart';
import '../../Domain/repositories/iAuthRepo.dart';

class FirebaseAuthRepo implements IAuthRepo {
  final FirebaseAuthService _authService;
  const FirebaseAuthRepo(this._authService);
  @override
  Future<String> signInEmailPass({
    required String email,
    required String pass,
  }) async {
//    loadingLogin = true;

    //  emit(LoginLoadingState());
    final response = await _authService.signInEmailPass(
      email: email,
      pass: pass,
    );
    if (CacheHelper.getData(key: response.user!.uid) == null) {
      await _authService.signOut();
      return '';
    }
    return response.user!.uid;
//    await CacheHelper.saveData(key: 'token', value: response.user!.uid);
  }

  @override
  Future<void> signUp(
      {required String email,
      required String firstName,
      required String lastName,
      required String pass,
      required String phone,
      String? imgUrl}) async {
    final response = await _authService.signUp(
      email: email,
      pass: pass,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );
    /*  final storageRef = FirebaseStorage.instance.ref();

      if (profileImage != null) {
        await storageRef
            .child(value.user!.uid)
            .child("profile")
            .putFile(profileImage);

        profileImageUrl = await storageRef
            .child(value.user!.uid)
            .child("profile")
            .getDownloadURL();
      } */
    //create table for merchant information

    await FirebaseFirestore.instance
        .collection('merchants')
        .doc(response.user!.uid)
        .set(
      {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'uid': response.user!.uid,
      },
    );
  }

  @override
  Future<bool> signInWithGoogle() async {
    final response = await _authService.signInWithGoogle();

    if (response != null) {
      if (CacheHelper.getData(key: 'GoogleToken') == null) {
        print('oh shit i\'m storing again');
        await CacheHelper.saveData(
            key: 'GoogleToken', value: response.user!.uid);
        await FirebaseFirestore.instance
            .collection('merchants')
            .doc(response.user!.uid)
            .set(
          {
            'firstName': response.user!.displayName!.split(' ')[0],
            'lastName': response.user!.displayName!.split(' ')[1],
            'email': response.user!.email,
            'phone': response.user!.phoneNumber,
            'uid': response.user!.uid,
          },
        );
      }

      return true;
    }
    return false;
  }

  @override
  Future<void> signOut() async {
    _authService.signOut();
  }

  @override
  Future<String?> sendOTP({required String phoneNumber}) async {
    await _authService.sendOTPCode(phoneNumber: phoneNumber);
    return _authService.verificationId();
  }
}
