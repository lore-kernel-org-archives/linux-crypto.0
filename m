From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 3/8] KEYS: Provide missing asymmetric key subops for new
 key type ops [ver 3]
Date: Wed, 11 May 2016 15:22:15 +0100
Message-ID: <20160511142215.4743.34404.stgit@warthog.procyon.org.uk>
References: <20160511142152.4743.14414.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org
To: mathew.j.martineau@linux.intel.com, tadeusz.struk@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160511142152.4743.14414.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Provide the missing asymmetric key subops for new key type ops.  This
include query, encrypt, decrypt and create signature.  Verify signature
already exists.  Also provided are accessor functions for this:

	int query_asymmetric_key(const struct key *key,
				 const struct key *password,
				 struct kernel_pkey_query *info);

	int encrypt_blob(struct kernel_pkey_params *params,
			 const void *data, void *enc);
	int decrypt_blob(struct kernel_pkey_params *params,
			 const void *enc, void *data);
	int create_signature(struct kernel_pkey_params *params,
			     const void *data, void *enc);

The public_key_signature struct gains an encoding field to carry the
encoding for verify_signature() and that function gains an extra key
pointer that can be used to pass a pointer to a logon key carrying a
password to unlock the key.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/crypto/asymmetric-keys.txt |   31 +++++++-
 crypto/asymmetric_keys/asymmetric_keys.h |    3 +
 crypto/asymmetric_keys/asymmetric_type.c |   60 ++++++++++++++--
 crypto/asymmetric_keys/pkcs7_trust.c     |    2 -
 crypto/asymmetric_keys/public_key.c      |    1 
 crypto/asymmetric_keys/restrict.c        |    2 -
 crypto/asymmetric_keys/signature.c       |  112 +++++++++++++++++++++++++++++-
 include/crypto/public_key.h              |   13 +++
 include/keys/asymmetric-subtype.h        |   10 +++
 security/integrity/digsig_asymmetric.c   |    2 -
 10 files changed, 216 insertions(+), 20 deletions(-)

diff --git a/Documentation/crypto/asymmetric-keys.txt b/Documentation/crypto/asymmetric-keys.txt
index 8c07e0ea6bc0..93a071714de7 100644
--- a/Documentation/crypto/asymmetric-keys.txt
+++ b/Documentation/crypto/asymmetric-keys.txt
@@ -123,6 +123,7 @@ An operation is provided to perform cryptographic signature verification, using
 an asymmetric key to provide or to provide access to the public key.
 
 	int verify_signature(const struct key *key,
+			     const struct key *password,
 			     const struct public_key_signature *sig);
 
 The caller must have already obtained the key from some source and can then use
@@ -148,6 +149,9 @@ In addition, the data must have been digested by the caller and the resulting
 hash must be pointed to by sig->digest and the size of the hash be placed in
 sig->digest_size.
 
+If the key needs to be unlocked with a passphrase, this can be passed in a
+logon key as the password argument.
+
 The function will return 0 upon success or -EKEYREJECTED if the signature
 doesn't match.
 
@@ -182,6 +186,10 @@ and looks like the following:
 
 		void (*describe)(const struct key *key, struct seq_file *m);
 		void (*destroy)(void *payload);
+		int (*query)(const struct kernel_pkey_params *params,
+			     struct kernel_pkey_query *info);
+		int (*eds_op)(struct kernel_pkey_params *params,
+			      const void *in, void *out);
 		int (*verify_signature)(const struct key *key,
 					const struct public_key_signature *sig);
 	};
@@ -206,12 +214,25 @@ There are a number of operations defined by the subtype:
      asymmetric key will look after freeing the fingerprint and releasing the
      reference on the subtype module.
 
- (3) verify_signature().
+ (3) query().
+
+     Mandatory.  This is a function for querying the capabilities of a key.  A
+     password can be provided if the key needs unlocking.
+
+ (4) eds_op().
+
+     Optional.  This is the entry point for the encryption, decryption and
+     signature creation operations (which are distinguished by the operation ID
+     in the parameter struct).  The subtype may do anything it likes to
+     implement an operation, including offloading to hardware.  A password can
+     be provided if the key needs unlocking.
+
+ (5) verify_signature().
 
-     Optional.  These are the entry points for the key usage operations.
-     Currently there is only the one defined.  If not set, the caller will be
-     given -ENOTSUPP.  The subtype may do anything it likes to implement an
-     operation, including offloading to hardware.
+     Optional.  This is the entry point for signature verification.  The
+     subtype may do anything it likes to implement an operation, including
+     offloading to hardware.  A password can be provided if the key needs
+     unlocking.
 
 
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
index 6600181d5d01..0b33a3ba43bd 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
+#include <keys/user-type.h>
 #include "asymmetric_keys.h"
 
 MODULE_LICENSE("GPL");
@@ -451,15 +452,58 @@ static void asymmetric_key_destroy(struct key *key)
 	asymmetric_key_free_kids(kids);
 }
 
