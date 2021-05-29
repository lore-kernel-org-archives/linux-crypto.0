Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91413C47082
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 09:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A444613CD
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 09:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhE2JDj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 May 2021 05:03:39 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2530 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhE2JDj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 May 2021 05:03:39 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fsb8R6F04zYpPF;
        Sat, 29 May 2021 16:59:19 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 17:02:01 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 29 May 2021 17:02:00 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: hisilicon/hpre - register ecdh NIST P384
Date:   Sat, 29 May 2021 16:58:47 +0800
Message-ID: <1622278727-22349-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Register ecdh NIST P384 curve and add the tfm initialization.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 56 ++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 323418b..a032c19 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -45,9 +45,11 @@ struct hpre_ctx;
 /* size in bytes of the n prime */
 #define HPRE_ECC_NIST_P192_N_SIZE	24
 #define HPRE_ECC_NIST_P256_N_SIZE	32
+#define HPRE_ECC_NIST_P384_N_SIZE	48
 
 /* size in bytes */
 #define HPRE_ECC_HW256_KSZ_B	32
+#define HPRE_ECC_HW384_KSZ_B	48
 
 typedef void (*hpre_cb)(struct hpre_ctx *ctx, void *sqe);
 
@@ -1211,12 +1213,21 @@ static void hpre_ecc_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all,
 	hpre_ctx_clear(ctx, is_clear_all);
 }
 
+/*
+ * The bits of 192/224/256/384/521 are supported by HPRE,
+ * and convert the bits like:
+ * bits<=256, bits=256; 256<bits<=384, bits=384; 384<bits<=576, bits=576;
+ * If the parameter bit width is insufficient, then we fill in the
+ * high-order zeros by soft, so TASK_LENGTH1 is 0x3/0x5/0x8;
+ */
 static unsigned int hpre_ecdh_supported_curve(unsigned short id)
 {
 	switch (id) {
 	case ECC_CURVE_NIST_P192:
 	case ECC_CURVE_NIST_P256:
 		return HPRE_ECC_HW256_KSZ_B;
+	case ECC_CURVE_NIST_P384:
+		return HPRE_ECC_HW384_KSZ_B;
 	default:
 		break;
 	}
@@ -1281,6 +1292,8 @@ static unsigned int hpre_ecdh_get_curvesz(unsigned short id)
 		return HPRE_ECC_NIST_P192_N_SIZE;
 	case ECC_CURVE_NIST_P256:
 		return HPRE_ECC_NIST_P256_N_SIZE;
+	case ECC_CURVE_NIST_P384:
+		return HPRE_ECC_NIST_P384_N_SIZE;
 	default:
 		break;
 	}
@@ -1613,6 +1626,15 @@ static int hpre_ecdh_nist_p256_init_tfm(struct crypto_kpp *tfm)
 	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
 }
 
+static int hpre_ecdh_nist_p384_init_tfm(struct crypto_kpp *tfm)
+{
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+
+	ctx->curve_id = ECC_CURVE_NIST_P384;
+
+	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
+}
+
 static void hpre_ecdh_exit_tfm(struct crypto_kpp *tfm)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
@@ -2017,6 +2039,23 @@ static struct kpp_alg ecdh_nist_p256 = {
 	},
 };
 
+static struct kpp_alg ecdh_nist_p384 = {
+	.set_secret = hpre_ecdh_set_secret,
+	.generate_public_key = hpre_ecdh_compute_value,
+	.compute_shared_secret = hpre_ecdh_compute_value,
+	.max_size = hpre_ecdh_max_size,
+	.init = hpre_ecdh_nist_p384_init_tfm,
+	.exit = hpre_ecdh_exit_tfm,
+	.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
+	.base = {
+		.cra_ctxsize = sizeof(struct hpre_ctx),
+		.cra_priority = HPRE_CRYPTO_ALG_PRI,
+		.cra_name = "ecdh-nist-p384",
+		.cra_driver_name = "hpre-ecdh-nist-p384",
+		.cra_module = THIS_MODULE,
+	},
+};
+
 static struct kpp_alg curve25519_alg = {
 	.set_secret = hpre_curve25519_set_secret,
 	.generate_public_key = hpre_curve25519_compute_value,
@@ -2044,16 +2083,25 @@ static int hpre_register_ecdh(void)
 		return ret;
 
 	ret = crypto_register_kpp(&ecdh_nist_p256);
-	if (ret) {
-		crypto_unregister_kpp(&ecdh_nist_p192);
-		return ret;
-	}
+	if (ret)
+		goto unregister_ecdh_p192;
+
+	ret = crypto_register_kpp(&ecdh_nist_p384);
+	if (ret)
+		goto unregister_ecdh_p256;
 
 	return 0;
+
+unregister_ecdh_p256:
+	crypto_unregister_kpp(&ecdh_nist_p256);
+unregister_ecdh_p192:
+	crypto_unregister_kpp(&ecdh_nist_p192);
+	return ret;
 }
 
 static void hpre_unregister_ecdh(void)
 {
+	crypto_unregister_kpp(&ecdh_nist_p384);
 	crypto_unregister_kpp(&ecdh_nist_p256);
 	crypto_unregister_kpp(&ecdh_nist_p192);
 }
-- 
2.8.1

