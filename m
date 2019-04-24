Return-Path: <SRS0=+uK6=S2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 693A9C10F11
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Apr 2019 07:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4102B206BA
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Apr 2019 07:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbfDXHyU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Apr 2019 03:54:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57944 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729767AbfDXHyT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Apr 2019 03:54:19 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 85B58C3B0CB00916E3E4;
        Wed, 24 Apr 2019 15:54:17 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Wed, 24 Apr 2019
 15:54:08 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: atmel - remove set but not used variable 'alg_name'
Date:   Wed, 24 Apr 2019 15:53:52 +0800
Message-ID: <20190424075352.22828-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/crypto/atmel-tdes.c: In function 'atmel_tdes_setkey':
drivers/crypto/atmel-tdes.c:803:14: warning: variable 'alg_name' set but not used [-Wunused-but-set-variable]

It is not used any more since
commit 52ea3cd2917b ("crypto: atmel - Forbid 2-key 3DES in FIPS mode")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/atmel-tdes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 12492d9..fa76620 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -800,12 +800,9 @@ static int atmel_tdes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
 	struct atmel_tdes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-	const char *alg_name;
 	u32 flags;
 	int err;
 
-	alg_name = crypto_tfm_alg_name(crypto_ablkcipher_tfm(tfm));
-
 	flags = crypto_ablkcipher_get_flags(tfm);
 	err = __des3_verify_key(&flags, key);
 	if (unlikely(err)) {
-- 
2.7.4


