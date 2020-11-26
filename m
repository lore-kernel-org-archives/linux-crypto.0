Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DCC1C56201
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 02:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E2372075A
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 02:03:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bY1rSPwc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732531AbgKZCDV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Nov 2020 21:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730764AbgKZCDV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Nov 2020 21:03:21 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F69C0613D4;
        Wed, 25 Nov 2020 18:03:20 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id m65so182849qte.11;
        Wed, 25 Nov 2020 18:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=siiY0wMF7vDJL7vIio5b4mkl2ZuGqWi0NQVeaLuYZ0s=;
        b=bY1rSPwcO7W98QYapRS5ErsbeHjk82zMx36oqb4TGVX8wLVMMQMu1Rb7Pj6e8q+N/3
         5/Uq+m4EQz5oEw1c7KqlfMJeC9k0b+Wtn4GefU7+g9bkryarbWhjMqqhARyzvCekR75O
         S9p9BDer9hssKYAqQpkEUvtF8kcBxJAmNyp2P3hz21jLsQ0NjXYuANL3zUICPnQmFklQ
         posP5yUXl3GSHukoytfEzQbdGcnfez9XyaRkskMuZotDpNePEbKUDl9b7g3+Wvx8IPFy
         ahwUWly+vxc+lFkFVXY2wSkmSaTeqPpbQFCprB3OdePHQPhOY+FX9GTVBcWllYK/dTw1
         pjyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=siiY0wMF7vDJL7vIio5b4mkl2ZuGqWi0NQVeaLuYZ0s=;
        b=nxxeN68G97lb9WZ5+DXRf6zBmroJ/gqA5DkTAe4WuANovSyxZGoJtIH1RLgdCGalhm
         +8QehDzBADgFgrYnzHQcNddkz38eNHmYw2YKJO/8VNbdZBJfsdTkAwDDmVvWFT+8rx+y
         a6478BJCxQ9SJKg5JBFoDPc2vpaFvV5do4qF12zHFdY+aiFje3gFbpa7os+lRbfy+Aeg
         t2gYw1wetkbKSryTmgN4VOontix7ZKcgErngmpFnbyEK2JppiAyH1/+sN7UslYEY1KwC
         yBlW99zhlVAaibiRo82yRE17gEhCzLzRrr9A1O+bQEIP0KhZj7bvWHxDTK/LEYvOQaBb
         a/NQ==
X-Gm-Message-State: AOAM531/FCHc1S4LEutPrKCo2s4rM3RwVIZTwmBArRXK4CLgI8qJKz70
        qQ+/z209ZsGbOrlQtOqATGwGsVO71lh7nPK7
X-Google-Smtp-Source: ABdhPJxQQj34TvKLNyuBVlhmIbXeFJdLQUR8L3DKT5/2GfXFi3vScahpNSRSELTn3Y8kyZ1HakpXYQ==
X-Received: by 2002:ac8:4614:: with SMTP id p20mr980526qtn.346.1606356197984;
        Wed, 25 Nov 2020 18:03:17 -0800 (PST)
Received: from localhost ([189.61.65.151])
        by smtp.gmail.com with ESMTPSA id c128sm1158055qkg.66.2020.11.25.18.03.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 25 Nov 2020 18:03:17 -0800 (PST)
From:   Saulo Alessandre <saulo.alessandre@gmail.com>
To:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saulo Alessandre <saulo.alessandre@tse.jus.br>
Subject: [PATCH] implements ecdsa 256, 384 and 521 alghorithm in akcipher model; change pcks7 and x509 to load certificates with ecdsa; increment testmgr to test ecdsa algo and finally allows signature and verification of modules with ecdsa algorithm
Date:   Wed, 25 Nov 2020 23:03:08 -0300
Message-Id: <20201126020308.25982-1-saulo.alessandre@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Saulo Alessandre <saulo.alessandre@tse.jus.br>

Signed-off-by: Saulo Alessandre <saulo.alessandre@tse.jus.br>
---
 Documentation/admin-guide/module-signing.rst |  10 +
 crypto/Kconfig                               |  12 +
 crypto/Makefile                              |   7 +
 crypto/asymmetric_keys/pkcs7_parser.c        |   7 +-
 crypto/asymmetric_keys/pkcs7_verify.c        |   5 +-
 crypto/asymmetric_keys/public_key.c          |  30 +-
 crypto/asymmetric_keys/x509_cert_parser.c    |  30 +-
 crypto/ecc.c                                 | 228 ++++++++-
 crypto/ecc.h                                 |  62 ++-
 crypto/ecc_curve_defs.h                      |  82 +++
 crypto/ecdsa.c                               | 508 +++++++++++++++++++
 crypto/ecdsa_params.asn1                     |   1 +
 crypto/ecdsa_signature.asn1                  |   6 +
 crypto/testmgr.c                             |  17 +-
 crypto/testmgr.h                             |  78 +++
 include/crypto/ecdh.h                        |   2 +
 include/linux/oid_registry.h                 |  12 +
 lib/oid_registry.c                           | 108 +++-
 18 files changed, 1146 insertions(+), 59 deletions(-)
 create mode 100644 crypto/ecdsa.c
 create mode 100644 crypto/ecdsa_params.asn1
 create mode 100644 crypto/ecdsa_signature.asn1

diff --git a/Documentation/admin-guide/module-signing.rst b/Documentation/admin-guide/module-signing.rst
index f8b584179..eeefc1cad 100644
--- a/Documentation/admin-guide/module-signing.rst
+++ b/Documentation/admin-guide/module-signing.rst
@@ -174,6 +174,16 @@ The full pathname for the resulting kernel_key.pem file can then be specified
 in the ``CONFIG_MODULE_SIG_KEY`` option, and the certificate and key therein will
 be used instead of an autogenerated keypair.
 
+It is also possible use the key private/public files using the ecdsa
+alghorithm that is more fast than rsa. For this, configure ``CONFIG_CRYPTO_ECDSA``
+and for generate key and certificate use the openssl commands.
+
+	openssl ecparam -gnenkey <prime256v1|secp384r1|secp521r1> \
+    	-name -noout -out kernel_key.pem
+	openssl req -new -key kernel_key.pem -x509 -nodes -days 36500 -out kernel_key.x509
+
+To sign with ecdsa use the same way or manually using scripts/sign-file.
+
 
 =========================
 Public keys in the kernel
diff --git a/crypto/Kconfig b/crypto/Kconfig
index b2cc0ad37..cbb1a4198 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -233,12 +233,24 @@ config CRYPTO_RSA
 	help
 	  Generic implementation of the RSA public key algorithm.
 
+config CRYPTO_ECDSA
+    tristate "ECDSA algorithm"
+    select CRYPTO_AKCIPHER
+    select CRYPTO_MANAGER
+    select MPILIB
+    select ASN1
+    help
+      Generic implementation of the ECDSA eliptical curve public key algorithm.
+
 config CRYPTO_DH
 	tristate "Diffie-Hellman algorithm"
 	select CRYPTO_KPP
 	select MPILIB
 	help
 	  Generic implementation of the Diffie-Hellman algorithm.
+	  FIPS 186-3, Digital Signature Standard using Mathematical routines for
+	  the NIST prime elliptic curves April 05, 2010. Compatible with openssl
+	  command line tools.
 
 config CRYPTO_ECC
 	tristate
diff --git a/crypto/Makefile b/crypto/Makefile
index aa740c849..5965b417c 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -171,6 +171,13 @@ ecdh_generic-y += ecdh.o
 ecdh_generic-y += ecdh_helper.o
 obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
 
+$(obj)/ecdsa_signature.asn1.o: $(obj)/ecdsa_signature.asn1.c $(obj)/ecdsa_signature.asn1.h
+$(obj)/ecdsa_params.asn1.o: $(obj)/ecdsa_params.asn1.c $(obj)/ecdsa_params.asn1.h
+clean-files += ecdsa_signature.asn1.c ecdsa_signature.asn1.h
+clean-files += ecdsa_params.asn1.c ecdsa_params.asn1.h
+ecdsa_generic-y := ecdsa_signature.asn1.o ecdsa_params.asn1.o ecdsa.o
+obj-$(CONFIG_CRYPTO_ECDSA) += ecdsa_generic.o
+
 $(obj)/ecrdsa_params.asn1.o: $(obj)/ecrdsa_params.asn1.c $(obj)/ecrdsa_params.asn1.h
 $(obj)/ecrdsa_pub_key.asn1.o: $(obj)/ecrdsa_pub_key.asn1.c $(obj)/ecrdsa_pub_key.asn1.h
 $(obj)/ecrdsa.o: $(obj)/ecrdsa_params.asn1.h $(obj)/ecrdsa_pub_key.asn1.h
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 967329e0a..501af4937 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -267,12 +267,17 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t hdrlen,
 	switch (ctx->last_oid) {
 	case OID_rsaEncryption:
 		ctx->sinfo->sig->pkey_algo = "rsa";
-		ctx->sinfo->sig->encoding = "pkcs1";
+		break;
+	case OID_id_ecdsa_with_sha256:
+	case OID_id_ecdsa_with_sha384:
+	case OID_id_ecdsa_with_sha512:
+		ctx->sinfo->sig->pkey_algo = "ecdsa";
 		break;
 	default:
 		printk("Unsupported pkey algo: %u\n", ctx->last_oid);
 		return -ENOPKG;
 	}
