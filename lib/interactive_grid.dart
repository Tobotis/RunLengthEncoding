import 'dart:math';
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:run_length_encoding/constants.dart';
import 'package:run_length_encoding/text_slider.dart';

class InteractiveGrid extends StatefulWidget {
  const InteractiveGrid({
    Key? key,
  }) : super(key: key);

  @override
  _InteractiveGridState createState() => _InteractiveGridState();
}

class _InteractiveGridState extends State<InteractiveGrid> {
  static int maxRes = 30;
  List<bool> pixel = List.generate(maxRes * maxRes, (index) => false);
  int res = 8;
  int codeBitLength = 4;
  ScrollController sc = ScrollController();
  @override
  Widget build(BuildContext context) {
    List<String> rle = calcRLE(pixel.sublist(0, (res * res)), codeBitLength);

    int rleBit = (rle.length * codeBitLength);
    int rleByte = (rleBit / 8).ceil();
    int bit = (res * res);
    int byte = (bit / 8).ceil();
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: res,
              children: List.generate(res * res, (index) {
                Color color = pixel[index] ? Colors.black : Colors.white;
                return MouseRegion(
                  onEnter: (event) {
                    if (event.buttons == 1) {
                      setState(() {
                        pixel[index] = !pixel[index];
                      });
                    }
                  },
                  child: GestureDetector(
                    onTap: () => setState(() {
                      pixel[index] = !pixel[index];
                    }),
                    child: AnimatedContainer(
                      duration: defaultPixelDuration,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        color: color,
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: sc,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Run-Length-Encoding",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runAlignment: WrapAlignment.spaceBetween,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              pixel = List.generate(
                                  maxRes * maxRes, (index) => false);
                            });
                          },
                          child: const Text("Clear")),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              pixel = List.generate(maxRes * maxRes,
                                  (index) => (index % 2) == 0 ? false : true);
                            });
                          },
                          child: const Text("Worst Case")),
                      IconButton(
                        onPressed: () {
                          js.context.callMethod('open',
                              ['https://github.com/tobotis/RunLengthEncoding']);
                        },
                        icon: const Icon(LineIcons.github),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextSlider(
                    title: "Resolution",
                    value: res,
                    max: maxRes,
                    min: 2,
                    onChanged: (int val) {
                      setState(() {
                        res = val;
                      });
                    },
                  ),
                  TextSlider(
                    title: "Encoding-Bits",
                    value: codeBitLength,
                    max: 10,
                    min: 2,
                    onChanged: (int val) {
                      setState(() {
                        codeBitLength = val;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Compression: ",
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Bit: " +
                                  double.parse(((rleBit / bit) * 100)
                                          .toStringAsFixed(3))
                                      .toString() +
                                  "%",
                              style: const TextStyle(fontSize: 30),
                              softWrap: true,
                            ),
                            Text(
                              "Byte: " +
                                  double.parse(((rleByte / byte) * 100)
                                          .toStringAsFixed(3))
                                      .toString() +
                                  "%",
                              style: const TextStyle(fontSize: 30),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  res < 15
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Without RLE",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        bit.toString() +
                                            "Bit " +
                                            (((res * res) % 8) != 0
                                                ? "≈ "
                                                : "= ") +
                                            byte.toString() +
                                            "Byte",
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    children: List.generate(
                                      (res * res),
                                      (index) => Text(
                                        (pixel[index] ? "1" : "0") +
                                            ((index + 1) % 4 == 0 ? " " : ""),
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "With RLE",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        rleBit.toString() +
                                            "Bit " +
                                            (((rle.length * codeBitLength) %
                                                        8) !=
                                                    0
                                                ? "≈ "
                                                : "= ") +
                                            rleByte.toString() +
                                            "Byte",
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    children: rle
                                        .map(
                                          (e) => Text(
                                            e + " ",
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const Text("Resolution is too high for more details"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<String> calcRLE(List<bool> booleans, int rleLength) {
  List<String> result = [];
  int counter = 0;
  bool? currentCounting;
  int biggestNumber = pow(2, rleLength - 1).toInt();
  for (bool b in booleans) {
    // There is a new run length
    currentCounting ??= b;
    // Is the bool on the current run length check
    if (currentCounting == b) {
      counter += 1;
      if (counter == biggestNumber) {
        String binary = convertToBinary(counter - 1);
        for (int i = binary.length; i < rleLength - 1; i++) {
          binary = "0" + binary;
        }
        result.add((currentCounting ? "1" : "0") + binary);
        currentCounting = null;
        counter = 0;
      }
    } else {
      // There is the other state (we have to change and switch)
      String binary = convertToBinary(counter - 1);
      for (int i = binary.length; i < rleLength - 1; i++) {
        binary = "0" + binary;
      }
      result.add((currentCounting ? "1" : "0") + binary);
      currentCounting = b;
      counter = 1;
    }
  }
  if (currentCounting != null) {
    String binary = convertToBinary(counter - 1);
    for (int i = binary.length; i < rleLength - 1; i++) {
      binary = "0" + binary;
    }
    result.add((currentCounting ? "1" : "0") + binary);
  }
  return result;
}

String convertToBinary(int num) {
  String result = "";
  if (num == 0) {
    return "0";
  }
  while (num > 0) {
    result = (num % 2).toString() + result;
    num = num ~/ 2;
  }
  return result;
}
