import 'package:equatable/equatable.dart';

/// User activity statistics.
class Statistics extends Equatable {
  /// View count.
  final int viewCount;

  /// Like count.
  final int likeCount;

  /// Dislike count.
  final int dislikeCount;

  /// Initializes an instance of [Statistics]
  const Statistics(this.viewCount, this.likeCount, this.dislikeCount);

  /// Average user rating in stars (1 star to 5 stars).
  num get avgRating {
    if (likeCount + dislikeCount == 0) {
      return 0;
    }
    return 1 + 4.0 * likeCount / (likeCount + dislikeCount);
  }

  @override
  List<Object> get props => [viewCount, likeCount, dislikeCount];
}
