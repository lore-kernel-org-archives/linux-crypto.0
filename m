Return-Path: <SRS0=z9QW=ZB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49896C17441
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 02:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2947F20865
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 02:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfKICpG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 21:45:06 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:5749 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726061AbfKICpG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 21:45:06 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 07A4A3D3DC3141E17821;
        Sat,  9 Nov 2019 10:45:04 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Sat, 9 Nov 2019 10:44:58 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Ripard <mripard@kernel.org>,
        "Chen-Yu Tsai" <wens@csie.org>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] crypto: sun8i-ss - Fix memdup.cocci warnings
Date:   Sat, 9 Nov 2019 02:44:03 +0000
Message-ID: <20191109024403.47106-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use kmemdup rather than duplicating its implementation

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index f0e7c1e12da6..b6e7c346c3ae 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -396,10 +396,9 @@ int sun8i_ce_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		kfree(op->key);
 	}
 	op->keylen = keylen;
-	op->key = kmalloc(keylen, GFP_KERNEL | GFP_DMA);
+	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
 	if (!op->key)
 		return -ENOMEM;
-	memcpy(op->key, key, keylen);
 
 	crypto_sync_skcipher_clear_flags(op->fallback_tfm, CRYPTO_TFM_REQ_MASK);
 	crypto_sync_skcipher_set_flags(op->fallback_tfm, tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
@@ -422,10 +421,9 @@ int sun8i_ce_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		kfree(op->key);
 	}
 	op->keylen = keylen;
-	op->key = kmalloc(keylen, GFP_KERNEL | GFP_DMA);
+	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
 	if (!op->key)
 		return -ENOMEM;
-	memcpy(op->key, key, keylen);
 
 	crypto_sync_skcipher_clear_flags(op->fallback_tfm, CRYPTO_TFM_REQ_MASK);
 	crypto_sync_skcipher_set_flags(op->fallback_tfm, tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);



