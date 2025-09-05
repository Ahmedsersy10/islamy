import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/resources/resources.dart';
import '../../../../../domain/models/quran/quran_model.dart';
import '../../../../../domain/models/quran/quran_search_model.dart';
import '../../../../../domain/models/hadith/hadith_model.dart';
import '../../../../../domain/models/adhkar/adhkar_model.dart';
import '../../../screens/quran/cubit/quran_cubit.dart';
import '../../../screens/hadith/cubit/hadith_cubit.dart';
import '../../../screens/adhkar/cubit/adhkar_cubit.dart';

enum _ResultType { quran, hadith, adhkar }

class _SearchResultItem {
  final _ResultType type;
  final String title;
  final String preview;
  final Object payload;

  _SearchResultItem({
    required this.type,
    required this.title,
    required this.preview,
    required this.payload,
  });
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<_SearchResultItem> _results = [];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() => _results = []);
      return;
    }

    final isArabic = context.locale.languageCode == "ar";

    final quranCubit = QuranCubit.get(context);
    final hadithCubit = HadithCubit.get(context);
    final adhkarCubit = AdhkarCubit.get(context);

    final List<_SearchResultItem> aggregated = [];

    // Quran search: use prebuilt index for text match, then map to page from full quran list
    for (final QuranSearchModel item in quranCubit.quranSearchData) {
      final text = item.text;
      if (_contains(text, trimmed)) {
        final surah = quranCubit.quranData.firstWhere(
          (s) => s.number == item.surahNumber,
          orElse: () => quranCubit.quranData.isNotEmpty
              ? quranCubit.quranData.first
              : QuranModel(
                  number: 1,
                  name: '',
                  englishName: '',
                  englishNameTranslation: '',
                  revelationType: '',
                  ayahs: const [],
                ),
        );
        final title = isArabic ? surah.name : surah.englishName;
        aggregated.add(
          _SearchResultItem(
            type: _ResultType.quran,
            title: title,
            preview: _preview(text, isRtl: true),
            payload: item,
          ),
        );
      }
    }

    // Hadith search: match in description or text
    for (final HadithModel h in hadithCubit.hadithList) {
      final desc = h.description ?? '';
      final body = h.hadith ?? '';
      if (_contains(desc, trimmed) || _contains(body, trimmed)) {
        final title = desc.isNotEmpty ? desc : (body.length > 16 ? body.substring(0, 16) : body);
        aggregated.add(
          _SearchResultItem(
            type: _ResultType.hadith,
            title: title,
            preview: _preview(body, isRtl: isArabic),
            payload: h,
          ),
        );
      }
    }

    // Adhkar search: match in category or dhikr text
    for (final AdhkarModel a in adhkarCubit.adhkarList) {
      if (_contains(a.category, trimmed) || _contains(a.dhikr, trimmed)) {
        aggregated.add(
          _SearchResultItem(
            type: _ResultType.adhkar,
            title: a.category,
            preview: _preview(a.dhikr, isRtl: isArabic),
            payload: a,
          ),
        );
      }
    }

    setState(() => _results = aggregated);
  }

  bool _contains(String source, String query) {
    return source.toLowerCase().contains(query.toLowerCase());
  }

  String _preview(String text, {bool isRtl = false, int maxWords = 12}) {
    final words = text.split(RegExp(r"\s+")).where((w) => w.isNotEmpty).toList();
    final sliced = words.take(maxWords).join(' ');
    return words.length > maxWords ? "$sliced…" : sliced;
  }

  void _onItemTap(_SearchResultItem item) {
    switch (item.type) {
      case _ResultType.quran:
        final quranCubit = QuranCubit.get(context);
        final quranList = quranCubit.quranData;
        final searchEntry = item.payload as QuranSearchModel;
        final pageNo = _getPageNumber(quranList: quranList, result: searchEntry);
        Navigator.pushNamed(context, Routes.quranRoute, arguments: {
          'quranList': quranList,
          'pageNo': pageNo,
        });
        break;
      case _ResultType.hadith:
        Navigator.pushNamed(context, Routes.hadithRoute, arguments: {
          'hadithModel': item.payload as HadithModel,
        });
        break;
      case _ResultType.adhkar:
        final adhkarCubit = AdhkarCubit.get(context);
        final selected = item.payload as AdhkarModel;
        final category = selected.category;
        final listForCategory = adhkarCubit.getAdhkarFromCategory(
          adhkarList: adhkarCubit.adhkarList,
          category: category,
        );
        Navigator.pushNamed(context, Routes.adhkarRoute, arguments: {
          'adhkarList': listForCategory,
          'category': category,
        });
        break;
    }
  }

  int _getPageNumber({required List<QuranModel> quranList, required QuranSearchModel result}) {
    for (final surah in quranList) {
      for (final ayah in surah.ayahs) {
        if (ayah.number == result.id) {
          return ayah.page;
        }
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Text(
          AppStrings.searchInQuran.tr(),
          style: theme.textTheme.titleLarge?.copyWith(color: ColorManager.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppPadding.p12.w),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(AppSize.s12.r),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onChanged: _onQueryChanged,
                      textInputAction: TextInputAction.search,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? ColorManager.white : ColorManager.black,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: AppPadding.p12.h,
                          horizontal: AppPadding.p12.w,
                        ),
                        hintText: AppStrings.searchInQuran.tr(),
                        border: InputBorder.none,
                      ),
                      textDirection: context.locale.languageCode == 'ar'
                          ? ui.TextDirection.rtl
                          : ui.TextDirection.ltr,
                    ),
                  ),
                  if (_controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        _onQueryChanged('');
                        _focusNode.requestFocus();
                      },
                    ),
                ],
              ),
            ),
            SizedBox(height: AppSize.s12.h),
            Expanded(
              child: _results.isEmpty
                  ? Center(
                      child: Text(
                        AppStrings.noRouteFound.tr(),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.unselectedWidgetColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _results.length,
                      separatorBuilder: (_, __) => Divider(
                        color: theme.dividerColor.withOpacity(0.3),
                        height: AppSize.s8.h,
                      ),
                      itemBuilder: (context, index) {
                        final item = _results[index];
                        return ListTile(
                          onTap: () => _onItemTap(item),
                          leading: _buildLeadingIcon(item.type, theme),
                          title: Text(
                            item.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: ColorManager.gold,
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: AppPadding.p5.h),
                            child: Text(
                              item.preview,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textDirection: context.locale.languageCode == 'ar'
                                  ? ui.TextDirection.rtl
                                  : ui.TextDirection.ltr,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.unselectedWidgetColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(_ResultType type, ThemeData theme) {
    switch (type) {
      case _ResultType.quran:
        return const Icon(Icons.menu_book, color: ColorManager.gold);
      case _ResultType.hadith:
        return const Icon(Icons.article, color: ColorManager.gold);
      case _ResultType.adhkar:
        return const Icon(Icons.favorite, color: ColorManager.gold);
    }
  }
}
