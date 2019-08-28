Return-Path: <SRS0=KXmQ=WY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BCA9C3A5A1
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 06:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E1F422CF5
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 06:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfH1Ghg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Aug 2019 02:37:36 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:34352 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726374AbfH1Ghf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Aug 2019 02:37:35 -0400
X-UUID: 84ec3a7a644b429eb59967b68ca96bcf-20190828
X-UUID: 84ec3a7a644b429eb59967b68ca96bcf-20190828
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <vic.wu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 192895952; Wed, 28 Aug 2019 14:37:31 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 28 Aug 2019 14:37:30 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 28 Aug 2019 14:37:30 +0800
From:   Vic Wu <vic.wu@mediatek.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ryder Lee <ryder.lee@mediatek.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Vic Wu <vic.wu@mediatek.com>
Subject: [PATCH 5/5] crypto: mediatek: fix incorrect crypto key setting
Date:   Wed, 28 Aug 2019 14:37:16 +0800
Message-ID: <20190828063716.22689-5-vic.wu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190828063716.22689-1-vic.wu@mediatek.com>
References: <20190828063716.22689-1-vic.wu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Record crypto key to context during setkey and set the key to
transform state buffer in encrypt/decrypt process.

Signed-off-by: Vic Wu <vic.wu@mediatek.com>
---
 drivers/crypto/mediatek/mtk-aes.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 9eeb8b8d..05f21dc8 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -107,6 +107,7 @@ struct mtk_aes_reqctx {
 struct mtk_aes_base_ctx {
 	struct mtk_cryp *cryp;
 	u32 keylen;
+	__le32 key[12];
 	__le32 keymode;
 
 	mtk_aes_fn start;
@@ -541,6 +542,8 @@ static int mtk_aes_handle_queue(struct mtk_cryp *cryp, u8 id,
 		backlog->complete(backlog, -EINPROGRESS);
 
 	ctx = crypto_tfm_ctx(areq->tfm);
+	/* Write key into state buffer */
+	memcpy(ctx->info.state, ctx->key, sizeof(ctx->key));
 
 	aes->areq = areq;
 	aes->ctx = ctx;
@@ -660,7 +663,7 @@ static int mtk_aes_setkey(struct crypto_ablkcipher *tfm,
 	}
 
 	ctx->keylen = SIZE_IN_WORDS(keylen);
-	mtk_aes_write_state_le(ctx->info.state, (const u32 *)key, keylen);
+	mtk_aes_write_state_le(ctx->key, (const u32 *)key, keylen);
 
 	return 0;
 }
@@ -1093,10 +1096,8 @@ static int mtk_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	if (err)
 		goto out;
 
-	/* Write key into state buffer */
-	mtk_aes_write_state_le(ctx->info.state, (const u32 *)key, keylen);
-	/* Write key(H) into state buffer */
-	mtk_aes_write_state_be(ctx->info.state + ctx->keylen, data->hash,
+	mtk_aes_write_state_le(ctx->key, (const u32 *)key, keylen);
+	mtk_aes_write_state_be(ctx->key + ctx->keylen, data->hash,
 			       AES_BLOCK_SIZE);
 out:
 	kzfree(data);
-- 
2.17.1

