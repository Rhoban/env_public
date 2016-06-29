<?php

// Values to be forced
$forceValues = [
    'benchmark' => 'false',
    'benchmarkDetail' => 0,
    'readFromLog' => 'false',
    'embedded' => 'true',
    'imageDelay' => 11,
    'nbparticlesBF' => 1,
    'playing' => 'true',
    'showRobotView' => 'false',
    'showTaggedImg' => 'false',
    'showTopView' => 'false'
];

if ($argc != 2) {
    die('Usage: embed input.xml > output.xml'."\n");
}

// 1: Removing the "dev" section
$data = file_get_contents($argv[1]);
$data = preg_replace('#<!-- dev -->(.+)<!-- /dev -->#mUsi', '', $data);

function sxml_append(SimpleXMLElement $to, SimpleXMLElement $from) {
    $toDom = dom_import_simplexml($to);
    $fromDom = dom_import_simplexml($from);
    $toDom->appendChild($toDom->ownerDocument->importNode($fromDom, true));
}

// Loading the XML file
$xml = simplexml_load_string($data);
foreach ($xml as $child) {
    $name = $child->getName();
    // 2: Replacing forced values
    if (isset($forceValues[$name])) {
        $child[0] = $forceValues[$name];
    }
    // 3: In the pipeline, disabling graphics
    if ($name == 'pipeline') {
        $remove = [];
        $removing = false;
        foreach ($child as $filter) {
            if ($filter->getName() == 'filter') {
                $p = &$filter->xpath('debugLevel/graphics');
                $p[0][0] = 'false';
                
                $p = &$filter->xpath('paramInts/paramInt');
                foreach ($p as $e) {
                    $a = $e->xpath('name');
                    if ($a[0][0] == 'tagLevel') {
                        $b = $e->xpath('value');
                        $b[0][0] = 0;
                    }
                }
            }
            $p = &$filter->xpath('className');
            if ($p[0][0] == 'SourceLogs2') {
                $removing = true;
            }
            if ($removing) {
                $remove[] = $filter;
            }
        }
        foreach ($remove as $r) {
            unset($r[0][0]);
        }

    }
}

echo $xml->asXML();
