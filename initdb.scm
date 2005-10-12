;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: initdb.scm,v 1.7 2005/10/12 17:49:01 cut-sea Exp $
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
    (add-fan "   " "anybody" "anybody@kagoiri.org")
    (add-fan "kago" "kago" "cut-sea@kagoiri.org" 'admin 'user)
    (add-fan "cut-sea" "cutsea" "cut-sea@kagoiri.org" 'user)

    (make <priority> :code "normal" :disp-name "����" :level 3)
    (make <priority> :code "low" :disp-name "��" :level 2)
    (make <priority> :code "high" :disp-name "��" :level 4)
    (make <priority> :code "super" :disp-name "Ķ��" :level 5)

    (make <status> :code "open" :disp-name "OPEN")
    (make <status> :code "completed" :disp-name "COMPLETED")
    (make <status> :code "on-hold" :disp-name "ON HOLD")
    (make <status> :code "taken" :disp-name "TAKEN")
    (make <status> :code "rejected" :disp-name "REJECTED")

    (make <type> :code "bug" :disp-name "�Х�")
    (make <type> :code "task" :disp-name "������")
    (make <type> :code "request" :disp-name "�ѹ���˾")
    (make <type> :code "discuss" :disp-name "����")
    (make <type> :code "report" :disp-name "���")
    (make <type> :code "term" :disp-name "�Ѹ�")
    (make <type> :code "etc" :disp-name "����¾")

    (make <category> :code "section" :disp-name "���������")
    (make <category> :code "global" :disp-name "����")
    (make <category> :code "infra" :disp-name "����ե�")
    (make <category> :code "master" :disp-name "�ޥ���")
    )
  (format #t "done~%")
  )

