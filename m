From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH] crypto: qat - Switch to new rsa_helper functions
Date: Thu, 30 Jun 2016 17:59:07 +0100
Message-ID: <1467305947-4666-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50908 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbcF3RCo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jun 2016 13:02:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Drop all asn1 related code in qat and use the new rsa_helper
functions rsa_parse_[pub|priv]_key for parsing the key

Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
---
 crypto/testmgr.c                                  |  1 +
 drivers/crypto/qat/Kconfig                        |  2 +-
 drivers/crypto/qat/qat_common/Makefile            | 10 -----
 drivers/crypto/qat/qat_common/qat_asym_algs.c     | 49 +++++++++--------------
 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1 | 11 -----
 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1  |  4 --
 6 files changed, 22 insertions(+), 55 deletions(-)
 delete mode 100644 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
 delete mode 100644 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 537fdc3..b52a81c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1941,6 +1941,7 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
 	if (err)
 		goto free_req;
 
+	err = -ENOMEM;
 	out_len_max = crypto_akcipher_maxsize(tfm);
 	outbuf_enc = kzalloc(out_len_max, GFP_KERNEL);
 	if (!outbuf_enc)
diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index 85b44e5..571d04d 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -5,11 +5,11 @@ config CRYPTO_DEV_QAT
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AKCIPHER
 	select CRYPTO_HMAC
+	select CRYPTO_RSA
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
 	select FW_LOADER
-	select ASN1
 
 config CRYPTO_DEV_QAT_DH895xCC
 	tristate "Support for Intel(R) DH895xCC"
diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index 6d74b91..92fb6ff 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -1,11 +1,3 @@
-$(obj)/qat_rsapubkey-asn1.o: $(obj)/qat_rsapubkey-asn1.c \
-			     $(obj)/qat_rsapubkey-asn1.h
-$(obj)/qat_rsaprivkey-asn1.o: $(obj)/qat_rsaprivkey-asn1.c \
-			      $(obj)/qat_rsaprivkey-asn1.h
-
-clean-files += qat_rsapubkey-asn1.c qat_rsapubkey-asn1.h
-clean-files += qat_rsaprivkey-asn1.c qat_rsaprivkey-asn1.h
-
 obj-$(CONFIG_CRYPTO_DEV_QAT) += intel_qat.o
 intel_qat-objs := adf_cfg.o \
 	adf_isr.o \
@@ -19,8 +11,6 @@ intel_qat-objs := adf_cfg.o \
 	adf_hw_arbiter.o \
 	qat_crypto.o \
 	qat_algs.o \
-	qat_rsapubkey-asn1.o \
-	qat_rsaprivkey-asn1.o \
 	qat_asym_algs.o \
 	qat_uclo.o \
 	qat_hal.o
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 05f49d4..04b0ef8 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -52,8 +52,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/fips.h>
 #include <crypto/scatterwalk.h>
-#include "qat_rsapubkey-asn1.h"
-#include "qat_rsaprivkey-asn1.h"
 #include "icp_qat_fw_pke.h"
 #include "adf_accel_devices.h"
 #include "adf_transport.h"
@@ -502,10 +500,8 @@ unmap_src:
 	return ret;
 }
 
-int qat_rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
-		  const void *value, size_t vlen)
+int qat_rsa_set_n(struct qat_rsa_ctx *ctx, const char *value, size_t vlen)
 {
-	struct qat_rsa_ctx *ctx = context;
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	const char *ptr = value;
@@ -518,11 +514,6 @@ int qat_rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
 
 	ctx->key_sz = vlen;
 	ret = -EINVAL;
-	/* In FIPS mode only allow key size 2K & 3K */
-	if (fips_enabled && (ctx->key_sz != 256 && ctx->key_sz != 384)) {
-		pr_err("QAT: RSA: key size not allowed in FIPS mode\n");
-		goto err;
-	}
 	/* invalid key size provided */
 	if (!qat_rsa_enc_fn_id(ctx->key_sz))
 		goto err;
@@ -540,10 +531,8 @@ err:
 	return ret;
 }
 
