import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:v2rayadmin/constant/ui.dart';
import 'package:v2rayadmin/model/data/remote/response/status.dart';
import '../../viewModel/homeViewModel/homeViewModel.dart';

//this class is using in both of (Edit Profile in home) & (Login Page)
class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState(); // new change
}

class _MainPageState extends State<MainPage> {
  String? birthCheck;
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
        create: (context) => HomeViewModel(),
        child: Consumer<HomeViewModel>(
          builder: (context, homeVm, child) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text("SBUK BOT",style: TextStyle(color: cRed),),
                ),
                backgroundColor: Colors.white,
                body: Directionality(
                  textDirection: TextDirection.ltr,
                  child: SafeArea(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16,),
                              Padding(
                                padding:EdgeInsets.only(left: dSpace_16),
                                child:SizedBox(
                                  height: MediaQuery.of(context).size.width - dSpace_32,
                                  width: MediaQuery.of(context).size.width,
                                  child: Lottie.asset("assets/redbot.json",repeat: false),
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: dSpace_16,vertical: dSpace_4),
                                child: TextField(
                                  cursorColor: cRed,
                                  controller: _controller,
                                  style: TextStyle(color: cRed),
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder( //<-- SEE HERE
                                      borderSide: BorderSide(
                                          width: 3, color: cRed),
                                    ),
                                    enabledBorder: const OutlineInputBorder( //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 3, color: Colors.black26,
                                      ),
                                    ),
                                    labelStyle: TextStyle(color: cRed),
                                    hintText: "IP Address",
                                    hintStyle: const TextStyle(color: Colors.black54),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: dSpace_16),
                                child: const Text("   Enter your Ip Server to Conncet",style: TextStyle(color: Colors.black54),),
                              ),
                              const SizedBox(height: 100,)
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:EdgeInsets.all(dSpace_16),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 56,
                                decoration: BoxDecoration(
                                    color: cRed,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    overlayColor: MaterialStateColor.resolveWith((states) => cRedDark),
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: (){
                                      homeVm.sendInputData(spcData: "CheckConnection");
                                    },
                                    child: Center(
                                      child:homeVm.espInputResponse.status! != Status.LOADING?
                                        Text(homeVm.getButtonLoginText()):const CircularProgressIndicator(color: Colors.white,strokeWidth: 2,),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ),
                )
            );
          },
        )
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}
