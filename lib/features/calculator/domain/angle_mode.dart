enum AngleMode {
  degrees,
  radians,
  gradians,
}

extension AngleModeLabel on AngleMode {
  String get shortLabel {
    switch (this) {
      case AngleMode.degrees:
        return 'DEG';
      case AngleMode.radians:
        return 'RAD';
      case AngleMode.gradians:
        return 'GRAD';
    }
  }
}
