Return-Path: <SRS0=HgoS=YM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 484BACA9EA0
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Oct 2019 00:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2722320663
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Oct 2019 00:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfJSAra (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Oct 2019 20:47:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4736 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbfJSAra (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Oct 2019 20:47:30 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 57688F09124E8B64AADE;
        Sat, 19 Oct 2019 08:47:28 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Sat, 19 Oct 2019 08:47:18 +0800
From:   Tian Tao <tiantao6@huawei.com>
To:     <gilad@benyossef.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
CC:     <linuxarm@huawei.com>
Subject: [PATCH] crypto: fix safexcel_hash warning PTR_ERR_OR_ZERO can be used
Date:   Sat, 19 Oct 2019 08:44:40 +0800
Message-ID: <1571445880-34025-1-git-send-email-tiantao6@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

fix below warning reported by coccicheck.
the below code is only in the crypto-dev tree currently.
drivers/crypto/inside-secure/safexcel_cipher.c:2527:1-3: WARNING:
PTR_ERR_OR_ZERO can be used.

Fixes: 38f21b4bab11 ("crypto: inside-secure - Added support for the AES XCBC ahash")

Signed-off-by: Tian Tao <tiantao6@huawei.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 85c3a07..3c71151 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -2109,10 +2109,8 @@ static int safexcel_xcbcmac_cra_init(struct crypto_tfm *tfm)
 
 	safexcel_ahash_cra_init(tfm);
 	ctx->kaes = crypto_alloc_cipher("aes", 0, 0);
-	if (IS_ERR(ctx->kaes))
-		return PTR_ERR(ctx->kaes);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(ctx->kaes);
 }
 
 static void safexcel_xcbcmac_cra_exit(struct crypto_tfm *tfm)
-- 
2.7.4

