enum EnumFilter {
  ALL,
  CREATED,
  IN_PROGRESS,
  FINISHED,
  CANCELED;

  static EnumFilter getEnumFilterFromString(String value) {
    switch (value) {
      case "ALL":
        return EnumFilter.ALL;
      case "CREATED":
        return EnumFilter.CREATED;
      case "IN_PROGRESS":
        return EnumFilter.IN_PROGRESS;
      case "FINISHED":
        return EnumFilter.FINISHED;
      case "CANCELED":
        return EnumFilter.CANCELED;
    }

    return EnumFilter.ALL;
  }
}

extension EnumFilterExtension on EnumFilter {
  String get name {
    switch (this) {
      case EnumFilter.ALL:
        return "Tous";
      case EnumFilter.CREATED:
        return "Créer";
      case EnumFilter.IN_PROGRESS:
        return "En cours";
      case EnumFilter.FINISHED:
        return "Terminer";
      case EnumFilter.CANCELED:
        return "Annuler";
    }
  }
}

extension EnumFilterString on EnumFilter {
  String getValue() {
    switch (this) {
      case EnumFilter.ALL:
        return "ALL";
      case EnumFilter.CREATED:
        return "CREATED";
      case EnumFilter.IN_PROGRESS:
        return "IN_PROGRESS";
      case EnumFilter.FINISHED:
        return "FINISHED";
      case EnumFilter.CANCELED:
        return "CANCELED";
    }
  }
}