import 'package:flutter/material.dart';
import 'package:vs/components/section.dart';

class ListSection extends Section {
  ListSection(String title, List<Widget> children, {Color color})
      : super(
            title,
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: children.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(height: 1),
              itemBuilder: (BuildContext context, int index) {
                return children[index];
              },
            ),
            color: color);
}
