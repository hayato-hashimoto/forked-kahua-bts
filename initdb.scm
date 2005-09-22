;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: initdb.scm,v 1.3 2005/09/22 23:00:16 cut-sea Exp $
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
    (add-fan "yasuyuki" "yasuyuki" "yasuyuki@timedia.co.jp" 'user)
    (add-fan "nobsun" "nobsun" "nyama@timedia.co.jp" 'user)
    (add-fan "cut-sea" "cutsea" "cut-sea@timedia.co.jp" 'user)
    (add-fan "kago" "kago" "kago@kagoiri.org" 'admin 'user)
    (add-fan "   " "anybody" "dummy@kahua.org")

    (make <priority> :priorityid "super" :disp-name "Ķ��" :level 5)
    (make <priority> :priorityid "high" :disp-name "��" :level 4)
    (make <priority> :priorityid "low" :disp-name "��" :level 2)
    (make <priority> :priorityid "normal" :disp-name "����" :level 3)
    (make <status> :statusid "rejected" :disp-name "REJECTED")
    (make <status> :statusid "taken" :disp-name "TAKEN")
    (make <status> :statusid "on-hold" :disp-name "ON HOLD")
    (make <status> :statusid "completed" :disp-name "COMPLETED")
    (make <status> :statusid "open" :disp-name "OPEN")
    (make <type> :typeid "etc" :disp-name "����¾")
    (make <type> :typeid "term" :disp-name "�Ѹ�")
    (make <type> :typeid "report" :disp-name "���")
    (make <type> :typeid "discuss" :disp-name "����")
    (make <type> :typeid "request" :disp-name "�ѹ���˾")
    (make <type> :typeid "task" :disp-name "������")
    (make <type> :typeid "bug" :disp-name "�Х�")
    (make <category> :categoryid "master" :disp-name "�ޥ���")
    (make <category> :categoryid "infra" :disp-name "����ե�")
    (make <category> :categoryid "global" :disp-name "����")
    (make <category> :categoryid "section" :disp-name "���������")
    (make <unit>
      :unit-name "Karetta.jp Proj." :description "Karetta.jp�ץ������ȤΥХ��ȥ�å��󥰤�Ԥ�"
      :fans '("   " "cut-sea") :priorities '("normal" "low" "high")
      :statuss '("open" "completed")
      :types '("bug" "task" "request" "discuss" "etc")
      :categories '("global" "infra" "master"))
    (make <unit>
      :unit-name "Kahua Project" :description "Kahua�ץ������ȤΥ������ޥ͡���"
      :fans '("   " "cut-sea" "dummy") :priorities '("normal" "low" "high" "super")
      :statuss '("open" "completed" "on-hold" "taken" "rejected")
      :types '("bug" "task" "request" "discuss" "report" "term" "etc")
      :categories '("section" "global" "infra" "master"))
    )
  (format #t "done~%")
  )

