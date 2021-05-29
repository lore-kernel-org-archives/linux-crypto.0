Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA19EC47082
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 09:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86564613B4
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 09:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhE2JCZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 May 2021 05:02:25 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2346 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhE2JCZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 May 2021 05:02:25 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fsb4p0zLJz1BFlh;
        Sat, 29 May 2021 16:56:10 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 17:00:47 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 29 May 2021 17:00:46 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: hisilicon/hpre - fix ecdh self test issue
Date:   Sat, 29 May 2021 16:57:37 +0800
Message-ID: <1622278657-55967-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When the key length is zero, use stdrng to generate private key
to pass the crypto ecdh-nist-p256 self test on vector 2.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 34 +++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 294c368..6ba5d8a 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -5,6 +5,7 @@
 #include <crypto/dh.h>
 #include <crypto/ecc_curve.h>
 #include <crypto/ecdh.h>
+#include <crypto/rng.h>
 #include <crypto/internal/akcipher.h>
 #include <crypto/internal/kpp.h>
 #include <crypto/internal/rsa.h>
@@ -38,6 +39,9 @@ struct hpre_ctx;
 #define HPRE_DFX_SEC_TO_US	1000000
 #define HPRE_DFX_US_TO_NS	1000
 
+/* due to nist p521  */
+#define HPRE_ECC_MAX_KSZ	66
+
 /* size in bytes of the n prime */
 #define HPRE_ECC_NIST_P192_N_SIZE	24
 #define HPRE_ECC_NIST_P256_N_SIZE	32
@@ -1333,11 +1337,32 @@ static bool hpre_key_is_zero(char *key, unsigned short key_sz)
 	return true;
 }
 
+static int ecdh_gen_privkey(struct hpre_ctx *ctx, struct ecdh *params)
+{
+	struct device *dev = ctx->dev;
+	int ret;
+
+	ret = crypto_get_default_rng();
+	if (ret) {
+		dev_err(dev, "failed to get default rng, ret = %d!\n", ret);
+		return ret;
+	}
+
+	ret = crypto_rng_get_bytes(crypto_default_rng, (u8 *)params->key,
+				   params->key_size);
+	crypto_put_default_rng();
+	if (ret)
+		dev_err(dev, "failed to get rng, ret = %d!\n", ret);
+
+	return ret;
+}
+
 static int hpre_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 				unsigned int len)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
 	struct device *dev = ctx->dev;
+	char key[HPRE_ECC_MAX_KSZ];
 	unsigned int sz, sz_shift;
 	struct ecdh params;
 	int ret;
@@ -1347,6 +1372,15 @@ static int hpre_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 		return -EINVAL;
 	}
 
+	/* Use stdrng to generate private key */
+	if (!params.key || !params.key_size) {
+		params.key = key;
+		params.key_size = hpre_ecdh_get_curvesz(ctx->curve_id);
+		ret = ecdh_gen_privkey(ctx, &params);
+		if (ret)
+			return ret;
+	}
+
 	if (hpre_key_is_zero(params.key, params.key_size)) {
 		dev_err(dev, "Invalid hpre key!\n");
 		return -EINVAL;
-- 
2.8.1