+int asymmetric_key_eds_op(struct kernel_pkey_params *params,
+			  const void *in, void *out)
+{
+	const struct asymmetric_key_subtype *subtype;
+	struct key *key = params->key, *password = params->password;
+	int ret;
+
+	pr_devel("==>%s()\n", __func__);
+
+	if (key->type != &key_type_asymmetric ||
+	    (password && password->type != &key_type_logon))
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
+	return verify_signature(params->key, params->password, &sig);
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
 
diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index f6a009d88a33..908140e334cf 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -115,7 +115,7 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 	return -ENOKEY;
 
 matched:
-	ret = verify_signature(key, sig);
+	ret = verify_signature(key, NULL, sig);
 	key_put(key);
 	if (ret < 0) {
 		if (ret == -ENOMEM)
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index fd76b5fc3b3a..96983906d2a2 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -164,6 +164,7 @@ error_free_tfm:
 EXPORT_SYMBOL_GPL(public_key_verify_signature);
 
 static int public_key_verify_signature_2(const struct key *key,
+					 const struct key *password,
 					 const struct public_key_signature *sig)
 {
 	const struct public_key *pk = key->payload.data[asym_crypto];
diff --git a/crypto/asymmetric_keys/restrict.c b/crypto/asymmetric_keys/restrict.c
index ac4bddf669de..d9efe00c5881 100644
--- a/crypto/asymmetric_keys/restrict.c
+++ b/crypto/asymmetric_keys/restrict.c
@@ -102,7 +102,7 @@ int restrict_link_by_signature(struct key *trust_keyring,
 	if (use_builtin_keys && !test_bit(KEY_FLAG_BUILTIN, &key->flags))
 		ret = -ENOKEY;
 	else
-		ret = verify_signature(key, sig);
+		ret = verify_signature(key, NULL, sig);
 	key_put(key);
 	return ret;
 }
diff --git a/crypto/asymmetric_keys/signature.c b/crypto/asymmetric_keys/signature.c
index 11b7ba170904..d69c76e2e991 100644
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
@@ -37,13 +39,118 @@ void public_key_signature_free(struct public_key_signature *sig)
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
+	struct key *key = params->key, *password = params->password;
+	int ret;
+
+	pr_devel("==>%s()\n", __func__);
+
+	if (key->type != &key_type_asymmetric ||
+	    (password && password->type != &key_type_logon))
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
+ * If the key needs to be unlocked, a password can be supplied in a logon key
+ * specified by params->password.
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
+ * If the private key needs to be unlocked, a password can be supplied in a
+ * logon key specified by params->password.
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
+ * If the private key needs to be unlocked, a password can be supplied in a
+ * logon key specified by params->password.
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
+ * @password: Logon key containing passphrase if one is needed
  * @sig: The signature to check
  *
  * Returns 0 if successful or else an error.
  */
 int verify_signature(const struct key *key,
+		     const struct key *password,
 		     const struct public_key_signature *sig)
 {
 	const struct asymmetric_key_subtype *subtype;
@@ -51,7 +158,8 @@ int verify_signature(const struct key *key,
 
 	pr_devel("==>%s()\n", __func__);
 
-	if (key->type != &key_type_asymmetric)
+	if (key->type != &key_type_asymmetric ||
+	    (password && password->type != &key_type_logon))
 		return -EINVAL;
 	subtype = asymmetric_key_subtype(key);
 	if (!subtype ||
@@ -60,7 +168,7 @@ int verify_signature(const struct key *key,
 	if (!subtype->verify_signature)
 		return -ENOTSUPP;
 
-	ret = subtype->verify_signature(key, sig);
+	ret = subtype->verify_signature(key, password, sig);
 
 	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 882ca0e1e7a5..1db6f1933dbd 100644
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
+extern int verify_signature(const struct key *, const struct key *,
+			    const struct public_key_signature *);
 
 int public_key_verify_signature(const struct public_key *pkey,
 				const struct public_key_signature *sig);
diff --git a/include/keys/asymmetric-subtype.h b/include/keys/asymmetric-subtype.h
index 2480469ce8fb..e7da2b3c4f31 100644
--- a/include/keys/asymmetric-subtype.h
+++ b/include/keys/asymmetric-subtype.h
@@ -17,6 +17,8 @@
 #include <linux/seq_file.h>
 #include <keys/asymmetric-type.h>
 
+struct kernel_pkey_query;
+struct kernel_pkey_params;
 struct public_key_signature;
 
 /*
@@ -34,8 +36,16 @@ struct asymmetric_key_subtype {
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
+				const struct key *password,
 				const struct public_key_signature *sig);
 };
 
diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 80052ed8d467..09105f7d54d2 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -110,7 +110,7 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 	pks.digest_size = datalen;
 	pks.s = hdr->sig;
 	pks.s_size = siglen;
-	ret = verify_signature(key, &pks);
+	ret = verify_signature(key, NULL, &pks);
 	key_put(key);
 	pr_debug("%s() = %d\n", __func__, ret);
 	return ret;
