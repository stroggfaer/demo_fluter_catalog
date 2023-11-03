import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:my_catalog/Model/AppState.dart';
import 'package:my_catalog/Redux/ThunkActionApi.dart';
import 'package:my_catalog/Redux/index.dart';
import 'package:my_catalog/Screens/BasketScreen/basket_pay.dart';
import 'package:my_catalog/Screens/ProfileScreen/stream_control_page.dart';
import 'package:my_catalog/Screens/ProfileScreen/stream_network_page.dart';
import 'package:my_catalog/Shared/Loading.dart';
import 'package:my_catalog/Shared/app_bar.dart';
import 'package:my_catalog/Shared/network_error.dart';
import 'package:my_catalog/Shared/tab_bottom_navigation_bar.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:my_catalog/Utils/helpers.dart';
import 'package:my_catalog/Utils/language_constants.dart';
import 'package:redux/redux.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  late int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Store <AppState> store = StoreProvider.of(context);
    return Scaffold(
        appBar: headerAppBar(context, titleAppBar:translation(context).profile,isBasket: true),
        body: SingleChildScrollView(
          child:  Padding(
            //padding: const EdgeInsets.symmetric(horizontal: 20.0),
            padding: const EdgeInsets.only(bottom: 20.0, top: 20.0, left: defaultPadding, right: defaultPadding ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.only(bottom: 20.0, top: 5.0),
                    child: StoreConnector<AppState, AppState>(
                      converter: (store) => store.state,
                      builder: (context, state) {
                        return Text('${translate('default.user')}: ${state.user?.name}');
                      },
                    )
                ),
                TextButton(
                    onPressed: () => {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => const BasketPay()))
                    },
                    child: Text('${translate('default.switch_to')} StreamBuilder Local')
                ),
                TextButton(
                    onPressed: () => {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => const StreamNetworkPage()))
                    },
                    child: Text('${translate('default.switch_to')} StreamBuilder Network')
                ),
                TextButton(
                    onPressed: () => {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => const StreamControlPage()))
                    },
                    child: Text('${translate('default.switch_to')} StreamBuilder Control')
                ),
                TextButton(
                    onPressed: () => {
                      alertShowErrorNetwork()
                    },
                    child: Text(translate('default.alert_test'))
                ),

                TextButton(
                    onPressed: () => {
                      APICacheManager().emptyCache(),
                      Helpers().alertShow(context: context, message: '${translate('default.cleared_cache')}!')
                    },
                    child: Text(translate('default.reset_cache'))
                ),
                TextButton(
                    onPressed: () =>  {
                      store.dispatch(ResetLoadTestThunkAction()),
                      loadTestThunkAction(store),
                      Helpers().alertShow(context: context, message: translate('default.test_passed'))
                    },
                    child: Text(translate('default.load_test'))
                ),
                TextButton(
                    onPressed: () =>  {
                      store.dispatch(ResetLoadTestThunkAction()),
                      setState(() => count = 0)
                    },
                    child: Text(translate('default.reset'))
                ),

                Container(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 10.0 ,left: 8),
                    child: Row(
                      children: [
                        Text('${translate('default.result')}:  '),
                        StoreConnector<AppState, dynamic>(
                            converter: (store) => store.state.counts,
                            builder: (context, counts) {
                              if(store.state.isSpinner) {
                                return const Loading(fullHeight: false, size: 20,border: 10);
                              }else{
                                return Text('$counts');
                              }
                            }
                        )
                      ],
                    )
                ),
                counterContent(),
                const SizedBox(height: 20,),
                Text(translatePlural('plural.demo',count))
                //"other": "You have pushed the button {{value}} times." // Вы нажали кнопку {{value}} раз.
              ],
            ),
          ),
        ),
        bottomNavigationBar: TabBottomNavigationBar(onTab: (int index) {
         // Navigator.pop(context);
        },indexTab: 1)
    );
  }

  Widget counterContent() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0, left: defaultPadding, right: defaultPadding ),
      child: Row(
        children: [
          ElevatedButton(onPressed: () => setState(() => count++), child: const Text("+")),
          SizedBox(
            width: 50,
            height: 50,
            child: Center(child: Text('$count')),
          ),
          ElevatedButton(onPressed: () => setState(() => count = count > 0 ? (count - 1) : 0), child: const Text("-"))
        ]
      ),
    );
  }
}
