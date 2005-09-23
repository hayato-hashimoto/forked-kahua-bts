;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: initdb.scm,v 1.5 2005/09/23 11:23:20 cut-sea Exp $
;;
;; include
(use kahua)
(use kahua-server)

(load "kagoiri-musume/version.kahua")
(load "kagoiri-musume/local.kahua")
(load "kagoiri-musume/class.kahua")

;;
(define (main args)
  (with-db (db *kagoiri-musume-database-name*)
    (add-fan "yasuyuki" "yasuyuki" "yasuyuki@kahua.org" 'user)
    (add-fan "nobsun" "nobsun" "nobsun@kahua.org" 'user)
    (add-fan "cut-sea" "cutsea" "cut-sea@kahua.org" 'user)
    (add-fan "shibata" "shibata" "shibata@kahua.org" 'user)
    (add-fan "takahiro" "takahiro" "takahiro@kahua.org" 'user)
    (add-fan "kago" "kago" "cut-sea@kahua.org" 'admin 'user)
    (add-fan "   " "anybody" "khead@kahua.org")

    (make <priority> :priorityid "super" :disp-name "超高" :level 5)
    (make <priority> :priorityid "high" :disp-name "高" :level 4)
    (make <priority> :priorityid "low" :disp-name "低" :level 2)
    (make <priority> :priorityid "normal" :disp-name "普通" :level 3)
    (make <status> :statusid "rejected" :disp-name "REJECTED")
    (make <status> :statusid "taken" :disp-name "TAKEN")
    (make <status> :statusid "on-hold" :disp-name "ON HOLD")
    (make <status> :statusid "completed" :disp-name "COMPLETED")
    (make <status> :statusid "open" :disp-name "OPEN")
    (make <type> :typeid "etc" :disp-name "その他")
    (make <type> :typeid "term" :disp-name "用語")
    (make <type> :typeid "report" :disp-name "報告")
    (make <type> :typeid "discuss" :disp-name "議論")
    (make <type> :typeid "request" :disp-name "変更要望")
    (make <type> :typeid "task" :disp-name "タスク")
    (make <type> :typeid "bug" :disp-name "バグ")
    (make <category> :categoryid "master" :disp-name "マスタ")
    (make <category> :categoryid "infra" :disp-name "インフラ")
    (make <category> :categoryid "global" :disp-name "全体")
    (make <category> :categoryid "section" :disp-name "セクション")
    (make <unit>
      :unit-name "Karetta.jp Proj." :description "Karetta.jpプロジェクトのバグトラッキングを行う"
      :fans '("   " "cut-sea") :priorities '("normal" "low" "high")
      :statuss '("open" "completed")
      :types '("bug" "task" "request" "discuss" "etc")
      :categories '("global" "infra" "master"))
    (make <unit>
      :unit-name "Kahua Project" :description "Kahuaプロジェクトのタスクマネージ"
      :fans '("   " "cut-sea" "dummy") :priorities '("normal" "low" "high" "super")
      :statuss '("open" "completed" "on-hold" "taken" "rejected")
      :types '("bug" "task" "request" "discuss" "report" "term" "etc")
      :categories '("section" "global" "infra" "master"))
    )
  (format #t "done~%")
  )

