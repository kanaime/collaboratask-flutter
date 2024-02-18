enum EnumStatus {
  CREATED,
  IN_PROGRESS,
  FINISHED,
  CANCELED;

  static EnumStatus getStatusFromString(String value) {
    switch (value) {
      case "CREATED":
        return EnumStatus.CREATED;
      case "IN_PROGRESS":
        return EnumStatus.IN_PROGRESS;
      case "FINISHED":
        return EnumStatus.FINISHED;
      case "CANCELED":
        return EnumStatus.CANCELED;
    }

    return EnumStatus.CREATED;
  }

}

extension ProjectStatusExtension on EnumStatus {
  String get name {
    switch (this) {
      case EnumStatus.CREATED:
        return "créer";
      case EnumStatus.IN_PROGRESS:
        return "en cours";
      case EnumStatus.FINISHED:
        return "terminer";
      case EnumStatus.CANCELED:
        return "annuler";
    }
  }
}

extension ProjectPercent on EnumStatus {
  double getPercent() {
    switch (this) {
      case EnumStatus.CREATED:
        return 0.0;
      case EnumStatus.IN_PROGRESS:
        return 0.5;
      case EnumStatus.FINISHED:
        return 1.0;
      case EnumStatus.CANCELED:
        return 1.0;
    }
  }
}

extension ProjectStatusString on EnumStatus {
  String getValue() {
    switch (this) {
      case EnumStatus.CREATED:
        return "CREATED";
      case EnumStatus.IN_PROGRESS:
        return "IN_PROGRESS";
      case EnumStatus.FINISHED:
        return "FINISHED";
      case EnumStatus.CANCELED:
        return "CANCELED";
    }
  }
}




