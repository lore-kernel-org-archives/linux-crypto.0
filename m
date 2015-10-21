From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/10] KEYS: Move the point of trust determination to
 __key_link()
Date: Wed, 21 Oct 2015 16:14:50 +0100
Message-ID: <20151021151450.4583.72309.stgit@warthog.procyon.org.uk>
References: <20151021151314.4583.90962.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: keyrings@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151021151314.4583.90962.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Move the point at which a key is determined to be trustworthy to
__key_link() so that we use the contents of the keyring being linked in to
to determine whether the key being linked in is trusted or not.

What is 'trusted' then becomes a matter of what's in the keyring.

Currently, the test is done when the key is parsed, but given that at that
point we can only sensibly refer to the contents of the system trusted
keyring, we can only use that as the basis for working out the
trustworthiness of a new key.

With this change, a trusted keyring is a set of keys that once the
trusted-only flag is set cannot be added to except by verification through
one of the contained keys.

Further, adding a key into a trusted keyring, whilst it might grant
trustworthiness in the context of that keyring, does not automatically
grant trustworthiness in the context of a second keyring to which it could
be secondarily linked.

To accomplish this, the authentication data associated with the key source
must now be retained.  For an X.509 cert, this means the contents of the
AuthorityKeyIdentifier and the signature data.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 certs/system_keyring.c                    |    3 +
 crypto/asymmetric_keys/Makefile           |    2 -
 crypto/asymmetric_keys/asymmetric_keys.h  |    2 +
 crypto/asymmetric_keys/asymmetric_type.c  |   15 +++++
 crypto/asymmetric_keys/pkcs7_trust.c      |   22 +++----
 crypto/asymmetric_keys/public_key.c       |   19 ++++++
 crypto/asymmetric_keys/public_key.h       |    6 ++
 crypto/asymmetric_keys/public_key_trust.c |   94 +++++++++++++----------------
 crypto/asymmetric_keys/x509_parser.h      |    6 --
 crypto/asymmetric_keys/x509_public_key.c  |    6 --
 include/crypto/public_key.h               |    8 +-
 include/keys/asymmetric-subtype.h         |    4 +
 security/integrity/digsig_asymmetric.c    |    5 +-
 13 files changed, 108 insertions(+), 84 deletions(-)

diff --git a/certs/system_keyring.c b/certs/system_keyring.c
index e7f286413276..fbaaaea59f02 100644
--- a/certs/system_keyring.c
+++ b/certs/system_keyring.c
@@ -35,7 +35,8 @@ static __init int system_trusted_keyring_init(void)
 		keyring_alloc(".system_keyring",
 			      KUIDT_INIT(0), KGIDT_INIT(0), current_cred(),
 			      ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
-			      KEY_USR_VIEW | KEY_USR_READ | KEY_USR_SEARCH),
+			       KEY_USR_VIEW | KEY_USR_READ | KEY_USR_SEARCH |
+			       KEY_USR_WRITE),
 			      KEY_ALLOC_NOT_IN_QUOTA, NULL);
 	if (IS_ERR(system_trusted_keyring))
 		panic("Can't allocate system trusted keyring\n");
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index bd07987c64e7..69bcdc9a2ce6 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys.o
 
 asymmetric_keys-y := asymmetric_type.o signature.o
 
-obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key.o
+obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key.o public_key_trust.o
 obj-$(CONFIG_PUBLIC_KEY_ALGO_RSA) += rsa.o
 
 #
diff --git a/crypto/asymmetric_keys/asymmetric_keys.h b/crypto/asymmetric_keys/asymmetric_keys.h
index 1d450b580245..ca8e9ac34ce6 100644
--- a/crypto/asymmetric_keys/asymmetric_keys.h
+++ b/crypto/asymmetric_keys/asymmetric_keys.h
@@ -9,6 +9,8 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+#include <keys/asymmetric-type.h>
+
 extern struct asymmetric_key_id *asymmetric_key_hex_to_key_id(const char *id);
 
 extern int __asymmetric_key_hex_to_key_id(const char *id,
diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index a79d30128821..e02cbd068151 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -362,10 +362,25 @@ static void asymmetric_key_destroy(struct key *key)
 	asymmetric_key_free_kids(kids);
 }
 
