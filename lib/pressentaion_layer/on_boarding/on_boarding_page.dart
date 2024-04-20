import 'package:flutter/material.dart';
import 'package:daily_schedules/shared/constants/colors.dart';
import 'package:daily_schedules/shared/constants/components.dart';
import 'package:daily_schedules/shared/constants/images.dart';
import 'package:daily_schedules/shared/constants/routes.dart';
import 'package:daily_schedules/shared/local/cache_helper.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 15, vertical: 35),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "WELCOME TO".toUpperCase(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  Container(
                    margin: const EdgeInsetsDirectional.only(bottom: 80.0),
                    color: mainColor,
                    padding: const EdgeInsetsDirectional.all(5),
                    child: Text(
                      "daily schedule app".toUpperCase(),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Image.asset(
                    logo_image,
                    fit: BoxFit.contain,
                    width: 200,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "Organize your time by divide each day to hours and decide what to do at each hour",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ElevatedButton(
                      onPressed: () {
                        CacheHelper.setData(
                            key: "isBoardingPageShaw", value: true).then((value)
                        => navigateAndFinish(context, mainRoute));
                        ;
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40),
                        backgroundColor: mainColor,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Adjust radius as desired
                        ),
                      ),
                      child: Text(
                        "lets go".toUpperCase(),
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