-int qat_rsa_get_e(void *context, size_t hdrlen, unsigned char tag,
-		  const void *value, size_t vlen)
+int qat_rsa_set_e(struct qat_rsa_ctx *ctx, const char *value, size_t vlen)
 {
-	struct qat_rsa_ctx *ctx = context;
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	const char *ptr = value;
@@ -559,18 +548,15 @@ int qat_rsa_get_e(void *context, size_t hdrlen, unsigned char tag,
 	}
 
 	ctx->e = dma_zalloc_coherent(dev, ctx->key_sz, &ctx->dma_e, GFP_KERNEL);
-	if (!ctx->e) {
-		ctx->e = NULL;
+	if (!ctx->e)
 		return -ENOMEM;
-	}
+
 	memcpy(ctx->e + (ctx->key_sz - vlen), ptr, vlen);
 	return 0;
 }
 
-int qat_rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
-		  const void *value, size_t vlen)
+int qat_rsa_set_d(struct qat_rsa_ctx *ctx, const char *value, size_t vlen)
 {
-	struct qat_rsa_ctx *ctx = context;
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	const char *ptr = value;
@@ -585,12 +571,6 @@ int qat_rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
 	if (!ctx->key_sz || !vlen || vlen > ctx->key_sz)
 		goto err;
 
-	/* In FIPS mode only allow key size 2K & 3K */
-	if (fips_enabled && (vlen != 256 && vlen != 384)) {
-		pr_err("QAT: RSA: key size not allowed in FIPS mode\n");
-		goto err;
-	}
-
 	ret = -ENOMEM;
 	ctx->d = dma_zalloc_coherent(dev, ctx->key_sz, &ctx->dma_d, GFP_KERNEL);
 	if (!ctx->d)
@@ -608,6 +588,7 @@ static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
 {
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
+	struct rsa_key rsa_key;
 	int ret;
 
 	/* Free the old key if any */
@@ -625,13 +606,23 @@ static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
 	ctx->d = NULL;
 
 	if (private)
-		ret = asn1_ber_decoder(&qat_rsaprivkey_decoder, ctx, key,
-				       keylen);
+		ret = rsa_parse_priv_key(&rsa_key, key, keylen);
 	else
-		ret = asn1_ber_decoder(&qat_rsapubkey_decoder, ctx, key,
-				       keylen);
+		ret = rsa_parse_pub_key(&rsa_key, key, keylen);
+	if (ret < 0)
+		goto free;
+
+	ret = qat_rsa_set_n(ctx, rsa_key.n, rsa_key.n_sz);
 	if (ret < 0)
 		goto free;
+	ret = qat_rsa_set_e(ctx, rsa_key.e, rsa_key.e_sz);
+	if (ret < 0)
+		goto free;
+	if (private) {
+		ret = qat_rsa_set_d(ctx, rsa_key.d, rsa_key.d_sz);
+		if (ret < 0)
+			goto free;
+	}
 
 	if (!ctx->n || !ctx->e) {
 		/* invalid key provided */
diff --git a/drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1 b/drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
deleted file mode 100644
index f0066ad..0000000
--- a/drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
+++ /dev/null
@@ -1,11 +0,0 @@
-RsaPrivKey ::= SEQUENCE {
-	version		INTEGER,
-	n		INTEGER ({ qat_rsa_get_n }),
-	e		INTEGER ({ qat_rsa_get_e }),
-	d		INTEGER ({ qat_rsa_get_d }),
-	prime1		INTEGER,
-	prime2		INTEGER,
-	exponent1	INTEGER,
-	exponent2	INTEGER,
-	coefficient	INTEGER
-}
diff --git a/drivers/crypto/qat/qat_common/qat_rsapubkey.asn1 b/drivers/crypto/qat/qat_common/qat_rsapubkey.asn1
deleted file mode 100644
index bd667b3..0000000
--- a/drivers/crypto/qat/qat_common/qat_rsapubkey.asn1
+++ /dev/null
@@ -1,4 +0,0 @@
-RsaPubKey ::= SEQUENCE {
-	n INTEGER ({ qat_rsa_get_n }),
-	e INTEGER ({ qat_rsa_get_e })
-}
-- 
2.7.4
