import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sole_trader/screens/clients_list_screen.dart';
import 'theme/theme_colors.dart';

// void main() {
//   runApp(MaterialApp(
//     title: 'RevenueCat Sample',
//     home: InitialScreen(),
//   ));
// }
final Color backgroundColor = LightTheme.cDarkYellow;
final Color textColor = LightTheme.cDarkBlue;
final Color iconsColor = LightTheme.cDarkBlue;

final TextStyle bodyTextStyle = TextStyle(
  color: textColor,
  fontSize: 15.0,
  fontWeight: FontWeight.w400,
  fontFamily: 'Poppins',
  letterSpacing: 1.1,
);

class paymentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<paymentScreen> {
  PurchaserInfo _purchaserInfo;
  Offerings _offerings;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(
        "XDNEiOgbdtFlYZNwxqJWAiSGuChXzWNQ"); //here is my public API key
    Purchases.addAttributionData({}, PurchasesAttributionNetwork.facebook);
    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
    Offerings offerings = await Purchases.getOfferings();
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _purchaserInfo = purchaserInfo;
      _offerings = offerings;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_purchaserInfo == null) {
      return Scaffold(
        backgroundColor: LightTheme.cLightYellow,
        appBar: AppBar(
          title: Text(
            "soleTrader",
            style: TextStyle(
              color: textColor,
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins',
              letterSpacing: 1.2,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: backgroundColor,
          // actions: widgets,
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(color: iconsColor, size: 30),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Loading...",
                style: bodyTextStyle,
              ),
              // FlatButton(
              //   color: LightTheme.cGreen,
              //   child: Text('Skip Purchasing'),
              //   onPressed: () {
              //     Navigator.of(context).pushReplacement(
              //         MaterialPageRoute(builder: (_) => ClientsListScreen()));
              //   },
              // ),
            ],
          ),
        ),
      );
    } else {
      var isPro =
          _purchaserInfo.entitlements.active.containsKey("unlimited_access");
      if (isPro) {
        // return ClientsListScreen();
        // Navigator.pop(context);
      } else {
        return UpsellScreen(
          offerings: _offerings,
        );
      }
    }
  }
}

class UpsellScreen extends StatelessWidget {
  final Offerings offerings;

  UpsellScreen({Key key, @required this.offerings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (offerings != null) {
      final offering = offerings.current;
      if (offering != null) {
        final monthly = offering.monthly;
        final annual = offering.annual;
        final lifetime = offering.lifetime;
        if (monthly != null && lifetime != null && annual != null) {
          return Scaffold(
            backgroundColor: LightTheme.cLightYellow,
            appBar: AppBar(
              title: Text(
                "soleTrader",
                style: TextStyle(
                  color: textColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                  letterSpacing: 1.2,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              backgroundColor: backgroundColor,
              // actions: widgets,
              centerTitle: true,
              elevation: 1,
              iconTheme: IconThemeData(color: iconsColor, size: 30),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Monthly subscription with 14 days trial',
                    style: bodyTextStyle,
                  ),
                  PurchaseButton(package: monthly),
                  Text('Annual subscription with 14 days trial',
                      style: bodyTextStyle),
                  PurchaseButton(package: annual),
                  Text('Lifetime access with one-time purchase',
                      style: bodyTextStyle),
                  PurchaseButton(package: lifetime),
                ],
              ),
            ),
          );
        }
      }
    }
    return Scaffold(
        backgroundColor: LightTheme.cLightYellow,
        appBar: AppBar(
          title: Text(
            "soleTrader",
            style: TextStyle(
              color: textColor,
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins',
              letterSpacing: 1.2,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: backgroundColor,
          // actions: widgets,
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(color: iconsColor, size: 30),
        ),
        body: Center(
          child: Text(
            "Loading...",
            style: bodyTextStyle,
          ),
        ));
  }
}

class PurchaseButton extends StatelessWidget {
  final Package package;

  PurchaseButton({Key key, @required this.package}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: LightTheme.cGreen,
      onPressed: () async {
        try {
          PurchaserInfo purchaserInfo =
              await Purchases.purchasePackage(package);
          var isPro =
              purchaserInfo.entitlements.all["unlimited_access"].isActive;
          if (isPro) {
            return ClientsListScreen();
          }
        } on PlatformException catch (e) {
          var errorCode = PurchasesErrorHelper.getErrorCode(e);
          if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
            print("User cancelled");
          } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
            print("User not allowed to purchase");
          }
        }
        return paymentScreen();
      },
      child: Text(
        "Buy - (${package.product.priceString})",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
