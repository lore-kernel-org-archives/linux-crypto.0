From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/8] KEYS: Provide missing asymmetric key subops for new key
 type ops [ver #2]
Date: Thu, 23 Jun 2016 14:47:57 +0100
Message-ID: <146668967735.2977.12615051102490182258.stgit@warthog.procyon.org.uk>
References: <146668965425.2977.13357101274301968911.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: mathew.j.martineau@linux.intel.com, dwmw2@infradead.org,
	tadeusz.struk@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <146668965425.2977.13357101274301968911.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Provide the missing asymmetric key subops for new key type ops.  This
include query, encrypt, decrypt and create signature.  Verify signature
already exists.  Also provided are accessor functions for this:

	int query_asymmetric_key(const struct key *key,
				 struct kernel_pkey_query *info);

	int encrypt_blob(struct kernel_pkey_params *params,
			 const void *data, void *enc);
	int decrypt_blob(struct kernel_pkey_params *params,
			 const void *enc, void *data);
	int create_signature(struct kernel_pkey_params *params,
			     const void *data, void *enc);

The public_key_signature struct gains an encoding field to carry the
encoding for verify_signature().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/crypto/asymmetric-keys.txt |   24 ++++++--
 crypto/asymmetric_keys/asymmetric_keys.h |    3 +
 crypto/asymmetric_keys/asymmetric_type.c |   59 ++++++++++++++++---
 crypto/asymmetric_keys/signature.c       |   95 ++++++++++++++++++++++++++++++
 include/crypto/public_key.h              |   13 +++-
 include/keys/asymmetric-subtype.h        |    9 +++
 6 files changed, 188 insertions(+), 15 deletions(-)

diff --git a/Documentation/crypto/asymmetric-keys.txt b/Documentation/crypto/asymmetric-keys.txt
index 8c07e0ea6bc0..cdf2aca41b2c 100644
--- a/Documentation/crypto/asymmetric-keys.txt
+++ b/Documentation/crypto/asymmetric-keys.txt
@@ -182,6 +182,10 @@ and looks like the following:
 
 		void (*describe)(const struct key *key, struct seq_file *m);
 		void (*destroy)(void *payload);
+		int (*query)(const struct kernel_pkey_params *params,
+			     struct kernel_pkey_query *info);
+		int (*eds_op)(struct kernel_pkey_params *params,
+			      const void *in, void *out);
 		int (*verify_signature)(const struct key *key,
 					const struct public_key_signature *sig);
 	};
@@ -206,12 +210,22 @@ There are a number of operations defined by the subtype:
      asymmetric key will look after freeing the fingerprint and releasing the
      reference on the subtype module.
 
- (3) verify_signature().
+ (3) query().
 
-     Optional.  These are the entry points for the key usage operations.
-     Currently there is only the one defined.  If not set, the caller will be
-     given -ENOTSUPP.  The subtype may do anything it likes to implement an
-     operation, including offloading to hardware.
+     Mandatory.  This is a function for querying the capabilities of a key.
+
+ (4) eds_op().
+
+     Optional.  This is the entry point for the encryption, decryption and
+     signature creation operations (which are distinguished by the operation ID
+     in the parameter struct).  The subtype may do anything it likes to
+     implement an operation, including offloading to hardware.
+
+ (5) verify_signature().
+
+     Optional.  This is the entry point for signature verification.  The
+     subtype may do anything it likes to implement an operation, including
+     offloading to hardware.
 
 
 ==========================
diff --git a/crypto/asymmetric_keys/asymmetric_keys.h b/crypto/asymmetric_keys/asymmetric_keys.h
index ca8e9ac34ce6..7be1ccf4fa9f 100644
--- a/crypto/asymmetric_keys/asymmetric_keys.h
+++ b/crypto/asymmetric_keys/asymmetric_keys.h
@@ -16,3 +16,6 @@ extern struct asymmetric_key_id *asymmetric_key_hex_to_key_id(const char *id);
 extern int __asymmetric_key_hex_to_key_id(const char *id,
 					  struct asymmetric_key_id *match_id,
 					  size_t hexlen);
+
+extern int asymmetric_key_eds_op(struct kernel_pkey_params *params,
+				 const void *in, void *out);
diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 6600181d5d01..77aa44abd7a6 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
+#include <keys/user-type.h>
 #include "asymmetric_keys.h"
 
 MODULE_LICENSE("GPL");
@@ -451,15 +452,57 @@ static void asymmetric_key_destroy(struct key *key)
 	asymmetric_key_free_kids(kids);
 }
 
