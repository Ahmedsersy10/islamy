import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:islamy/app/utils/custom_container_info.dart';
import 'package:islamy/presentation/components/separator.dart';
import '../../../app/resources/resources.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? ColorManager.darkGrey
          : ColorManager.gold,
      width: AppSize.s200 * 1.7,
      child: Padding(
        padding: const EdgeInsets.only(top: AppPadding.p40),
        child: Column(
          children: [
            // Center(
            //   child: Image.asset(
            //     "assets/images/splash.png",
            //     width: 250,
            //     height: 200,
            //   ),
            // ),
            // getSeparator(context),
            CustomContainerInfo(
              titel: "عبداللّه السرسي \nرحمةالله ورضوانه عليه",
              subtitel:
                  " هذا التطبيق هو صدقة جارية خالصة لوجه الله تعالى، \nعلى روح أخي عبد الله \n أسأل الله العظيم أن يتقبّلها منّا بقبول حسن، وأن يجعل كل خير أو علم يُستفاد منه في ميزان حسناته إلى يوم الدين، وأن يُنوّر قبره، ويُسكنه الفردوس الأعلى بلا حساب ولا سابق عذاب  ويغفر لنا وله ولجميع المسلمين.",
              image: "assets/images/عبدالله.jpg",
              height: 600,
            )
          ],
        ),
      ),
    );
  }

  InkWell _draweritem(String title, void Function() ontap) {
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.only(top: AppMargin.m16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: AppSize.s20),
            ),
            const Icon(Icons.double_arrow)
          ],
        ),
      ),
    );
  }
}
