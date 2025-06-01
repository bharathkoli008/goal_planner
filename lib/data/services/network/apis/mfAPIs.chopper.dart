// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfAPIs.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$MfStockService extends MfStockService {
  _$MfStockService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = MfStockService;

  @override
  Future<Response<dynamic>> getMutualFundData(String schemeCode) {
    final Uri $url = Uri.parse('/${schemeCode}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAllMutualFunds() {
    final Uri $url = Uri.parse('/');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> searchMutualFund(Map<String, dynamic> queries) {
    final Uri $url = Uri.parse('https://stock.indianapi.in/mutual_fund_search');
    final Map<String, dynamic> $params = queries;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> mutualFundDetails(Map<String, dynamic> queries) {
    final Uri $url =
        Uri.parse('https://stock.indianapi.in/mutual_funds_details');
    final Map<String, dynamic> $params = queries;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> searchStock(Map<String, dynamic> queries) {
    final Uri $url = Uri.parse('https://stock.indianapi.in/industry_search');
    final Map<String, dynamic> $params = queries;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> stockDetails(Map<String, dynamic> queries) {
    final Uri $url = Uri.parse('https://stock.indianapi.in/stock');
    final Map<String, dynamic> $params = queries;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
