// Single import file for the whole app (same idea as Aspirant League).
// Every screen / repo just imports this instead of a long list of packages.
export 'dart:async';
export 'dart:convert';

export 'package:flutter/foundation.dart';
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:dio/dio.dart';
export 'package:equatable/equatable.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:cached_network_image/cached_network_image.dart';

export 'core/core.dart';
export 'constants/constants.dart';
export 'data/data.dart';
export 'global_widgets/global_widgets.dart';
export 'presentation/presentation.dart';
