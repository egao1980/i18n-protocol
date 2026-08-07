(in-package #:i18n-protocol)

(defclass i18n-backend () ()
  (:documentation "Base class for i18n-protocol backends (ICU4C, …)."))

(defvar *i18n-backend* nil
  "Current i18n backend.")

(defgeneric backend-capabilities (backend)
  (:documentation "Capability keywords: :locale :message :plural :catalog")
  (:method ((backend i18n-backend)) '()))

(defun use-i18n-backend (backend)
  (check-type backend i18n-backend)
  (setf *i18n-backend* backend))

(defmacro with-i18n-backend (backend &body body)
  `(let ((*i18n-backend* ,backend))
     ,@body))

(defun ensure-i18n-backend (&optional (backend *i18n-backend*))
  (or backend
      (error 'i18n-error
             :message "*i18n-backend* is nil — load an i18n-backend-* system")))

(defun require-capability (capability &optional (backend (ensure-i18n-backend)))
  (unless (member capability (backend-capabilities backend) :test #'eq)
    (error 'i18n-unsupported
           :capability capability
           :message (format nil "backend ~a lacks ~s" backend capability)))
  backend)