+/*
+ * Verify the trust on an asymmetric key when added to a trusted-only keyring.
+ * The keyring provides a list of keys to check against.
+ */
+static int asymmetric_key_verify_trust(const union key_payload *payload,
+				       struct key *keyring)
+{
+	struct asymmetric_key_subtype *subtype = payload->data[asym_subtype];
+
+	pr_devel("==>%s()\n", __func__);
+
+	return subtype->verify_trust(payload, keyring);
+}
+
 struct key_type key_type_asymmetric = {
 	.name		= "asymmetric",
 	.preparse	= asymmetric_key_preparse,
 	.free_preparse	= asymmetric_key_free_preparse,
+	.verify_trust	= asymmetric_key_verify_trust,
 	.instantiate	= generic_key_instantiate,
 	.match_preparse	= asymmetric_key_match_preparse,
 	.match_free	= asymmetric_key_match_free,
diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 400ef359448a..8760bc566902 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -51,9 +51,9 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 		/* Look to see if this certificate is present in the trusted
 		 * keys.
 		 */
-		key = x509_request_asymmetric_key(trust_keyring,
-						  x509->id, x509->skid,
-						  false);
+		key = request_asymmetric_key(trust_keyring,
+					     x509->id, x509->skid,
+					     false);
 		if (!IS_ERR(key)) {
 			/* One of the X.509 certificates in the PKCS#7 message
 			 * is apparently the same as one we already trust.
@@ -84,10 +84,10 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 	 * trusted keys.
 	 */
 	if (last && (last->sig->auth_ids[0] || last->sig->auth_ids[1])) {
-		key = x509_request_asymmetric_key(trust_keyring,
-						  last->sig->auth_ids[0],
-						  last->sig->auth_ids[1],
-						  false);
+		key = request_asymmetric_key(trust_keyring,
+					     last->sig->auth_ids[0],
+					     last->sig->auth_ids[1],
+					     false);
 		if (!IS_ERR(key)) {
 			x509 = last;
 			pr_devel("sinfo %u: Root cert %u signer is key %x\n",
@@ -101,10 +101,10 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 	/* As a last resort, see if we have a trusted public key that matches
 	 * the signed info directly.
 	 */
-	key = x509_request_asymmetric_key(trust_keyring,
-					  sinfo->sig->auth_ids[0],
-					  NULL,
-					  false);
+	key = request_asymmetric_key(trust_keyring,
+				     sinfo->sig->auth_ids[0],
+				     NULL,
+				     false);
 	if (!IS_ERR(key)) {
 		pr_devel("sinfo %u: Direct signer is key %x\n",
 			 sinfo->index, key_serial(key));
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index f5b4824b7c77..7a6d2b3a7168 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -135,6 +135,24 @@ static int public_key_verify_signature_2(const struct key *key,
 }
 
 /*
+ * Verify the trust on an asymmetric key when added to a trusted-only keyring.
+ * The keyring provides a list of keys to check against.
+ */
+static int public_key_verify_trust(const union key_payload *payload,
+				   struct key *keyring)
+{
+	const struct public_key_signature *sig = payload->data[asym_auth];
+	int ret;
+
+	pr_devel("==>%s()\n", __func__);
+
+	ret = public_key_validate_trust(sig, keyring);
+	if (ret == -ENOKEY)
+		ret = -EPERM;
+	return ret;
+}
+
+/*
  * Public key algorithm asymmetric key subtype
  */
 struct asymmetric_key_subtype public_key_subtype = {
@@ -143,6 +161,7 @@ struct asymmetric_key_subtype public_key_subtype = {
 	.name_len		= sizeof("public_key") - 1,
 	.describe		= public_key_describe,
 	.destroy		= public_key_destroy,
+	.verify_trust		= public_key_verify_trust,
 	.verify_signature	= public_key_verify_signature_2,
 };
 EXPORT_SYMBOL_GPL(public_key_subtype);
diff --git a/crypto/asymmetric_keys/public_key.h b/crypto/asymmetric_keys/public_key.h
index 5c37a22a0637..2962025e1c09 100644
--- a/crypto/asymmetric_keys/public_key.h
+++ b/crypto/asymmetric_keys/public_key.h
@@ -34,3 +34,9 @@ extern const struct public_key_algorithm RSA_public_key_algorithm;
  */
 extern int public_key_verify_signature(const struct public_key *pk,
 				       const struct public_key_signature *sig);
+
+/*
+ * public_key_trust.c
+ */
+extern int public_key_validate_trust(const struct public_key_signature *sig,
+				     struct key *trust_keyring);
diff --git a/crypto/asymmetric_keys/public_key_trust.c b/crypto/asymmetric_keys/public_key_trust.c
index 753a413d479b..285f9d6658d4 100644
--- a/crypto/asymmetric_keys/public_key_trust.c
+++ b/crypto/asymmetric_keys/public_key_trust.c
@@ -1,6 +1,6 @@
-/* Instantiate a public key crypto key from an X.509 Certificate
+/* Validate one public key against another to determine trust chaining.
  *
- * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2015 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -9,20 +9,12 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
-#define pr_fmt(fmt) "X.509: "fmt
-#include <linux/module.h>
+#define pr_fmt(fmt) "PKEY: "fmt
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/err.h>
-#include <linux/mpi.h>
-#include <linux/asn1_decoder.h>
-#include <keys/asymmetric-subtype.h>
-#include <keys/asymmetric-parser.h>
-#include <keys/system_keyring.h>
-#include <crypto/hash.h>
 #include "asymmetric_keys.h"
 #include "public_key.h"
-#include "x509_parser.h"
 
 static bool use_builtin_keys;
 static struct asymmetric_key_id *ca_keyid;
@@ -63,21 +55,20 @@ __setup("ca_keys=", ca_keys_setup);
 #endif
 
 /**
- * x509_request_asymmetric_key - Request a key by X.509 certificate params.
+ * request_asymmetric_key - Request a key by ID.
  * @keyring: The keys to search.
- * @id: The issuer & serialNumber to look for or NULL.
- * @skid: The subjectKeyIdentifier to look for or NULL.
+ * @id_0: The first ID to look for or NULL.
+ * @id_1: The second ID to look for or NULL.
  * @partial: Use partial match if true, exact if false.
  *
  * Find a key in the given keyring by identifier.  The preferred identifier is
- * the issuer + serialNumber and the fallback identifier is the
- * subjectKeyIdentifier.  If both are given, the lookup is by the former, but
- * the latter must also match.
+ * the id_0 and the fallback identifier is the id_1.  If both are given, the
+ * lookup is by the former, but the latter must also match.
  */
-struct key *x509_request_asymmetric_key(struct key *keyring,
-					const struct asymmetric_key_id *id,
-					const struct asymmetric_key_id *skid,
-					bool partial)
+struct key *request_asymmetric_key(struct key *keyring,
+				   const struct asymmetric_key_id *id_0,
+				   const struct asymmetric_key_id *id_1,
+				   bool partial)
 {
 	struct key *key;
 	key_ref_t ref;
@@ -85,12 +76,12 @@ struct key *x509_request_asymmetric_key(struct key *keyring,
 	char *req, *p;
 	int len;
 
-	if (id) {
-		lookup = id->data;
-		len = id->len;
+	if (id_0) {
+		lookup = id_0->data;
+		len = id_0->len;
 	} else {
-		lookup = skid->data;
-		len = skid->len;
+		lookup = id_1->data;
+		len = id_1->len;
 	}
 
 	/* Construct an identifier "id:<keyid>". */
@@ -130,14 +121,15 @@ struct key *x509_request_asymmetric_key(struct key *keyring,
 	}
 
 	key = key_ref_to_ptr(ref);
-	if (id && skid) {
+	if (id_0 && id_1) {
 		const struct asymmetric_key_ids *kids = asymmetric_key_ids(key);
-		if (!kids->id[1]) {
-			pr_debug("issuer+serial match, but expected SKID missing\n");
+
+		if (!kids->id[0]) {
+			pr_debug("First ID matches, but second is missing\n");
 			goto reject;
 		}
-		if (!asymmetric_key_id_same(skid, kids->id[1])) {
-			pr_debug("issuer+serial match, but SKID does not\n");
+		if (!asymmetric_key_id_same(id_1, kids->id[1])) {
+			pr_debug("First ID matches, but second does not\n");
 			goto reject;
 		}
 	}
@@ -149,44 +141,40 @@ reject:
 	key_put(key);
 	return ERR_PTR(-EKEYREJECTED);
 }
-EXPORT_SYMBOL_GPL(x509_request_asymmetric_key);
+EXPORT_SYMBOL_GPL(request_asymmetric_key);
 
 /*
  * Check the new certificate against the ones in the trust keyring.  If one of
  * those is the signing key and validates the new certificate, then mark the
  * new certificate as being trusted.
  *
- * Return 0 if the new certificate was successfully validated, 1 if we couldn't
- * find a matching parent certificate in the trusted list and an error if there
- * is a matching certificate but the signature check fails.
+ * Return 0 if the new certificate was successfully validated, -ENOKEY if we
+ * couldn't find a matching parent certificate in the trusted list and some
+ * other error if there is a matching certificate but the signature check
+ * fails or cannot be performed.
  */
-int x509_validate_trust(struct x509_certificate *cert,
-			struct key *trust_keyring)
+int public_key_validate_trust(const struct public_key_signature *sig,
+			      struct key *trust_keyring)
 {
-	struct public_key_signature *sig = cert->sig;
 	struct key *key;
-	int ret = 1;
+	int ret;
 
 	if (!trust_keyring)
 		return -EOPNOTSUPP;
 	if (ca_keyid && !asymmetric_key_id_partial(sig->auth_ids[1], ca_keyid))
 		return -EPERM;
-	if (cert->unsupported_sig)
-		return -ENOPKG;
 
-	key = x509_request_asymmetric_key(trust_keyring,
-					  sig->auth_ids[0], sig->auth_ids[1],
-					  false);
+	key = request_asymmetric_key(trust_keyring,
+				     sig->auth_ids[0],
+				     sig->auth_ids[1],
+				     false);
 	if (IS_ERR(key))
-		return PTR_ERR(key);
-
-	if (!use_builtin_keys ||
-	    test_bit(KEY_FLAG_BUILTIN, &key->flags)) {
-		ret = public_key_verify_signature(
-			key->payload.data[asym_crypto], cert->sig);
-		if (ret == -ENOPKG)
-			cert->unsupported_sig = true;
-	}
+		return -ENOKEY;
+
+	if (use_builtin_keys && !test_bit(KEY_FLAG_BUILTIN, &key->flags))
+		ret = -ENOKEY;
+	else
+		ret = verify_signature(key, sig);
 	key_put(key);
 	return ret;
 }
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 7a802b09a509..05eef1c68881 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -58,9 +58,3 @@ extern int x509_decode_time(time64_t *_t,  size_t hdrlen,
  */
 extern int x509_get_sig_params(struct x509_certificate *cert);
 extern int x509_check_for_self_signed(struct x509_certificate *cert);
-
-/*
- * public_key_trust.c
- */
-extern int x509_validate_trust(struct x509_certificate *cert,
-			       struct key *trust_keyring);
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 19f4abc762ee..df504f8ef783 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -97,7 +97,6 @@ error:
 	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(x509_get_sig_params);
 
 /*
  * Check for self-signedness in an X.509 cert and if found, check the signature
@@ -204,11 +203,6 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 			/* There's no point retaining the signature */
 			public_key_free(NULL, cert->sig);
 			cert->sig = NULL;
-		} else {
-			ret = x509_validate_trust(cert,
-						  get_system_trusted_keyring());
-			if (ret == -EKEYREJECTED)
-				goto error_free_cert;
 		}
 	}
 
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index ed86bfb23e89..eaaf261d398a 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -102,9 +102,9 @@ extern int verify_signature(const struct key *key,
 			    const struct public_key_signature *sig);
 
 struct asymmetric_key_id;
-extern struct key *x509_request_asymmetric_key(struct key *keyring,
-					       const struct asymmetric_key_id *id,
-					       const struct asymmetric_key_id *skid,
-					       bool partial);
+extern struct key *request_asymmetric_key(struct key *keyring,
+					  const struct asymmetric_key_id *id_0,
+					  const struct asymmetric_key_id *id_1,
+					  bool partial);
 
 #endif /* _LINUX_PUBLIC_KEY_H */
diff --git a/include/keys/asymmetric-subtype.h b/include/keys/asymmetric-subtype.h
index 2480469ce8fb..5c8d056d163a 100644
--- a/include/keys/asymmetric-subtype.h
+++ b/include/keys/asymmetric-subtype.h
@@ -34,6 +34,10 @@ struct asymmetric_key_subtype {
 	/* Destroy a key of this subtype */
 	void (*destroy)(void *payload_crypto, void *payload_auth);
 
+	/* Verify the trust on a key against a keyring of keys */
+	int (*verify_trust)(const union key_payload *payload,
+			    struct key *keyring);
+
 	/* Verify the signature on a key of this subtype (optional) */
 	int (*verify_signature)(const struct key *key,
 				const struct public_key_signature *sig);
diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 4fec1816a2b3..668e054e534b 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -23,7 +23,8 @@
 /*
  * Request an asymmetric key.
  */
-static struct key *request_asymmetric_key(struct key *keyring, uint32_t keyid)
+static struct key *ds_request_asymmetric_key(struct key *keyring,
+					     uint32_t keyid)
 {
 	struct key *key;
 	char name[12];
@@ -83,7 +84,7 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 	if (hdr->hash_algo >= PKEY_HASH__LAST)
 		return -ENOPKG;
 
-	key = request_asymmetric_key(keyring, __be32_to_cpu(hdr->keyid));
+	key = ds_request_asymmetric_key(keyring, __be32_to_cpu(hdr->keyid));
 	if (IS_ERR(key))
 		return PTR_ERR(key);
 
