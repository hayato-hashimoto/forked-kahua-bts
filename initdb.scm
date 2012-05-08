;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: initdb.scm,v 1.24 2006/12/27 17:45:52 cut-sea Exp $

;;
;; include
(use file.util)
(use gauche.parseopt)
(use kahua)
(use kahua-server)

(load "kagoiri-musume/version.kahua")
(load "kagoiri-musume/util.kahua")
(load "kagoiri-musume/class.kahua")

;; for test
(if (symbol-bound? 'config-file)
    (kahua-init config-file))

;; DB Setting.
;;

(define-if-not-bound *kagoiri-musume-log-database-name*
  (let1 conf (kahua-config)
    #`",(ref conf 'database-directory)/log"))

;; tip
(define-macro (new class key . args)
  `(if (not (find-kahua-instance ,class ,key))
       (make ,class :code ,key ,@args)))

;; tip
(define-macro (new-fan key . args)
  `(if (not (find-kahua-instance <fan> ,key))
       (add-fan ,key ,@args)))

;;
(define (main args)
  (let-args (cdr args)
      ((conf-file "c=s" #f)
       (site "S=s" #f))
    (let* ((conf (if site (kahua-common-init site conf-file) (kahua-config)))
	   (database  #`",(ref conf 'database-directory)/,(ref conf 'default-database-name)"))
      (with-db (db database)
	  (new-fan "kago" "kago" "cut-sea@kagoiri.org" 'admin 'developer 'client 'user)
	(new-fan "cut-sea" "cutsea" "cut-sea@kagoiri.org" 'developer 'user)

	(new <priority> "normal" :disp-name "普通" :level 3)
	(new <priority> "low" :disp-name "低" :level 2)
	(new <priority> "high" :disp-name "高" :level 4)
	(new <priority> "super" :disp-name "超高" :level 5)

	(new <status> "open" :disp-name "OPEN")
	(new <status> "completed" :disp-name "COMPLETED")
	(new <status> "on-hold" :disp-name "ON HOLD")
	(new <status> "taken" :disp-name "TAKEN")
	(new <status> "rejected" :disp-name "REJECTED")

	(new <type> "bug" :disp-name "バグ")
	(new <type> "task" :disp-name "タスク")
	(new <type> "request" :disp-name "変更要望")
	(new <type> "discuss" :disp-name "議論")
	(new <type> "report" :disp-name "報告")
	(new <type> "term" :disp-name "用語")
	(new <type> "etc" :disp-name "その他")

	(new <category> "section" :disp-name "セクション")
	(new <category> "global" :disp-name "全体")
	(new <category> "infra" :disp-name "インフラ")
	(new <category> "master" :disp-name "マスタ")
	)
      (format #t "database initialize done~%")
      (exit 0))))

