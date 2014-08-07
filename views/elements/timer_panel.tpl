{*
/**
 * Smarty Timer Panel Element
 *
 * PHP versions 4 and 5
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright 2005-2010, Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright 2005-2010, Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org
 * @package       debug_kit
 * @subpackage    debug_kit.views.elements
 * @since         DebugKit 0.1
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 **/
*}

{if !isset($debugKitInHistoryMode)}
	{$timers = DebugKitDebugger::getTimers(true)}
	{$currentMemory = DebugKitDebugger::getMemoryUse()}
	{$peakMemory = DebugKitDebugger::getPeakMemoryUse()}
	{$requestTime = DebugKitDebugger::requestTime()}
{else}
	{$content = $toolbar->readCache('timer', $view->params['pass'][0])}
	{if is_array($content)}
		{foreach $content as $k => $v}
			{assign var=$k value=$v}
		{/foreach}
	{/if}
{/if}

<div class="debug-info">
	<h2>Memory</h2>
	<div class="peak-mem-use">
		{$toolbar->message('Peak Memory Use', $number->toReadableSize($peakMemory))}
	</div>

	{$headers = ['Message', 'Memory use']}
	{$memoryPoints = DebugKitDebugger::getMemoryPoints()}

	{$rows = []}
	{foreach $memoryPoints as $key => $value}
		{$rows[] = [$key, $number->toReadableSize($value)]}
	{/foreach}

	{$toolbar->table($rows, $headers)}
</div>

<div class="debug-info debug-timers">
	<h2>Timers</h2>
	<div class="request-time">
		{$totalTime = $number->precision($requestTime * 1000, 0)|cat:' (ms)'}
		{$toolbar->message('Total Request Time:', $totalTime)}
	</div>

{$rows = []}
{$end = end($timers)}
{$maxTime = $end.end}

{$headers = ['Message', 'Time in ms', 'Graph']}

{$i = 0}
{$values = array_values($timers)}

{foreach $timers as $timerName => $timeInfo}
	{$indent = 0}
	{for $j = 0 to ($i - 1)}
		{if (($values[$j]['end'] > $timeInfo['start']) && ($values[$j]['end']) > ($timeInfo['end']))}
			{$indent = $indent + 1}
		{/if}
	{/for}
	{$indent = str_repeat(' » ', $indent)}
	{$rows[] = [
		$indent|cat:$timeInfo.message,
		$number->precision($timeInfo.time * 1000, 2),
		$simpleGraph->bar(
			$number->precision($timeInfo.time * 1000, 2),
			$number->precision($timeInfo.start * 1000, 2),
			[
				'max' => $maxTime * 1000,
				'requestTime' => $requestTime * 1000
			]
		)
	]}
	{$i = $i + 1}
{/foreach}

{* can't unset var in smarty??
{if (strtolower($toolbar->getName()) == 'firephptoolbar')}
	{for $i = 0 to $i < count($rows)}
		{$rows[$i][2]|@unset}
	{/for}
	{$headers[2]|@unset}
{/if}
*}

{$toolbar->table($rows, $headers, ['title' => 'Timers'])}

{if (!isset($debugKitInHistoryMode))}
	{* use 'if' because $toolbar->writeCache return true on success and smarty print 1 *}
	{if $toolbar->writeCache('timer', [
		'timers' => $timers,
		'currentMemory' => $currentMemory,
		'peakMemory' => $peakMemory,
		'requestTime' => $requestTime
	])}{/if}
{/if}
</div>
