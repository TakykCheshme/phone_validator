import 'dart:ui';

import 'package:flutter/material.dart';


class ResizeModel<T>{

 late final T _xSmall;
 late final T _small;
 late final T _medium;
 late final T _large;
 late final T _xlarge;
 late final double totalWidth;
 late final T value;

  T _invoke(){
     if(totalWidth <= 380 ){
       return _xSmall;
     }
     else if(totalWidth>380 && totalWidth <= 414){
       return _small;
     }
     else if(totalWidth>414 && totalWidth<=600){
       return _medium;
     }
     else if(totalWidth>600 && totalWidth<=800){
       return _large;
     }
     else{
       return _xlarge;
     }
  }

  ResizeModel({T? xSmall ,required T small, T? medium, T? large, T? xlarge,required this.totalWidth }):
    _xSmall = xSmall ?? small,
    _small = small,
    _medium = medium ?? small,
    _large = large ?? small,
    _xlarge = xlarge ?? small
    {
      value = _invoke();
    }

}


class Sizing{
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _blocksizeHorizontal = 0;
  static late double _blockSizeVertical = 0;
  static late double horizontalPadding;
  static late double topPadding;
  static late double bottomPadding;
  static late double aspectRatio;

  void init( BoxConstraints constraints, Orientation orientation ){
    if( orientation == Orientation.portrait ){
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
    }
    else{
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
    }
    _blocksizeHorizontal = _screenWidth/100;
    _blockSizeVertical = _screenHeight/100;

    horizontalPadding = _blocksizeHorizontal*4;
    topPadding =  MediaQueryData.fromWindow(window).padding.top;
    bottomPadding = MediaQueryData.fromWindow(window).padding.bottom;
    aspectRatio =  _blockSizeVertical / _blocksizeHorizontal;
  }
}

extension SizingExtendsion on num{

  double get w => Sizing._blocksizeHorizontal*this;

  double get h => Sizing._blockSizeVertical*this;

  double font(){
    return this*ResizeModel<double>(
      xSmall: 1,
      small: 1.1, 
      medium: 1.15, 
      large: 1.2, 
      xlarge: 1.25,
      totalWidth: Sizing._screenWidth
    ).value;
  }

}

class SizeInitializer extends StatelessWidget {
  const SizeInitializer({required this.child}) : super(key: const Key('sizeInit'));

  final Widget child;

  @override
  Widget build(BuildContext context) {
   return OrientationBuilder(
    builder: (context, orientation) {
      return LayoutBuilder(
        builder: (context, constraints) {
          Sizing().init(constraints, orientation);  
          return child;
        },
      );
    },
  );
  }
}














