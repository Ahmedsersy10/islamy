import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:islamy/presentation/home/screens/search/view/search_screen.dart';
import 'package:islamy/presentation/home/screens/settings/view/settings_screen.dart';
// import 'package:islamy/app/utils/custom_search.dart';

import '../../../app/utils/constants.dart';
import '../../../di/di.dart';
import '../../../domain/models/quran/quran_model.dart';
// import '../../../domain/models/prayer_timings/prayer_timings_model.dart';
import '../../components/mydrawer.dart';
import '../../../../../app/resources/resources.dart';

import '../cubit/home_cubit.dart';
import '../screens/quran/cubit/quran_cubit.dart';
// import '../screens/prayer_times/cubit/prayer_timings_cubit.dart';
import '../screens/adhkar/view/adhkar_screen.dart';
import '../screens/hadith/view/hadith_screen.dart';
import '../screens/prayer_times/view/prayer_timings_screen.dart';
import '../screens/quran/view/quran_screen.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<HomeCubit>()..isThereABookMarked(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          bool darkMode = cubit.darkModeOn(context);
          var quranCubit = QuranCubit.get(context);
          List<QuranModel> quranList = quranCubit.quranData;
          // final prayerCubit = PrayerTimingsCubit.get(context);
          return Scaffold(
            key: _scaffoldKey,
            floatingActionButton: null,
            appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(
                  AppStrings.home.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: ColorManager.white),
                ),
                leading: isThereABookMarkedPage
                    ? IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            Routes.quranRoute,
                            arguments: {
                              'quranList': quranList,
                              'pageNo': cubit.getBookMarkPage(),
                            },
                          );
                        },
                        icon: const Icon(Icons.bookmark,
                            color: ColorManager.gold),
                      )
                    : SizedBox(),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return SettingsScreen();
                        },
                      ));
                    },
                    icon: Icon(
                      Icons.settings,
                      size: AppSize.s20.r,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                    icon: Icon(
                      Icons.sort,
                      size: AppSize.s20.r,
                    ),
                  ),
                ]),
            endDrawer: const MyDrawer(),
            body: Padding(
              padding: EdgeInsets.all(AppPadding.p12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: AppSize.s16.h),
                  _HomeCard(
                    iconPath: ImageAsset.quranIcon,
                    title: AppStrings.quran.tr(),
                    darkMode: darkMode,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(
                              title: Text(
                                AppStrings.quran.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: ColorManager.white),
                              ),
                            ),
                            body: const Padding(
                              padding: EdgeInsets.all(8),
                              child: QuranScreen(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: AppSize.s16.h),
                  Expanded(
                    child: GridView.count(
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSize.s12.h,
                      crossAxisSpacing: AppSize.s12.w,
                      childAspectRatio: 1.1,
                      children: [
                        _HomeCard(
                          iconPath: ImageAsset.hadithIcon,
                          title: AppStrings.hadith.tr(),
                          darkMode: darkMode,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => Scaffold(
                                  appBar: AppBar(
                                    title: Text(
                                      AppStrings.hadith.tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(color: ColorManager.white),
                                    ),
                                  ),
                                  body: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: HadithScreen(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        _HomeCard(
                          iconPath: ImageAsset.adhkarIcon,
                          title: AppStrings.adhkar.tr(),
                          darkMode: darkMode,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => Scaffold(
                                  appBar: AppBar(
                                    title: Text(
                                      AppStrings.adhkar.tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(color: ColorManager.white),
                                    ),
                                  ),
                                  body: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: AdhkarScreen(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        _HomeCard(
                          iconPath: ImageAsset.prayerIcon,
                          title: AppStrings.prayerTimes.tr(),
                          darkMode: darkMode,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => Scaffold(
                                  appBar: AppBar(
                                    title: Text(
                                      AppStrings.prayerTimes.tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(color: ColorManager.white),
                                    ),
                                  ),
                                  body: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: PrayerTimingsScreen(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        _HomeCard(
                          iconPath: ImageAsset.searchIcon,
                          title: AppStrings.searchInQuran.tr(),
                          darkMode: darkMode,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SearchScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final bool darkMode;
  final VoidCallback onTap;

  const _HomeCard({
    required this.iconPath,
    required this.title,
    required this.darkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSize.s16.r),
      onTap: onTap,
      child: Card(
        elevation: 3,
        shadowColor: darkMode
            ? ColorManager.darkSecondary
            : ColorManager.lightPrimary.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s16.r),
        ),
        color: darkMode ? ColorManager.darkGrey : ColorManager.lightPrimary,
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: AppSize.s50.r,
                height: AppSize.s50.r,
                colorFilter:
                    const ColorFilter.mode(ColorManager.white, BlendMode.srcIn),
              ),
              SizedBox(height: AppSize.s12.h),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: ColorManager.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Removed unused _DateHeader widget
