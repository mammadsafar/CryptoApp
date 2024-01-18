// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:crypto/Model/chartModel.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class SelectCoin extends StatefulWidget {
  var selectItem;

  SelectCoin({super.key, this.selectItem});

  @override
  State<SelectCoin> createState() => _SelectCoinState();
}

class _SelectCoinState extends State<SelectCoin> {
  late TrackballBehavior trackballBehavior;

  List<ChartModel>? itemChart;

  @override
  void initState() {
    getChart();
    trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        height: myHeight,
        width: myWidth,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: myWidth * 0.05,
                vertical: myHeight * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: myHeight * 0.08,
                        child: Image.network(widget.selectItem.image),
                      ),
                      SizedBox(width: myWidth * 0.03),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.selectItem.id,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: myHeight * 0.01),
                          Text(
                            widget.selectItem.symbol,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$${widget.selectItem.currentPrice}",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: myHeight * 0.01),
                      Text(
                        '${widget.selectItem.marketCapChangePercentage24H}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color:
                              widget.selectItem.marketCapChangePercentage24H >=
                                      0
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: myWidth * 0.05,
                      vertical: myHeight * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Low',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: myHeight * 0.01),
                            Text(
                              "\$${widget.selectItem.low24H}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'High',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: myHeight * 0.01),
                            Text(
                              "\$${widget.selectItem.high24H}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'Vol',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: myHeight * 0.01),
                            Text(
                              "\$" +
                                  widget.selectItem.totalVolume.toString() +
                                  'M',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: myHeight * 0.02),
                  SizedBox(
                    height: myHeight * 0.3,
                    width: myWidth,
                    // color: Colors.amber,
                    child: isRefresh == true
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xffFBC700),
                            ),
                          )
                        : itemChart == null
                            ? Padding(
                                padding: EdgeInsets.all(myHeight * 0.06),
                                child: const Center(
                                  child: Text(
                                    "Attention this Api is free, so you cannot send multiple requests per second, Please wait and tye again later.",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              )
                            : SfCartesianChart(
                                trackballBehavior: trackballBehavior,
                                zoomPanBehavior: ZoomPanBehavior(
                                    enablePinching: true, zoomMode: ZoomMode.x),
                                series: <CandleSeries>[
                                  CandleSeries<ChartModel, int>(
                                    enableSolidCandles: true,
                                    enableTooltip: true,
                                    bullColor: Colors.green,
                                    bearColor: Colors.red,
                                    dataSource: itemChart!,
                                    xValueMapper: (ChartModel sales, _) =>
                                        sales.time,
                                    lowValueMapper: (ChartModel sales, _) =>
                                        sales.low,
                                    highValueMapper: (ChartModel sales, _) =>
                                        sales.high,
                                    openValueMapper: (ChartModel sales, _) =>
                                        sales.open,
                                    closeValueMapper: (ChartModel sales, _) =>
                                        sales.close,
                                    animationDuration: 55,
                                  ),
                                ],
                              ),
                  ),
                  SizedBox(height: myHeight * 0.01),
                  Center(
                    child: SizedBox(
                      height: myHeight * 0.035,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: text.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: myWidth * 0.02),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  textBool = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                  ];
                                  textBool[index] = true;
                                  setDays(text[index]);
                                  getChart();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: myWidth * 0.03,
                                    vertical: myHeight * 0.005),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: textBool[index] == true
                                      ? const Color(0xffFBC700).withOpacity(0.5)
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  text[index],
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: myHeight * 0.04),
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: myWidth * 0.06),
                          child: const Text(
                            'News',
                            style: TextStyle(fontSize: 23),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: myWidth * 0.06,
                              vertical: myHeight * 0.01),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: Text(
                                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: myWidth * 0.25,
                                child: CircleAvatar(
                                  radius: myHeight * 0.04,
                                  backgroundImage: const AssetImage(
                                      'assets/image/avatar.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: myHeight * 0.1,
              width: myWidth,
              child: Column(
                children: [
                  const Divider(),
                  SizedBox(height: myHeight * 0.01),
                  Row(
                    children: [
                      SizedBox(width: myWidth * 0.05),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: myHeight * 0.015),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xffFBC700),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: myHeight * 0.02,
                              ),
                              const Text(
                                'Add to portfolio',
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: myWidth * 0.05),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: myHeight * 0.012),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          child: Image.asset(
                            'assets/icons/3.1.png',
                            height: myHeight * 0.03,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: myWidth * 0.05),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  List<String> text = ['D', 'W', 'M', '3M', '6M', 'Y'];
  List<bool> textBool = [false, false, true, false, false, false];
  int days = 30;

  setDays(String txt) {
    if (txt == 'D') {
      setState(() {
        days = 1;
      });
    } else if (txt == 'W') {
      setState(() {
        days = 7;
      });
    } else if (txt == 'M') {
      setState(() {
        days = 30;
      });
    } else if (txt == '3M') {
      setState(() {
        days = 9;
      });
    } else if (txt == '6M') {
      setState(() {
        days = 180;
      });
    } else if (txt == 'Y') {
      setState(() {
        days = 365;
      });
    }
  }

  bool isRefresh = true;

  Future<void> getChart() async {
    String url =
        '${'https://api.coingecko.com/api/v3/coins/' + widget.selectItem.id}/ohlc?vs_currency=usd&days=$days';
    setState(() {
      isRefresh = true;
    });
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    setState(() {
      isRefresh = false;
    });
    if (response.statusCode == 200) {
      Iterable x = json.decode(response.body);
      List<ChartModel> modelList =
          x.map((e) => ChartModel.fromJson(e)).toList();
      setState(() {
        itemChart = modelList;
      });
    } else {
      print('Status code => ${response.statusCode}');
    }
  }
}
