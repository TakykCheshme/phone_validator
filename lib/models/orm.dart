import 'package:flutter/material.dart';

mixin BuildableMixin on Orm{
  Widget builder(BuildContext ctx);
}


abstract class Orm{

  Map<String, dynamic> jSON;
  int get id => jSON['id'];

  bool operator ==(other) {
    return (other is Orm && other.hashCode == this.hashCode);
  }
  int get hashCode => id.hashCode;

  Orm(this.jSON);

}