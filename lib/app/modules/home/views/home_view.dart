import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:custom_battery_indicator/app/modules/home/controllers/home_controller.dart';
import 'package:custom_battery_indicator/app/modules/home/views/widgets/custom_battery.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            Text(
              "Testing of Baterry ",
              style: TextStyle(fontSize: 25),
            ),
            BatteryIndicatorCustom(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: controller.decrement, child: Text("Down")),
                ElevatedButton(
                    onPressed: controller.increment, child: Text("Up")),
              ],
            )
          ])),
    );
  }
}
