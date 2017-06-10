# redmine_citrus_interlock_progress

* This plugin is 'issue' extension for Redmine.  
(このプラグインはRedmineのチケット拡張機能です。)

## Compatibility

* Redmine 3.3.3
* Ruby 2.3.4

I am checking the operation.  
(以上のバージョンで動作確認を行っています。)

## Installation

1. change directory

        cd {REDMINE_ROOT}/plugins

2. put plugin files

    * git clone

            git clone https://github.com/take64/redmine_citrus_interlock_progress.git redmine_citrus_interlock_progress

        or

            git clone git@github.com:take64/redmine_citrus_interlock_progress.git redmine_citrus_interlock_progress

    * zip unarchive

            wget https://github.com/take64/redmine_citrus_interlock_progress/archive/master.zip

3. Redmine restart

## Usage

### Citrus Interlock Progress

* Purpose

    * In all cases, interlock progress of parent ticket and child ticket.  
    (全ての場合に、親チケットと子チケットの進捗を同期する。)

* Contents

    * Parent ticket 'ABCD'  
    Child ticket 'A', 'B', 'C', 'D'

    * A => 50%, B => 25%, C => 75%, D => 50%  
    ABCD => 50%

## License

* GNU General Public License, version 2 (GPLv2)

## Auther/Developer

**take64** (Citrus/besidesplus)
* Twitter: https://twitter.com/citrus_take64
* github: https://github.com/take64
* website: http://besidesplus.net/
