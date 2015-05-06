From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC v2 2/2] crypto: RSA: KEYS: convert rsa and public key to
 new PKE API
Date: Wed, 06 May 2015 12:36:53 -0700
Message-ID: <20150506193653.9329.97756.stgit@tstruk-mobl1>
References: <20150506193643.9329.75351.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, tadeusz.struk@intel.com,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150506193643.9329.75351.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Change the existing rsa and public key code to integrate it
with the new Public Key Encryption API.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/asymmetric_keys/Kconfig            |    1 
 crypto/asymmetric_keys/pkcs7_parser.c     |    2 -
 crypto/asymmetric_keys/pkcs7_trust.c      |    2 -
 crypto/asymmetric_keys/pkcs7_verify.c     |    3 +
 crypto/asymmetric_keys/public_key.c       |   89 +++++++++++++++++++----------
 crypto/asymmetric_keys/public_key.h       |   36 ------------
 crypto/asymmetric_keys/rsa.c              |   43 +++++++++++---
 crypto/asymmetric_keys/x509_cert_parser.c |    3 +
 crypto/asymmetric_keys/x509_public_key.c  |    6 +-
 include/crypto/public_key.h               |   11 +---
 10 files changed, 104 insertions(+), 92 deletions(-)
 delete mode 100644 crypto/asymmetric_keys/public_key.h

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 4870f28..1b7d7d6 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -23,6 +23,7 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 config PUBLIC_KEY_ALGO_RSA
 	tristate "RSA public-key algorithm"
 	select MPILIB
+	select CRYPTO_PKEY
 	help
 	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
 
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 3bd5a1e..054f110 100644
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
index cd45545..9f1035c 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -16,7 +16,8 @@
 #include <linux/err.h>
 #include <linux/asn1.h>
 #include <crypto/hash.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
+#include <crypto/pkey.h>
 #include "pkcs7_parser.h"
 
 /*
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 2f6e4fb..d147ee0 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -18,30 +18,28 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <keys/asymmetric-subtype.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
+#include <crypto/pkey.h>
 
 MODULE_LICENSE("GPL");
 
 const char *const pkey_algo_name[PKEY_ALGO__LAST] = {
-	[PKEY_ALGO_DSA]		= "DSA",
-	[PKEY_ALGO_RSA]		= "RSA",
+	[PKEY_ALGO_DSA]		= "dsa",
+	[PKEY_ALGO_RSA]		= "rsa",
 };
 EXPORT_SYMBOL_GPL(pkey_algo_name);
 
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
@@ -52,7 +50,8 @@ static void public_key_describe(const struct key *asymmetric_key,
 
 	if (key)
 		seq_printf(m, "%s.%s",
-			   pkey_id_type_name[key->id_type], key->algo->name);
+			   pkey_id_type_name[key->id_type],
+			   pkey_algo_name[key->pkey_algo]);
 }
 
 /*
@@ -71,40 +70,68 @@ void public_key_destroy(void *payload)
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
-int public_key_verify_signature(const struct public_key *pk,
+int public_key_verify_signature(const struct public_key *pkey,
 				const struct public_key_signature *sig)
 {
-	const struct public_key_algorithm *algo;
-
-	BUG_ON(!pk);
-	BUG_ON(!pk->mpi[0]);
-	BUG_ON(!pk->mpi[1]);
+	struct crypto_pkey *tfm;
+	struct pkey_request *req;
+	struct public_key_completion compl;
+	int ret;
+
+	BUG_ON(!pkey);
+	BUG_ON(!pkey->mpi[0]);
+	BUG_ON(!pkey->mpi[1]);
 	BUG_ON(!sig);
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
+	if (pkey->pkey_algo >= PKEY_ALGO__LAST)
+		return -ENOPKG;
 
-	if (!algo->verify_signature)
-		return -ENOTSUPP;
+	tfm = crypto_alloc_pkey(pkey_algo_name[pkey->pkey_algo], 0, 0);
+	if (IS_ERR(tfm))
+		return -ENOMEM;
 
-	if (sig->nr_mpi != algo->n_sig_mpi) {
+	if (!(pkey_capabilities(tfm) & PKEY_CAN_VERIFY))
+		return -EINVAL;
+
+	if (sig->nr_mpi != pkey_num_sig_mpi(tfm)) {
 		pr_debug("Signature has %u MPI not %u\n",
-			 sig->nr_mpi, algo->n_sig_mpi);
+			 sig->nr_mpi, pkey_num_sig_mpi(tfm));
 		return -EINVAL;
 	}
 
-	return algo->verify_signature(pk, sig);
+	req = pkey_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	init_completion(&compl.completion);
+	pkey_request_set_crypt(req, pkey, sig);
+	pkey_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				 CRYPTO_TFM_REQ_MAY_SLEEP,
+				 public_key_verify_done, &compl);
+	ret = crypto_pkey_verify(req);
+	if (ret == -EINPROGRESS) {
+		wait_for_completion(&compl.completion);
+		ret = compl.err;
+	}
+	pkey_request_free(req);
+	crypto_free_pkey(tfm);
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
index 459cf97..4282d30 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -14,7 +14,8 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <crypto/algapi.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
+#include <crypto/pkey.h>
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("RSA Public Key Algorithm");
@@ -207,9 +208,10 @@ static int RSA_verify(const u8 *H, const u8 *EM, size_t k, size_t hash_size,
 /*
  * Perform the verification step [RFC3447 sec 8.2.2].
  */
