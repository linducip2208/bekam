<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Cache-Control: no-store, no-cache, must-revalidate');

$dataFile = __DIR__ . '/counter-data.json';
$today = date('Y-m-d');
$now = time();
$onlineWindow = 300; // 5 menit dianggap online
$ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
$ua = $_SERVER['HTTP_USER_AGENT'] ?? 'unknown';
$visitorKey = md5($ip . substr($ua, 0, 50));
$page = $_GET['page'] ?? '/';
$action = $_GET['action'] ?? 'track';

if (!file_exists($dataFile)) {
    file_put_contents($dataFile, json_encode([
        'total_visitors' => 0,
        'total_pageviews' => 0,
        'daily' => [],
        'visitors' => [],
        'online' => [],
        'pages' => [],
    ]));
}

$data = json_decode(file_get_contents($dataFile), true);

if ($action === 'get') {
    cleanupOnline($data, $onlineWindow, $now);
    $todayData = $data['daily'][$today] ?? ['visitors' => 0, 'pageviews' => 0];
    echo json_encode([
        'total_visitors' => $data['total_visitors'],
        'total_pageviews' => $data['total_pageviews'],
        'today_visitors' => $todayData['visitors'],
        'today_pageviews' => $todayData['pageviews'],
        'online' => count($data['online']),
        'top_pages' => getTopPages($data['pages'], 5),
    ], JSON_PRETTY_PRINT);
    exit;
}

if ($action === 'track') {
    // Track pageview
    $data['total_pageviews']++;

    if (!isset($data['daily'][$today])) {
        $data['daily'][$today] = ['visitors' => 0, 'pageviews' => 0];
    }
    $data['daily'][$today]['pageviews']++;

    // Track unique visitor
    if (!isset($data['visitors'][$visitorKey])) {
        $data['visitors'][$visitorKey] = $now;
        $data['total_visitors']++;
        $data['daily'][$today]['visitors']++;
    } else {
        $data['visitors'][$visitorKey] = $now;
    }

    // Track online
    $data['online'][$visitorKey] = $now;

    // Track pages
    if (!isset($data['pages'][$page])) {
        $data['pages'][$page] = 0;
    }
    $data['pages'][$page]++;

    // Cleanup old daily data (keep 90 days)
    foreach ($data['daily'] as $date => $val) {
        if (strtotime($date) < strtotime('-90 days')) {
            unset($data['daily'][$date]);
        }
    }

    cleanupOnline($data, $onlineWindow, $now);
    file_put_contents($dataFile, json_encode($data));

    $todayData = $data['daily'][$today] ?? ['visitors' => 0, 'pageviews' => 0];
    echo json_encode([
        'status' => 'ok',
        'total_visitors' => $data['total_visitors'],
        'total_pageviews' => $data['total_pageviews'],
        'today_visitors' => $todayData['visitors'],
        'today_pageviews' => $todayData['pageviews'],
        'online' => count($data['online']),
    ]);
    exit;
}

function cleanupOnline(&$data, $window, $now) {
    foreach ($data['online'] as $key => $time) {
        if ($now - $time > $window) {
            unset($data['online'][$key]);
        }
    }
}

function getTopPages($pages, $limit) {
    arsort($pages);
    return array_slice($pages, 0, $limit, true);
}
