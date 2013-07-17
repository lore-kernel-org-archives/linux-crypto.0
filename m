From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 04/20] ima: read and use signature hash algorithm
Date: Wed, 17 Jul 2013 19:51:24 -0400
Message-ID: <1374105100-25880-5-git-send-email-zohar@linux.vnet.ibm.com>
References: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Dmitry Kasatkin <d.kasatkin@samsung.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>

All files on the filesystem, currently, are hashed using the same hash
algorithm.  In preparation for files from different packages being
signed using different hash algorithms, this patch adds support for
reading the signature hash algorithm from the 'security.ima' extended
attribute and calculates the appropriate file data hash based on it.

Changelog:
- fix scripts Lindent and checkpatch msgs - Mimi

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/digsig_asymmetric.c | 11 ---------
 security/integrity/ima/ima.h           | 29 ++++++++++++++++++++---
 security/integrity/ima/ima_api.c       | 12 +++++++++-
 security/integrity/ima/ima_appraise.c  | 42 +++++++++++++++++++++++++++-------
 security/integrity/ima/ima_main.c      | 11 +++++++--
 security/integrity/integrity.h         | 11 +++++++++
 6 files changed, 91 insertions(+), 25 deletions(-)

diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index b475466..9eae480 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -20,17 +20,6 @@
 #include "integrity.h"
 
 /*
- * signature format v2 - for using with asymmetric keys
- */
-struct signature_v2_hdr {
-	uint8_t version;	/* signature format version */
-	uint8_t	hash_algo;	/* Digest algorithm [enum pkey_hash_algo] */
-	uint32_t keyid;		/* IMA key identifier - not X509/PGP specific*/
-	uint16_t sig_size;	/* signature size */
-	uint8_t sig[0];		/* signature payload */
-} __packed;
-
-/*
  * Request an asymmetric key.
  */
 static struct key *request_asymmetric_key(struct key *keyring, uint32_t keyid)
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index eb86032..efcdef2 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -99,7 +99,9 @@ static inline unsigned long ima_hash_key(u8 *digest)
 int ima_get_action(struct inode *inode, int mask, int function);
 int ima_must_measure(struct inode *inode, int mask, int function);
 int ima_collect_measurement(struct integrity_iint_cache *iint,
-			    struct file *file);
+			    struct file *file,
+			    struct evm_ima_xattr_data **xattr_value,
+			    int *xattr_len);
 void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
 			   const unsigned char *filename);
 void ima_audit_measurement(struct integrity_iint_cache *iint,
@@ -132,17 +134,25 @@ void ima_delete_rules(void);
 
 #ifdef CONFIG_IMA_APPRAISE
 int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
-			     struct file *file, const unsigned char *filename);
+			     struct file *file, const unsigned char *filename,
+			     struct evm_ima_xattr_data *xattr_value,
+			     int xattr_len);
 int ima_must_appraise(struct inode *inode, int mask, enum ima_hooks func);
 void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file);
 enum integrity_status ima_get_cache_status(struct integrity_iint_cache *iint,
 					   int func);
+void ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value, int xattr_len,
+		       struct ima_digest_data *hash);
+int ima_read_xattr(struct dentry *dentry,
+		   struct evm_ima_xattr_data **xattr_value);
 
 #else
 static inline int ima_appraise_measurement(int func,
 					   struct integrity_iint_cache *iint,
 					   struct file *file,
-					   const unsigned char *filename)
+					   const unsigned char *filename,
+					   struct evm_ima_xattr_data *xattr_value,
+					   int xattr_len)
 {
 	return INTEGRITY_UNKNOWN;
 }
@@ -163,6 +173,19 @@ static inline enum integrity_status ima_get_cache_status(struct integrity_iint_c
 {
 	return INTEGRITY_UNKNOWN;
 }
+
+static inline void ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
+				     int xattr_len,
+				     struct ima_digest_data *hash)
+{
+}
+
+static inline int ima_read_xattr(struct dentry *dentry,
+				 struct evm_ima_xattr_data **xattr_value)
+{
+	return 0;
+}
+
 #endif
 
 /* LSM based policy rules require audit */
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index e531fe2..1dba98e 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -139,17 +139,27 @@ int ima_must_measure(struct inode *inode, int mask, int function)
  * Return 0 on success, error code otherwise
  */
 int ima_collect_measurement(struct integrity_iint_cache *iint,
-			    struct file *file)
+			    struct file *file,
+			    struct evm_ima_xattr_data **xattr_value,
+			    int *xattr_len)
 {
 	struct inode *inode = file_inode(file);
 	const char *filename = file->f_dentry->d_name.name;
 	int result = 0;
 
+	if (xattr_value)
+		*xattr_len = ima_read_xattr(file->f_dentry, xattr_value);
+
 	if (!(iint->flags & IMA_COLLECTED)) {
 		u64 i_version = file_inode(file)->i_version;
 
 		/* use default hash algorithm */
 		iint->ima_hash.algo = ima_hash_algo;
+
+		if (xattr_value)
+			ima_get_hash_algo(*xattr_value, *xattr_len,
+					  &iint->ima_hash);
+
 		result = ima_calc_file_hash(file, &iint->ima_hash);
 		if (!result) {
 			iint->version = i_version;
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index f2a3bda..5b59b43 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -107,6 +107,34 @@ static void ima_cache_flags(struct integrity_iint_cache *iint, int func)
 	}
 }
 
+void ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value, int xattr_len,
+		       struct ima_digest_data *hash)
+{
+	struct signature_v2_hdr *sig;
+
+	if (!xattr_value || xattr_len < 0 || xattr_len <= 1 + sizeof(*sig))
+		return;
+
+	sig = (typeof(sig)) xattr_value->digest;
+
+	if (xattr_value->type != EVM_IMA_XATTR_DIGSIG || sig->version != 2)
+		return;
+
+	hash->algo = sig->hash_algo;
+}
+
+int ima_read_xattr(struct dentry *dentry,
+		   struct evm_ima_xattr_data **xattr_value)
+{
+	struct inode *inode = dentry->d_inode;
+
+	if (!inode->i_op->getxattr)
+		return 0;
+
+	return vfs_getxattr_alloc(dentry, XATTR_NAME_IMA, (char **)xattr_value,
+				  0, GFP_NOFS);
+}
+
 /*
  * ima_appraise_measurement - appraise file measurement
  *
@@ -116,23 +144,22 @@ static void ima_cache_flags(struct integrity_iint_cache *iint, int func)
  * Return 0 on success, error code otherwise
  */
 int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
