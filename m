Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC60EC433E6
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 07:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DA9F64E58
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 07:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhBWHNa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Feb 2021 02:13:30 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12941 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbhBWHN0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Feb 2021 02:13:26 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Dl9Fk6zr6zjQ98;
        Tue, 23 Feb 2021 15:11:22 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Tue, 23 Feb 2021 15:12:33 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <tudor.ambarus@microchip.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 3/7] crypto: move curve_id of ECDH from the key to algorithm name
Date:   Tue, 23 Feb 2021 15:10:15 +0800
Message-ID: <1614064219-40701-4-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1614064219-40701-1-git-send-email-yumeng18@huawei.com>
References: <1614064219-40701-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. crypto and crypto/atmel-ecc:
   Move curve id of ECDH from the key into the algorithm name instead
   in crypto and atmel-ecc, so ECDH algorithm name change form 'ecdh'
   to 'ecdh-nist-pxxx', and we cannot use 'curve_id' in 'struct ecdh';
2. crypto/testmgr and net/bluetooth:
   Modify 'testmgr.c', 'testmgr.h' and 'net/bluetooth' to adapt
   the modification.

Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 crypto/ecdh.c               | 72 +++++++++++++++++++++++++++++++--------------
 crypto/ecdh_helper.c        |  4 +--
 crypto/testmgr.c            | 13 ++++++--
 crypto/testmgr.h            | 34 ++++++++++-----------
 drivers/crypto/atmel-ecc.c  | 14 ++++-----
 include/crypto/ecdh.h       |  2 --
 net/bluetooth/ecdh_helper.c |  2 --
 net/bluetooth/selftest.c    |  2 +-
 net/bluetooth/smp.c         |  6 ++--
 9 files changed, 88 insertions(+), 61 deletions(-)

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
index fca63b5..f18f902 100644
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
 
@@ -70,7 +69,6 @@ int crypto_ecdh_decode_key(const char *buf, unsigned int len,
 	if (unlikely(len < secret.len))
 		return -EINVAL;
 
-	ptr = ecdh_unpack_data(&params->curve_id, ptr, sizeof(params->curve_id));
 	ptr = ecdh_unpack_data(&params->key_size, ptr, sizeof(params->key_size));
 	if (secret.len != crypto_ecdh_key_len(params))
 		return -EINVAL;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 9335999..c290ba0 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4904,11 +4904,20 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 #endif
-		.alg = "ecdh",
+#ifndef CONFIG_CRYPTO_FIPS
+		.alg = "ecdh-nist-p192",
 		.test = alg_test_kpp,
 		.fips_allowed = 1,
 		.suite = {
-			.kpp = __VECS(ecdh_tv_template)
+			.kpp = __VECS(ecdh_p192_tv_template)
+		}
+	}, {
+#endif
+		.alg = "ecdh-nist-p256",
+		.test = alg_test_kpp,
+		.fips_allowed = 1,
+		.suite = {
+			.kpp = __VECS(ecdh_p256_tv_template)
 		}
 	}, {
 		.alg = "ecrdsa",
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index ced56ea..6426603 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -2261,19 +2261,17 @@ static const struct kpp_testvec curve25519_tv_template[] = {
 }
 };
 
