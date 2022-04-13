import 'package:flutter/material.dart';
import 'package:gloc_ui/data/ClocResult.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    Key? key,
    required this.clocResult,
  }) : super(key: key);

  final ClocResult clocResult;
  final _cardSpacing = 30.0;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            _RepoTitle(url: clocResult.giturl),
            SizedBox(height: _cardSpacing),
            _CodeCount(
                totalLines: clocResult.totalLines,
                totalCode: clocResult.totalCode,
                totalBlank: clocResult.totalBlank,
                totalComment: clocResult.totalComment),
          ],
        ),
    );
  }
}

class _RepoTitle extends StatelessWidget {
  const _RepoTitle({
    required this.url,
  });

  final Uri? url;

  @override
  Widget build(BuildContext context) {
    final String nameString = url?.pathSegments.last ?? "Your Repository";
    final String urlString = url?.toString() ?? "Unknown URL";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(nameString,
            style: Theme.of(context).textTheme.displaySmall),
        Text(urlString, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

class _CodeCount extends StatelessWidget {
  const _CodeCount(
      {required this.totalLines,
      required this.totalCode,
      required this.totalBlank,
      required this.totalComment});

  final int totalLines, totalCode, totalBlank, totalComment;
  final double barHeight = 100.0;

  Widget _buildBarSection(int count, Color color) {
    return Expanded(
      flex: ((count / totalLines) * 100.0).round(),
      child: Container(
        height: barHeight,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$totalLines lines of code',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Row(children: [
          _buildBarSection(totalCode, Colors.red),
          _buildBarSection(
              totalComment, Colors.blue),
          _buildBarSection(totalBlank, Colors.green),
        ]),
        Text('Hello'),
      ],
    );
  }
}
