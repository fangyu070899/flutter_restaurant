import 'package:flutter/material.dart';

import '../restaurant.dart';
import '../restaurant_card.dart';
import '../restaurant_model.dart';

import 'dart:io';
import 'package:flutter_project/speech/flutter_tts.dart';
import 'package:flutter_project/speech/socket_stt.dart';
import 'package:flutter_project/speech/socket_tts.dart';
import 'package:flutter_project/speech/sound_player.dart';
import 'package:flutter_project/speech/sound_recorder.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // get SoundRecorder
  final recorder = SoundRecorder();
  // get soundPlayer
  final player = SoundPlayer();

  // Declare TextEditingController to get the value in TextField
  static TextEditingController ttsController = TextEditingController();
  TextEditingController recognitionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    recorder.init();
    player.init();
    RestaurantModel.search_results = "";
    ttsController.text = "";
  }

  @override
  void dispose() {
    RestaurantModel.search_results = "";
    ttsController.text = "";
    recorder.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 設定不讓鍵盤擠壓頁面
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: const Text('search restaurant'),
          backgroundColor: Color.fromARGB(255, 104, 192, 157)),
      body: Column(
        children: [
          buildRadio(),
          Row(
            children: [
              Flexible(
                flex: 5,
                child: Center(child: buildOutputField()),
              ),
              Flexible(
                flex: 2,
                child: Center(child: buildRecord()),
              ),
            ],
          ),
          Expanded(
              child: FutureBuilder(
                  future: RestaurantModel.searchRestaurant(
                      recognitionController.text),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final restaurants = snapshot.data as List<Restaurant>;
                      return ListView.builder(
                          key: UniqueKey(),
                          itemCount: restaurants.length,
                          itemBuilder: (context, index) {
                            if (restaurants.isNotEmpty &&
                                restaurants.length > 0 &&
                                RestaurantModel.search_pos[0].length > 0 &&
                                RestaurantModel.search_pos[1].length > 0) {
                              ttsController.text =
                                  RestaurantModel.search_results;
                              return RestaurantCard(
                                row: RestaurantModel.search_pos[0][index],
                                col: RestaurantModel.search_pos[1][index],
                                image: Image.network(
                                  restaurants.elementAt(index).imagePath,
                                  fit: BoxFit.cover,
                                ),
                                title: restaurants.elementAt(index).title,
                                isFavorite: RestaurantModel.getFavoriteByIndex(
                                    RestaurantModel.search_pos[0][index],
                                    RestaurantModel.search_pos[1][index]),
                              );
                            } else {
                              return const Center(
                                  child: Text("restaurant not found"));
                            }
                          });
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  })),
          Center(child: buildTtsField("Search results ($recognitionLanguage)")),
        ],
      ),
    );
  }

  // build the button of recorder
  Widget buildRecord() {
    // whether is recording
    final isRecording = recorder.isRecording;
    // if recording => icon is Icons.stop
    // else => icon is Icons.mic
    final icon = isRecording ? Icons.stop : Icons.mic;
    // if recording => color of button is red
    // else => color of button is white
    final primary =
        isRecording ? Colors.red : Color.fromARGB(255, 104, 192, 157);
    // if recording => text in button is STOP
    // else => text in button is START
    final text = isRecording ? 'STOP' : 'START';
    // if recording => text in button is white
    // else => color of button is black
    final onPrimary = isRecording ? Colors.white : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          // 設定 Icon 大小及屬性
          minimumSize: const Size(80, 50),
          primary: primary,
          onPrimary: onPrimary,
        ),
        icon: Icon(icon),
        label: Text(
          text,
          // 設定字體大小及字體粗細（bold粗體，normal正常體）
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        // 當 icon 被點擊時執行的動作
        onPressed: () async {
          // getTemporaryDirectory(): 取得暫存資料夾，這個資料夾隨時可能被系統或使用者操作清除
          Directory tempDir = await path_provider.getTemporaryDirectory();
          // define file directory
          String path = '${tempDir.path}/SpeechRecognition.wav';
          // 控制開始錄音或停止錄音
          await recorder.toggleRecording(path);
          // When stop recording, pass wave file to socket
          if (!recorder.isRecording) {
            if (recognitionLanguage == "Taiwanese") {
              // if recognitionLanguage == "Taiwanese" => use Minnan model
              // setTxt is call back function
              // parameter: wav file path, call back function, model
              await Speech2Text().connect(path, setTxt, "Minnan");
              // glSocket.listen(dataHandler, cancelOnError: false);
            } else {
              // if recognitionLanguage == "Chinese" => use MTK_ch model
              await Speech2Text().connect(path, setTxt, "MTK_ch");
            }
          }
          // set state is recording or stop
          setState(() {
            recorder.isRecording;
          });
        },
      ),
    );
  }

  // set recognitionController.text function
  void setTxt(taiTxt) {
    setState(() {
      RestaurantModel.search_pos[0].clear();
      RestaurantModel.search_pos[1].clear();
      recognitionController.text = taiTxt;
      RestaurantModel.search_results = "";
    });
  }

  Future play(String pathToReadAudio) async {
    await player.play(pathToReadAudio);
    setState(() {
      player.init();
      player.isPlaying;
    });
  }

  Widget buildTtsField(txt) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 40),
      child: TextField(
        controller: ttsController,
        decoration: InputDecoration(
          filled: true, //重點，必須設定為true，fillColor才有效
          fillColor: Colors.white, //背景顏色，必須結合filled: true,才有效
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.black, // 設定邊框的顏色
              width: 1.0, // 設定邊框的粗細
            ),
          ),
          // when user choose the TextField
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: Colors.black, // 設定邊框的顏色
                width: 1, // 設定邊框的粗細
              )),
          hintText: txt,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.play_arrow,
              color: Colors.grey,
            ),
            onPressed: () async {
              // String strings = chineseController.text;
              // if (strings.isEmpty) return;
              // print(strings);
              // await Text2SpeechFlutter().speak(strings);
              // 得到 TextField 中輸入的 value
              String strings = ttsController.text;
              // 如果為空則 return
              if (strings.isEmpty) return;

              if (recognitionLanguage == "Chinese") {
                await Text2Speech().connect(play, strings, "chinese");
              } else {
                await Text2Speech().connect(play, strings, "taiwanese");
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildOutputField() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 0),
      child: TextField(
        controller: recognitionController, // 設定 controller
        enabled: false, // 設定不能接受輸入
        decoration: const InputDecoration(
          fillColor: Colors.white, // 背景顏色，必須結合filled: true,才有效
          filled: true, // 重點，必須設定為true，fillColor才有效
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)), // 設定邊框圓角弧度
            borderSide: BorderSide(
              color: Colors.black, // 設定邊框的顏色
              width: 1.0, // 設定邊框的粗細
            ),
          ),
        ),
      ),
    );
  }

  // Use to choose language of speech recognition
  String recognitionLanguage = "Taiwanese";

  Widget buildRadio() {
    return Row(children: <Widget>[
      Flexible(
        child: RadioListTile<String>(
          // 設定此選項 value
          value: 'Taiwanese',
          // Set option name、color
          title: const Text(
            'Taiwanese',
            style: TextStyle(color: Colors.black),
          ),
          //  如果Radio的value和groupValu一樣就是此 Radio 選中其他設置為不選中
          groupValue: recognitionLanguage,
          // 設定選種顏色
          activeColor: Color.fromARGB(255, 104, 192, 157),
          onChanged: (value) {
            setState(() {
              // 將 recognitionLanguage 設為 Taiwanese
              recognitionLanguage = "Taiwanese";
            });
          },
        ),
      ),
      Flexible(
        child: RadioListTile<String>(
          // 設定此選項 value
          value: 'Chinese',
          // Set option name、color
          title: const Text(
            'Chinese',
            style: TextStyle(color: Colors.black),
          ),
          //  如果Radio的value和groupValu一樣就是此 Radio 選中其他設置為不選中
          groupValue: recognitionLanguage,
          // 設定選種顏色
          activeColor: Color.fromARGB(255, 104, 192, 157),
          onChanged: (value) {
            setState(() {
              // 將 recognitionLanguage 設為 Taiwanese
              recognitionLanguage = "Chinese";
            });
          },
        ),
      ),
    ]);
  }
}