-static int RSA_verify_signature(const struct public_key *key,
-				const struct public_key_signature *sig)
+static int RSA_verify_signature(struct pkey_request *req)
 {
+	const struct public_key *key = req->pkey;
+	const struct public_key_signature *sig = req->signature;
 	size_t tsize;
 	int ret;
 
@@ -268,11 +270,32 @@ error:
 	return ret;
 }
 
-const struct public_key_algorithm RSA_public_key_algorithm = {
-	.name		= "RSA",
-	.n_pub_mpi	= 2,
-	.n_sec_mpi	= 3,
-	.n_sig_mpi	= 1,
-	.verify_signature = RSA_verify_signature,
+static struct pkey_alg rsa = {
+	.verify = RSA_verify_signature,
+	.n_pub_mpi = 2,
+	.n_sec_mpi = 3,
+	.n_sig_mpi = 1,
+	.capabilities = PKEY_CAN_VERIFY,
+	.base = {
+		.cra_name = "rsa",
+		.cra_driver_name = "rsa-keys",
+		.cra_priority = 100,
+		.cra_ctxsize = 0,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
 };
-EXPORT_SYMBOL_GPL(RSA_public_key_algorithm);
+
+static int rsa_init(void)
+{
+	return crypto_register_pkey(&rsa);
+}
+
+static void rsa_exit(void)
+{
+	crypto_unregister_pkey(&rsa);
+}
+
+module_init(rsa_init);
+module_exit(rsa_exit);
+MODULE_ALIAS_CRYPTO("rsa");
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index a668d90..de81968 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -15,7 +15,8 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/oid_registry.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
+#include <crypto/pkey.h>
 #include "x509_parser.h"
 #include "x509-asn1.h"
 #include "x509_rsakey-asn1.h"
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index a6c4203..d705945 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -20,8 +20,9 @@
 #include <keys/asymmetric-parser.h>
 #include <keys/system_keyring.h>
 #include <crypto/hash.h>
+#include <crypto/public_key.h>
+#include <crypto/pkey.h>
 #include "asymmetric_keys.h"
-#include "public_key.h"
 #include "x509_parser.h"
 
 static bool use_builtin_keys;
@@ -250,8 +251,6 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	if (cert->pub->pkey_algo >= PKEY_ALGO__LAST ||
 	    cert->sig.pkey_algo >= PKEY_ALGO__LAST ||
 	    cert->sig.pkey_hash_algo >= PKEY_HASH__LAST ||
-	    !pkey_algo[cert->pub->pkey_algo] ||
-	    !pkey_algo[cert->sig.pkey_algo] ||
 	    !hash_algo_name[cert->sig.pkey_hash_algo]) {
 		ret = -ENOPKG;
 		goto error_free_cert;
@@ -270,7 +269,6 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		 pkey_algo_name[cert->sig.pkey_algo],
 		 hash_algo_name[cert->sig.pkey_hash_algo]);
 
-	cert->pub->algo = pkey_algo[cert->pub->pkey_algo];
 	cert->pub->id_type = PKEY_ID_X509;
 
 	/* Check the signature on the key if it appears to be self-signed */
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 54add20..34b6fb8 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -25,7 +25,6 @@ enum pkey_algo {
 };
 
 extern const char *const pkey_algo_name[PKEY_ALGO__LAST];
-extern const struct public_key_algorithm *pkey_algo[PKEY_ALGO__LAST];
 
 /* asymmetric key implementation supports only up to SHA224 */
 #define PKEY_HASH__LAST		(HASH_ALGO_SHA224 + 1)
@@ -45,12 +44,6 @@ extern const char *const pkey_id_type_name[PKEY_ID_TYPE__LAST];
  * part.
  */
 struct public_key {
-	const struct public_key_algorithm *algo;
-	u8	capabilities;
-#define PKEY_CAN_ENCRYPT	0x01
-#define PKEY_CAN_DECRYPT	0x02
-#define PKEY_CAN_SIGN		0x04
-#define PKEY_CAN_VERIFY		0x08
 	enum pkey_algo pkey_algo : 8;
 	enum pkey_id_type id_type : 8;
 	union {
@@ -95,6 +88,7 @@ struct public_key_signature {
 	};
 };
 
+extern struct asymmetric_key_subtype public_key_subtype;
 struct key;
 extern int verify_signature(const struct key *key,
 			    const struct public_key_signature *sig);
@@ -104,4 +98,7 @@ extern struct key *x509_request_asymmetric_key(struct key *keyring,
 					       const struct asymmetric_key_id *kid,
 					       bool partial);
 
+int public_key_verify_signature(const struct public_key *pkey,
+				const struct public_key_signature *sig);
+
 #endif /* _LINUX_PUBLIC_KEY_H */
