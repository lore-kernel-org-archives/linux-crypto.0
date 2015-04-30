From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC 2/2] crypto: RSA: KEYS: convert rsa and public key to new
 PKE API
Date: Thu, 30 Apr 2015 15:36:58 -0700
Message-ID: <20150430223658.10157.32631.stgit@tstruk-mobl1>
References: <20150430223647.10157.82156.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: corbet@lwn.net, keescook@chromium.org, qat-linux@intel.com,
	jwboyer@redhat.com, richard@nod.at, d.kasatkin@samsung.com,
	linux-kernel@vger.kernel.org, steved@redhat.com,
	dhowells@redhat.com, vgoyal@redhat.com, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	jdelvare@suse.de, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150430223647.10157.82156.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Change the existing rsa and public key code to integrate it
with the new Public Key Encryption API.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 Documentation/crypto/asymmetric-keys.txt  |   10 +++-
 crypto/asymmetric_keys/Kconfig            |    1 
 crypto/asymmetric_keys/pkcs7_parser.c     |    4 +-
 crypto/asymmetric_keys/pkcs7_trust.c      |    2 -
 crypto/asymmetric_keys/pkcs7_verify.c     |    5 +-
 crypto/asymmetric_keys/public_key.c       |   73 +++++++++++++++++------------
 crypto/asymmetric_keys/public_key.h       |   36 --------------
 crypto/asymmetric_keys/rsa.c              |   47 +++++++++++++++----
 crypto/asymmetric_keys/x509_cert_parser.c |   14 ++++--
 crypto/asymmetric_keys/x509_public_key.c  |   14 ++----
 include/crypto/public_key.h               |   24 +++-------
 kernel/module_signing.c                   |    9 +++-
 12 files changed, 124 insertions(+), 115 deletions(-)
 delete mode 100644 crypto/asymmetric_keys/public_key.h

diff --git a/Documentation/crypto/asymmetric-keys.txt b/Documentation/crypto/asymmetric-keys.txt
index b767590..47bb5fb 100644
--- a/Documentation/crypto/asymmetric-keys.txt
+++ b/Documentation/crypto/asymmetric-keys.txt
@@ -89,11 +89,9 @@ inclusion is required:
 	#include <crypto/public_key.h>
 
 This gives access to functions for dealing with asymmetric / public keys.
-Three enums are defined there for representing public-key cryptography
+Two enums are defined there for representing public-key cryptography
 algorithms:
 
-	enum pkey_algo
-
 digest algorithms used by those:
 
 	enum pkey_hash_algo
@@ -102,6 +100,11 @@ and key identifier representations:
 
 	enum pkey_id_type
 
+Additionally public key algorithm names are defined:
+#define PKEY_ALGO_DSA "dsa"
+#define PKEY_ALGO_RSA "rsa"
+These will be used to allocate public key tfm instances.
+
 Note that the key type representation types are required because key
 identifiers from different standards aren't necessarily compatible.  For
 instance, PGP generates key identifiers by hashing the key data plus some
