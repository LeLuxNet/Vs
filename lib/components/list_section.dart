import 'package:flutter/material.dart';
import 'package:vs/components/section.dart';

class ListSection extends Section {
  ListSection(String title, List<Widget> children, {Color color})
      : super(
            title,
      ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: children.length,
        itemBuilder: (BuildContext context, int i) => children[i],
            ),
            color: color);
}
