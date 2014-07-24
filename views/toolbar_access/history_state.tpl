{*
<?php
/**
 * Toolbar history state view.
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
 * @subpackage    debug_kit.views.helpers
 * @since         DebugKit 1.0
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 **/
?>
*}
{$panels = []}
{foreach $toolbarState as $panelName => $panel}
	{$panels[$panelName] = $view->element($panel.elementName, ['content' => $panel.content, 'plugin' => $panel.plugin])}
{/foreach}
{$javascript->object($panels)}
{$conf->write('debug', 0)}
