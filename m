From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 14/20] ima: define template fields library and new helpers
Date: Wed, 17 Jul 2013 19:51:34 -0400
Message-ID: <1374105100-25880-15-git-send-email-zohar@linux.vnet.ibm.com>
References: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Cc: Roberto Sassu <roberto.sassu@polito.it>,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:36389 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621Ab3GQXwH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jul 2013 19:52:07 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Wed, 17 Jul 2013 17:52:07 -0600
In-Reply-To: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Roberto Sassu <roberto.sassu@polito.it>

This patch defines a library containing two initial template fields,
inode digest (d) and file name (n), the 'ima' template descriptor,
whose format is 'd|n', and two helper functions,
ima_write_template_field_data() and ima_show_template_field_data().

Changelog:
- replace ima_eventname_init() parameter NULL checking with BUG_ON.
  (suggested by Mimi)
- include "new template fields for inode digest (d) and file name (n)"
  definitions to fix a compiler warning.  - Mimi
- unnecessary to prefix static function names with 'ima_'. remove
  prefix to resolve Lindent formatting changes. - Mimi
- abbreviated/removed inline comments - Mimi

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/Makefile           |   2 +-
 security/integrity/ima/ima.h              |   5 +
 security/integrity/ima/ima_fs.c           |   4 +-
 security/integrity/ima/ima_template.c     |  15 ++-
 security/integrity/ima/ima_template_lib.c | 192 ++++++++++++++++++++++++++++++
 security/integrity/ima/ima_template_lib.h |  31 +++++
 6 files changed, 241 insertions(+), 8 deletions(-)
 create mode 100644 security/integrity/ima/ima_template_lib.c
 create mode 100644 security/integrity/ima/ima_template_lib.h

diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
index 7fe4ae3..d79263d 100644
--- a/security/integrity/ima/Makefile
+++ b/security/integrity/ima/Makefile
@@ -6,5 +6,5 @@
 obj-$(CONFIG_IMA) += ima.o
 
 ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
-	 ima_policy.o ima_template.o
+	 ima_policy.o ima_template.o ima_template_lib.o
 ima-$(CONFIG_IMA_APPRAISE) += ima_appraise.o
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index c85718f..e1f081d 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -39,6 +39,9 @@ enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
 #define IMA_TEMPLATE_FIELD_ID_MAX_LEN	16
 #define IMA_TEMPLATE_NUM_FIELDS_MAX	15
 
+#define IMA_TEMPLATE_IMA_NAME "ima"
+#define IMA_TEMPLATE_IMA_FMT "d|n"
+
 /* set during initialization */
 extern int ima_initialized;
 extern int ima_used_chip;
@@ -105,6 +108,8 @@ int __init ima_calc_boot_aggregate(struct ima_digest_data *hash);
 void ima_add_violation(struct file *file, const unsigned char *filename,
 		       const char *op, const char *cause);
 int ima_init_crypto(void);
+void ima_putc(struct seq_file *m, void *data, int datalen);
+void ima_print_digest(struct seq_file *m, u8 *digest, int size);
 
 int ima_init_template(void);
 
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 89adf1d..f9d8d05 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -100,7 +100,7 @@ static void ima_measurements_stop(struct seq_file *m, void *v)
 {
 }
 
