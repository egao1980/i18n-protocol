(in-package #:i18n-protocol)

(define-condition i18n-error (error)
  ((message :initarg :message :reader i18n-error-message :initform nil)
   (capability :initarg :capability :reader i18n-error-capability :initform nil))
  (:report (lambda (c s)
             (format s "i18n error~@[: ~a~]" (i18n-error-message c)))))

(define-condition i18n-unsupported (i18n-error) ()
  (:report (lambda (c s)
             (format s "i18n capability unsupported~@[: ~a~]~@[ (~s)~]"
                     (i18n-error-message c) (i18n-error-capability c)))))

(define-condition i18n-locale-error (i18n-error) ())
(define-condition i18n-message-error (i18n-error) ())
(define-condition i18n-catalog-error (i18n-error) ())
