Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8099BC43461
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 06:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53F6E61465
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 06:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhELGoT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 02:44:19 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3729 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhELGoQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 02:44:16 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fg4sF0fV7zmgKB;
        Wed, 12 May 2021 14:39:45 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Wed, 12 May 2021 14:43:00 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] crypto: ecdh - register NIST P384 tfm
Date:   Wed, 12 May 2021 14:40:01 +0800
Message-ID: <1620801602-49287-3-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1620801602-49287-1-git-send-email-tanghui20@huawei.com>
References: <1620801602-49287-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add ecdh_nist_p384_init_tfm and register and unregister P384 tfm.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 crypto/ecdh.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 65fb685..cae79da 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -173,6 +173,31 @@ static struct kpp_alg ecdh_nist_p256 = {
 	},
 };
 
+static int ecdh_nist_p384_init_tfm(struct crypto_kpp *tfm)
+{
+	struct ecdh_ctx *ctx = ecdh_get_ctx(tfm);
+
+	ctx->curve_id = ECC_CURVE_NIST_P384;
+	ctx->ndigits = ECC_CURVE_NIST_P384_DIGITS;
+
+	return 0;
+}
+
+static struct kpp_alg ecdh_nist_p384 = {
+	.set_secret = ecdh_set_secret,
+	.generate_public_key = ecdh_compute_value,
+	.compute_shared_secret = ecdh_compute_value,
+	.max_size = ecdh_max_size,
+	.init = ecdh_nist_p384_init_tfm,
+	.base = {
+		.cra_name = "ecdh-nist-p384",
+		.cra_driver_name = "ecdh-nist-p384-generic",
+		.cra_priority = 100,
+		.cra_module = THIS_MODULE,
+		.cra_ctxsize = sizeof(struct ecdh_ctx),
+	},
+};
+
 static bool ecdh_nist_p192_registered;
 
 static int ecdh_init(void)
@@ -186,8 +211,15 @@ static int ecdh_init(void)
 	if (ret)
 		goto nist_p256_error;
 
+	ret = crypto_register_kpp(&ecdh_nist_p384);
+	if (ret)
+		goto nist_p384_error;
+
 	return 0;
 
+nist_p384_error:
+	crypto_unregister_kpp(&ecdh_nist_p256);
+
 nist_p256_error:
 	if (ecdh_nist_p192_registered)
 		crypto_unregister_kpp(&ecdh_nist_p192);
@@ -199,6 +231,7 @@ static void ecdh_exit(void)
 	if (ecdh_nist_p192_registered)
 		crypto_unregister_kpp(&ecdh_nist_p192);
 	crypto_unregister_kpp(&ecdh_nist_p256);
+	crypto_unregister_kpp(&ecdh_nist_p384);
 }
 
 subsys_initcall(ecdh_init);
-- 
2.8.1

