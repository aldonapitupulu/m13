import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MainScreen1 extends StatefulWidget {
  const MainScreen1({super.key});

  @override
  State<MainScreen1> createState() => _MainScreen1State();
}

class _MainScreen1State extends State<MainScreen1> {
  int coin = 0;
  late BannerAd _bannerAd;
  bool _isBannerReady = false;

  late InterstitialAd _interstitialAd;
  bool _isInterstitialReady = false;

  late RewardedAd  _rewardedAd;
  bool _isRewardedReady = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admov")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.monetization_on, size: 50,
                ),
                Text(
                  coin.toString(),
                  style: TextStyle(fontSize: 50),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _loadinterstisialAd();
                if (_isInterstitialReady) {
                  _interstitialAd.show();
                }
              }, child: Text("Interstitial ads")),
              ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _loadRewardedAd();
                if (_isRewardedReady) {
                  _rewardedAd.show(onUserEarnedReward:
                  (AdWithoutView ad, RewardItem reward) {
                    setState(() {
                      coin += 1;
                    });
                  });
                }
              }, child: Text("Rewarded")),
            ),
            Expanded(
              child: _isBannerReady
                ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  ),
                )
                : Container()
              ),
        ],
      )
    );
  }
  
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-3940256099942544/6300978111",
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          _isBannerReady = false;
          ad.dispose();
        },
      ),
      request: AdRequest(),
    );
    _bannerAd.load();
  }
  
  void _loadinterstisialAd() {
    InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
       request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                print("close Inter ads");
              },
            );
            setState(() {
              _isInterstitialReady =true;
              _interstitialAd = ad;
            });
          },
           onAdFailedToLoad: (err) {
            _isInterstitialReady = false;
            _interstitialAd.dispose();
           },
         ),
        );
  }
  
   void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: "ca-app-pub-3940256099942544/5224354917",
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _isRewardedReady = false;
              });
              _loadBannerAd();
            },
          );
          setState(() {
            _isRewardedReady = true;
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          _isRewardedReady = false;
          _rewardedAd.dispose();
        },
      ),
    );
  }
}