+	ctx->sinfo->sig->encoding = "pkcs1";
 	return 0;
 }
 
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index ce49820ca..a963aa9ec 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -41,8 +41,11 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 	 * big the hash operational data will be.
 	 */
 	tfm = crypto_alloc_shash(sinfo->sig->hash_algo, 0, 0);
-	if (IS_ERR(tfm))
+	if (IS_ERR(tfm)) {
+		pr_warn("%s unsupported hash_algo[%s]", __func__,
+				sinfo->sig->hash_algo);
 		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
+	}
 
 	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
 	sig->digest_size = crypto_shash_digestsize(tfm);
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index e5fae4e83..106938fff 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -67,19 +67,29 @@ int software_key_determine_akcipher(const char *encoding,
 {
 	int n;
 
-	if (strcmp(encoding, "pkcs1") == 0) {
-		/* The data wangled by the RSA algorithm is typically padded
-		 * and encoded in some manner, such as EMSA-PKCS1-1_5 [RFC3447
-		 * sec 8.2].
-		 */
-		if (!hash_algo)
+	if (encoding && strcmp(encoding, "pkcs1") == 0) {
+		if (pkey->pkey_algo && strcmp(pkey->pkey_algo, "rsa") == 0) {
+			/* The data wangled by the RSA algorithm is typically padded
+			 * and encoded in some manner, such as EMSA-PKCS1-1_5 [RFC3447
+			 * sec 8.2].
+			 */
+			if (!hash_algo)
+				n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
+						"pkcs1pad(%s)",
+						pkey->pkey_algo);
+			else
+				n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
+						"pkcs1pad(%s,%s)",
+						pkey->pkey_algo, hash_algo);
+		} else if (pkey->pkey_algo &&
+					strcmp(pkey->pkey_algo, "ecdsa") == 0) {
 			n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
-				     "pkcs1pad(%s)",
-				     pkey->pkey_algo);
+					"%s(%s)", pkey->pkey_algo, hash_algo);
+		}
 		else
 			n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
-				     "pkcs1pad(%s,%s)",
-				     pkey->pkey_algo, hash_algo);
+					"pkcs1pad(%s,%s)",
+					pkey->pkey_algo, hash_algo);
 		return n >= CRYPTO_MAX_ALG_NAME ? -EINVAL : 0;
 	}
 
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 26ec20ef4..3912171f7 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -197,6 +197,7 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 
 	pr_debug("PubKey Algo: %u\n", ctx->last_oid);
 
+	ctx->key_algo = ctx->last_oid;
 	switch (ctx->last_oid) {
 	case OID_md2WithRSAEncryption:
 	case OID_md3WithRSAEncryption:
@@ -204,27 +205,15 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 		return -ENOPKG; /* Unsupported combination */
 
 	case OID_md4WithRSAEncryption:
-		ctx->cert->sig->hash_algo = "md4";
-		goto rsa_pkcs1;
-
 	case OID_sha1WithRSAEncryption:
-		ctx->cert->sig->hash_algo = "sha1";
-		goto rsa_pkcs1;
-
 	case OID_sha256WithRSAEncryption:
-		ctx->cert->sig->hash_algo = "sha256";
-		goto rsa_pkcs1;
-
 	case OID_sha384WithRSAEncryption:
-		ctx->cert->sig->hash_algo = "sha384";
-		goto rsa_pkcs1;
-
 	case OID_sha512WithRSAEncryption:
-		ctx->cert->sig->hash_algo = "sha512";
-		goto rsa_pkcs1;
-
 	case OID_sha224WithRSAEncryption:
-		ctx->cert->sig->hash_algo = "sha224";
+	case OID_id_ecdsa_with_sha1:
+	case OID_id_ecdsa_with_sha256:
+	case OID_id_ecdsa_with_sha384:
+	case OID_id_ecdsa_with_sha512:
 		goto rsa_pkcs1;
 
 	case OID_gost2012Signature256:
@@ -237,9 +226,13 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 	}
 
 rsa_pkcs1:
-	ctx->cert->sig->pkey_algo = "rsa";
+	lookup_oid_sign_info(ctx->key_algo, &ctx->cert->sig->pkey_algo);
+	lookup_oid_digest_info(ctx->key_algo, &ctx->cert->sig->hash_algo,
+							NULL, NULL);
 	ctx->cert->sig->encoding = "pkcs1";
 	ctx->algo_oid = ctx->last_oid;
+	pr_info("Found %s(%s) X509 certificate\n", ctx->cert->sig->pkey_algo,
+		ctx->cert->sig->hash_algo);
 	return 0;
 ecrdsa:
 	ctx->cert->sig->pkey_algo = "ecrdsa";