-			     struct file *file, const unsigned char *filename)
+			     struct file *file, const unsigned char *filename,
+			     struct evm_ima_xattr_data *xattr_value,
+			     int xattr_len)
 {
 	struct dentry *dentry = file->f_dentry;
 	struct inode *inode = dentry->d_inode;
-	struct evm_ima_xattr_data *xattr_value = NULL;
 	enum integrity_status status = INTEGRITY_UNKNOWN;
 	const char *op = "appraise_data";
 	char *cause = "unknown";
-	int rc;
+	int rc = xattr_len;
 
 	if (!ima_appraise)
 		return 0;
 	if (!inode->i_op->getxattr)
 		return INTEGRITY_UNKNOWN;
 
-	rc = vfs_getxattr_alloc(dentry, XATTR_NAME_IMA, (char **)&xattr_value,
-				0, GFP_NOFS);
 	if (rc <= 0) {
 		if (rc && rc != -ENODATA)
 			goto out;
@@ -159,7 +186,7 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 			status = INTEGRITY_FAIL;
 			break;
 		}
-		if (rc - 1 == iint->ima_hash.length)
+		if (xattr_len - 1 == iint->ima_hash.length)
 			rc = memcmp(xattr_value->digest,
 				    iint->ima_hash.digest,
 				    iint->ima_hash.length);
@@ -207,7 +234,6 @@ out:
 		ima_cache_flags(iint, func);
 	}
 	ima_set_cache_status(iint, func, status);
-	kfree(xattr_value);
 	return status;
 }
 
@@ -223,7 +249,7 @@ void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file)
 	if (iint->flags & IMA_DIGSIG)
 		return;
 
-	rc = ima_collect_measurement(iint, file);
+	rc = ima_collect_measurement(iint, file, NULL, NULL);
 	if (rc < 0)
 		return;
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index a8ae99b..c22027e 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -149,6 +149,8 @@ static int process_measurement(struct file *file, const char *filename,
 	char *pathbuf = NULL;
 	const char *pathname = NULL;
 	int rc = -ENOMEM, action, must_appraise, _func;
+	struct evm_ima_xattr_data *xattr_value = NULL, **xattr_ptr = NULL;
+	int xattr_len = 0;
 
 	if (!ima_initialized || !S_ISREG(inode->i_mode))
 		return 0;
@@ -187,7 +189,10 @@ static int process_measurement(struct file *file, const char *filename,
 		goto out_digsig;
 	}
 
-	rc = ima_collect_measurement(iint, file);
+	if (action & IMA_APPRAISE_SUBMASK)
+		xattr_ptr = &xattr_value;
+
+	rc = ima_collect_measurement(iint, file, xattr_ptr, &xattr_len);
 	if (rc != 0)
 		goto out_digsig;
 
@@ -198,7 +203,8 @@ static int process_measurement(struct file *file, const char *filename,
 	if (action & IMA_MEASURE)
 		ima_store_measurement(iint, file, pathname);
 	if (action & IMA_APPRAISE_SUBMASK)
-		rc = ima_appraise_measurement(_func, iint, file, pathname);
+		rc = ima_appraise_measurement(_func, iint, file, pathname,
+					      xattr_value, xattr_len);
 	if (action & IMA_AUDIT)
 		ima_audit_measurement(iint, pathname);
 	kfree(pathbuf);
@@ -207,6 +213,7 @@ out_digsig:
 		rc = -EACCES;
 out:
 	mutex_unlock(&inode->i_mutex);
+	kfree(xattr_value);
 	if ((rc && must_appraise) && (ima_appraise & IMA_APPRAISE_ENFORCE))
 		return -EACCES;
 	return 0;
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index a97f1091..d519a9c 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -70,6 +70,17 @@ struct ima_digest_data {
 	u8 digest[IMA_MAX_DIGEST_SIZE];
 } __packed;
 
+/*
+ * signature format v2 - for using with asymmetric keys
+ */
+struct signature_v2_hdr {
+	uint8_t version;	/* signature format version */
+	uint8_t	hash_algo;	/* Digest algorithm [enum pkey_hash_algo] */
+	uint32_t keyid;		/* IMA key identifier - not X509/PGP specific */
+	uint16_t sig_size;	/* signature size */
+	uint8_t sig[0];		/* signature payload */
+} __packed;
+
 /* integrity data associated with an inode */
 struct integrity_iint_cache {
 	struct rb_node rb_node;	/* rooted in integrity_iint_tree */
-- 
1.8.1.4

