(in-package #:i18n-protocol)

;;; Message catalogs / resource bundles — gettext-like DX over backend storage.
;;; Not tied to .po; backends may use ICU ResourceBundle, gettext, or JSON catalogs.

(defclass message-catalog ()
  ((locale :initarg :locale :reader catalog-locale :initform nil)
   (raw :initarg :raw :accessor catalog-raw :initform nil))
  (:documentation "Locale message catalog / resource bundle."))

(defvar *message-catalog* nil
  "Dynamically bound default catalog for TRANSLATE.")

(defgeneric backend-load-catalog (backend source &key locale)
  (:documentation "Load catalog from SOURCE (pathname, string id, or opaque)."))

(defgeneric backend-make-message-catalog (backend &key locale)
  (:documentation "Empty or locale-default catalog."))

(defgeneric backend-catalog-get (backend catalog key &key default)
  (:documentation "Lookup KEY → pattern string or NIL."))

(defgeneric backend-catalog-has-p (backend catalog key))

(defgeneric backend-catalog-locales (backend catalog)
  (:documentation "Locales covered by this catalog family."))

(defun load-catalog (source &key locale (backend *i18n-backend*))
  (backend-load-catalog
   (require-capability :catalog (ensure-i18n-backend backend))
   source :locale (or locale *locale*)))

(defun make-message-catalog (&key locale (backend *i18n-backend*))
  (backend-make-message-catalog
   (require-capability :catalog (ensure-i18n-backend backend))
   :locale (or locale *locale*)))

(defun catalog-get (catalog key &key default (backend *i18n-backend*))
  (backend-catalog-get (ensure-i18n-backend backend) catalog key :default default))

(defun catalog-has-p (catalog key &key (backend *i18n-backend*))
  (backend-catalog-has-p (ensure-i18n-backend backend) catalog key))

(defun catalog-locales (catalog &key (backend *i18n-backend*))
  (backend-catalog-locales (ensure-i18n-backend backend) catalog))

(defmacro with-catalog (catalog &body body)
  `(let ((*message-catalog* ,catalog))
     ,@body))

(defun translate (key &optional arguments &key catalog locale (backend *i18n-backend*))
  "Lookup KEY in CATALOG (or *MESSAGE-CATALOG*), then MF2-format with ARGUMENTS.
Without ARGUMENTS, returns the raw pattern string."
  (let* ((cat (or catalog *message-catalog*))
         (b (ensure-i18n-backend backend)))
    (unless cat
      (error 'i18n-catalog-error :message "no message catalog bound"))
    (let ((pattern (catalog-get cat key :backend b)))
      (unless pattern
        (error 'i18n-catalog-error
               :message (format nil "missing catalog key ~s" key)))
      (if arguments
          (format-message pattern arguments :locale (or locale *locale*) :backend b)
          pattern))))

(defun ntranslate (key count &optional arguments &key catalog locale
                    (backend *i18n-backend*))
  "Plural-aware translate. Merges :count into ARGUMENTS for MF2 .match plural."
  (let ((args (cond
                ((null arguments) (list (cons "count" count)))
                ((hash-table-p arguments)
                 (setf (gethash "count" arguments) count)
                 arguments)
                (t (acons "count" count (copy-list arguments))))))
    (translate key args :catalog catalog :locale locale :backend backend)))
