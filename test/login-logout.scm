;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: login-logout.scm,v 1.1 2006/03/18 12:21:16 shibata Exp $

(load "common.scm")

(test-start "kagoiri-musume login-logout check")

(*setup*)

;;------------------------------------------------------------
;; Run kagoiri-musume
(test-section "kahua-server kagoiri-musume.kahua")

(with-worker
 (w *worker-command*)

 (test* "run kagoiri-musume.kahua" #t (worker-running? w))

 (call-worker-test* "��������̥ե�����"

                    :node '(*TOP*
                            (form (@ (method "POST")
                                     (action ?&login))
                                  ?*))

                    :sxpath (//body '(form)))


 (call-worker-test* "��������̥���ץå�����"

                    :node '(*TOP* (input (@ (value "login") (type "submit") (name "submit")))
                                  (input (@ (value "") (type "text") (name "name") (id "focus")))
                                  (input (@ (value "") (type "password") (name "pass"))))

                    :sxpath (//body '(form // input)))

 (call-worker-test* "��������"

                    :node '(*TOP* (!contain "Login"))

                    :sxpath (//header-action '(// a *text*)))

 (call-worker-test* "�����󤷤ƥ桼��̾������å�"

                    :gsid 'login

                    :node '(*TOP* (!contain "cut-sea"))

                    :body '(("name" "cut-sea") ("pass" "cutsea"))

                    :sxpath (//header-action '(// a *text*)))

 (call-worker-test* "�����󤷤ƥ������ȥ�󥯤�����å�"

                    :gsid 'login

                    :node '(*TOP* (!contain
                                   (a (@ (href ?&logout) ?*)
                                      "Logout")))

                    :body '(("name" "cut-sea") ("pass" "cutsea"))

                    :sxpath (//header-action '(// a)))

 (call-worker-test* "�������Ȥ��ƥ桼��̾��ɽ������ʤ���������å�"

                    :gsid 'logout

                    :node '(*TOP* (!exclude "cut-sea"))

                    :sxpath (//header-action '(// a *text*))

                    :redirect #t
                    )

 (call-worker-test* "�������Ȥ��ƥ������󥯤�����å�"

                    :gsid 'logout

                    :node '(*TOP* (!contain "Login"))

                    :sxpath (//header-action '(// a *text*))

                    :redirect #t
                    )

 )

(test-end)


