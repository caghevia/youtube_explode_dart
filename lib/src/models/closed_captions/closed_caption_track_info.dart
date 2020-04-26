import 'package:equatable/equatable.dart';

import '../models.dart';

/// Metadata associated with a certain [ClosedCaptionTrack]
class ClosedCaptionTrackInfo extends Equatable {
  /// Manifest URL of the associated track.
  final Uri url;

  /// Language of the associated track.
  final Language language;

  /// Whether the associated track was automatically generated.
  final bool isAutoGenerated;

  /// Initializes an instance of [ClosedCaptionTrackInfo]
  const ClosedCaptionTrackInfo(this.url, this.language, {this.isAutoGenerated});

  @override
  List<Object> get props => [url, language, isAutoGenerated];
}
