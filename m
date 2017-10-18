From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v5 17/18] ima: Implement support for module-style appended signatures
Date: Tue, 17 Oct 2017 22:53:30 -0200
Message-ID: <20171018005331.2688-18-bauerman@linux.vnet.ibm.com>
References: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
To: linux-integrity@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch actually implements the appraise_type=modsig option, allowing
IMA to read and verify modsig signatures

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h          |  17 +++--
 security/integrity/ima/ima_appraise.c | 119 ++++++++++++++++++++++++++++++++--
 security/integrity/ima/ima_main.c     |   7 +-
 3 files changed, 128 insertions(+), 15 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index eb58af06566f..b082138461b3 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -157,7 +157,8 @@ void ima_init_template_list(void);
 
 static inline bool is_ima_sig(const struct evm_ima_xattr_data *xattr_value)
 {
-	return xattr_value && xattr_value->type == EVM_IMA_XATTR_DIGSIG;
+	return xattr_value && (xattr_value->type == EVM_IMA_XATTR_DIGSIG ||
+			       xattr_value->type == IMA_MODSIG);
 }
 
 /*
@@ -243,9 +244,10 @@ int ima_policy_show(struct seq_file *m, void *v);
 #ifdef CONFIG_IMA_APPRAISE
 int ima_appraise_measurement(enum ima_hooks func,
 			     struct integrity_iint_cache *iint,
-			     struct file *file, const unsigned char *filename,
-			     struct evm_ima_xattr_data *xattr_value,
-			     int xattr_len, int opened);
+			     struct file *file, const void *buf, loff_t size,
+			     const unsigned char *filename,
+			     struct evm_ima_xattr_data **xattr_value,
+			     int *xattr_len, int opened);
 int ima_must_appraise(struct inode *inode, int mask, enum ima_hooks func);
 void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file);
 enum integrity_status ima_get_cache_status(struct integrity_iint_cache *iint,
@@ -270,10 +272,11 @@ void ima_free_xattr_data(struct evm_ima_xattr_data *hdr);
 #else
 static inline int ima_appraise_measurement(enum ima_hooks func,
 					   struct integrity_iint_cache *iint,
-					   struct file *file,
+					   struct file *file, const void *buf,
+					   loff_t size,
 					   const unsigned char *filename,
-					   struct evm_ima_xattr_data *xattr_value,
-					   int xattr_len, int opened)
+					   struct evm_ima_xattr_data **xattr_value,
+					   int *xattr_len, int opened)
 {
 	return INTEGRITY_UNKNOWN;
 }
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 58e147049e98..108690741c1a 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -190,6 +190,45 @@ int ima_read_xattr(struct dentry *dentry,
 	return ret;
 }
 
+static int appraise_modsig(struct integrity_iint_cache *iint,
+			   struct evm_ima_xattr_data *xattr_value,
+			   int xattr_len)
+{
+	enum hash_algo algo;
+	const void *digest;
+	void *buf;
+	int rc, len;
+	u8 dig_len;
+
+	rc = ima_modsig_verify(INTEGRITY_KEYRING_IMA, xattr_value);
+	if (rc)
+		return rc;
+
+	/*
+	 * The signature is good. Now let's put the sig hash
+	 * into the iint cache so that it gets stored in the
+	 * measurement list.
+	 */
+
+	rc = ima_get_modsig_hash(xattr_value, &algo, &digest, &dig_len);
+	if (rc)
+		return rc;
+
+	len = sizeof(iint->ima_hash) + dig_len;
+	buf = krealloc(iint->ima_hash, len, GFP_NOFS);
+	if (!buf)
+		return -ENOMEM;
+
+	iint->ima_hash = buf;
+	iint->flags |= IMA_DIGSIG;
+	iint->ima_hash->algo = algo;
+	iint->ima_hash->length = dig_len;
+
+	memcpy(iint->ima_hash->digest, digest, dig_len);
+
+	return 0;
+}
+
 /*
  * ima_appraise_measurement - appraise file measurement
  *
@@ -200,18 +239,28 @@ int ima_read_xattr(struct dentry *dentry,
  */
 int ima_appraise_measurement(enum ima_hooks func,
 			     struct integrity_iint_cache *iint,
-			     struct file *file, const unsigned char *filename,
-			     struct evm_ima_xattr_data *xattr_value,
-			     int xattr_len, int opened)
+			     struct file *file, const void *buf, loff_t size,
+			     const unsigned char *filename,
+			     struct evm_ima_xattr_data **xattr_value_,
+			     int *xattr_len_, int opened)
 {
 	static const char op[] = "appraise_data";
 	const char *cause = "unknown";
 	struct dentry *dentry = file_dentry(file);
 	struct inode *inode = d_backing_inode(dentry);
 	enum integrity_status status = INTEGRITY_UNKNOWN;
-	int rc = xattr_len, hash_start = 0;
+	struct evm_ima_xattr_data *xattr_value = *xattr_value_;
+	int xattr_len = *xattr_len_, rc = xattr_len, hash_start = 0;
+	bool appraising_modsig = false;
+
+	if (iint->flags & IMA_MODSIG_ALLOWED &&
+	    !ima_read_modsig(func, buf, size, &xattr_value, &xattr_len)) {
+		appraising_modsig = true;
+		rc = xattr_len;
+	}
 
-	if (!(inode->i_opflags & IOP_XATTR))
+	/* If not appraising a modsig, we need an xattr. */
+	if (!appraising_modsig && !(inode->i_opflags & IOP_XATTR))
 		return INTEGRITY_UNKNOWN;
 
 	if (rc <= 0) {
@@ -235,6 +284,9 @@ int ima_appraise_measurement(enum ima_hooks func,
 	case INTEGRITY_UNKNOWN:
 		break;
 	case INTEGRITY_NOXATTRS:	/* No EVM protected xattrs. */
+		/* It's fine not to have xattrs when using a modsig. */
+		if (appraising_modsig)
+			break;
 	case INTEGRITY_NOLABEL:		/* No security.evm xattr. */
 		cause = "missing-HMAC";
 		goto out;
@@ -242,6 +294,8 @@ int ima_appraise_measurement(enum ima_hooks func,
 		cause = "invalid-HMAC";
 		goto out;
 	}
+
+ retry:
 	switch (xattr_value->type) {
 	case IMA_XATTR_DIGEST_NG:
 		/* first byte contains algorithm id */
@@ -285,6 +339,61 @@ int ima_appraise_measurement(enum ima_hooks func,
 			status = INTEGRITY_PASS;
 		}
 		break;
+	case IMA_MODSIG:
+		/*
+		 * To avoid being tricked into an infinite loop, we don't allow
+		 * a modsig stored in the xattr.
+		 */
+		if (!appraising_modsig) {
+			status = INTEGRITY_UNKNOWN;
+			cause = "unknown-ima-data";
+			break;
+		}
+
+		rc = appraise_modsig(iint, xattr_value, xattr_len);
+		if (!rc) {
+			kfree(*xattr_value_);
+			*xattr_value_ = xattr_value;
+			*xattr_len_ = xattr_len;
+
+			status = INTEGRITY_PASS;
+			break;
+		}
+
+		ima_free_xattr_data(xattr_value);
+
+		/*
+		 * The appended signature failed verification. If there's a
+		 * signature in the extended attribute, let's fall back to it.
+		 */
+		if (inode->i_opflags & IOP_XATTR && *xattr_len_ != 0 &&
+		    *xattr_len_ != -ENODATA) {
+			const char *modsig_cause = rc == -EOPNOTSUPP ?
+				"unknown" : "invalid-signature";
+
+			/* First, log that the modsig verification failed. */
+			integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
+					    filename, op, modsig_cause, rc, 0);
+
+			xattr_len = rc = *xattr_len_;
+			xattr_value = *xattr_value_;
+			appraising_modsig = false;
+
+			if (rc > 0)
+				/* Process xattr contents. */
+				goto retry;
+
+			/* Unexpected error reading xattr. */
+			status = INTEGRITY_UNKNOWN;
+		} else {
+			if (rc == -EOPNOTSUPP)
+				status = INTEGRITY_UNKNOWN;
+			else {
+				cause = "invalid-signature";
+				status = INTEGRITY_FAIL;
+			}
+		}
+		break;
 	default:
 		status = INTEGRITY_UNKNOWN;
 		cause = "unknown-ima-data";
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 8e96450e27f5..6a2d960fbd92 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -243,8 +243,9 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
 		pathname = ima_d_path(&file->f_path, &pathbuf, filename);
 
 	if (rc == 0 && (action & IMA_APPRAISE_SUBMASK))
-		rc = ima_appraise_measurement(func, iint, file, pathname,
-					      xattr_value, xattr_len, opened);
+		rc = ima_appraise_measurement(func, iint, file, buf, size,
+					      pathname, &xattr_value,
+					      &xattr_len, opened);
 	if (action & IMA_MEASURE)
 		ima_store_measurement(iint, file, pathname,
 				      xattr_value, xattr_len, pcr);
@@ -255,7 +256,7 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
 	if ((mask & MAY_WRITE) && (iint->flags & IMA_DIGSIG) &&
 	     !(iint->flags & IMA_NEW_FILE))
 		rc = -EACCES;
-	kfree(xattr_value);
+	ima_free_xattr_data(xattr_value);
 out_free:
 	if (pathbuf)
 		__putname(pathbuf);