+int asymmetric_key_eds_op(struct kernel_pkey_params *params,
+			  const void *in, void *out)
+{
+	const struct asymmetric_key_subtype *subtype;
+	struct key *key = params->key;
+	int ret;
+
+	pr_devel("==>%s()\n", __func__);
+
+	if (key->type != &key_type_asymmetric)
+		return -EINVAL;
+	subtype = asymmetric_key_subtype(key);
+	if (!subtype ||
+	    !key->payload.data[0])
+		return -EINVAL;
+	if (!subtype->eds_op)
+		return -ENOTSUPP;
+
+	ret = subtype->eds_op(params, in, out);
+
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+
+static int asymmetric_key_verify_signature(struct kernel_pkey_params *params,
+					   const void *in, const void *in2)
+{
+	struct public_key_signature sig = {
+		.s_size		= params->in2_len,
+		.digest_size	= params->in_len,
+		.encoding	= params->encoding,
+		.hash_algo	= params->hash_algo,
+		.digest		= (void *)in,
+		.s		= (void *)in2,
+	};
+
+	return verify_signature(params->key, &sig);
+}
+
 struct key_type key_type_asymmetric = {
-	.name		= "asymmetric",
-	.preparse	= asymmetric_key_preparse,
-	.free_preparse	= asymmetric_key_free_preparse,
-	.instantiate	= generic_key_instantiate,
-	.match_preparse	= asymmetric_key_match_preparse,
-	.match_free	= asymmetric_key_match_free,
-	.destroy	= asymmetric_key_destroy,
-	.describe	= asymmetric_key_describe,
+	.name			= "asymmetric",
+	.preparse		= asymmetric_key_preparse,
+	.free_preparse		= asymmetric_key_free_preparse,
+	.instantiate		= generic_key_instantiate,
+	.match_preparse		= asymmetric_key_match_preparse,
+	.match_free		= asymmetric_key_match_free,
+	.destroy		= asymmetric_key_destroy,
+	.describe		= asymmetric_key_describe,
+	.asym_query		= query_asymmetric_key,
+	.asym_eds_op		= asymmetric_key_eds_op,
+	.asym_verify_signature	= asymmetric_key_verify_signature,
 };
 EXPORT_SYMBOL_GPL(key_type_asymmetric);
 
diff --git a/crypto/asymmetric_keys/signature.c b/crypto/asymmetric_keys/signature.c
index 11b7ba170904..78545b446400 100644
--- a/crypto/asymmetric_keys/signature.c
+++ b/crypto/asymmetric_keys/signature.c
@@ -16,7 +16,9 @@
 #include <linux/export.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/keyctl.h>
 #include <crypto/public_key.h>
+#include <keys/user-type.h>
 #include "asymmetric_keys.h"
 
 /*
@@ -37,6 +39,99 @@ void public_key_signature_free(struct public_key_signature *sig)
 EXPORT_SYMBOL_GPL(public_key_signature_free);
 
 /**
+ * query_asymmetric_key - Get information about an aymmetric key.
+ * @params: Various parameters.
+ * @info: Where to put the information.
+ */
+int query_asymmetric_key(const struct kernel_pkey_params *params,
+			 struct kernel_pkey_query *info)
+{
+	const struct asymmetric_key_subtype *subtype;
+	struct key *key = params->key;
+	int ret;
+
+	pr_devel("==>%s()\n", __func__);
+
+	if (key->type != &key_type_asymmetric)
+		return -EINVAL;
+	subtype = asymmetric_key_subtype(key);
+	if (!subtype ||
+	    !key->payload.data[0])
+		return -EINVAL;
+	if (!subtype->query)
+		return -ENOTSUPP;
+
+	ret = subtype->query(params, info);
+
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(query_asymmetric_key);
+
+/**
+ * encrypt_blob - Encrypt data using an asymmetric key
+ * @params: Various parameters
+ * @data: Data blob to be encrypted, length params->data_len
+ * @enc: Encrypted data buffer, length params->enc_len
+ *
+ * Encrypt the specified data blob using the private key specified by
+ * params->key.  The encrypted data is wrapped in an encoding if
+ * params->encoding is specified (eg. "pkcs1").
+ *
+ * Returns the length of the data placed in the encrypted data buffer or an
+ * error.
+ */
+int encrypt_blob(struct kernel_pkey_params *params,
+		 const void *data, void *enc)
+{
+	params->op = kernel_pkey_encrypt;
+	return asymmetric_key_eds_op(params, data, enc);
+}
+EXPORT_SYMBOL_GPL(encrypt_blob);
+
+/**
+ * decrypt_blob - Decrypt data using an asymmetric key
+ * @params: Various parameters
+ * @enc: Encrypted data to be decrypted, length params->enc_len
+ * @data: Decrypted data buffer, length params->data_len
+ *
+ * Decrypt the specified data blob using the private key specified by
+ * params->key.  The decrypted data is wrapped in an encoding if
+ * params->encoding is specified (eg. "pkcs1").
+ *
+ * Returns the length of the data placed in the decrypted data buffer or an
+ * error.
+ */
+int decrypt_blob(struct kernel_pkey_params *params,
+		 const void *enc, void *data)
+{
+	params->op = kernel_pkey_decrypt;
+	return asymmetric_key_eds_op(params, enc, data);
+}
+EXPORT_SYMBOL_GPL(decrypt_blob);
+
+/**
+ * create_signature - Sign some data using an asymmetric key
+ * @params: Various parameters
+ * @data: Data blob to be signed, length params->data_len
+ * @enc: Signature buffer, length params->enc_len
+ *
+ * Sign the specified data blob using the private key specified by params->key.
+ * The signature is wrapped in an encoding if params->encoding is specified
+ * (eg. "pkcs1").  If the encoding needs to know the digest type, this can be
+ * passed through params->hash_algo (eg. "sha1").
+ *
+ * Returns the length of the data placed in the signature buffer or an error.
+ */
+int create_signature(struct kernel_pkey_params *params,
+		     const void *data, void *enc)
+{
+	params->op = kernel_pkey_sign;
+	return asymmetric_key_eds_op(params, data, enc);
+}
+EXPORT_SYMBOL_GPL(create_signature);
+
+/**
  * verify_signature - Initiate the use of an asymmetric key to verify a signature
  * @key: The asymmetric key to verify against
  * @sig: The signature to check
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 882ca0e1e7a5..c46140d3729c 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -14,6 +14,8 @@
 #ifndef _LINUX_PUBLIC_KEY_H
 #define _LINUX_PUBLIC_KEY_H
 
+#include <linux/keyctl.h>
+
 /*
  * Cryptographic data for the public-key subtype of the asymmetric key type.
  *
@@ -40,6 +42,7 @@ struct public_key_signature {
 	u8 digest_size;		/* Number of bytes in digest */
 	const char *pkey_algo;
 	const char *hash_algo;
+	const char *encoding;
 };
 
 extern void public_key_signature_free(struct public_key_signature *sig);
@@ -54,8 +57,14 @@ extern int restrict_link_by_signature(struct key *trust_keyring,
 				      const struct key_type *type,
 				      const union key_payload *payload);
 
-extern int verify_signature(const struct key *key,
-			    const struct public_key_signature *sig);
+extern int query_asymmetric_key(const struct kernel_pkey_params *,
+				struct kernel_pkey_query *);
+
+extern int encrypt_blob(struct kernel_pkey_params *, const void *, void *);
+extern int decrypt_blob(struct kernel_pkey_params *, const void *, void *);
+extern int create_signature(struct kernel_pkey_params *, const void *, void *);
+extern int verify_signature(const struct key *,
+			    const struct public_key_signature *);
 
 int public_key_verify_signature(const struct public_key *pkey,
 				const struct public_key_signature *sig);
diff --git a/include/keys/asymmetric-subtype.h b/include/keys/asymmetric-subtype.h
index 2480469ce8fb..bd12733058c6 100644
--- a/include/keys/asymmetric-subtype.h
+++ b/include/keys/asymmetric-subtype.h
@@ -17,6 +17,8 @@
 #include <linux/seq_file.h>
 #include <keys/asymmetric-type.h>
 
+struct kernel_pkey_query;
+struct kernel_pkey_params;
 struct public_key_signature;
 
 /*
@@ -34,6 +36,13 @@ struct asymmetric_key_subtype {
 	/* Destroy a key of this subtype */
 	void (*destroy)(void *payload_crypto, void *payload_auth);
 
+	int (*query)(const struct kernel_pkey_params *params,
+		     struct kernel_pkey_query *info);
+
+	/* Encrypt/decrypt/sign data */
+	int (*eds_op)(struct kernel_pkey_params *params,
+		      const void *in, void *out);
+
 	/* Verify the signature on a key of this subtype (optional) */
 	int (*verify_signature)(const struct key *key,
 				const struct public_key_signature *sig);