@@ -266,6 +259,7 @@ int x509_note_signature(void *context, size_t hdrlen,
 	}
 
 	if (strcmp(ctx->cert->sig->pkey_algo, "rsa") == 0 ||
+	    strcmp(ctx->cert->sig->pkey_algo, "ecdsa") == 0 ||
 	    strcmp(ctx->cert->sig->pkey_algo, "ecrdsa") == 0) {
 		/* Discard the BIT STRING metadata */
 		if (vlen < 1 || *(const u8 *)value != 0)
@@ -453,6 +447,8 @@ int x509_extract_key_data(void *context, size_t hdrlen,
 	ctx->key_algo = ctx->last_oid;
 	if (ctx->last_oid == OID_rsaEncryption)
 		ctx->cert->pub->pkey_algo = "rsa";
+	else if (ctx->last_oid == OID_id_ecPublicKey)
+		ctx->cert->pub->pkey_algo = "ecdsa";
 	else if (ctx->last_oid == OID_gost2012PKey256 ||
 		 ctx->last_oid == OID_gost2012PKey512)
 		ctx->cert->pub->pkey_algo = "ecrdsa";
diff --git a/crypto/ecc.c b/crypto/ecc.c
index 8ee787723..290db857b 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -45,11 +45,15 @@ typedef struct {
 static inline const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
 {
 	switch (curve_id) {
-	/* In FIPS mode only allow P256 and higher */
+		/* In FIPS mode only allow P256 and higher */
 	case ECC_CURVE_NIST_P192:
 		return fips_enabled ? NULL : &nist_p192;
 	case ECC_CURVE_NIST_P256:
 		return &nist_p256;
+	case ECC_CURVE_NIST_P384:
+		return &nist_p384;
+	case ECC_CURVE_NIST_P521:
+		return &nist_p521;
 	default:
 		return NULL;
 	}
@@ -235,6 +239,24 @@ static u64 vli_lshift(u64 *result, const u64 *in, unsigned int shift,
 	return carry;
 }
 
+static u64 vli_rshift(u64 *result, const u64 *in, unsigned int shift,
+		      unsigned int ndigits)
+{
+	u64 carry = 0;
+	int i;
+
+	for (i = 0; i < ndigits; i++) {
+		if (i + 1 < ndigits)
+			carry = in[i + 1] << (64 - shift);
+		else
+			carry = 0;
+
+		result[i] = (in[i] >> shift) | carry;
+	}
+
+	return carry;
+}
+
 /* Computes vli = vli >> 1. */
 static void vli_rshift1(u64 *vli, unsigned int ndigits)
 {
@@ -339,7 +361,7 @@ static uint128_t mul_64_64(u64 left, u64 right)
 #if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
 	unsigned __int128 m = (unsigned __int128)left * right;
 
-	result.m_low  = m;
+	result.m_low = m;
 	result.m_high = m >> 64;
 #else
 	u64 a0 = left & 0xffffffffull;
@@ -474,7 +496,7 @@ static void vli_square(u64 *result, const u64 *left, unsigned int ndigits)
 /* Computes result = (left + right) % mod.
  * Assumes that left < mod and right < mod, result != mod.
  */
-static void vli_mod_add(u64 *result, const u64 *left, const u64 *right,
+void vli_mod_add(u64 *result, const u64 *left, const u64 *right,
 			const u64 *mod, unsigned int ndigits)
 {
 	u64 carry;
@@ -487,6 +509,7 @@ static void vli_mod_add(u64 *result, const u64 *left, const u64 *right,
 	if (carry || vli_cmp(result, mod, ndigits) >= 0)
 		vli_sub(result, result, mod, ndigits);
 }
+EXPORT_SYMBOL(vli_mod_add);
 
 /* Computes result = (left - right) % mod.
  * Assumes that left < mod and right < mod, result != mod.
@@ -775,6 +798,146 @@ static void vli_mmod_fast_256(u64 *result, const u64 *product,
 	}
 }
 
+#define E64LL(x32, y32) (((u64)x32 << 32) | y32)
+#define SHL32(x64)   (x64 << 32)
+#define SHR32(x64)   (x64 >> 32)
+#define AND64H(x64)  (x64 & 0xffFFffFF00000000ull)
+#define AND64L(x64)  (x64 & 0x00000000ffFFffFFull)
+
+/* Computes result = product % curve_prime
+ * from "Mathematical routines for the NIST prime elliptic curves"
+ */
+static void vli_mmod_fast_384(u64 *result, const u64 *product,
+			      const u64 *curve_prime, u64 *tmp)
+{
+	int carry;
+	const unsigned int ndigits = 6;
+
+	/* t */
+	vli_set(result, product, ndigits);
+
+	/* s1 */
+	tmp[0] = 0;		// 0 || 0
+	tmp[1] = 0;		// 0 || 0
+	tmp[2] = E64LL(product[11], SHR32(product[10]));	//a22||a21
+	tmp[3] = SHR32(product[11]);	// 0 ||a23
+	tmp[4] = 0;		// 0 || 0
+	tmp[5] = 0;		// 0 || 0
+	carry = vli_lshift(tmp, tmp, 1, ndigits);
+	carry += vli_add(result, result, tmp, ndigits);
+
+	/* s2 */
+	tmp[0] = product[6];	//a13||a12
+	tmp[1] = product[7];	//a15||a14
+	tmp[2] = product[8];	//a17||a16
+	tmp[3] = product[9];	//a19||a18
+	tmp[4] = product[10];	//a21||a20
+	tmp[5] = product[11];	//a23||a22
+	carry += vli_add(result, result, tmp, ndigits);
+
+	/* s3 */
+	tmp[0] = E64LL(product[11], SHR32(product[10]));	//a22||a21
+	tmp[1] = E64LL(product[6], SHR32(product[11]));	//a12||a23
+	tmp[2] = E64LL(product[7], SHR32(product[6]));	//a14||a13
+	tmp[3] = E64LL(product[8], SHR32(product[7]));	//a16||a15
+	tmp[4] = E64LL(product[9], SHR32(product[8]));	//a18||a17
+	tmp[5] = E64LL(product[10], SHR32(product[9]));	//a20||a19
+	carry += vli_add(result, result, tmp, ndigits);
+
+	/* s4 */
+	tmp[0] = AND64H(product[11]);	//a23|| 0
+	tmp[1] = SHL32(product[10]);	//a20|| 0
+	tmp[2] = product[6];	//a13||a12
+	tmp[3] = product[7];	//a15||a14
+	tmp[4] = product[8];	//a17||a16
+	tmp[5] = product[9];	//a19||a18
+	carry += vli_add(result, result, tmp, ndigits);
+
+	/* s5 */
+	tmp[0] = 0;		//  0|| 0
+	tmp[1] = 0;		//  0|| 0
+	tmp[2] = product[10];	//a21||a20
+	tmp[3] = product[11];	//a23||a22
+	tmp[4] = 0;		//  0|| 0
+	tmp[5] = 0;		//  0|| 0
+	carry += vli_add(result, result, tmp, ndigits);
+
+	/* s6 */
+	tmp[0] = AND64L(product[10]);	// 0 ||a20
+	tmp[1] = AND64H(product[10]);	//a21|| 0
+	tmp[2] = product[11];	//a23||a22
+	tmp[3] = 0;		// 0 || 0
+	tmp[4] = 0;		// 0 || 0
+	tmp[5] = 0;		// 0 || 0
+	carry += vli_add(result, result, tmp, ndigits);
+
+	/* d1 */
+	tmp[0] = E64LL(product[6], SHR32(product[11]));	//a12||a23
+	tmp[1] = E64LL(product[7], SHR32(product[6]));	//a14||a13
+	tmp[2] = E64LL(product[8], SHR32(product[7]));	//a16||a15
+	tmp[3] = E64LL(product[9], SHR32(product[8]));	//a18||a17
+	tmp[4] = E64LL(product[10], SHR32(product[9]));	//a20||a19
+	tmp[5] = E64LL(product[11], SHR32(product[10]));	//a22||a21
+	carry -= vli_sub(result, result, tmp, ndigits);
+
+	/* d2 */
+	tmp[0] = SHL32(product[10]);	//a20|| 0
+	tmp[1] = E64LL(product[11], SHR32(product[10]));	//a22||a21
+	tmp[2] = SHR32(product[11]);	// 0 ||a23
+	tmp[3] = 0;		// 0 || 0
+	tmp[4] = 0;		// 0 || 0
+	tmp[5] = 0;		// 0 || 0
+	carry -= vli_sub(result, result, tmp, ndigits);
+
+	/* d3 */
+	tmp[0] = 0;		// 0 || 0
+	tmp[1] = AND64H(product[11]);	//a23|| 0
+	tmp[2] = SHR32(product[11]);	// 0 ||a23
+	tmp[3] = 0;		// 0 || 0
+	tmp[4] = 0;		// 0 || 0
+	tmp[5] = 0;		// 0 || 0
+	carry -= vli_sub(result, result, tmp, ndigits);
+
+	if (carry < 0) {
+		do {
+			carry += vli_add(result, result, curve_prime, ndigits);
+		} while (carry < 0);
+	} else {
+		while (carry || vli_cmp(curve_prime, result, ndigits) != 1)
+			carry -= vli_sub(result, result, curve_prime, ndigits);
+	}
+
+}
+
+#undef E64LL
+#undef SHL32
+#undef SHR32
+#undef AND64H
+#undef AND64L
+
+/* Computes result = product % curve_prime
+ * from "Mathematical routines for the NIST prime elliptic curves"
+ */
+static void vli_mmod_fast_521(u64 *result, const u64 *product,
+			      const u64 *curve_prime, u64 *tmp)
+{
+	int carry;
+	const unsigned int ndigits = 9;
+
+	/* t 512 bits + 9 bits a0 .. a520 */
+	vli_set(result, product, 9);
+	result[8] &= 0x000001ff;
+
+	/* t 512 bits + 9 bits a521 .. a1041 */
+	vli_set(tmp, product + 8, ndigits);
+	vli_rshift(tmp, tmp, 9, ndigits);
+
+	carry = vli_add(result, result, tmp, ndigits);
+
+	while (carry || vli_cmp(curve_prime, result, ndigits) != 1)
+		carry -= vli_sub(result, result, curve_prime, ndigits);
+}
+
 /* Computes result = product % curve_prime for different curve_primes.
  *
  * Note that curve_primes are distinguished just by heuristic check and
@@ -785,23 +948,6 @@ static bool vli_mmod_fast(u64 *result, u64 *product,
 {
 	u64 tmp[2 * ECC_MAX_DIGITS];
 
-	/* Currently, both NIST primes have -1 in lowest qword. */
-	if (curve_prime[0] != -1ull) {
-		/* Try to handle Pseudo-Marsenne primes. */
-		if (curve_prime[ndigits - 1] == -1ull) {
-			vli_mmod_special(result, product, curve_prime,
-					 ndigits);
-			return true;
-		} else if (curve_prime[ndigits - 1] == 1ull << 63 &&
-			   curve_prime[ndigits - 2] == 0) {
-			vli_mmod_special2(result, product, curve_prime,
-					  ndigits);
-			return true;
-		}
-		vli_mmod_barrett(result, product, curve_prime, ndigits);
-		return true;
-	}
-
 	switch (ndigits) {
 	case 3:
 		vli_mmod_fast_192(result, product, curve_prime, tmp);
@@ -809,7 +955,29 @@ static bool vli_mmod_fast(u64 *result, u64 *product,
 	case 4:
 		vli_mmod_fast_256(result, product, curve_prime, tmp);
 		break;
+	case 6:
+		vli_mmod_fast_384(result, product, curve_prime, tmp);
+		break;
+	case 9:
+		vli_mmod_fast_521(result, product, curve_prime, tmp);
+		break;
 	default:
+		/* Currently, both NIST primes have -1 in lowest qword. */
+		if (curve_prime[0] != -1ull) {
+			/* Try to handle Pseudo-Marsenne primes. */
+			if (curve_prime[ndigits - 1] == -1ull) {
+				vli_mmod_special(result, product, curve_prime,
+						 ndigits);
+				return true;
+			} else if (curve_prime[ndigits - 1] == 1ull << 63 &&
+				   curve_prime[ndigits - 2] == 0) {
+				vli_mmod_special2(result, product, curve_prime,
+						  ndigits);
+				return true;
+			}
+			vli_mmod_barrett(result, product, curve_prime, ndigits);
+			return true;
+		}
 		pr_err_ratelimited("ecc: unsupported digits size!\n");
 		return false;
 	}
@@ -830,8 +998,19 @@ void vli_mod_mult_slow(u64 *result, const u64 *left, const u64 *right,
 }
 EXPORT_SYMBOL(vli_mod_mult_slow);
 
+/* Computes result = input % curve_prime. */
+void vli_mod_slow(u64 *result, const u64 *input,
+		  const u64 *mod, unsigned int ndigits)
+{
+	u64 product[ECC_MAX_DIGITS * 2] = { 0 };
+
+	vli_set(&product[0], input, ndigits);
+	vli_mmod_slow(result, product, mod, ndigits);
+}
+EXPORT_SYMBOL(vli_mod_slow);
+
 /* Computes result = (left * right) % curve_prime. */
-static void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
+void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
 			      const u64 *curve_prime, unsigned int ndigits)
 {
 	u64 product[2 * ECC_MAX_DIGITS];
@@ -839,9 +1018,10 @@ static void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
 	vli_mult(product, left, right, ndigits);
 	vli_mmod_fast(result, product, curve_prime, ndigits);
 }
+EXPORT_SYMBOL(vli_mod_mult_fast);
 
 /* Computes result = left^2 % curve_prime. */
-static void vli_mod_square_fast(u64 *result, const u64 *left,
+void vli_mod_square_fast(u64 *result, const u64 *left,
 				const u64 *curve_prime, unsigned int ndigits)
 {
 	u64 product[2 * ECC_MAX_DIGITS];
@@ -849,6 +1029,7 @@ static void vli_mod_square_fast(u64 *result, const u64 *left,
 	vli_square(product, left, ndigits);
 	vli_mmod_fast(result, product, curve_prime, ndigits);
 }
+EXPORT_SYMBOL(vli_mod_square_fast);
 
 #define EVEN(vli) (!(vli[0] & 1))
 /* Computes result = (1 / p_input) % mod. All VLIs are the same size.
@@ -933,11 +1114,12 @@ EXPORT_SYMBOL(vli_mod_inv);
 /* ------ Point operations ------ */
 
 /* Returns true if p_point is the point at infinity, false otherwise. */
-static bool ecc_point_is_zero(const struct ecc_point *point)
+bool ecc_point_is_zero(const struct ecc_point *point)
 {
 	return (vli_is_zero(point->x, point->ndigits) &&
 		vli_is_zero(point->y, point->ndigits));
 }
+EXPORT_SYMBOL(ecc_point_is_zero);
 
 /* Point multiplication algorithm using Montgomery's ladder with co-Z
  * coordinates. From http://eprint.iacr.org/2011/338.pdf
diff --git a/crypto/ecc.h b/crypto/ecc.h
index ab0eb70b9..0d2965cbe 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -29,9 +29,11 @@
 /* One digit is u64 qword. */
 #define ECC_CURVE_NIST_P192_DIGITS  3
 #define ECC_CURVE_NIST_P256_DIGITS  4
-#define ECC_MAX_DIGITS             (512 / 64)
+#define ECC_CURVE_NIST_P384_DIGITS  6
+#define ECC_CURVE_NIST_P521_DIGITS  9
+#define ECC_MAX_DIGITS              (ECC_CURVE_NIST_P521_DIGITS)
 
-#define ECC_DIGITS_TO_BYTES_SHIFT 3
+#define ECC_DIGITS_TO_BYTES_SHIFT   3
 
 /**
  * struct ecc_point - elliptic curve point in affine coordinates
@@ -147,6 +149,9 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
 				struct ecc_point *pk);
 
+/* Returns true if p_point is the point at infinity, false otherwise. */
+bool ecc_point_is_zero(const struct ecc_point *point);
+
 /**
  * vli_is_zero() - Determine is vli is zero
  *
@@ -211,6 +216,22 @@ void vli_from_le64(u64 *dest, const void *src, unsigned int ndigits);
 void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
 		 unsigned int ndigits);
 
+/**
+ * vli_mod_slow() - Computes result = product % mod, where product is 2N words
+ * long.
+ * Reference: Ken MacKay's micro-ecc.
+ * Currently only designed to work for curve_p or curve_n.
+ *
+ * @result:		where to write result value
+ * @product:	vli number to operate mod on
+ * @mod:		modulus
+ * @ndigits:		length of all vlis
+ *
+ * Note: Assumes that mod is big enough curve order.
+ */
+void vli_mod_slow(u64 *result, const u64 *input, const u64 *mod,
+				unsigned int ndigits);
+
 /**
  * vli_mod_mult_slow() - Modular multiplication
  *
@@ -225,6 +246,43 @@ void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
 void vli_mod_mult_slow(u64 *result, const u64 *left, const u64 *right,
 		       const u64 *mod, unsigned int ndigits);
 
+/* Computes result = (left + right) % mod.
+ * Assumes that left < mod and right < mod, result != mod.
+ */
+void vli_mod_add(u64 *result, const u64 *left, const u64 *right,
+			const u64 *mod, unsigned int ndigits);
+
+/**
+ * vli_mod_fast() - Computes result = product % curve_prime for different
+ * curve_primes.
+ *
+ * Note that curve_primes are distinguished just by heuristic check and
+ * not by complete conformance check.
+ *
+ * @result:		where to write result value
+ * @input:		vli number to multiply with @right
+ * @mod:		mod
+ * @ndigits:		length of all vlis
+ *
+ * Note: Assumes that mod is big enough curve order.
+ */
+void vli_mod_fast(u64 *result, const u64 *input, const u64 *mod,
+				unsigned int ndigits);
+
+/**
+ * vli_mod_mult_fast() - Modular multiplication
+ *
+ * @result:		where to write result value
+ * @left:		vli number to multiply with @right
+ * @right:		vli number to multiply with @left
+ * @mod:		modulus
+ * @ndigits:		length of all vlis
+ *
+ * Note: Assumes that mod is big enough curve order.
+ */
+void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
+			      const u64 *curve_prime, unsigned int ndigits);
+
 /**
  * ecc_point_mult_shamir() - Add two points multiplied by scalars
  *
diff --git a/crypto/ecc_curve_defs.h b/crypto/ecc_curve_defs.h
index 69be6c7d2..3d9776102 100644
--- a/crypto/ecc_curve_defs.h
+++ b/crypto/ecc_curve_defs.h
@@ -54,4 +54,86 @@ static struct ecc_curve nist_p256 = {
 	.b = nist_p256_b
 };
 
+/* NIST P-384 */
+static u64 nist_p384_g_x[] = { 0x3A545E3872760AB7ull, 0x5502F25DBF55296Cull,
+				0x59F741E082542A38ull, 0x6E1D3B628BA79B98ull,
+				0x8Eb1C71EF320AD74ull, 0xAA87CA22BE8B0537ull };
+static u64 nist_p384_g_y[] = { 0x7A431D7C90EA0E5Full, 0x0A60B1CE1D7E819Dull,
+				0xE9DA3113B5F0B8C0ull, 0xF8F41DBD289A147Cull,
+				0x5D9E98BF9292DC29ull, 0x3617DE4A96262C6Full };
+static u64 nist_p384_p[] = { 0x00000000FFFFFFFFull, 0xFFFFFFFF00000000ull,
+				0xFFFFFFFFFFFFFFFEull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull };
+static u64 nist_p384_n[] = { 0xECEC196ACCC52973ull, 0x581A0DB248B0A77Aull,
+				0xC7634D81F4372DDFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull };
+static u64 nist_p384_a[] = { 0x00000000FFFFFFFCull, 0xFFFFFFFF00000000ull,
+				0xFFFFFFFFFFFFFFFEull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull };
+static u64 nist_p384_b[] = { 0x2a85c8edd3ec2aefull, 0xc656398d8a2ed19dull,
+				0x0314088f5013875aull, 0x181d9c6efe814112ull,
+				0x988e056be3f82d19ull, 0xb3312fa7e23ee7e4ull };
+static struct ecc_curve nist_p384 = {
+	.name = "nist_384",
+	.g = {
+		.x = nist_p384_g_x,
+		.y = nist_p384_g_y,
+		.ndigits = 6,
+	},
+	.p = nist_p384_p,
+	.n = nist_p384_n,
+	.a = nist_p384_a,
+	.b = nist_p384_b
+};
+
+/* NIST P-521 */
+static u64 nist_p521_g_x[] = { 0xF97E7E31C2E5BD66ull, 0x3348B3C1856A429Bull,
+				0xFE1DC127A2FFA8DEull, 0xA14B5E77EFE75928ull,
+				0xF828AF606B4D3DBAull, 0x9C648139053FB521ull,
+				0x9E3ECB662395B442ull, 0x858E06B70404E9CDull,
+				0x00000000000000C6ull };
+static u64 nist_p521_g_y[] = { 0x88BE94769FD16650ull, 0x353C7086A272C240ull,
+				0xC550B9013FAD0761ull, 0x97EE72995EF42640ull,
+				0x17AFBD17273E662Cull, 0x98F54449579B4468ull,
+				0x5C8A5FB42C7D1BD9ull, 0x39296A789A3BC004ull,
+				0x0000000000000118ull };
+static u64 nist_p521_p[] = { 0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0x00000000000001FFull };
+static u64 nist_p521_n[] = { 0xBB6FB71E91386409ull, 0x3BB5C9B8899C47AEull,
+				0x7FCC0148F709A5D0ull, 0x51868783BF2F966Bull,
+				0xFFFFFFFFFFFFFFFAull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0x00000000000001FFull };
+static u64 nist_p521_a[] = { 0xFFFFFFFFFFFFFFFCull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0x00000000000001FFull };
+static u64 nist_p521_b[] = { 0xEF451FD46B503F00ull, 0x3573DF883D2C34F1ull,
+				0x1652C0BD3BB1BF07ull, 0x56193951EC7E937Bull,
+				0xB8B489918EF109E1ull, 0xA2DA725B99B315F3ull,
+				0x929A21A0B68540EEull, 0x953EB9618E1C9A1Full,
+				0x0000000000000051ull };
+
+static struct ecc_curve nist_p521 = {
+	.name = "nist_521",
+	.g = {
+		.x = nist_p521_g_x,
+		.y = nist_p521_g_y,
+		.ndigits = 9,
+	},
+	.p = nist_p521_p,
+	.n = nist_p521_n,
+	.a = nist_p521_a,
+	.b = nist_p521_b
+};
+
+#define NIST_UNPACKED_KEY_ID 0x04
+#define NISTP256_PACKED_KEY_SIZE 64
+#define NISTP384_PACKED_KEY_SIZE 96
+#define NISTP521_PACKED_KEY_SIZE 132
+
 #endif
diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
new file mode 100644
index 000000000..202ab9e41
--- /dev/null
+++ b/crypto/ecdsa.c
@@ -0,0 +1,508 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Elliptic Curve Digital Signature Algorithm for Cryptographic API
+ *
+ * Copyright (c) 2019 Saulo Alessandre <saulo.alessandre@gmail.com>
+ *
+ * References:
+ * Mathematical routines for the NIST prime elliptic curves April 05, 2010
+ * Technical Guideline TR-03111 - Elliptic Curve Cryptography
+ * FIPS 186-3, Digital Signature Standard
+ *
+ * this code is strongly embased on the ecrdsa code, written by
+ *  Vitaly Chikunov <vt@altlinux.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <crypto/internal/akcipher.h>
+#include <crypto/akcipher.h>
+#include <linux/oid_registry.h>
+#include <asm/unaligned.h>
+#include "crypto/public_key.h"
+#include "ecc.h"
+#include "ecc_curve_defs.h"
+#include "ecdsa_signature.asn1.h"
+#include "ecdsa_params.asn1.h"
+
+#define MAX_DIGEST_SIZE		64
+
+#define ECDSA_MAX_BITS     521
+#define ECDSA_MAX_SIG_SIZE 140
+#define ECDSA_MAX_DIGITS   9
+
+struct ecdsa_ctx {
+	enum OID algo_oid;	/* overall public key oid */
+	enum OID curve_oid;	/* parameter */
+	enum OID digest_oid;	/* parameter */
+	const struct ecc_curve *curve;	/* curve from oid */
+	unsigned int digest_len;	/* parameter (bytes) */
+	const char *digest;	/* digest name from oid */
+	unsigned int key_len;	/* @key length (bytes) */
+	const char *key;	/* raw public key */
+	struct ecc_point pub_key;
+	u64 _pubp[2][ECDSA_MAX_DIGITS];	/* point storage for @pub_key */
+};
+
+struct ecdsa_sig_ctx {
+	u64 r[ECDSA_MAX_DIGITS];
+	u64 s[ECDSA_MAX_DIGITS];
+	int sig_size;
+	u8 ndigits;
+};
+
+static int check_digest_len(int len)
+{
+	switch (len) {
+	case 32:
+	case 48:
+	case 64:
+		return 0;
+	default:
+		return -1;
+	}
+}
+
+static inline void ecc_swap_digits(const u64 *in, u64 *out,
+				   unsigned int ndigits)
+{
+	const __be64 *src = (__force __be64 *) in;
+	int i;
+
+	for (i = 0; i < ndigits; i++)
+		out[i] = be64_to_cpu(src[ndigits - 1 - i]);
+}
+
+static int ecdsa_parse_sig_rs(struct ecdsa_sig_ctx *ctx, u64 *rs,
+			      size_t hdrlen, unsigned char tag,
+			      const void *value, size_t vlen)
+{
+	u8 ndigits;
+	// skip byte 0 if exists
+	const void *idx = value;
+
+	if (*(u8 *) idx == 0x0) {
+		idx++;
+		vlen--;
+	}
+	ndigits = vlen / 8;
+	if (ndigits == ctx->ndigits)
+		ecc_swap_digits((const u64 *)idx, rs, ndigits);
+	else {
+		u8 nvalue[ECDSA_MAX_SIG_SIZE];
+		const u8 start = (ctx->ndigits * 8) - vlen;
+
+		memset(nvalue, 0, start);
+		memcpy(nvalue + start, idx, vlen);
+		ecc_swap_digits((const u64 *)nvalue, rs, ctx->ndigits);
+		vlen = ctx->ndigits * 8;
+	}
+	ctx->sig_size += vlen;
+	return 0;
+}
+
+int ecdsa_parse_sig_r(void *context, size_t hdrlen, unsigned char tag,
+		      const void *value, size_t vlen)
+{
+	struct ecdsa_sig_ctx *ctx = context;
+
+	return ecdsa_parse_sig_rs(ctx, ctx->r, hdrlen, tag, value, vlen);
+}
+
+int ecdsa_parse_sig_s(void *context, size_t hdrlen, unsigned char tag,
+		      const void *value, size_t vlen)
+{
+	struct ecdsa_sig_ctx *ctx = context;
+
+	return ecdsa_parse_sig_rs(ctx, ctx->s, hdrlen, tag, value, vlen);
+}
+
+#define ASN_TAG_SIZE	5
+
+static int ecdsa_verify(struct akcipher_request *req, enum OID oid)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct ecdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct ecdsa_sig_ctx ctx_sig;
+	u8 sig[ECDSA_MAX_SIG_SIZE];
+	u8 digest[MAX_DIGEST_SIZE];
+	u16 ndigits = ctx->pub_key.ndigits;
+	u16 min_digits;
+	u64 _r[ECDSA_MAX_DIGITS];	/* ecc_point x */
+	u64 _s[ECDSA_MAX_DIGITS];	/* ecc_point y and temp s^{-1} */
+	u64 e[ECDSA_MAX_DIGITS];	/* h \mod q */
+	u64 v[ECDSA_MAX_DIGITS];	/* s^{-1}e \mod q */
+	u64 u[ECDSA_MAX_DIGITS];	/* s^{-1}r \mod q */
+	struct ecc_point cc = ECC_POINT_INIT(_r, _s, ndigits);	/* reuse r, s */
+	struct scatterlist *sgl_s, *sgl_d;
+	int err;
+	int i;
+
+	if (lookup_oid_digest_info(oid, &ctx->digest, &ctx->digest_len,
+				   &ctx->digest_oid))
+		return -ENOPKG;
+
+	min_digits =
+	    (ndigits < ctx->digest_len / 8) ? ndigits : ctx->digest_len / 8;
+
+	if (!ctx->curve || !ctx->digest || !req->src || !ctx->pub_key.x)
+		return -EBADMSG;
+	if (check_digest_len(req->dst_len)) {
+		pr_err("%s: invalid source digest size %d\n",
+				__func__, req->dst_len);
+		return -EBADMSG;
+	}
+	if (check_digest_len(ctx->digest_len)) {
+		pr_err("%s: invalid context digest size %d\n",
+				__func__, ctx->digest_len);
+		return -EBADMSG;
+	}
+
+	sgl_s = req->src;
+	sgl_d = (((void *)req->src) + sizeof(struct scatterlist));
+
+	if (ctx->pub_key.ndigits != ctx->curve->g.ndigits ||
+	    WARN_ON(sgl_s->length > sizeof(sig)) ||
+	    WARN_ON(sgl_d->length > sizeof(digest))) {
+		pr_err("%s: invalid curve size g(%d) pub(%d)\n",
+				__func__,
+		       ctx->curve->g.ndigits, ctx->pub_key.ndigits);
+		return -EBADMSG;
+	}
+	sg_copy_to_buffer(sgl_s, sg_nents_for_len(sgl_s, sgl_s->length),
+			  sig, sizeof(sig));
+	sg_copy_to_buffer(sgl_d, sg_nents_for_len(sgl_d, sgl_d->length),
+			  digest, sizeof(digest));
+
+	ctx_sig.sig_size = 0;
+	ctx_sig.ndigits = ndigits;
+	err =
+	    asn1_ber_decoder(&ecdsa_signature_decoder, &ctx_sig, sig,
+			     sgl_s->length);
+	if (err < 0)
+		return err;
+
+	/* Step 1: verify that 0 < r < q, 0 < s < q */
+	if (vli_is_zero(ctx_sig.r, ndigits) ||
+	    vli_cmp(ctx_sig.r, ctx->curve->n, ndigits) == 1 ||
+	    vli_is_zero(ctx_sig.s, ndigits) ||
+	    vli_cmp(ctx_sig.s, ctx->curve->n, ndigits) == 1)
+		return -EKEYREJECTED;
+
+	/* need truncate digest */
+	for (i = min_digits; i < ndigits; i++)
+		e[i] = 0;
+	/* Step 2: calculate hash (h) of the message (passed as input) */
+	/* Step 3: calculate e = h \mod q */
+	vli_from_be64(e, digest, min_digits);
+	if (vli_cmp(e, ctx->curve->n, ndigits) == 1)
+		vli_sub(e, e, ctx->curve->n, ndigits);
+	if (vli_is_zero(e, ndigits))
+		e[0] = 1;
+
+	/* Step 4: calculate _s = s^{-1} \mod q */
+	vli_mod_inv(_s, ctx_sig.s, ctx->curve->n, ndigits);
+	/* Step 5: calculate u = s^{-1} * e \mod q */
+	vli_mod_mult_slow(u, _s, e, ctx->curve->n, ndigits);
+	/* Step 6: calculate v = s^{-1} * r \mod q */
+	vli_mod_mult_slow(v, _s, ctx_sig.r, ctx->curve->n, ndigits);
+	/* Step 7: calculate cc = (x0, y0) = uG + vP */
+	ecc_point_mult_shamir(&cc, u, &ctx->curve->g, v, &ctx->pub_key,
+			      ctx->curve);
+	/* v = x0 mod q */
+	vli_mod_slow(v, cc.x, ctx->curve->n, ndigits);
+
+	/* Step 9: if X0 == r signature is valid */
+	if (vli_cmp(v, ctx_sig.r, ndigits) == 0)
+		return 0;
+
+	return -EKEYREJECTED;
+}
+
+static int ecdsa_verify_256(struct akcipher_request *req)
+{
+	return ecdsa_verify(req, OID_id_ecdsa_with_sha256);
+}
+
+static int ecdsa_verify_384(struct akcipher_request *req)
+{
+	return ecdsa_verify(req, OID_id_ecdsa_with_sha384);
+}
+
+static int ecdsa_verify_512(struct akcipher_request *req)
+{
+	return ecdsa_verify(req, OID_id_ecdsa_with_sha512);
+}
+
+static const struct ecc_curve *get_curve_by_oid(enum OID oid)
+{
+	switch (oid) {
+	case OID_id_secp192r1:
+		return &nist_p192;
+	case OID_id_secp256r1:
+		return &nist_p256;
+	case OID_id_secp384r1:
+		return &nist_p384;
+	case OID_id_secp521r1:
+		return &nist_p521;
+	default:
+		return NULL;
+	}
+}
+
+int ecdsa_param_curve(void *context, size_t hdrlen, unsigned char tag,
+		      const void *value, size_t vlen)
+{
+	struct ecdsa_ctx *ctx = context;
+
+	ctx->curve_oid = look_up_OID(value, vlen);
+	if (!ctx->curve_oid)
+		return -EINVAL;
+	ctx->curve = get_curve_by_oid(ctx->curve_oid);
+
+	return 0;
+}
+
+/* Optional. If present should match expected digest algo OID. */
+int ecdsa_param_digest(void *context, size_t hdrlen, unsigned char tag,
+		       const void *value, size_t vlen)
+{
+	struct ecdsa_ctx *ctx = context;
+	int digest_oid = look_up_OID(value, vlen);
+
+	if (digest_oid != ctx->digest_oid)
+		return -EINVAL;
+
+	return 0;
+}
+
+int ecdsa_parse_pub_key(void *context, size_t hdrlen, unsigned char tag,
+			const void *value, size_t vlen)
+{
+	struct ecdsa_ctx *ctx = context;
+
+	ctx->key = value;
+	ctx->key_len = vlen;
+	return 0;
+}
+
+static u8 *pkey_unpack_u32(u32 *dst, void *src)
+{
+	memcpy(dst, src, sizeof(*dst));
+	return src + sizeof(*dst);
+}
+
+static inline void copy4be8(u64 *out, const u8 *in, u32 size)
+{
+	int i;
+	u8 *dst = (u8 *) out;
+
+	*out = 0;
+	for (i = 0; i < size; i++) {
+		*dst = in[size - i - 1];
+		dst++;
+	}
+}
+
+static void convert4be(u64 *out, const u8 *in, u32 size)
+{
+	int i;
+
+	while (*in == 0 && size > 0) {
+		in++;
+		size--;
+	}
+	in = in + size;
+	/* convert from BE */
+	for (i = 0; i < size; i += 8) {
+		const u32 count = size - i;
+		const u32 limit = count >= 8 ? 8 : count;
+		const u8 *part = in - limit;
+
+		if (limit == 8)
+			*out = get_unaligned_be64(part);
+		else
+			copy4be8(out, part, limit);
+		out++;
+		in -= limit;
+	}
+}
+
+/* Parse BER encoded subjectPublicKey. */
+static int ecdsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
+			     unsigned int keylen)
+{
+	struct ecdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	unsigned int ndigits;
+	u32 algo, paramlen;
+	u8 *params;
+	int err;
+	const u8 nist_type = *(u8 *) key;
+	u8 half_pub;
+
+	/* Key parameters is in the key after keylen. */
+	params = (u8 *) key + keylen;
+	params = pkey_unpack_u32(&algo, params);
+	params = pkey_unpack_u32(&paramlen, params);
+
+	ctx->algo_oid = algo;
+
+	/* Parse SubjectPublicKeyInfo.AlgorithmIdentifier.parameters. */
+	err = asn1_ber_decoder(&ecdsa_params_decoder, ctx, params, paramlen);
+	if (err < 0)
+		return err;
+	ctx->key = key;
+	ctx->key_len = keylen;
+	if (!ctx->curve)
+		return -ENOPKG;
+
+	/*
+	 * Accepts only uncompressed it's not accepted
+	 */
+	if (nist_type != NIST_UNPACKED_KEY_ID)
+		return -ENOPKG;
+	/* Skip nist type octet */
+	ctx->key++;
+	ctx->key_len--;
+	if (ctx->key_len != NISTP256_PACKED_KEY_SIZE
+	    && ctx->key_len != NISTP384_PACKED_KEY_SIZE
+	    && ctx->key_len != NISTP521_PACKED_KEY_SIZE)
+		return -ENOPKG;
+	ndigits = ctx->key_len / sizeof(u64) / 2;
+	if (ndigits * 2 * sizeof(u64) < ctx->key_len)
+		ndigits++;
+	half_pub = ctx->key_len / 2;
+	/*
+	 * Sizes of key_len and curve should match each other.
+	 */
+	if (ctx->curve->g.ndigits != ndigits)
+		return -ENOPKG;
+	ctx->pub_key = ECC_POINT_INIT(ctx->_pubp[0], ctx->_pubp[1], ndigits);
+	/*
+	 * X509 stores key.x and key.y as BE
+	 */
+	if (ndigits != 9) {
+		vli_from_be64(ctx->pub_key.x, ctx->key, ndigits);
+		vli_from_be64(ctx->pub_key.y, ctx->key + half_pub, ndigits);
+	} else {
+		convert4be(ctx->pub_key.x, ctx->key, half_pub);
+		convert4be(ctx->pub_key.y, ctx->key + half_pub, half_pub);
+	}
+	err = ecc_is_pubkey_valid_partial(ctx->curve, &ctx->pub_key);
+	if (err)
+		return -EKEYREJECTED;
+
+	return 0;
+}
+
+static unsigned int ecdsa_max_size(struct crypto_akcipher *tfm)
+{
+	struct ecdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+
+	/*
+	 * Verify doesn't need any output, so it's just informational
+	 * for keyctl to determine the key bit size.
+	 */
+	return ctx->pub_key.ndigits * sizeof(u64);
+}
+
+static void ecdsa_exit_tfm(struct crypto_akcipher *tfm)
+{
+}
+
+//static const struct s_ecdsa_template {
+//    const char  *name;
+//    enum OID    oid;
+//    size_t      size;
+//    int (*ecdsa_verify)(struct akcipher_request *req);
+//} ecdsa_templates[] = {
+//    {"ecdsa(sha256)", OID_id_ecdsa_with_sha256, ecdsa_verify},
+//    {"ecdsa(sha384)", OID_id_ecdsa_with_sha384, ecdsa_verify},
+//    {"ecdsa(sha512)", OID_id_ecdsa_with_sha512, ecdsa_verify},
+//    NULL
+//};
+
+static struct akcipher_alg ecdsa_alg256 = {
+	.verify = ecdsa_verify_256,
+	.set_pub_key = ecdsa_set_pub_key,
+	.max_size = ecdsa_max_size,
+	.exit = ecdsa_exit_tfm,
+	.base = {
+		 .cra_name = "ecdsa(sha256)",
+		 .cra_driver_name = "ecdsa-generic",
+		 .cra_priority = 100,
+		 .cra_module = THIS_MODULE,
+		 .cra_ctxsize = sizeof(struct ecdsa_ctx),
+		 },
+};
+
+static struct akcipher_alg ecdsa_alg384 = {
+	.verify = ecdsa_verify_384,
+	.set_pub_key = ecdsa_set_pub_key,
+	.max_size = ecdsa_max_size,
+	.exit = ecdsa_exit_tfm,
+	.base = {
+		 .cra_name = "ecdsa(sha384)",
+		 .cra_driver_name = "ecdsa-generic",
+		 .cra_priority = 100,
+		 .cra_module = THIS_MODULE,
+		 .cra_ctxsize = sizeof(struct ecdsa_ctx),
+		 },
+};
+
+static struct akcipher_alg ecdsa_alg512 = {
+	.verify = ecdsa_verify_512,
+	.set_pub_key = ecdsa_set_pub_key,
+	.max_size = ecdsa_max_size,
+	.exit = ecdsa_exit_tfm,
+	.base = {
+		 .cra_name = "ecdsa(sha512)",
+		 .cra_driver_name = "ecdsa-generic",
+		 .cra_priority = 100,
+		 .cra_module = THIS_MODULE,
+		 .cra_ctxsize = sizeof(struct ecdsa_ctx),
+		 },
+};
+
+static int __init ecdsa_mod_init(void)
+{
+	int result;
+
+	result = crypto_register_akcipher(&ecdsa_alg256);
+	if (result)
+		goto out256;
+	result = crypto_register_akcipher(&ecdsa_alg384);
+	if (result)
+		goto out384;
+	result = crypto_register_akcipher(&ecdsa_alg512);
+	if (result)
+		goto out512;
+	return 0;
+
+out512:
+	crypto_unregister_akcipher(&ecdsa_alg384);
+out384:
+	crypto_unregister_akcipher(&ecdsa_alg256);
+out256:
+	return result;
+}
+
+static void __exit ecdsa_mod_fini(void)
+{
+	crypto_unregister_akcipher(&ecdsa_alg256);
+	crypto_unregister_akcipher(&ecdsa_alg384);
+	crypto_unregister_akcipher(&ecdsa_alg512);
+}
+
+subsys_initcall(ecdsa_mod_init);
+module_exit(ecdsa_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Saulo Alessandre <saulo.alessandre@gmail.com>");
+MODULE_DESCRIPTION("EC-DSA generic algorithm");
+MODULE_ALIAS_CRYPTO("ecdsa-generic");
diff --git a/crypto/ecdsa_params.asn1 b/crypto/ecdsa_params.asn1
new file mode 100644
index 000000000..f683aec27
--- /dev/null
+++ b/crypto/ecdsa_params.asn1
@@ -0,0 +1 @@
+EcdsaCurve ::=  OBJECT IDENTIFIER ({ ecdsa_param_curve })
diff --git a/crypto/ecdsa_signature.asn1 b/crypto/ecdsa_signature.asn1
new file mode 100644
index 000000000..378e73913
--- /dev/null
+++ b/crypto/ecdsa_signature.asn1
@@ -0,0 +1,6 @@
+EcdsaSignature ::= SEQUENCE {
+    signatureR  INTEGER ({ ecdsa_parse_sig_r }),
+    signatureS  INTEGER ({ ecdsa_parse_sig_s })
+}
+
+EcdsaPubKey ::= BIT STRING ({ ecdsa_parse_pub_key })
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 7473c5bc0..119a62630 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3728,8 +3728,15 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 	memcpy(xbuf[0], m, m_size);
 
 	sg_init_table(src_tab, 3);
-	sg_set_buf(&src_tab[0], xbuf[0], 8);
-	sg_set_buf(&src_tab[1], xbuf[0] + 8, m_size - 8);
+	if (vecs->algo == OID_id_ecdsa_with_sha256 ||
+		vecs->algo == OID_id_ecdsa_with_sha384 ||
+		vecs->algo == OID_id_ecdsa_with_sha512) {
+		sg_set_buf(&src_tab[0], xbuf[0], m_size);
+		sg_set_buf(&src_tab[1], xbuf[1], c_size);
+	} else {
+		sg_set_buf(&src_tab[0], xbuf[0], 8);
+		sg_set_buf(&src_tab[1], xbuf[0] + 8, m_size - 8);
+	}
 	if (vecs->siggen_sigver_test) {
 		if (WARN_ON(c_size > PAGE_SIZE))
 			goto free_all;
@@ -4550,6 +4557,12 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.kpp = __VECS(ecdh_tv_template)
 		}
+	}, {
+		.alg = "ecdsa",
+		.test = alg_test_akcipher,
+		.suite = {
+			.akcipher = __VECS(ecdsa_tv_template)
+		}
 	}, {
 		.alg = "ecrdsa",
 		.test = alg_test_akcipher,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index ef7d21f39..42fadd0c0 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -560,6 +560,84 @@ static const struct akcipher_testvec rsa_tv_template[] = {
 	}
 };
 
+/*
+ * EC-DSA test vectors
+ */
+static const struct akcipher_testvec ecdsa_tv_template[] = {
+	{
+	.key =
+	"\x04\x9c\x9e\x45\xe5\x61\xf4\x3d\xf8\x8f\xea\xdf\xce\x9a\xd5\x2a"
+	"\x9e\x7e\x8a\x0a\xef\xff\xad\x9c\x2e\x87\x8e\xa0\xa9\x40\x0a\x3d"
+	"\x7f\x01\x85\x8d\xd6\x36\xcf\x84\x56\x59\xb8\xd8\x3d\x20\x78\xe7"
+	"\xaf\x35\xa8\xeb\x89\x37\x0e\x52\xa7\x71\x81\x2f\x64\xbb\x1d\x6c"
+	"\x04",
+	.key_len = 65,
+	/*
+	 * m is SHA256 hash of following message:
+	 * "\x49\x41\xbe\x0a\x0c\xc9\xf6\x35\x51\xe4\x27\x56\x13\x71\x4b\xd0"
+	 * "\x36\x92\x84\x89\x1b\xf8\x56\x4a\x72\x61\x14\x69\x4f\x5e\x98\xa5"
+	 * "\x80\x5a\x37\x51\x1f\xd8\xf5\xb5\x63\xfc\xf4\xb1\xbb\x4d\x33\xa3"
+	 * "\x1e\xb9\x75\x8b\x9c\xda\x7e\x6d\x3a\x77\x85\xf7\xfc\x4e\xe7\x64"
+	 * "\x43\x10\x19\xa0\x59\xae\xe0\xad\x4b\xd3\xc4\x45\xf7\xb1\xc2\xc1"
+	 * "\x65\x01\x41\x39\x5b\x45\x47\xed\x2b\x51\xed\xe3\xd0\x09\x10\xd2"
+	 * "\x39\x6c\x4a\x3f\xe5\xd2\x20\xe6\xb0\x71\x7d\x5b\xed\x26\x60\xf1"
+	 * "\xb4\x73\xd1\xdb\x7d\xc4\x19\x91\xee\xf6\x32\x76\xf2\x19\x7d\xb7"
+	 */
+	.m =
+	"\x3e\xc8\xa1\x26\x20\x54\x44\x52\x48\x0d\xe5\x66\xf3\xb3\xf5\x04"
+	"\xbe\x10\xa8\x48\x94\x22\x2d\xdd\xba\x7a\xb4\x76\x8d\x79\x98\x89",
+	.m_size = 32,
+	.params = /* ecdsaWithSHA512 */
+	//"\x06\x08\x2a\x86\x48\xce\x3d\x04\x03\x04",
+	"\x06\x08\x2A\x86\x48\xCE\x3D\x03\x01\x07",
+	.param_len = 10,
+	.c =
+	"\x30\x44\x02\x20\x2b\xf7\x53\x42\xc2\x80\x52\xca\x9f\x54\x5e\x52"
+	"\xe2\x46\xa4\x83\xf4\x00\x59\x1e\x88\xd4\x7a\x88\x96\xb7\xee\xc7"
+	"\xbf\x2c\x1e\xd0\x02\x20\x46\x58\x95\x5f\x39\x75\x35\xaa\x73\x7d"
+	"\xe3\x87\x18\xad\x6d\x60\xd0\xc3\xb7\x21\x10\xeb\x77\x7b\x5a\xd4"
+	"\x52\x05\xc0\xfe\xa8\x46",
+	.c_size = 70,
+	.algo = OID_id_ecdsa_with_sha256,
+	.public_key_vec = true,
+	.siggen_sigver_test = true,
+	},
+	{
+	.key =
+	"\x04\xee\x89\x69\x41\xa0\x10\xfe\x56\xbc\x50\x37\x6d\xa1\xfe"
+	"\x89\xa6\x34\xaf\x0a\x97\x7c\x7a\x5c\x13\x5f\xea\x5f\x36\x07"
+	"\x82\xd4\x4b\x09\x97\xd4\xf9\x91\xb9\x0e\x06\xd4\x3d\xd3\x87"
+	"\xc3\x1b\x00\x93\xc8\x0f\x8a\x45\xa9\xb7\x3d\xa0\xbf\xe3\xb3"
+	"\x0f\x9a\xf0\xbd\x70\x62\x16\x40\xc3\x83\x56\x25\xc3\x0f\x85"
+	"\xa2\xd3\x88\x89\xbd\x5b\x92\x27\x3f\x95\x77\xd0\xc1\x49\x07"
+	"\xe2\xa5\xd7\xb2\x5b\xba\xea",
+	.key_len = 97,
+	/*
+	 * m is SHA256 hash of same previous message:
+	 * "\x49\x41\xbe\x0a ...                         \xf2\x19\x7d\xb7"
+	 */
+	.m =
+	"\x3e\xc8\xa1\x26\x20\x54\x44\x52\x48\x0d\xe5\x66\xf3\xb3\xf5\x04"
+	"\xbe\x10\xa8\x48\x94\x22\x2d\xdd\xba\x7a\xb4\x76\x8d\x79\x98\x89",
+	.m_size = 32,
+	.params = /* ecdsaWithSHA512 */
+	"\x06\x05\x2B\x81\x04\x00\x22",
+	.param_len = 7,
+	.c =
+	"\x30\x64\x02\x30\x4f\xd3\xe8\x98\xcb\x6b\x82\x4b\x41\x2d\x3b\x85"
+	"\xde\x07\x19\xc4\x64\x2b\xd9\x80\x00\x50\xa8\x79\x48\x07\x75\xb6"
+	"\x56\x66\xb9\x89\x0b\xab\x89\x18\x4c\xe9\x21\x38\x4e\xe0\x70\x9d"
+	"\x80\x76\x8a\x2b\x02\x30\x5f\x01\xc5\x0b\x6e\x72\x42\x2e\x79\xee"
+	"\x42\x15\xe0\x16\xf5\x38\x90\x49\x44\x7f\xca\x29\xdf\x0d\xce\x5b"
+	"\xeb\x7f\xef\x2a\x51\xef\x52\x6e\x14\xa6\x25\xe5\xfb\x7b\x66\xea"
+	"\x07\x3f\x4c\x17\xd0\xfc",
+	.c_size = 102,
+	.algo = OID_id_ecdsa_with_sha256,
+	.public_key_vec = true,
+	.siggen_sigver_test = true,
+	},
+};
+
 /*
  * EC-RDSA test vectors are generated by gost-engine.
  */
diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
index a5b805b55..6c7333f82 100644
--- a/include/crypto/ecdh.h
+++ b/include/crypto/ecdh.h
@@ -25,6 +25,8 @@
 /* Curves IDs */
 #define ECC_CURVE_NIST_P192	0x0001
 #define ECC_CURVE_NIST_P256	0x0002
+#define ECC_CURVE_NIST_P384	0x0003
+#define ECC_CURVE_NIST_P521	0x0004
 
 /**
  * struct ecdh - define an ECDH private key
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index 657d6bf2c..3cfcb390f 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -17,9 +17,15 @@
  *	  build_OID_registry.pl to generate the data for look_up_OID().
  */
 enum OID {
+	OID__undef,		/* 1.0 */
 	OID_id_dsa_with_sha1,		/* 1.2.840.10030.4.3 */
 	OID_id_dsa,			/* 1.2.840.10040.4.1 */
+	OID_id_secp192r1,	/* 1.2.840.10045.3.1.1 */
+	OID_id_secp256r1,	/* 1.2.840.10045.3.1.7 */
 	OID_id_ecdsa_with_sha1,		/* 1.2.840.10045.4.1 */
+	OID_id_ecdsa_with_sha256,		/* 1.2.840.10045.4.3.2 */
+	OID_id_ecdsa_with_sha384,		/* 1.2.840.10045.4.3.3 */
+	OID_id_ecdsa_with_sha512,		/* 1.2.840.10045.4.3.4 */
 	OID_id_ecPublicKey,		/* 1.2.840.10045.2.1 */
 
 	/* PKCS#1 {iso(1) member-body(2) us(840) rsadsi(113549) pkcs(1) pkcs-1(1)} */
@@ -58,6 +64,8 @@ enum OID {
 
 	OID_certAuthInfoAccess,		/* 1.3.6.1.5.5.7.1.1 */
 	OID_sha1,			/* 1.3.14.3.2.26 */
+	OID_id_secp384r1,		/* 1.3.132.0.34 */
+	OID_id_secp521r1,		/* 1.3.132.0.35 */
 	OID_sha256,			/* 2.16.840.1.101.3.4.2.1 */
 	OID_sha384,			/* 2.16.840.1.101.3.4.2.2 */
 	OID_sha512,			/* 2.16.840.1.101.3.4.2.3 */
@@ -113,5 +121,9 @@ enum OID {
 extern enum OID look_up_OID(const void *data, size_t datasize);
 extern int sprint_oid(const void *, size_t, char *, size_t);
 extern int sprint_OID(enum OID, char *, size_t);
+extern int lookup_oid_sign_info(enum OID oid,
+		const char **sign_algo);
+extern int lookup_oid_digest_info(enum OID oid,
+		const char **hash_algo, u32 *hash_len, enum OID *oid_algo);
 
 #endif /* _LINUX_OID_REGISTRY_H */
diff --git a/lib/oid_registry.c b/lib/oid_registry.c
index f7ad43f28..a4bb2e0bd 100644
--- a/lib/oid_registry.c
+++ b/lib/oid_registry.c
@@ -84,14 +84,115 @@ enum OID look_up_OID(const void *data, size_t datasize)
 			}
 		}
 		return oid;
-	next:
+next:
 		;
 	}
 
 	return OID__NR;
 }
+
 EXPORT_SYMBOL_GPL(look_up_OID);
 
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wswitch"
+int lookup_oid_sign_info(enum OID oid, const char **sign_algo)
+{
+	int ret = -1;
+
+	if (sign_algo) {
+		switch (oid) {
+		case OID_md4WithRSAEncryption:
+		case OID_sha1WithRSAEncryption:
+		case OID_sha256WithRSAEncryption:
+		case OID_sha384WithRSAEncryption:
+		case OID_sha512WithRSAEncryption:
+		case OID_sha224WithRSAEncryption:
+			if (sign_algo)
+				*sign_algo = "rsa";
+			ret = 0;
+			break;
+		case OID_id_ecdsa_with_sha1:
+		case OID_id_ecdsa_with_sha256:
+		case OID_id_ecdsa_with_sha384:
+		case OID_id_ecdsa_with_sha512:
+			if (sign_algo)
+				*sign_algo = "ecdsa";
+			ret = 0;
+			break;
+		}
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lookup_oid_sign_info);
+
+int lookup_oid_digest_info(enum OID oid,
+			   const char **digest_algo, u32 *digest_len,
+			   enum OID *digest_oid)
+{
+	int ret = 0;
+
+	switch (oid) {
+	case OID_md4WithRSAEncryption:
+		if (digest_algo)
+			*digest_algo = "md4";
+		if (digest_oid)
+			*digest_oid = OID_md4;
+		if (digest_len)
+			*digest_len = 16;
+		break;
+	case OID_sha1WithRSAEncryption:
+	case OID_id_ecdsa_with_sha1:
+		if (digest_algo)
+			*digest_algo = "sha1";
+		if (digest_oid)
+			*digest_oid = OID_sha1;
+		if (digest_len)
+			*digest_len = 20;
+		break;
+	case OID_sha224WithRSAEncryption:
+		if (digest_algo)
+			*digest_algo = "sha224";
+		if (digest_oid)
+			*digest_oid = OID_sha224;
+		if (digest_len)
+			*digest_len = 28;
+		break;
+	case OID_sha256WithRSAEncryption:
+	case OID_id_ecdsa_with_sha256:
+		if (digest_algo)
+			*digest_algo = "sha256";
+		if (digest_oid)
+			*digest_oid = OID_sha256;
+		if (digest_len)
+			*digest_len = 32;
+		break;
+	case OID_sha384WithRSAEncryption:
+	case OID_id_ecdsa_with_sha384:
+		if (digest_algo)
+			*digest_algo = "sha384";
+		if (digest_oid)
+			*digest_oid = OID_sha384;
+		if (digest_len)
+			*digest_len = 48;
+		break;
+	case OID_sha512WithRSAEncryption:
+	case OID_id_ecdsa_with_sha512:
+		if (digest_algo)
+			*digest_algo = "sha512";
+		if (digest_oid)
+			*digest_oid = OID_sha512;
+		if (digest_len)
+			*digest_len = 64;
+		break;
+	default:
+		ret = -1;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lookup_oid_digest_info);
+
+#pragma GCC diagnostic pop
+
 /*
  * sprint_OID - Print an Object Identifier into a buffer
  * @data: The encoded OID to print
@@ -149,6 +250,7 @@ int sprint_oid(const void *data, size_t datasize, char *buffer, size_t bufsize)
 	snprintf(buffer, bufsize, "(bad)");
 	return -EBADMSG;
 }
+
 EXPORT_SYMBOL_GPL(sprint_oid);
 
 /**
@@ -167,9 +269,9 @@ int sprint_OID(enum OID oid, char *buffer, size_t bufsize)
 	BUG_ON(oid >= OID__NR);
 
 	ret = sprint_oid(oid_data + oid_index[oid],
-			 oid_index[oid + 1] - oid_index[oid],
-			 buffer, bufsize);
+			 oid_index[oid + 1] - oid_index[oid], buffer, bufsize);
 	BUG_ON(ret == -EBADMSG);
 	return ret;
 }
+
 EXPORT_SYMBOL_GPL(sprint_OID);
-- 
2.17.1