@@ -131,6 +134,7 @@ transferred the relevant bits to the structure pointed to by sig.
 
 	struct public_key_signature {
 		u8 *digest;
+		char *pkey_algo;
 		u8 digest_size;
 		enum pkey_hash_algo pkey_hash_algo : 8;
 		u8 nr_mpi;
diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 4870f28..1ad10f1 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -23,6 +23,7 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 config PUBLIC_KEY_ALGO_RSA
 	tristate "RSA public-key algorithm"
 	select MPILIB
+	select CRYPTO_PKE
 	help
 	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
 
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 3bd5a1e..d37a608 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -15,7 +15,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/oid_registry.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
 #include "pkcs7_parser.h"
 #include "pkcs7-asn1.h"
 
@@ -376,7 +376,7 @@ int pkcs7_sig_note_signature(void *context, size_t hdrlen,
 	struct pkcs7_parse_context *ctx = context;
 	MPI mpi;
 
-	BUG_ON(ctx->sinfo->sig.pkey_algo != PKEY_ALGO_RSA);
+	BUG_ON(strcmp(ctx->sinfo->sig.pkey_algo, PKEY_ALGO_RSA));
 
 	mpi = mpi_read_raw_data(value, vlen);
 	if (!mpi)
diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 1d29376..68ebae2 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -17,7 +17,7 @@
 #include <linux/asn1.h>
 #include <linux/key.h>
 #include <keys/asymmetric-type.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
 #include "pkcs7_parser.h"
 
 /**
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index cd45545..28f4a77 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -16,7 +16,7 @@
 #include <linux/err.h>
 #include <linux/asn1.h>
 #include <crypto/hash.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
 #include "pkcs7_parser.h"
 
 /*
@@ -144,7 +144,8 @@ static int pkcs7_find_key(struct pkcs7_message *pkcs7,
 		pr_devel("Sig %u: Found cert serial match X.509[%u]\n",
 			 sinfo->index, certix);
 
-		if (x509->pub->pkey_algo != sinfo->sig.pkey_algo) {
+		if (strcmp(pke_alg_name(x509->pub->tfm),
+			   sinfo->sig.pkey_algo)) {
 			pr_warn("Sig %u: X.509 algo and PKCS#7 sig algo don't match\n",
 				sinfo->index);
 			continue;
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 2f6e4fb..031112a 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -18,30 +18,21 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <keys/asymmetric-subtype.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
 
 MODULE_LICENSE("GPL");
 
-const char *const pkey_algo_name[PKEY_ALGO__LAST] = {
-	[PKEY_ALGO_DSA]		= "DSA",
-	[PKEY_ALGO_RSA]		= "RSA",
-};
-EXPORT_SYMBOL_GPL(pkey_algo_name);
-
-const struct public_key_algorithm *pkey_algo[PKEY_ALGO__LAST] = {
-#if defined(CONFIG_PUBLIC_KEY_ALGO_RSA) || \
-	defined(CONFIG_PUBLIC_KEY_ALGO_RSA_MODULE)
-	[PKEY_ALGO_RSA]		= &RSA_public_key_algorithm,
-#endif
-};
-EXPORT_SYMBOL_GPL(pkey_algo);
-
 const char *const pkey_id_type_name[PKEY_ID_TYPE__LAST] = {
 	[PKEY_ID_PGP]		= "PGP",
 	[PKEY_ID_X509]		= "X509",
 };
 EXPORT_SYMBOL_GPL(pkey_id_type_name);
 
+struct public_key_completion {
+	struct completion completion;
+	int err;
+};
+
 /*
  * Provide a part of a description of the key for /proc/keys.
  */
@@ -52,7 +43,8 @@ static void public_key_describe(const struct key *asymmetric_key,
 
 	if (key)
 		seq_printf(m, "%s.%s",
-			   pkey_id_type_name[key->id_type], key->algo->name);
+			   pkey_id_type_name[key->id_type],
+			   pke_alg_name(key->tfm));
 }
 
 /*
@@ -71,13 +63,27 @@ void public_key_destroy(void *payload)
 }
 EXPORT_SYMBOL_GPL(public_key_destroy);
 
+static void public_key_verify_done(struct crypto_async_request *req, int err)
+{
+	struct public_key_completion *compl = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	compl->err = err;
+	complete(&compl->completion);
+}
+
 /*
  * Verify a signature using a public key.
  */
 int public_key_verify_signature(const struct public_key *pk,
 				const struct public_key_signature *sig)
 {
-	const struct public_key_algorithm *algo;
+	struct crypto_pke *tfm;
+	struct pke_request *req;
+	struct public_key_completion compl;
+	int ret;
 
 	BUG_ON(!pk);
 	BUG_ON(!pk->mpi[0]);
@@ -86,25 +92,32 @@ int public_key_verify_signature(const struct public_key *pk,
 	BUG_ON(!sig->digest);
 	BUG_ON(!sig->mpi[0]);
 
-	algo = pk->algo;
-	if (!algo) {
-		if (pk->pkey_algo >= PKEY_ALGO__LAST)
-			return -ENOPKG;
-		algo = pkey_algo[pk->pkey_algo];
-		if (!algo)
-			return -ENOPKG;
-	}
+	tfm = pk->tfm;
+	if (IS_ERR(tfm))
+		return -EINVAL;
 
-	if (!algo->verify_signature)
-		return -ENOTSUPP;
+	req = pke_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
 
-	if (sig->nr_mpi != algo->n_sig_mpi) {
+	if (sig->nr_mpi != pke_num_sig_mpi(tfm)) {
 		pr_debug("Signature has %u MPI not %u\n",
-			 sig->nr_mpi, algo->n_sig_mpi);
+			 sig->nr_mpi, pke_num_sig_mpi(tfm));
 		return -EINVAL;
 	}
 
-	return algo->verify_signature(pk, sig);
+	init_completion(&compl.completion);
+	pke_request_set_crypt(req, pk, sig);
+	pke_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				 CRYPTO_TFM_REQ_MAY_SLEEP,
+				 public_key_verify_done, &compl);
+	ret = crypto_pke_verify(req);
+	if (ret == -EINPROGRESS) {
+		wait_for_completion(&compl.completion);
+		ret = compl.err;
+	}
+	pke_request_free(req);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(public_key_verify_signature);
 
diff --git a/crypto/asymmetric_keys/public_key.h b/crypto/asymmetric_keys/public_key.h
deleted file mode 100644
index 5c37a22..0000000
--- a/crypto/asymmetric_keys/public_key.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/* Public key algorithm internals
- *
- * See Documentation/crypto/asymmetric-keys.txt
- *
- * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#include <crypto/public_key.h>
-
-extern struct asymmetric_key_subtype public_key_subtype;
-
-/*
- * Public key algorithm definition.
- */
-struct public_key_algorithm {
-	const char	*name;
-	u8		n_pub_mpi;	/* Number of MPIs in public key */
-	u8		n_sec_mpi;	/* Number of MPIs in secret key */
-	u8		n_sig_mpi;	/* Number of MPIs in a signature */
-	int (*verify_signature)(const struct public_key *key,
-				const struct public_key_signature *sig);
-};
-
-extern const struct public_key_algorithm RSA_public_key_algorithm;
-
-/*
- * public_key.c
- */
-extern int public_key_verify_signature(const struct public_key *pk,
-				       const struct public_key_signature *sig);
diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index 459cf97..d7ad132 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -14,7 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <crypto/algapi.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("RSA Public Key Algorithm");
@@ -207,9 +207,10 @@ static int RSA_verify(const u8 *H, const u8 *EM, size_t k, size_t hash_size,
 /*
  * Perform the verification step [RFC3447 sec 8.2.2].
  */
-static int RSA_verify_signature(const struct public_key *key,
-				const struct public_key_signature *sig)
+static int RSA_verify_signature(struct pke_request *req)
 {
+	const struct public_key *key = req->pk;
+	const struct public_key_signature *sig = req->pks;
 	size_t tsize;
 	int ret;
 
@@ -268,11 +269,37 @@ error:
 	return ret;
 }
 
-const struct public_key_algorithm RSA_public_key_algorithm = {
-	.name		= "RSA",
-	.n_pub_mpi	= 2,
-	.n_sec_mpi	= 3,
-	.n_sig_mpi	= 1,
-	.verify_signature = RSA_verify_signature,
+static struct crypto_alg rsa = {
+	.cra_name = "rsa",
+	.cra_driver_name = "rsa-keys",
+	.cra_priority = 100,
+	.cra_flags = CRYPTO_ALG_TYPE_PKE,
+	.cra_ctxsize = 0,
+	.cra_alignmask = 0,
+	.cra_type = &crypto_pke_type,
+	.cra_module = THIS_MODULE,
+	.cra_u = {
+		.pke = {
+			.verify = RSA_verify_signature,
+			.capabilities = PKEY_CAN_VERIFY,
+			.pub_mpis = 2,
+			.sec_mpis = 3,
+			.sig_mpis = 1,
+		},
+	},
 };
-EXPORT_SYMBOL_GPL(RSA_public_key_algorithm);
+
+static int rsa_init(void)
+{
+	return crypto_register_alg(&rsa);
+}
+
+static void rsa_exit(void)
+{
+	if (crypto_unregister_alg(&rsa))
+		BUG();
+}
+
+module_init(rsa_init);
+module_exit(rsa_exit);
+MODULE_ALIAS_CRYPTO("rsa");
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index a668d90..56816aa 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -15,7 +15,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/oid_registry.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
 #include "x509_parser.h"
 #include "x509-asn1.h"
 #include "x509_rsakey-asn1.h"
@@ -43,6 +43,8 @@ struct x509_parse_context {
 void x509_free_certificate(struct x509_certificate *cert)
 {
 	if (cert) {
+		if (cert->pub && !IS_ERR(cert->pub->tfm))
+			crypto_free_pke(cert->pub->tfm);
 		public_key_destroy(cert->pub);
 		kfree(cert->issuer);
 		kfree(cert->subject);
@@ -100,6 +102,14 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 		ret = PTR_ERR(kid);
 		goto error_decode;
 	}
+
+	cert->pub->tfm = crypto_alloc_pke(ctx->cert->sig.pkey_algo, 0, 0);
+	if (IS_ERR(cert->pub->tfm)) {
+		pr_err("Failed to alloc pkey algo %s\n",
+		       ctx->cert->sig.pkey_algo);
+		goto error_decode;
+	}
+
 	cert->id = kid;
 
 	kfree(ctx);
@@ -378,8 +388,6 @@ int x509_extract_key_data(void *context, size_t hdrlen,
 	if (ctx->last_oid != OID_rsaEncryption)
 		return -ENOPKG;
 
-	ctx->cert->pub->pkey_algo = PKEY_ALGO_RSA;
-
 	/* Discard the BIT STRING metadata */
 	ctx->key = value + 1;
 	ctx->key_size = vlen - 1;
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index a6c4203..4a346c7 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -20,8 +20,8 @@
 #include <keys/asymmetric-parser.h>
 #include <keys/system_keyring.h>
 #include <crypto/hash.h>
+#include <crypto/public_key.h>
 #include "asymmetric_keys.h"
-#include "public_key.h"
 #include "x509_parser.h"
 
 static bool use_builtin_keys;
@@ -247,17 +247,13 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	pr_devel("Cert Issuer: %s\n", cert->issuer);
 	pr_devel("Cert Subject: %s\n", cert->subject);
 
-	if (cert->pub->pkey_algo >= PKEY_ALGO__LAST ||
-	    cert->sig.pkey_algo >= PKEY_ALGO__LAST ||
-	    cert->sig.pkey_hash_algo >= PKEY_HASH__LAST ||
-	    !pkey_algo[cert->pub->pkey_algo] ||
-	    !pkey_algo[cert->sig.pkey_algo] ||
+	if (cert->sig.pkey_hash_algo >= PKEY_HASH__LAST ||
 	    !hash_algo_name[cert->sig.pkey_hash_algo]) {
 		ret = -ENOPKG;
 		goto error_free_cert;
 	}
 
-	pr_devel("Cert Key Algo: %s\n", pkey_algo_name[cert->pub->pkey_algo]);
+	pr_devel("Cert Key Algo: %s\n", pke_alg_name(cert->pub->tfm));
 	pr_devel("Cert Valid From: %04ld-%02d-%02d %02d:%02d:%02d\n",
 		 cert->valid_from.tm_year + 1900, cert->valid_from.tm_mon + 1,
 		 cert->valid_from.tm_mday, cert->valid_from.tm_hour,
@@ -266,11 +262,9 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		 cert->valid_to.tm_year + 1900, cert->valid_to.tm_mon + 1,
 		 cert->valid_to.tm_mday, cert->valid_to.tm_hour,
 		 cert->valid_to.tm_min,  cert->valid_to.tm_sec);
-	pr_devel("Cert Signature: %s + %s\n",
-		 pkey_algo_name[cert->sig.pkey_algo],
+	pr_devel("Cert Signature: %s + %s\n", cert->sig.pkey_algo,
 		 hash_algo_name[cert->sig.pkey_hash_algo]);
 
-	cert->pub->algo = pkey_algo[cert->pub->pkey_algo];
 	cert->pub->id_type = PKEY_ID_X509;
 
 	/* Check the signature on the key if it appears to be self-signed */
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 54add20..c4420e9 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -15,17 +15,12 @@
 #define _LINUX_PUBLIC_KEY_H
 
 #include <linux/mpi.h>
+#include <linux/crypto.h>
 #include <keys/asymmetric-type.h>
 #include <crypto/hash_info.h>
 
-enum pkey_algo {
-	PKEY_ALGO_DSA,
-	PKEY_ALGO_RSA,
-	PKEY_ALGO__LAST
-};
-
-extern const char *const pkey_algo_name[PKEY_ALGO__LAST];
-extern const struct public_key_algorithm *pkey_algo[PKEY_ALGO__LAST];
+#define PKEY_ALGO_DSA "dsa"
+#define PKEY_ALGO_RSA "rsa"
 
 /* asymmetric key implementation supports only up to SHA224 */
 #define PKEY_HASH__LAST		(HASH_ALGO_SHA224 + 1)
@@ -45,13 +40,7 @@ extern const char *const pkey_id_type_name[PKEY_ID_TYPE__LAST];
  * part.
  */
 struct public_key {
-	const struct public_key_algorithm *algo;
-	u8	capabilities;
-#define PKEY_CAN_ENCRYPT	0x01
-#define PKEY_CAN_DECRYPT	0x02
-#define PKEY_CAN_SIGN		0x04
-#define PKEY_CAN_VERIFY		0x08
-	enum pkey_algo pkey_algo : 8;
+	struct crypto_pke *tfm;
 	enum pkey_id_type id_type : 8;
 	union {
 		MPI	mpi[5];
@@ -79,9 +68,9 @@ extern void public_key_destroy(void *payload);
  */
 struct public_key_signature {
 	u8 *digest;
+	char *pkey_algo;
 	u8 digest_size;			/* Number of bytes in digest */
 	u8 nr_mpi;			/* Occupancy of mpi[] */
-	enum pkey_algo pkey_algo : 8;
 	enum hash_algo pkey_hash_algo : 8;
 	union {
 		MPI mpi[2];
@@ -95,6 +84,7 @@ struct public_key_signature {
 	};
 };
 
+extern struct asymmetric_key_subtype public_key_subtype;
 struct key;
 extern int verify_signature(const struct key *key,
 			    const struct public_key_signature *sig);
@@ -104,4 +94,6 @@ extern struct key *x509_request_asymmetric_key(struct key *keyring,
 					       const struct asymmetric_key_id *kid,
 					       bool partial);
 
+int public_key_verify_signature(const struct public_key *pk,
+				const struct public_key_signature *sig);
 #endif /* _LINUX_PUBLIC_KEY_H */
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index be5b8fa..1c55adb 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -28,7 +28,7 @@
  *	- Information block
  */
 struct module_signature {
-	u8	algo;		/* Public-key crypto algorithm [enum pkey_algo] */
+	u8	algo;		/* Public-key crypto algorithm */
 	u8	hash;		/* Digest algorithm [enum hash_algo] */
 	u8	id_type;	/* Key identifier type [enum pkey_id_type] */
 	u8	signer_len;	/* Length of signer's name */
@@ -37,6 +37,10 @@ struct module_signature {
 	__be32	sig_len;	/* Length of signature data */
 };
 
+static const char *const pkey_algo_name[] = {
+	PKEY_ALGO_DSA, PKEY_ALGO_RSA
+};
+
 /*
  * Digest the module contents.
  */
@@ -213,7 +217,8 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
 	sig = mod + modlen;
 
 	/* For the moment, only support RSA and X.509 identifiers */
-	if (ms.algo != PKEY_ALGO_RSA ||
+	if (ARRAY_SIZE(pkey_algo_name) - 1 < ms.algo ||
+	    strcmp(pkey_algo_name[ms.algo], PKEY_ALGO_RSA) != 0 ||
 	    ms.id_type != PKEY_ID_X509)
 		return -ENOPKG;
 
