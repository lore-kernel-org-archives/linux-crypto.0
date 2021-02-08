Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE18C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB5AE64E8F
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhBHJqC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:46:02 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12490 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbhBHJmi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:42:38 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DZ1GJ0MV7zjKc4;
        Mon,  8 Feb 2021 17:40:08 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 17:41:20 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <tudor.ambarus@microchip.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 5/9] crypto: move curve_id of ECDH to algorithm name
Date:   Mon, 8 Feb 2021 17:38:53 +0800
Message-ID: <1612777137-51067-6-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612777137-51067-1-git-send-email-yumeng18@huawei.com>
References: <1612777137-51067-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. Move curve id of ECDH from the key into the algorithm name instead in
   crypto;
2. Modify 'testmgr.c' and 'testmgr.h' to adapt the modification.

Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 crypto/ecdh.c         | 72 +++++++++++++++++++++++++++++++++++----------------
 crypto/ecdh_helper.c  |  4 +--
 crypto/testmgr.c      | 11 ++++++--
 crypto/testmgr.h      | 32 ++++++++++-------------
 include/crypto/ecdh.h |  2 --
 5 files changed, 74 insertions(+), 47 deletions(-)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 96f80c8..04a427b 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -23,33 +23,16 @@ static inline struct ecdh_ctx *ecdh_get_ctx(struct crypto_kpp *tfm)
 	return kpp_tfm_ctx(tfm);
 }
 
-static unsigned int ecdh_supported_curve(unsigned int curve_id)
-{
-	switch (curve_id) {
-	case ECC_CURVE_NIST_P192: return ECC_CURVE_NIST_P192_DIGITS;
-	case ECC_CURVE_NIST_P256: return ECC_CURVE_NIST_P256_DIGITS;
-	default: return 0;
-	}
-}
-
 static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 			   unsigned int len)
 {
 	struct ecdh_ctx *ctx = ecdh_get_ctx(tfm);
 	struct ecdh params;
-	unsigned int ndigits;
 
 	if (crypto_ecdh_decode_key(buf, len, &params) < 0 ||
-	    params.key_size > sizeof(ctx->private_key))
+	    params.key_size > sizeof(u64) * ctx->ndigits)
 		return -EINVAL;
 
-	ndigits = ecdh_supported_curve(params.curve_id);
-	if (!ndigits)
-		return -EINVAL;
-
-	ctx->curve_id = params.curve_id;
-	ctx->ndigits = ndigits;
-
 	if (!params.key || !params.key_size)
 		return ecc_gen_privkey(ctx->curve_id, ctx->ndigits,
 				       ctx->private_key);
@@ -140,13 +123,24 @@ static unsigned int ecdh_max_size(struct crypto_kpp *tfm)
 	return ctx->ndigits << (ECC_DIGITS_TO_BYTES_SHIFT + 1);
 }
 
