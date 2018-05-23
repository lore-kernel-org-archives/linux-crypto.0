From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: [PATCH v7 04/14] integrity: Introduce struct evm_xattr
Date: Tue, 22 May 2018 21:12:43 -0300
Message-ID: <20180523001253.15247-5-bauerman@linux.ibm.com>
References: <20180523001253.15247-1-bauerman@linux.ibm.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
To: linux-integrity@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180523001253.15247-1-bauerman@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Even though struct evm_ima_xattr_data includes a fixed-size array to hold a
SHA1 digest, most of the code ignores the array and uses the struct to mean
"type indicator followed by data of unspecified size" and tracks the real
size of what the struct represents in a separate length variable.

The only exception to that is the EVM code, which correctly uses the
definition of struct evm_ima_xattr_data.

So make this explicit in the code by removing the length specification from
the array in struct evm_ima_xattr_data. Also, change the name of the
element from digest to data since in most places the array doesn't hold a
digest.

A separate struct evm_xattr is introduced, with the original definition of
evm_ima_xattr_data to be used in the places that actually expect that
definition.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
---
 security/integrity/evm/evm_crypto.c   |  4 ++--
 security/integrity/evm/evm_main.c     | 10 +++++-----
 security/integrity/ima/ima_appraise.c |  7 ++++---
 security/integrity/integrity.h        |  5 +++++
 4 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 494da5fcc092..c03ebb0c20b4 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -302,7 +302,7 @@ int evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
 			const char *xattr_value, size_t xattr_value_len)
 {
 	struct inode *inode = d_backing_inode(dentry);
-	struct evm_ima_xattr_data xattr_data;
+	struct evm_xattr xattr_data;
 	int rc = 0;
 
 	/*
@@ -318,7 +318,7 @@ int evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
 	rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
 			   xattr_value_len, xattr_data.digest);
 	if (rc == 0) {
-		xattr_data.type = EVM_XATTR_HMAC;
+		xattr_data.data.type = EVM_XATTR_HMAC;
 		rc = __vfs_setxattr_noperm(dentry, XATTR_NAME_EVM,
 					   &xattr_data,
 					   sizeof(xattr_data), 0);
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index f9eff5041e4c..65f9578be058 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -134,7 +134,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 					     struct integrity_iint_cache *iint)
 {
 	struct evm_ima_xattr_data *xattr_data = NULL;
-	struct evm_ima_xattr_data calc;
+	struct evm_xattr calc;
 	enum integrity_status evm_status = INTEGRITY_PASS;
 	struct inode *inode;
 	int rc, xattr_len;
@@ -167,7 +167,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 	/* check value type */
 	switch (xattr_data->type) {
 	case EVM_XATTR_HMAC:
-		if (xattr_len != sizeof(struct evm_ima_xattr_data)) {
+		if (xattr_len != sizeof(struct evm_xattr)) {
 			evm_status = INTEGRITY_FAIL;
 			goto out;
 		}
@@ -175,7 +175,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 				   xattr_value_len, calc.digest);
 		if (rc)
 			break;
-		rc = crypto_memneq(xattr_data->digest, calc.digest,
+		rc = crypto_memneq(xattr_data->data, calc.digest,
 			    sizeof(calc.digest));
 		if (rc)
 			rc = -EINVAL;
@@ -518,7 +518,7 @@ int evm_inode_init_security(struct inode *inode,
 				 const struct xattr *lsm_xattr,
 				 struct xattr *evm_xattr)
 {
-	struct evm_ima_xattr_data *xattr_data;
+	struct evm_xattr *xattr_data;
 	int rc;
 
 	if (!evm_key_loaded() || !evm_protected_xattr(lsm_xattr->name))
@@ -528,7 +528,7 @@ int evm_inode_init_security(struct inode *inode,
 	if (!xattr_data)
 		return -ENOMEM;
 
-	xattr_data->type = EVM_XATTR_HMAC;
+	xattr_data->data.type = EVM_XATTR_HMAC;
 	rc = evm_init_hmac(inode, lsm_xattr, xattr_data->digest);
 	if (rc < 0)
 		goto out;
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 8bd7a0733e51..a6b2995b7d0b 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -167,7 +167,8 @@ enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
 		return sig->hash_algo;
 		break;
 	case IMA_XATTR_DIGEST_NG:
-		ret = xattr_value->digest[0];
+		/* first byte contains algorithm id */
+		ret = xattr_value->data[0];
 		if (ret < HASH_ALGO__LAST)
 			return ret;
 		break;
@@ -175,7 +176,7 @@ enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
 		/* this is for backward compatibility */
 		if (xattr_len == 21) {
 			unsigned int zero = 0;
-			if (!memcmp(&xattr_value->digest[16], &zero, 4))
+			if (!memcmp(&xattr_value->data[16], &zero, 4))
 				return HASH_ALGO_MD5;
 			else
 				return HASH_ALGO_SHA1;
@@ -274,7 +275,7 @@ int ima_appraise_measurement(enum ima_hooks func,
 			/* xattr length may be longer. md5 hash in previous
 			   version occupied 20 bytes in xattr, instead of 16
 			 */
-			rc = memcmp(&xattr_value->digest[hash_start],
+			rc = memcmp(&xattr_value->data[hash_start],
 				    iint->ima_hash->digest,
 				    iint->ima_hash->length);
 		else
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 0bb372eed62a..714fe2e135c7 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -78,6 +78,11 @@ enum evm_ima_xattr_type {
 
 struct evm_ima_xattr_data {
 	u8 type;
+	u8 data[];
+} __packed;
+
+struct evm_xattr {
+	struct evm_ima_xattr_data data;
 	u8 digest[SHA1_DIGEST_SIZE];
 } __packed;
 