-static void ima_putc(struct seq_file *m, void *data, int datalen)
+void ima_putc(struct seq_file *m, void *data, int datalen)
 {
 	while (datalen--)
 		seq_putc(m, *(char *)data++);
@@ -168,7 +168,7 @@ static const struct file_operations ima_measurements_ops = {
 	.release = seq_release,
 };
 
-static void ima_print_digest(struct seq_file *m, u8 *digest, int size)
+void ima_print_digest(struct seq_file *m, u8 *digest, int size)
 {
 	int i;
 
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 7e86783..8100422 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -13,15 +13,20 @@
  *      Helpers to manage template descriptors.
  */
 #include "ima.h"
+#include "ima_template_lib.h"
 
 static struct ima_template_desc defined_templates[] = {
+	{.name = IMA_TEMPLATE_IMA_NAME,.fmt = IMA_TEMPLATE_IMA_FMT},
 };
 
 static struct ima_template_field supported_fields[] = {
+	{.field_id = "d",.field_init = ima_eventdigest_init,
+	 .field_show = ima_show_template_digest},
+	{.field_id = "n",.field_init = ima_eventname_init,
+	 .field_show = ima_show_template_string},
 };
 
-static struct ima_template_field *ima_lookup_template_field(
-							const char *field_id)
+static struct ima_template_field *lookup_template_field(const char *field_id)
 {
 	int i;
 
@@ -32,7 +37,7 @@ static struct ima_template_field *ima_lookup_template_field(
 	return NULL;
 }
 
-static int ima_template_fmt_size(char *template_fmt)
+static int template_fmt_size(char *template_fmt)
 {
 	char c;
 	int template_fmt_len = strlen(template_fmt);
@@ -53,7 +58,7 @@ static int template_desc_init_fields(char *template_fmt,
 				     int *num_fields)
 {
 	char *c, *template_fmt_ptr = template_fmt;
-	int template_num_fields = ima_template_fmt_size(template_fmt);
+	int template_num_fields = template_fmt_size(template_fmt);
 	int i, result = 0;
 
 	if (template_num_fields > IMA_TEMPLATE_NUM_FIELDS_MAX)
@@ -66,7 +71,7 @@ static int template_desc_init_fields(char *template_fmt,
 	}
 	for (i = 0; (c = strsep(&template_fmt_ptr, "|")) != NULL &&
 	     i < template_num_fields; i++) {
-		struct ima_template_field *f = ima_lookup_template_field(c);
+		struct ima_template_field *f = lookup_template_field(c);
 
 		if (!f) {
 			result = -ENOENT;
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
new file mode 100644
index 0000000..f1a2fcb
--- /dev/null
+++ b/security/integrity/ima/ima_template_lib.c
@@ -0,0 +1,192 @@
+/*
+ * Copyright (C) 2013 Politecnico di Torino, Italy
+ *                    TORSEC group -- http://security.polito.it
+ *
+ * Author: Roberto Sassu <roberto.sassu@polito.it>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * File: ima_template_lib.c
+ *      Library of supported template fields.
+ */
+#include "ima_template_lib.h"
+
+enum data_formats { DATA_FMT_DIGEST = 0, DATA_FMT_EVENT_NAME, DATA_FMT_STRING };
+static int ima_write_template_field_data(const void *data, const u32 datalen,
+					 enum data_formats datafmt,
+					 struct ima_field_data *field_data)
+{
+	u8 *buf, *buf_ptr;
+	u32 buflen;
+
+	switch (datafmt) {
+	case DATA_FMT_EVENT_NAME:
+		buflen = IMA_EVENT_NAME_LEN_MAX + 1;
+		break;
+	case DATA_FMT_STRING:
+		buflen = datalen + 1;
+		break;
+	default:
+		buflen = datalen;
+	}
+
+	buf = kzalloc(buflen, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	memcpy(buf, data, datalen);
+
+	/*
+	 * Replace all space characters with underscore for event names and
+	 * strings. This avoid that, during the parsing of a measurements list,
+	 * filenames with spaces or that end with the suffix ' (deleted)' are
+	 * split into multiple template fields (the space is the delimitator
+	 * character for measurements lists in ASCII format).
+	 */
+	if (datafmt == DATA_FMT_EVENT_NAME || datafmt == DATA_FMT_STRING) {
+		for (buf_ptr = buf; buf_ptr - buf < datalen; buf_ptr++)
+			if (*buf_ptr == ' ')
+				*buf_ptr = '_';
+	}
+
+	field_data->data = buf;
+	field_data->len = buflen;
+	return 0;
+}
+
+static void ima_show_template_data_ascii(struct seq_file *m,
+					 enum ima_show_type show,
+					 enum data_formats datafmt,
+					 struct ima_field_data *field_data)
+{
+	switch (datafmt) {
+	case DATA_FMT_DIGEST:
+		ima_print_digest(m, field_data->data, field_data->len);
+		break;
+	case DATA_FMT_STRING:
+		seq_printf(m, "%s", field_data->data);
+		break;
+	default:
+		break;
+	}
+}
+
+static void ima_show_template_data_binary(struct seq_file *m,
+					  enum ima_show_type show,
+					  enum data_formats datafmt,
+					  struct ima_field_data *field_data)
+{
+	if (datafmt != DATA_FMT_DIGEST)
+		ima_putc(m, &field_data->len, sizeof(u32));
+	ima_putc(m, field_data->data, field_data->len);
+}
+
+static void ima_show_template_field_data(struct seq_file *m,
+					 enum ima_show_type show,
+					 enum data_formats datafmt,
+					 struct ima_field_data *field_data)
+{
+	switch (show) {
+	case IMA_SHOW_ASCII:
+		ima_show_template_data_ascii(m, show, datafmt, field_data);
+		break;
+	case IMA_SHOW_BINARY:
+		ima_show_template_data_binary(m, show, datafmt, field_data);
+		break;
+	default:
+		break;
+	}
+}
+
+void ima_show_template_digest(struct seq_file *m, enum ima_show_type show,
+			      struct ima_field_data *field_data)
+{
+	ima_show_template_field_data(m, show, DATA_FMT_DIGEST, field_data);
+}
+
+void ima_show_template_string(struct seq_file *m, enum ima_show_type show,
+			      struct ima_field_data *field_data)
+{
+	ima_show_template_field_data(m, show, DATA_FMT_STRING, field_data);
+}
+
+/*
+ * This function writes the digest of an event.
+ */
+int ima_eventdigest_init(struct integrity_iint_cache *iint, struct file *file,
+			 const unsigned char *filename,
+			 struct ima_field_data *field_data)
+{
+	struct {
+		struct ima_digest_data hdr;
+		char digest[IMA_MAX_DIGEST_SIZE];
+	} hash;
+	u8 *cur_digest = hash.hdr.digest;
+	u32 cur_digestsize = IMA_DIGEST_SIZE;
+	struct inode *inode;
+	int result;
+
+	memset(&hash, 0, sizeof(hash));
+
+	if (!iint)		/* recording a violation. */
+		goto out;
+
+	if (iint->ima_hash->algo == ima_hash_algo) {
+		cur_digest = iint->ima_hash->digest;
+		cur_digestsize = iint->ima_hash->length;
+		goto out;
+	}
+
+	if (!file)		/* missing info to re-calculate the digest */
+		return -EINVAL;
+
+	inode = file_inode(file);
+	hash.hdr.algo = ima_hash_algo;
+	result = ima_calc_file_hash(file, &hash.hdr);
+	if (result) {
+		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
+				    filename, "collect_data",
+				    "failed", result, 0);
+		return result;
+	}
+out:
+	return ima_write_template_field_data(cur_digest, cur_digestsize,
+					     DATA_FMT_DIGEST, field_data);
+}
+
+/*
+ * This function writes the name of an event.
+ */
+int ima_eventname_init(struct integrity_iint_cache *iint, struct file *file,
+		       const unsigned char *filename,
+		       struct ima_field_data *field_data)
+{
+	const char *cur_filename = NULL;
+	u32 cur_filename_len = 0;
+
+	BUG_ON(filename == NULL && file == NULL);
+
+	if (filename) {
+		cur_filename = filename;
+		cur_filename_len = strlen(filename);
+
+		if (cur_filename_len <= IMA_EVENT_NAME_LEN_MAX)
+			goto out;
+	}
+
+	if (file) {
+		cur_filename = file->f_dentry->d_name.name;
+		cur_filename_len = strlen(cur_filename);
+	} else
+		/*
+		 * Truncate filename if the latter is too long and
+		 * the file descriptor is not available.
+		 */
+		cur_filename_len = IMA_EVENT_NAME_LEN_MAX;
+out:
+	return ima_write_template_field_data(cur_filename, cur_filename_len,
+					     DATA_FMT_EVENT_NAME, field_data);
+}
diff --git a/security/integrity/ima/ima_template_lib.h b/security/integrity/ima/ima_template_lib.h
new file mode 100644
index 0000000..2cecc83
--- /dev/null
+++ b/security/integrity/ima/ima_template_lib.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (C) 2013 Politecnico di Torino, Italy
+ *                    TORSEC group -- http://security.polito.it
+ *
+ * Author: Roberto Sassu <roberto.sassu@polito.it>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * File: ima_template_lib.h
+ *      Header for the library of supported template fields.
+ */
+#ifndef __LINUX_IMA_TEMPLATE_LIB_H
+#define __LINUX_IMA_TEMPLATE_LIB_H
+
+#include <linux/seq_file.h>
+#include "ima.h"
+
+void ima_show_template_digest(struct seq_file *m, enum ima_show_type show,
+			      struct ima_field_data *field_data);
+void ima_show_template_string(struct seq_file *m, enum ima_show_type show,
+			      struct ima_field_data *field_data);
+int ima_eventdigest_init(struct integrity_iint_cache *iint, struct file *file,
+			 const unsigned char *filename,
+			 struct ima_field_data *field_data);
+int ima_eventname_init(struct integrity_iint_cache *iint, struct file *file,
+		       const unsigned char *filename,
+		       struct ima_field_data *field_data);
+#endif /* __LINUX_IMA_TEMPLATE_LIB_H */
-- 
1.8.1.4
