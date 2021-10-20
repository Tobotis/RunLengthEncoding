import 'package:flutter/material.dart';
import 'package:run_length_encoding/constants.dart';
import 'package:run_length_encoding/text_slider.dart';

class InteractiveGrid extends StatefulWidget {
  const InteractiveGrid({Key? key}) : super(key: key);

  @override
  _InteractiveGridState createState() => _InteractiveGridState();
}

class _InteractiveGridState extends State<InteractiveGrid> {
  List<bool> pixel = List.generate(20 * 20, (index) => false);
  int rows = 8;
  int columns = 8;
  int codeBitLength = 4;
  bool useRLE = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: rows,
                  children: List.generate(rows * columns, (index) {
                    Color color = pixel[index] ? Colors.black : Colors.white;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          pixel[index] = true;
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
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                (rows * columns).toString() +
                                    "Bit ≈ " +
                                    ((rows * columns) / 8).toString() +
                                    "Byte",
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            children: List.generate(
                              rows * columns,
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
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            TextSlider(
              title: "Rows",
              value: rows,
              max: 20,
              min: 2,
              onChanged: (int val) {
                setState(() {
                  rows = val;
                });
              },
            ),
            TextSlider(
              title: "Columns",
              value: columns,
              max: 20,
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
    );
  }
}
