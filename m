From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v5 06/18] ima: Improvements in ima_appraise_measurement
Date: Tue, 17 Oct 2017 22:53:19 -0200
Message-ID: <20171018005331.2688-7-bauerman@linux.vnet.ibm.com>
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

Replace nested ifs in the EVM xattr verification logic with a switch
statement, making the code easier to understand.

Also, add comments to the if statements in the out section.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h          |  5 +++++
 security/integrity/ima/ima_appraise.c | 33 ++++++++++++++++++++-------------
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index d52b487ad259..4e61d3189b72 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -155,6 +155,11 @@ unsigned long ima_get_binary_runtime_size(void);
 int ima_init_template(void);
 void ima_init_template_list(void);
 
+static inline bool is_ima_sig(const struct evm_ima_xattr_data *xattr_value)
+{
+	return xattr_value && xattr_value->type == EVM_IMA_XATTR_DIGSIG;
+}
+
 /*
  * used to protect h_table and sha_table
  */
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 58c6a60c7e83..2c069f47eeec 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -204,7 +204,7 @@ int ima_appraise_measurement(enum ima_hooks func,
 			     int xattr_len, int opened)
 {
 	static const char op[] = "appraise_data";
-	char *cause = "unknown";
+	const char *cause = "unknown";
 	struct dentry *dentry = file_dentry(file);
 	struct inode *inode = d_backing_inode(dentry);
 	enum integrity_status status = INTEGRITY_UNKNOWN;
@@ -229,11 +229,16 @@ int ima_appraise_measurement(enum ima_hooks func,
 	}
 
 	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value, rc, iint);
-	if (status != INTEGRITY_PASS && status != INTEGRITY_UNKNOWN) {
-		if (status == INTEGRITY_NOLABEL || status == INTEGRITY_NOXATTRS)
-			cause = "missing-HMAC";
-		else if (status == INTEGRITY_FAIL)
-			cause = "invalid-HMAC";
+	switch (status) {
+	case INTEGRITY_PASS:
+	case INTEGRITY_UNKNOWN:
+		break;
+	case INTEGRITY_NOXATTRS:	/* No EVM protected xattrs. */
+	case INTEGRITY_NOLABEL:		/* No security.evm xattr. */
+		cause = "missing-HMAC";
+		goto out;
+	case INTEGRITY_FAIL:		/* Invalid HMAC/signature. */
+		cause = "invalid-HMAC";
 		goto out;
 	}
 	switch (xattr_value->type) {
@@ -287,17 +292,19 @@ int ima_appraise_measurement(enum ima_hooks func,
 
 out:
 	if (status != INTEGRITY_PASS) {
+		/* Fix mode, but don't replace file signatures. */
 		if ((ima_appraise & IMA_APPRAISE_FIX) &&
-		    (!xattr_value ||
-		     xattr_value->type != EVM_IMA_XATTR_DIGSIG)) {
+		    !is_ima_sig(xattr_value)) {
 			if (!ima_fix_xattr(dentry, iint))
 				status = INTEGRITY_PASS;
-		} else if (inode->i_size == 0 &&
-			   (iint->flags & IMA_NEW_FILE) &&
-			   xattr_value &&
-			   xattr_value->type == EVM_IMA_XATTR_DIGSIG) {
+		}
+
+		/* Permit new files with file signatures, but without data. */
+		if (inode->i_size == 0 && (iint->flags & IMA_NEW_FILE) &&
+		    is_ima_sig(xattr_value)) {
 			status = INTEGRITY_PASS;
 		}
+
 		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
 				    op, cause, rc, 0);
 	} else {
@@ -404,7 +411,7 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 		if (!xattr_value_len || xvalue->type >= IMA_XATTR_LAST)
 			return -EINVAL;
 		ima_reset_appraise_flags(d_backing_inode(dentry),
-			xvalue->type == EVM_IMA_XATTR_DIGSIG);
+					 is_ima_sig(xvalue));
 		result = 0;
 	}
 	return result;

