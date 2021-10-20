import 'dart:math';

import 'package:flutter/material.dart';
import 'package:run_length_encoding/constants.dart';
import 'package:run_length_encoding/text_slider.dart';

class InteractiveGrid extends StatefulWidget {
  const InteractiveGrid({Key? key}) : super(key: key);

  @override
  _InteractiveGridState createState() => _InteractiveGridState();
}

class _InteractiveGridState extends State<InteractiveGrid> {
  int maxRow = 20;
  int maxColumn = 20;
  List<bool> pixel = List.generate(20 * 20, (index) => false);
  int rows = 8;
  int columns = 8;
  int codeBitLength = 4;
  bool useRLE = true;
  ScrollController sc = ScrollController();
  @override
  Widget build(BuildContext context) {
    List<String> rle =
        calcRLE(pixel.sublist(0, (rows * columns)), codeBitLength);

    int rleBit = (rle.length * codeBitLength);
    int rleByte = (rleBit / 8).ceil();
    int bit = (rows * columns);
    int byte = (bit / 8).ceil();
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: rows,
                  children: List.generate(rows * columns, (index) {
                    Color color = pixel[index] ? Colors.black : Colors.white;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          pixel[index] = !pixel[index];
                        });
                      },
                      child: AnimatedContainer(
                        duration: defaultPixelDuration,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          color: color,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: const Text("1"),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: const Text(
                        "0",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            pixel = List.generate(
                                maxRow * maxColumn, (index) => false);
                          });
                        },
                        icon: const Icon(Icons.check),
                        label: const Text("Best Case")),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            pixel = List.generate(maxRow * maxColumn,
                                (index) => (index % 2) == 0 ? false : true);
                          });
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("Worst Case")),
                  ],
                ),
              ),
              Row(
                children: [
                  TextSlider(
                    title: "Columns",
                    value: rows,
                    max: maxRow,
                    min: 2,
                    onChanged: (int val) {
                      setState(() {
                        rows = val;
                      });
                    },
                  ),
                  TextSlider(
                    title: "Rows",
                    value: columns,
                    max: maxColumn,
                    min: 2,
                    onChanged: (int val) {
                      setState(() {
                        columns = val;
                      });
                    },
                  ),
                  /*Row(
              children: [
                Checkbox(
                    fillColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                    value: useRLE,
                    onChanged: (bool? val) => {
                          setState(() {
                            useRLE = val ?? useRLE;
                          })
                        }),
                const Text("Use RLE"),
              ],
            ),*/
                  useRLE
                      ? TextSlider(
                          title: "Encoding-Bits",
                          value: codeBitLength,
                          max: 10,
                          min: 2,
                          onChanged: (int val) {
                            setState(() {
                              codeBitLength = val;
                            });
                          },
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            controller: sc,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Run-Length-Encoding",
                    style: TextStyle(fontSize: 50),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Without RLE",
                            style: TextStyle(fontSize: 25),
                          ),
                          Text(
                            bit.toString() +
                                "Bit " +
                                (((rows * columns) % 8) != 0 ? "≈ " : "= ") +
                                byte.toString() +
                                "Byte",
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        children: List.generate(
                          (rows * columns),
                          (index) => Text(
                            (pixel[index] ? "1" : "0") +
                                ((index + 1) % 4 == 0 ? " " : ""),
                            style: const TextStyle(fontSize: 18),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "With RLE",
                            style: TextStyle(fontSize: 25),
                          ),
                          Text(
                            rleBit.toString() +
                                "Bit " +
                                (((rle.length * codeBitLength) % 8) != 0
                                    ? "≈ "
                                    : "= ") +
                                rleByte.toString() +
                                "Byte",
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        children: rle
                            .map(
                              (e) => Text(
                                e + " ",
                                style: const TextStyle(fontSize: 18),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Compression (rle size/normal size): ",
                        style: TextStyle(fontSize: 25),
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
                            style: const TextStyle(fontSize: 40),
                            softWrap: true,
                          ),
                          Text(
                            "Byte: " +
                                double.parse(((rleByte / byte) * 100)
                                        .toStringAsFixed(3))
                                    .toString() +
                                "%",
                            style: const TextStyle(fontSize: 40),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