-static const struct kpp_testvec ecdh_tv_template[] = {
-	{
 #ifndef CONFIG_CRYPTO_FIPS
+static const struct kpp_testvec ecdh_p192_tv_template[] = {
+	{
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
+};
 #endif
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
diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 9bd8e51..9ade6ad 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -104,7 +104,7 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 		return -EINVAL;
 	}
 
-	ctx->n_sz = atmel_ecdh_supported_curve(params.curve_id);
+	ctx->n_sz = atmel_ecdh_supported_curve(ctx->curve_id);
 	if (!ctx->n_sz || params.key_size) {
 		/* fallback to ecdh software implementation */
 		ctx->do_fallback = true;
@@ -125,7 +125,6 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 		goto free_cmd;
 
 	ctx->do_fallback = false;
-	ctx->curve_id = params.curve_id;
 
 	atmel_i2c_init_genkey_cmd(cmd, DATA_SLOT_2);
 
@@ -263,6 +262,7 @@ static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
 	struct crypto_kpp *fallback;
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 
+	ctx->curve_id = ECC_CURVE_NIST_P256;
 	ctx->client = atmel_ecc_i2c_client_alloc();
 	if (IS_ERR(ctx->client)) {
 		pr_err("tfm - i2c_client binding failed\n");
@@ -306,7 +306,7 @@ static unsigned int atmel_ecdh_max_size(struct crypto_kpp *tfm)
 	return ATMEL_ECC_PUBKEY_SIZE;
 }
 
-static struct kpp_alg atmel_ecdh = {
+static struct kpp_alg atmel_ecdh_nist_p256 = {
 	.set_secret = atmel_ecdh_set_secret,
 	.generate_public_key = atmel_ecdh_generate_public_key,
 	.compute_shared_secret = atmel_ecdh_compute_shared_secret,
@@ -315,7 +315,7 @@ static struct kpp_alg atmel_ecdh = {
 	.max_size = atmel_ecdh_max_size,
 	.base = {
 		.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
-		.cra_name = "ecdh",
+		.cra_name = "ecdh-nist-p256",
 		.cra_driver_name = "atmel-ecdh",
 		.cra_priority = ATMEL_ECC_PRIORITY,
 		.cra_module = THIS_MODULE,
@@ -340,14 +340,14 @@ static int atmel_ecc_probe(struct i2c_client *client,
 		      &driver_data.i2c_client_list);
 	spin_unlock(&driver_data.i2c_list_lock);
 
-	ret = crypto_register_kpp(&atmel_ecdh);
+	ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
 	if (ret) {
 		spin_lock(&driver_data.i2c_list_lock);
 		list_del(&i2c_priv->i2c_client_list_node);
 		spin_unlock(&driver_data.i2c_list_lock);
 
 		dev_err(&client->dev, "%s alg registration failed\n",
-			atmel_ecdh.base.cra_driver_name);
+			atmel_ecdh_nist_p256.base.cra_driver_name);
 	} else {
 		dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
 	}
@@ -365,7 +365,7 @@ static int atmel_ecc_remove(struct i2c_client *client)
 		return -EBUSY;
 	}
 
-	crypto_unregister_kpp(&atmel_ecdh);
+	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
 
 	spin_lock(&driver_data.i2c_list_lock);
 	list_del(&i2c_priv->i2c_client_list_node);
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
diff --git a/net/bluetooth/ecdh_helper.c b/net/bluetooth/ecdh_helper.c
index 3226fe0..989401f 100644
--- a/net/bluetooth/ecdh_helper.c
+++ b/net/bluetooth/ecdh_helper.c
@@ -126,8 +126,6 @@ int set_ecdh_privkey(struct crypto_kpp *tfm, const u8 private_key[32])
 	int err;
 	struct ecdh p = {0};
 
-	p.curve_id = ECC_CURVE_NIST_P256;
-
 	if (private_key) {
 		tmp = kmalloc(32, GFP_KERNEL);
 		if (!tmp)
diff --git a/net/bluetooth/selftest.c b/net/bluetooth/selftest.c
index f71c6fa..f49604d 100644
--- a/net/bluetooth/selftest.c
+++ b/net/bluetooth/selftest.c
@@ -205,7 +205,7 @@ static int __init test_ecdh(void)
 
 	calltime = ktime_get();
 
-	tfm = crypto_alloc_kpp("ecdh", 0, 0);
+	tfm = crypto_alloc_kpp("ecdh-nist-p256", 0, 0);
 	if (IS_ERR(tfm)) {
 		BT_ERR("Unable to create ECDH crypto context");
 		err = PTR_ERR(tfm);
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index c659c46..5de73de 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -1387,7 +1387,7 @@ static struct smp_chan *smp_chan_create(struct l2cap_conn *conn)
 		goto zfree_smp;
 	}
 
-	smp->tfm_ecdh = crypto_alloc_kpp("ecdh", 0, 0);
+	smp->tfm_ecdh = crypto_alloc_kpp("ecdh-nist-p256", 0, 0);
 	if (IS_ERR(smp->tfm_ecdh)) {
 		BT_ERR("Unable to create ECDH crypto context");
 		goto free_shash;
@@ -3282,7 +3282,7 @@ static struct l2cap_chan *smp_add_cid(struct hci_dev *hdev, u16 cid)
 		return ERR_CAST(tfm_cmac);
 	}
 
-	tfm_ecdh = crypto_alloc_kpp("ecdh", 0, 0);
+	tfm_ecdh = crypto_alloc_kpp("ecdh-nist-p256", 0, 0);
 	if (IS_ERR(tfm_ecdh)) {
 		BT_ERR("Unable to create ECDH crypto context");
 		crypto_free_shash(tfm_cmac);
@@ -3807,7 +3807,7 @@ int __init bt_selftest_smp(void)
 		return PTR_ERR(tfm_cmac);
 	}
 
-	tfm_ecdh = crypto_alloc_kpp("ecdh", 0, 0);
+	tfm_ecdh = crypto_alloc_kpp("ecdh-nist-p256", 0, 0);
 	if (IS_ERR(tfm_ecdh)) {
 		BT_ERR("Unable to create ECDH crypto context");
 		crypto_free_shash(tfm_cmac);
-- 
2.8.1

