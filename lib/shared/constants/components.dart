import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daily_schedules/routes.dart';
import 'package:daily_schedules/shared/constants/colors.dart';

void navigateTo(fromWidgetContext, toRouteName, {arguments}) =>
    Navigator.push(
        fromWidgetContext, MaterialPageRoute(builder: (context) => AppPages().generatePage(RouteSettings(name: toRouteName, arguments: arguments))));

void navigateAndFinish(fromWidgetContext, toRouteName, {arguments}) =>
    Navigator.pushAndRemoveUntil(
        fromWidgetContext,
        MaterialPageRoute(
          builder: (context) => AppPages().generatePage(RouteSettings(name: toRouteName, arguments: arguments)),
        ), (route) {
      return false;
    });

void back(context){
  Navigator.pop(context);
}


Widget buildTitle({required String title,}) =>
    Text(title,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18
      ),
    );

Widget buildField({Function(String value)? onChange,
  bool isForDescription  = false,
  bool isTherePrefixSearchIcon = false,
  required TextEditingController controller, required String placeholder}) =>
    Container(
        margin: const EdgeInsetsDirectional.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ConditionalBuilder(
          condition: isForDescription == false,
          builder: (context) => TextField(
            onChanged: onChange,
            maxLines: 1,
            expands: false,
            maxLength: 22,
            cursorColor: mainColor,
            cursorWidth: 7,
            controller: controller,
            decoration: InputDecoration(
              hintText: placeholder,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              prefixIcon: isTherePrefixSearchIcon ? const Icon(Icons.search) : null
            ),
          ),
          fallback: (context) =>
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: TextField(
                  maxLength: 220,
                  cursorColor: mainColor,
                  cursorWidth: 7,
                  maxLines: null,
                  minLines: 2,
                  style: const TextStyle(
                    textBaseline: TextBaseline.alphabetic,
                  ),
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
        )
    );

Widget buildTitleWithField({Function(String value)? onChange,
  bool isForDescription  = false, required String title,
  required TextEditingController controller, required String placeholder}) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(title: title),
        buildField(isForDescription: isForDescription, onChange: onChange, controller: controller, placeholder: placeholder),
      ],
    );

void getToast({
  required String message,
  required Color bkgColor,
  required Color textColor,
}){
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT, // seconds for android.. // 5 seconds for LONG, 1 for SHORT
    gravity: ToastGravity.TOP,
// timeInSecForIosWeb: 1, // seconds for web
    backgroundColor: bkgColor,
    textColor: textColor,
    fontSize: 16.0,
  );
}


Widget buildNoData({required String image, required String text})=>SingleChildScrollView(
  child: SizedBox(
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50,),
        Image.asset(image, fit: BoxFit.fill, width: 220,),
        Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
        const SizedBox(height: 50,),
      ],
    ),
  ),
);