// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

// ignore: must_be_immutable
class Item extends StatelessWidget {
  var item;
  Item({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: myWidth * 0.06, vertical: myHeight * 0.02),
      child: Container(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: myHeight * 0.05,
                child: Image.network(item.image),
              ),
            ),
            SizedBox(width: myWidth * 0.01),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.id,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: myWidth * 0.02),
                  Text(
                    '0.4 ' + item.symbol,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: myWidth * 0.03),
            Expanded(
              flex: 1,
              child: Container(
                height: myHeight * 0.05,
                // width: myWidth * 0.2,
                child: Sparkline(
                  data: item.sparklineIn7D.price,
                  lineWidth: 2.0,
                  lineColor: item.marketCapChangePercentage24H >= 0
                      ? Colors.green
                      : Colors.red,
                  fillMode: FillMode.below,
                  fillGradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.7],
                    colors: item.marketCapChangePercentage24H >= 0
                        ? [Colors.green, Colors.green.shade100]
                        : [
                            Colors.red,
                            Colors.red.shade100,
                          ],
                  ),
                ),
              ),
            ),
            SizedBox(width: myWidth * 0.04),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$ ${item.currentPrice}',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        item.priceChange24H.toString().contains('-')
                            // ignore: prefer_interpolation_to_compose_strings
                            ? "- \$" +
                                item.priceChange24H
                                    .toStringAsFixed(2)
                                    .replaceAll('-', '')
                            // ignore: prefer_interpolation_to_compose_strings
                            : "\$" + item.priceChange24H.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: myWidth * 0.025),
                      Text(
                        item.marketCapChangePercentage24H.toStringAsFixed(2) +
                            '%',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: item.marketCapChangePercentage24H >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
