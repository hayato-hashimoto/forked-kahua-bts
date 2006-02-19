;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: common-test.scm,v 1.2 2006/02/19 03:09:14 shibata Exp $

;; ����ƥ�ĺ����ѥƥ��ȥ饤�֥��

(define-module common-test
  (use gauche.test)
  (use gauche.collection)
  (use file.util)
  (use text.tree)
  (use sxml.ssax)
  (use sxml.sxpath)
  (use kahua)
  (use kahua.test.xml)
  (use kahua.test.worker)
  (export //page-title
          login
          make-unit
          ))

(select-module common-test)

(define //page-title '(// (div (@ (equal? (id "body")))) h2))


(define (login w . options)
  (let-keywords* options ((top :top '?*))

    (reset-gsid w)

    (test* "���������"
           `(*TOP*
             (form (@ (method "POST")
                      (action ,top))
                   ?*))
           (call-worker/gsid->sxml w '() '() '(// (div (@ (equal? (id "body")))) form))
           (make-match&pick w))))

(define (make-unit w . options)
  (let-keywords* options ((view :view '?*)
                          (edit :edit '?*))

    (test* "��˥åȺ����ڡ���"
           '(*TOP*
             (form (@ (onsubmit "return submitForm(this)")
                      (method "POST")
                      (action ?&))
                   ?*
                   (input (@ (value "����˥åȷ���") (type "submit")))))
           (call-worker/gsid->sxml w
                                   '()
                                   '(("name" "cut-sea") ("pass" "cutsea"))
                                   '(// (div (@ (equal? (id "body")))) form))
           (make-match&pick w))

    (test/send&pick "��˥åȺ��� ���֥ߥå�"
                    w
                    '(("priority" "normal" "low" "high")
                      ("status" "open" "completed")
                      ("type" "bug" "task" "request")
                      ("category" "global" "section")
                      ("name" "����̼��Test Proj.")
                      ("desc" "����̼���ΥХ��ȥ�å��󥰤�Ԥ���˥å�")
                      ("fans" "   " "cut-sea")))

    (test* "������˥åȤγ�ǧ"
           `(*TOP*
             (tr ?@
                 (td (a (@ (href ,edit)) "����"))
                 (td (a (@ (href ,view)) "����̼��Test Proj.") " (0)")
                 (td "����̼���ΥХ��ȥ�å��󥰤�Ԥ���˥å�")
                 (td "cut-sea")
                 (td (a ?@ "��"))))
           (call-worker/gsid->sxml
            w
            '()
            '()
            '(// (div (@ (equal? (id "body")))) table tbody tr))
           (make-match&pick w))))