import 'dart:core';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/theme.dart';
import 'package:flutter_application_1/pages/palette/svg.dart';
import 'package:flutter_application_1/provider/theme_provider.dart';
import 'package:flutter_application_1/utils/palette.dart';
import 'package:flutter_application_1/utils/shared_preference_util.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_color_utilities/palettes/core_palette.dart';
import 'package:provider/provider.dart';

class SelectThemePage extends StatefulWidget {
  const SelectThemePage({super.key});

  @override
  State<SelectThemePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SelectThemePage> {
  int selectedTheme = 0;  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyTheme().then((value){
        debugPrint("选择主题${value}");
      setState(() {
        selectedTheme = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final presetThemes = PresetThemes.values;

    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text("选择主题"),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.all(48.0),
              margin: const EdgeInsets.only(
                  bottom: 24, top: 16, left: 24, right: 24),
              child: SvgPicture.string(
                parseDynamicColor(PALETTE_SVG,
                    primaryColor: Theme.of(context).colorScheme.primary.value),
                height: 120,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(24.0),
            sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                    childCount: presetThemes.length, (context, index) {
                  return buildSelectablePalette(presetThemes[index].color,index);
                    
                }),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0)),
          )
        ],
      )),
    );

    
  }
    Future<int> getMyTheme() {
    return SharedPreferencesManager.instance.get(SharedPreferencesKey.theme);
  }

    Widget buildSelectablePalette(Color seedColor, int index) {
      //调色板
      final tonalPalettes = CorePalette.contentOf(seedColor.value);
    return GestureDetector(
      onTap: () {
        Provider.of<ThemeNotifier>(context,listen: false).toggleTheme(seedColor);
        SharedPreferencesManager.instance.set<int>(SharedPreferencesKey.theme, index);
        setState(() {
          selectedTheme = index;
        });
      },
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            color: Theme.of(context).secondaryHeaderColor),
        child: ClipOval(
          child: SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              children: [
                Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 48,
                      height: 48,
                      color: Color(tonalPalettes.primary.get(90)),
                    )),
                Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      color: Color(tonalPalettes.tertiary.get(90)),
                    )),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      color: Color(tonalPalettes.secondary.get(60)),
                    )),
                if(index == selectedTheme)
                Positioned(
                    left: 10,
                    right: 10,
                    top: 10,
                    bottom: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(tonalPalettes.primary.get(40)),
                      ),
                      child: const Icon(
                        Icons.check_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}





