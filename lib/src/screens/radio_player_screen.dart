import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/src/models/radio_response.dart';
import 'package:radio_app/src/providers/radio_provider.dart';
import 'package:volume_controller/volume_controller.dart';

class RadioPlayerScreen extends StatefulWidget {
  @override
  State<RadioPlayerScreen> createState() => _RadioPlayerScreenState();
}

class _RadioPlayerScreenState extends State<RadioPlayerScreen> with TickerProviderStateMixin {
  late AnimationController animationController;
  late RadioProvider provider;

  double _volumeListenerValue = 0;
  double _setVolumeValue = 0;
  double _getVolume = 0;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<RadioProvider>(context, listen: false);
    animationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
    });

    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
  }

  @override
  void dispose() {
    animationController.dispose();
    VolumeController().removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final station = provider.selectedStation;

    return Scaffold(
      body: Center(
        child: Stack(children: [
          _Background(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _BackButton(),
                _DiskImage(),
                SizedBox(height: 10),
                _TitleAndGenre(station: station),
                SizedBox(height: 50),
                _PlayerController(animationController),
                _buildVolume(),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Slider _buildVolume() {
    return Slider(
      activeColor: Color(0xffB7B0E8),
      min: 0.0,
      max: 1,
      onChanged: (newRating) {
        _setVolumeValue = newRating;
        VolumeController().setVolume(_setVolumeValue, showSystemUI: false);
        setState(() {});
      },
      value: _setVolumeValue,
    );
  }
}

class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.center, colors: [
          // Color(0xff33333E),
          Color(0xffB7B0E8),
          Color(0xff201E28),
        ], stops: [
          0.1,
          0.8
        ]),
      ),
    );
  }
}

class _DiskImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final radioProvider = Provider.of<RadioProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(20),
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200),
            gradient: const LinearGradient(begin: Alignment.topLeft, colors: [
              // Color(0xff484750),
              Color(0xffB7B0E8),
              Color(0xff1E1C24),
            ]),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SpinPerfect(
                  duration: Duration(seconds: 10),
                  infinite: true,
                  manualTrigger: true,
                  animate: false,
                  controller: (animationController) {
                    radioProvider.controller = animationController;
                    if (radioProvider.isPlaying) {
                      animationController.forward();
                    }
                    animationController.addStatusListener((status) {
                      if (status == AnimationStatus.completed && radioProvider.isPlaying) {
                        animationController.forward();
                        radioProvider.isPlaying = true;
                        radioProvider.controller.repeat();
                      }
                    });
                  },
                  child: Hero(
                    tag: radioProvider.selectedStation.heroId,
                    child: CircleAvatar(
                      radius: 300,
                      backgroundColor: Color(0xffB7B0E8),
                      backgroundImage: NetworkImage(radioProvider.selectedStation.radioImage),
                    ),
                  ),
                ),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(100)),
                ),
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(color: Color(0xff201E28), borderRadius: BorderRadius.circular(100)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlayerController extends StatefulWidget {
  final AnimationController animationController;
  const _PlayerController(this.animationController);

  @override
  State<_PlayerController> createState() => _PlayerControllerState();
}

class _PlayerControllerState extends State<_PlayerController> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RadioProvider>(context);

    return Container(
      height: 70,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            backgroundColor: Color(0xffB7B0E8),
            onPressed: () {
              provider.isPlaying ? provider.radioPlayer.stop() : provider.radioPlayer.play();
              if (provider.isPlaying) {
                widget.animationController.reverse();
                provider.isPlaying = false;
                provider.controller.stop();
              } else {
                widget.animationController.forward();
                provider.isPlaying = true;
                provider.controller.repeat();
              }
              setState(() {});
            },
            child: Icon(
              provider.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 30,
              color: Color(0xff2C302E),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleAndGenre extends StatelessWidget {
  const _TitleAndGenre({
    Key? key,
    required this.station,
  }) : super(key: key);

  final Station station;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          station.radioName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: 'Baloo2',
          ),
        ),
        Text(station.genre, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Baloo2'))
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.chevron_left_rounded,
              size: 40,
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
