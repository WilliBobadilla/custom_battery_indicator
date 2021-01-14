//taken from

import 'package:custom_battery_indicator/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatteryIndicatorCustom extends GetView<HomeController> {
  /*-------------battery indicator------------*/
  BatteryIndicatorStyle style;

  /// widget`s width / height , default to 2.5：1
  double ratio;

  /// color of borderline , and fill color when colorful is false
  Color mainColor;

  /// if colorful = true , then the fill color will automatic change depend on battery value
  bool colorful;

  /// whether paint fill color
  bool showPercentSlide;

  /// whether show battery value , Recommended [NOT] set to True when colorful = false
  bool showPercentNum;

  /// default to 14.0
  double size;

  /// battery value font size, default to null
  double percentNumSize;

  BatteryIndicatorCustom(
      {this.style = BatteryIndicatorStyle.flat,
      this.ratio = 5,
      this.mainColor = Colors.green,
      this.colorful = true,
      this.percentNumSize = 30.0,
      this.showPercentSlide = true,
      this.showPercentNum = true,
      this.size = 35});
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new SizedBox(
        height: this.size,
        width: this.size * this.ratio,
        child: Obx(() => CustomPaint(
              //with the Obx we can "observe" changes from the this
              painter: BatteryIndicatorPainter(
                  controller.batteryLevel.value,
                  this.style,
                  this.showPercentSlide,
                  this.colorful,
                  this.mainColor),
              child: new Center(
                child: new Padding(
                  padding: new EdgeInsets.only(
                      right: this.style == BatteryIndicatorStyle.flat
                          ? 0.0
                          : this.size * this.ratio * 0.04),
                  child: this.showPercentNum
                      ? new Text(
                          controller.batteryLevel.value.toString(),
                          style: new TextStyle(
                              fontSize: this.percentNumSize ?? this.size * 0.9),
                        )
                      : new Text(
                          '',
                          style: new TextStyle(
                              fontSize: this.percentNumSize ?? this.size * 0.9),
                        ),
                ),
              ),
            )),
      ),
    );
  }
}

class BatteryIndicatorPainter extends CustomPainter {
  int batteryLv;
  BatteryIndicatorStyle style;
  bool colorful;
  bool showPercentSlide;
  Color mainColor;
  HomeController homeController = Get.find<
      HomeController>(); //here whe find the controller to change the value from batery level
  BatteryIndicatorPainter(this.batteryLv, this.style, this.showPercentSlide,
      this.colorful, this.mainColor);

  @override
  void paint(Canvas canvas, Size size) {
    if (style == BatteryIndicatorStyle.flat) {
      //this is for flat style
      canvas.drawRRect(
          RRect.fromLTRBR(0.0, size.height * 0.05, size.width,
              size.height * 0.95, const Radius.circular(100.0)),
          Paint()
            ..color = mainColor
            ..strokeWidth = 0.5
            ..style = PaintingStyle.stroke);

      if (showPercentSlide) {
        canvas.clipRect(Rect.fromLTWH(0.0, size.height * 0.05,
            size.width * fixedBatteryLv / 100, size.height * 0.95));

        double offset = size.height * 0.1;

        canvas.drawRRect(
            new RRect.fromLTRBR(
                offset,
                size.height * 0.05 + offset,
                size.width - offset,
                size.height * 0.95 - offset,
                const Radius.circular(100.0)),
            new Paint()
              ..color = colorful ? getBatteryLvColor : mainColor
              ..style = PaintingStyle.fill);
      }
    } else {
      canvas.drawRRect(
          new RRect.fromLTRBR(0.0, size.height * 0.05, size.width * 0.92,
              size.height * 0.95, new Radius.circular(size.height * 0.1)),
          new Paint()
            ..color = mainColor
            ..strokeWidth = 0.8
            ..style = PaintingStyle.stroke);

      canvas.drawRRect(
          new RRect.fromLTRBR(size.width * 0.92, size.height * 0.25, size.width,
              size.height * 0.75, new Radius.circular(size.height * 0.1)),
          new Paint()
            ..color = mainColor
            ..style = PaintingStyle.fill);

      if (showPercentSlide) {
        canvas.clipRect(Rect.fromLTWH(0.0, size.height * 0.05,
            size.width * 0.92 * fixedBatteryLv / 100, size.height * 0.95));

        double offset = size.height * 0.1;

        canvas.drawRRect(
            RRect.fromLTRBR(
                offset,
                size.height * 0.05 + offset,
                size.width * 0.92 - offset,
                size.height * 0.95 - offset,
                Radius.circular(size.height * 0.1)),
            Paint()
              ..color = colorful ? getBatteryLvColor : mainColor
              ..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return (oldDelegate as BatteryIndicatorPainter).batteryLv != batteryLv ||
        (oldDelegate as BatteryIndicatorPainter).mainColor != mainColor;
  }

  get fixedBatteryLv => homeController.batteryLevel.value < 10
      ? 4 + homeController.batteryLevel.value / 2
      : homeController.batteryLevel.value; //here we change the value

  get getBatteryLvColor => homeController.batteryLevel.value < 15
      ? Colors.red
      : batteryLv < 30
          ? Colors.orange
          : Colors.green;
}
