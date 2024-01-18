import 'package:crypto/Model/coinModel.dart';
import 'package:crypto/View/Components/item2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Components/item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getCoinMarket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            colors: [
              Color.fromARGB(255, 253, 225, 112),
              Color(0xffFBC700),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: myHeight * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: myWidth * 0.02,
                      vertical: myHeight * 0.005,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text(
                      'Main Portfolio',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const Text(
                    'Top 10 coins',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Text(
                    'Exprimental',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '\$ 7,466.20',
                    style: TextStyle(fontSize: 27),
                  ),
                  Container(
                    padding: EdgeInsets.all(myWidth * 0.02),
                    height: myHeight * 0.04,
                    width: myWidth * 0.1,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    child: Image.asset(
                      'assets/icons/5.1.png',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
              child: const Row(
                children: [
                  Text(
                    '+162% all time',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: myHeight * 0.018,
            ),
            Container(
              height: myHeight * 0.7,
              width: myWidth,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.grey.shade100,
                    spreadRadius: 5,
                    offset: const Offset(0, 3),
                  )
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: myHeight * 0.03,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: myWidth * 0.08),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Assets',
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(Icons.add)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: myHeight * 0.02,
                  ),
                  Container(
                    height: myHeight * 0.4,
                    child: isRefreshing
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xffFBC700),
                            ),
                          )
                        : coinMarket == null || coinMarket!.isEmpty
                            ? Padding(
                                padding: EdgeInsets.all(myHeight * 0.06),
                                child: const Center(
                                  child: Text(
                                    "Attention this Api is free, so you cannot send multiple requests per second, Please wait and tye again later.",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: 4,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Item(item: coinMarket![index]);
                                },
                              ),
                  ),
                  SizedBox(
                    height: myHeight * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: myWidth * 0.05),
                    child: const Row(
                      children: [
                        Text(
                          'Recommend to Buy',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: myWidth,
                      child: Padding(
                        padding: EdgeInsets.only(left: myWidth * 0.05),
                        child: isRefreshing
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xffFBC700),
                                ),
                              )
                            : coinMarket == null || coinMarket!.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.all(myHeight * 0.06),
                                    child: const Center(
                                      child: Text(
                                        "Attention this Api is free, so you cannot send multiple requests per second, Please wait and tye again later.",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: coinMarket!.length,
                                    itemBuilder: (context, index) {
                                      return Item2(item: coinMarket![index]);
                                    },
                                  ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isRefreshing = true;
  List? coinMarket = [];
  var coinMarketList;

  Future<List<CoinModel>?> getCoinMarket() async {
    const url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';
    setState(() {
      isRefreshing = true;
    });
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    setState(() {
      isRefreshing = false;
    });
    if (response.statusCode == 200) {
      var x = response.body;
      coinMarketList = coinModelFromJson(x);
      setState(() {
        coinMarket = coinMarketList;
      });
    } else {
      print('Status code => ${response.statusCode}');
    }
    return null;
  }
}
