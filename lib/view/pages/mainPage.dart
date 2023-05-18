import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:v2rayadmin/constant/constants.dart';
import 'package:v2rayadmin/constant/ui.dart';
import 'package:v2rayadmin/model/data/remote/response/status.dart';
import 'package:v2rayadmin/view/pages/controlPage.dart';
import '../../viewModel/homeViewModel/homeViewModel.dart';

int hiddenItem = 30;
//this class is using in both of (Edit Profile in home) & (Login Page)
class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState(); // new change
}

class _MainPageState extends State<MainPage> {
  ScrollController _scrollController = ScrollController();
  String? birthCheck;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
    // TODO: implement initState
    super.initState();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Guide',style: TextStyle(color: Colors.black87,fontSize: 20),),
              SizedBox(height: dSpace_8,),
              iconText(text: "Put the IP of your device in the box and wait for the program to check your request after pressing the connect button."
                "Your request will be sent to the following address: \n"
                  "DEVICE_IP_ADDRESS:PORT/submit\n"
                "If the connection is established, you will go to the robot controller page.",icon: Container()),
              SizedBox(height: dSpace_16,),
              const Text('Developed by SAMG',style: TextStyle(color: Colors.black87,fontSize: 20),),
              SizedBox(height: dSpace_8,),
              iconText(text: "Github : github.com/samg-hub",icon: icons_24(const Icon(Icons.circle,color: Colors.black87,size: 12,))),
              SizedBox(height: dSpace_4,),
              iconText(icon: icons_24(const Icon(Icons.rocket_launch,color: Colors.black87,size: 20,)),text: "Tel : @s_amg")
            ],
          ),
        );
      },
    );
  }
  Widget iconText({Widget? icon,String? text}){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon ?? Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(5)
          ),
        ),
        SizedBox(width: dSpace_8,),
        Flexible(child:Text(text.toString(),style: const TextStyle(color: Colors.black87)))
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HomeViewModel(),
        child: Consumer<HomeViewModel>(
          builder: (context, homeVm, child) {
            return Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text("SBUK BOT",style: TextStyle(color: cRed),),
                  actions: [
                    Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: (){
                              _showBottomSheet();
                            },
                            child: icons_40(const Icon(Icons.info,color: Color(0xff909495),)),
                          ),
                        ),
                        SizedBox(width: dSpace_8,)
                      ],
                    )
                  ],
                ),
                backgroundColor: Colors.white,
                body: Directionality(
                  textDirection: TextDirection.ltr,
                  child: SafeArea(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          reverse: true,
                          controller: _scrollController,
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
                                  child: InkWell(
                                    onTap: () async{
                                      hiddenItem--;
                                      if (hiddenItem == 0){
                                        setState(() {
                                          hiddenItem = 0;
                                        });
                                        Future.delayed(const Duration(milliseconds: 1000)).then((value){
                                          setState(() {
                                            hiddenItem = 30;
                                          });
                                        });
                                      }
                                    },
                                    child: hiddenItem == 0 ? Image.asset("assets/hiddenItem.jpeg") : Lottie.asset("assets/redbot.json",repeat: true),
                                  )
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: dSpace_16,vertical: dSpace_4),
                                child: TextField(
                                  // keyboardType: TextInputType.numberWithOptions(),
                                  cursorColor: cRed,
                                  controller: homeVm.ipController,
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
                                padding: EdgeInsets.only(left: dSpace_16,),
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
                                    onTap: ()async{
                                      ipAddress = "http://${homeVm.ipController.text}/";
                                      ipInput = homeVm.ipController.text;
                                      await homeVm.sendInputData(spcData: "9999");
                                      await Future.delayed(const Duration(seconds: 1));
                                      if(homeVm.espInputResponse.status == Status.COMPLETED){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ControllPage(),));
                                      }
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
    super.dispose();
  }
}
