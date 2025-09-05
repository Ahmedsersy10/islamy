import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:islamy/presentation/components/separator.dart';
import '../../../app/resources/resources.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      width: AppSize.s200 * 1.2,
      child: Padding(
        padding: const EdgeInsets.only(top: AppPadding.p40),
        child: Column(
          children: [
            // Container(
            //   height: AppSize.s140,
            //   width: AppSize.s160,
            //   margin: const EdgeInsets.symmetric(vertical: AppMargin.m20),
            //   decoration: const BoxDecoration(
            //       image: DecorationImage(
            //           image: AssetImage(ImageAsset.launcherIcon), fit: BoxFit.fill)),
            // ),
            _draweritem(AppStrings.pillars.tr(), () {
              Navigator.of(context).pushNamed(Routes.pillarsRoute);
            }),
            getSeparator(context),
            // _draweritem(AppStrings.browse.tr(), () {
            //   Navigator.of(context).pushNamed(Routes.browsenetRoute);
            // })
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
