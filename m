Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104A0C433ED
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 02:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9FA961056
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 02:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhDBCug (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Apr 2021 22:50:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15525 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbhDBCug (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Apr 2021 22:50:36 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FBPc95LznzNs6m;
        Fri,  2 Apr 2021 10:47:53 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.498.0; Fri, 2 Apr 2021
 10:50:26 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liulongfang@huawei.com>, <yekai13@huawei.com>
Subject: [PATCH] crypto:hisilicon/sec - fixup checking the 3DES weak key
Date:   Fri, 2 Apr 2021 10:47:57 +0800
Message-ID: <1617331677-49794-1-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

skcipher: Add a verifying to check whether the triple DES key
is weak.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 2eaa516..ee18c88 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -7,6 +7,7 @@
 #include <crypto/des.h>
 #include <crypto/hash.h>
 #include <crypto/internal/aead.h>
+#include <crypto/internal/des.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
 #include <crypto/skcipher.h>
@@ -573,10 +574,18 @@ static void sec_skcipher_uninit(struct crypto_skcipher *tfm)
 	sec_ctx_base_uninit(ctx);
 }
 
-static int sec_skcipher_3des_setkey(struct sec_cipher_ctx *c_ctx,
+static int sec_skcipher_3des_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				    const u32 keylen,
 				    const enum sec_cmode c_mode)
 {
+	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
+	int ret;
+
+	ret = verify_skcipher_des3_key(tfm, key);
+	if (ret)
+		return ret;
+
 	switch (keylen) {
 	case SEC_DES3_2KEY_SIZE:
 		c_ctx->c_key_len = SEC_CKEY_3DES_2KEY;
@@ -648,7 +657,7 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 	switch (c_alg) {
 	case SEC_CALG_3DES:
-		ret = sec_skcipher_3des_setkey(c_ctx, keylen, c_mode);
+		ret = sec_skcipher_3des_setkey(tfm, key, keylen, c_mode);
 		break;
 	case SEC_CALG_AES:
 	case SEC_CALG_SM4:
-- 
2.8.1

