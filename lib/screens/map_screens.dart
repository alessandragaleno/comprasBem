import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreens extends StatefulWidget {
  @override
  _MapScreensState createState() => _MapScreensState();

}

class  _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  latLng _userLocaton = LatLng (-23.5505, -46.6333); //padrão: São Paulo

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

  // verifica se o GPS está ativado
  serviceEnable = await Geolocator.isLocationServiceEnable();
  if (!serviceEnabled) {
      return;
    }

  // vrifuca permissões
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      return;
    }
  }

  // obtem a localização atual
  Position position = await Geolocator.getCurrentPosition();
  setState(() {
    _userLocation = LatLng(position.latitude, position.longitude);
    });

    // Move a câmera para a localização do usuário
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(_userLocaton)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Google Maps no Flutter")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _userLocation,
          zoom: 14,
        ),
        onMapCreated: (controller) => _mapController = controller,
        myLocationEnabled: true, // exibe o ponto azul de usuario
        myLocationButtonEnabled: true, // exibe o botão de localização
      )
    );
  }
}