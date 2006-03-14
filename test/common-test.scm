;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: common-test.scm,v 1.6 2006/03/14 15:01:00 shibata Exp $

;; ����ƥ�ĺ����ѥƥ��ȥ饤�֥��

(define-module common-test
  (use srfi-13)
  (use gauche.test)
  (use gauche.collection)
  (use file.util)
  (use text.tree)
  (use sxml.ssax)
  (use sxml.sxpath)
  (use kahua)
  (use kahua.test.xml)
  (use kahua.test.worker)
  (export  //body
           //page-title
           //navigation
           //menu
           login
           make-unit
           make-musume
          ))

(select-module common-test)

(define //body '(// (div (@ (equal? (id "body"))))))
(define //page-title `(,@//body h2))
(define //navigation '(// (div (@ (equal? (id "navigation"))))))
(define //menu '(// (ul (@ (equal? (class "menu"))))))


(define (login w . options)
  (let-keywords* options ((top :top '?*))

    (test-section "common-test.scm: login")

    (reset-gsid w)

    (test* "login: ���������"
           `(*TOP*
             (form (@ (method "POST")
                      (action ,top))
                   ?*))
           (call-worker/gsid->sxml w '() '() '(// (div (@ (equal? (id "body")))) form))
           (make-match&pick w))))

(define (make-unit w . options)
  (let-keywords* options ((view :view '?*)
                          (edit :edit '?*))

    (test-section "common-test.scm: make-unit")

    (test* "make-unit: ��˥åȺ����ڡ���"
           '(*TOP*
             (form (@ (onsubmit "return submitCreateUnit(this)")
                      (method "POST")
                      (action ?&))
                   ?*
                   (input (@ (value "����˥åȷ���") (type "submit")))))
           (call-worker/gsid->sxml w
                                   '()
                                   '(("name" "cut-sea") ("pass" "cutsea"))
                                   '(// (div (@ (equal? (id "body")))) form))
           (make-match&pick w))

    (test/send&pick "make-unit: ��˥åȺ��� ���֥ߥå�"
                    w
                    '(("priority" "normal" "low" "high")
                      ("status" "open" "completed")
                      ("type" "bug" "task" "request")
                      ("category" "global" "section")
                      ("name" "����̼��Test Proj.")
                      ("desc" "����̼���ΥХ��ȥ�å��󥰤�Ԥ���˥å�")
                      ("fans" "   " "cut-sea")))

    (test* "make-unit: ������˥åȤγ�ǧ"
           `(*TOP*
             (tr ?@
                 (td ?@ (a (@ (href ,view)) "����̼��Test Proj.") " (0)")
                 (td "����̼���ΥХ��ȥ�å��󥰤�Ԥ���˥å�")
                 (td (span ?@
                           (span ?@ "1��"))
                     (div ?@ (div "cut-sea")))
                 (td (a ?@ "��"))
                 (td ?@ (span ?@ (a (@ (href ,edit)) "����")))))
           (call-worker/gsid->sxml
            w
            '()
            '()
            '(// (div (@ (equal? (id "body")))) table tbody tr))
           (make-match&pick w))))

(define (make-musume w . options)
  (let-keywords* options ((unit-view :unit-view #f)
                          (view :view #f))

    (test-section "common-test.scm: make-musume")

    (make-unit w :view (or unit-view '?&))

    (when unit-view
      (set-gsid w (string-drop (symbol->string unit-view) 2)))

    (test* "make-musume: �Ʒ�������"
           '(*TOP*
             ?*
             (li (a (@ (href ?&)
                       ?*)
                    "������̼��"))
             ?*)
           (call-worker/gsid->sxml w
                                   '()
                                   '()
                                   '(// (ul (@ (equal? (class "menu")))) *))
           (make-match&pick w))

    (test* "make-musume: �ե�����"
           '(*TOP*
             (form (@ ?*
                      (action ?&))
                   ?*))
           (call-worker/gsid->sxml w
                                   '()
                                   '()
                                   '(// (form (@ (equal? (id "mainedit"))))))
           (make-match&pick w))

    (test* "make-musume: �Ʒ���� ���֥ߥå�"
           `(*TOP*
             (!contain (Status "302 Moved")
                       (Location ,(or view '?&))))
           (call-worker/gsid
            w
            '()
            '(("priority" "high")
              ("status" "open")
              ("type" "task")
              ("category" "global")
              ("name" "�ƥ��Ȥ�̼��")
              ("melody" "�ƥ��Ȥ򤹤�ɬ�פ�����ΤǤ���ʤ�")
              ("assign" "cut-sea"))
            header->sxml)
           (make-match&pick w))

    (when view
      (set-gsid w (string-drop (symbol->string view) 2)))

    (test* "make-musume: �����Ʒ��melody�ꥹ�ȥڡ���"
           '(*TOP*
             (h3 "����̼��Test Proj. - 1���ƥ��Ȥ�̼�� - OPEN"))
           (call-worker/gsid->sxml w
                                   '()
                                   '()
                                   `(,@//body h3))
           test-sxml-match?)


    ))