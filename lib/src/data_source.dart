import 'dart:io';
import 'package:meta/meta.dart' show required;
import 'package:video_player/video_player.dart';

class DataSource {
  final File file;
  final String dataSource, package;
  final DataSourceType type;
  final VideoFormat formatHint;
  final Future<ClosedCaptionFile> closedCaptionFile;

  DataSource({
    this.file,
    this.dataSource,
    @required this.type,
    this.formatHint,
    this.package,
    this.closedCaptionFile,
  })  : assert(type != null),
        assert((type == DataSourceType.file && file != null) ||
            dataSource != null);

  DataSource copyWith({
    File file,
    String dataSource,
    String package,
    DataSourceType type,
    VideoFormat formatHint,
    Future<ClosedCaptionFile> closedCaptionFile,
  }) {
    return DataSource(
      file: file ?? this.file,
      dataSource: dataSource ?? this.dataSource,
      type: type ?? this.type,
      package: package ?? this.package,
      formatHint: formatHint ?? this.formatHint,
      closedCaptionFile: closedCaptionFile ?? this.closedCaptionFile,
    );
  }
}