-static struct kpp_alg ecdh = {
+static int ecdh_nist_p192_init_tfm(struct crypto_kpp *tfm)
+{
+	struct ecdh_ctx *ctx = ecdh_get_ctx(tfm);
+
+	ctx->curve_id = ECC_CURVE_NIST_P192;
+	ctx->ndigits = ECC_CURVE_NIST_P192_DIGITS;
+
+	return 0;
+}
+
+static struct kpp_alg ecdh_nist_p192 = {
 	.set_secret = ecdh_set_secret,
 	.generate_public_key = ecdh_compute_value,
 	.compute_shared_secret = ecdh_compute_value,
 	.max_size = ecdh_max_size,
+	.init = ecdh_nist_p192_init_tfm,
 	.base = {
-		.cra_name = "ecdh",
+		.cra_name = "ecdh-nist-p192",
 		.cra_driver_name = "ecdh-generic",
 		.cra_priority = 100,
 		.cra_module = THIS_MODULE,
@@ -154,14 +148,48 @@ static struct kpp_alg ecdh = {
 	},
 };
 
+static int ecdh_nist_p256_init_tfm(struct crypto_kpp *tfm)
+{
+	struct ecdh_ctx *ctx = ecdh_get_ctx(tfm);
+
+	ctx->curve_id = ECC_CURVE_NIST_P256;
+	ctx->ndigits = ECC_CURVE_NIST_P256_DIGITS;
+
+	return 0;
+}
+
+static struct kpp_alg ecdh_nist_p256 = {
+	.set_secret = ecdh_set_secret,
+	.generate_public_key = ecdh_compute_value,
+	.compute_shared_secret = ecdh_compute_value,
+	.max_size = ecdh_max_size,
+	.init = ecdh_nist_p256_init_tfm,
+	.base = {
+		.cra_name = "ecdh-nist-p256",
+		.cra_driver_name = "ecdh-generic",
+		.cra_priority = 100,
+		.cra_module = THIS_MODULE,
+		.cra_ctxsize = sizeof(struct ecdh_ctx),
+	},
+};
+
+static bool ecdh_nist_p192_registered;
+
 static int ecdh_init(void)
 {
-	return crypto_register_kpp(&ecdh);
+	int ret;
+
+	ret = crypto_register_kpp(&ecdh_nist_p192);
+	ecdh_nist_p192_registered = ret == 0;
+
+	return crypto_register_kpp(&ecdh_nist_p256);
 }
 
 static void ecdh_exit(void)
 {
-	crypto_unregister_kpp(&ecdh);
+	if (ecdh_nist_p192_registered)
+		crypto_unregister_kpp(&ecdh_nist_p192);
+	crypto_unregister_kpp(&ecdh_nist_p256);
 }
 
 subsys_initcall(ecdh_init);
diff --git a/crypto/ecdh_helper.c b/crypto/ecdh_helper.c
index 66fcb2e..c79696f 100644
--- a/crypto/ecdh_helper.c
+++ b/crypto/ecdh_helper.c
@@ -10,7 +10,7 @@
 #include <crypto/ecdh.h>
 #include <crypto/kpp.h>
 
-#define ECDH_KPP_SECRET_MIN_SIZE (sizeof(struct kpp_secret) + 2 * sizeof(short))
+#define ECDH_KPP_SECRET_MIN_SIZE (sizeof(struct kpp_secret) + sizeof(short))
 
 static inline u8 *ecdh_pack_data(void *dst, const void *src, size_t sz)
 {
@@ -46,7 +46,6 @@ int crypto_ecdh_encode_key(char *buf, unsigned int len,
 		return -EINVAL;
 
 	ptr = ecdh_pack_data(ptr, &secret, sizeof(secret));
-	ptr = ecdh_pack_data(ptr, &params->curve_id, sizeof(params->curve_id));
 	ptr = ecdh_pack_data(ptr, &params->key_size, sizeof(params->key_size));
 	ecdh_pack_data(ptr, params->key, params->key_size);
 
@@ -67,7 +66,6 @@ int crypto_ecdh_decode_key(const char *buf, unsigned int len,
 	if (secret.type != CRYPTO_KPP_SECRET_TYPE_ECDH)
 		return -EINVAL;
 
-	ptr = ecdh_unpack_data(&params->curve_id, ptr, sizeof(params->curve_id));
 	ptr = ecdh_unpack_data(&params->key_size, ptr, sizeof(params->key_size));
 	if (secret.len != crypto_ecdh_key_len(params))
 		return -EINVAL;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1a4103b..b890ac5 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4910,11 +4910,18 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 #endif
-		.alg = "ecdh",
+		.alg = "ecdh-nist-p192",
 		.test = alg_test_kpp,
 		.fips_allowed = 1,
 		.suite = {
-			.kpp = __VECS(ecdh_tv_template)
+			.kpp = __VECS(ecdh_p192_tv_template)
+		}
+	}, {
+		.alg = "ecdh-nist-p256",
+		.test = alg_test_kpp,
+		.fips_allowed = 1,
+		.suite = {
+			.kpp = __VECS(ecdh_p256_tv_template)
 		}
 	}, {
 		.alg = "ecrdsa",
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 99aca08..85bf54e 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -2261,19 +2261,17 @@ static const struct kpp_testvec curve25519_tv_template[] = {
 }
 };
 
-static const struct kpp_testvec ecdh_tv_template[] = {
+static const struct kpp_testvec ecdh_p192_tv_template[] = {
 	{
 #ifndef CONFIG_CRYPTO_FIPS
 	.secret =
 #ifdef __LITTLE_ENDIAN
 	"\x02\x00" /* type */
-	"\x20\x00" /* len */
-	"\x01\x00" /* curve_id */
+	"\x1e\x00" /* len */
 	"\x18\x00" /* key_size */
 #else
 	"\x00\x02" /* type */
-	"\x00\x20" /* len */
-	"\x00\x01" /* curve_id */
+	"\x00\x1e" /* len */
 	"\x00\x18" /* key_size */
 #endif
 	"\xb5\x05\xb1\x71\x1e\xbf\x8c\xda"
@@ -2301,18 +2299,20 @@ static const struct kpp_testvec ecdh_tv_template[] = {
 	.b_public_size = 48,
 	.expected_a_public_size = 48,
 	.expected_ss_size = 24
-	}, {
+	}
 #endif
+};
+
+static const struct kpp_testvec ecdh_p256_tv_template[] = {
+	{
 	.secret =
 #ifdef __LITTLE_ENDIAN
 	"\x02\x00" /* type */
-	"\x28\x00" /* len */
-	"\x02\x00" /* curve_id */
+	"\x26\x00" /* len */
 	"\x20\x00" /* key_size */
 #else
 	"\x00\x02" /* type */
-	"\x00\x28" /* len */
-	"\x00\x02" /* curve_id */
+	"\x00\x26" /* len */
 	"\x00\x20" /* key_size */
 #endif
 	"\x24\xd1\x21\xeb\xe5\xcf\x2d\x83"
@@ -2350,25 +2350,21 @@ static const struct kpp_testvec ecdh_tv_template[] = {
 	.secret =
 #ifdef __LITTLE_ENDIAN
 	"\x02\x00" /* type */
-	"\x08\x00" /* len */
-	"\x02\x00" /* curve_id */
+	"\x06\x00" /* len */
 	"\x00\x00", /* key_size */
 #else
 	"\x00\x02" /* type */
-	"\x00\x08" /* len */
-	"\x00\x02" /* curve_id */
+	"\x00\x06" /* len */
 	"\x00\x00", /* key_size */
 #endif
 	.b_secret =
 #ifdef __LITTLE_ENDIAN
 	"\x02\x00" /* type */
-	"\x28\x00" /* len */
-	"\x02\x00" /* curve_id */
+	"\x26\x00" /* len */
 	"\x20\x00" /* key_size */
 #else
 	"\x00\x02" /* type */
-	"\x00\x28" /* len */
-	"\x00\x02" /* curve_id */
+	"\x00\x26" /* len */
 	"\x00\x20" /* key_size */
 #endif
 	"\x24\xd1\x21\xeb\xe5\xcf\x2d\x83"
diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
index a5b805b..deaaa48 100644
--- a/include/crypto/ecdh.h
+++ b/include/crypto/ecdh.h
@@ -29,12 +29,10 @@
 /**
  * struct ecdh - define an ECDH private key
  *
- * @curve_id:	ECC curve the key is based on.
  * @key:	Private ECDH key
  * @key_size:	Size of the private ECDH key
  */
 struct ecdh {
-	unsigned short curve_id;
 	char *key;
 	unsigned short key_size;
 };
-- 
2.8.1

