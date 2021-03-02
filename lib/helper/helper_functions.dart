import 'dart:convert';

import 'package:project_stock_market/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
 static String sharedPreferenceUserLoggedInKey = 'ISLOGGEDIN';
 static String sharedPreferenceUser = "USERMODEL";

 static Future<bool> saveUserLoggedInSharedPreference(isUserLoggedIn) async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return await preferences.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
 }

 static Future<bool> getUserLoggedInSharedPreference() async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return await preferences.getBool(sharedPreferenceUserLoggedInKey);
 }

 static Future<bool> saveUserModel(UserModel userModel) async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return await preferences.setString(sharedPreferenceUser, json.encode(userModel));
 }

 static Future<Map<String, dynamic>> getUserModel() async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return await json.decode(preferences.getString(sharedPreferenceUser));
 }

 static resetUserModel() async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return await preferences.remove(sharedPreferenceUser);
 }

 static resetLoggedIn() async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return await preferences.remove(sharedPreferenceUserLoggedInKey);
 }
}