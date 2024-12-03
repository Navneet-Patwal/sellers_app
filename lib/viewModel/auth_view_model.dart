import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers/global/global_ins.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

class AuthViewModel{
  ValidateSignUpForm(XFile? imageXFile,String password, String confirmPassword, String name, String email, String phone, String locationAddress, BuildContext context) async{
    if(imageXFile==null){
      commonViewModel.showSnackBar("Please Select Image File", context);
      return;
    }
    else{
      if(password == confirmPassword){
        if(name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && phone.isNotEmpty && locationAddress.isNotEmpty){
          await createUserInFirebaseAuth(email,password,context);
          //TODO uploadImageToStorage()
        }
        else{
          commonViewModel.showSnackBar("Please fill all fields", context);
          return;
        }
      }
      else{
        commonViewModel.showSnackBar("Password do not match", context);
        return;
      }
    }
  }


  createUserInFirebaseAuth(String email, String password,BuildContext context)async{
    User? currentFirebaseUser;
    await FirebaseAuth.instance.createUserWithEmailAndPassword
      (
        email: email,
        password: password
    ).then((valueAuth){
      currentFirebaseUser = valueAuth.user;
    }).catchError((errorMessage){
      commonViewModel.showSnackBar(errorMessage, context);
    });

    if(currentFirebaseUser==null){
      return;
    }
  }
  uploadImageToStorage(imageXFile){

  }

}