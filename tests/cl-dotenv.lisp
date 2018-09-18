(defpackage #:cl-dotenv/tests
  (:use #:cl
        #:cl-dotenv
        #:prove))
(in-package #:cl-dotenv/tests)

(plan 1)

(subtest "cl-dotenv:read-env"
  (subtest "READ-ENV throws error if .env file is corrupt"
    (is-error (.env:read-env (asdf:system-relative-pathname "cl-dotenv-test"
                                                            "./tests/.env-corrupt"))
              'malformed-entry))

  (subtest "READ-ENV loads a .env file"
    (let ((env (.env:read-env (asdf:system-relative-pathname "cl-dotenv-test"
                                                             "./tests/.env-test"))))
      (is (gethash "TEST_VAR_1" env) "test1")
      (is (gethash "TEST_VAR_2" env) "test2")))

  (subtest "LOAD-ENV  sets the environment"
    (.env:load-env (asdf:system-relative-pathname "cl-dotenv-test"
                                                  "./tests/.env-test"))

    (is (uiop:getenv "TEST_VAR_1") "test1")
    (is (uiop:getenv "TEST_VAR_2") "test2")))

(finalize)
