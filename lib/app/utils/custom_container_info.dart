import 'package:flutter/material.dart';
import 'package:islamy/app/resources/color_manager.dart';
import 'package:islamy/app/resources/values.dart';

class CustomContainerInfo extends StatelessWidget {
  const CustomContainerInfo({
    super.key,
    required this.titel,
    required this.subtitel,
    required this.image,
    required this.height,
  });
  final String titel, subtitel, image;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.s200 * 1.5,
      height: height,
      padding: const EdgeInsets.symmetric(
        horizontal: AppMargin.m16,
        vertical: AppMargin.m8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.transparent,
      ),
      child: Column(
        spacing: AppMargin.m16,
        children: [
          const SizedBox(height: AppMargin.m16),
          CircleAvatar(
            radius: 81,
            backgroundColor: Colors.black,
            child: CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(image),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              titel,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? ColorManager.gold
                    : ColorManager.black,
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              subtitel,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? ColorManager.gold
                    : ColorManager.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
