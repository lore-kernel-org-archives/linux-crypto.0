Return-Path: <SRS0=KXmQ=WY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD465C3A5A4
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 06:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E26422CF5
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 06:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfH1Gh3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Aug 2019 02:37:29 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:16591 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726374AbfH1Gh3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Aug 2019 02:37:29 -0400
X-UUID: e9c422f9d0b1419582e8cf49c49553fb-20190828
X-UUID: e9c422f9d0b1419582e8cf49c49553fb-20190828
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <vic.wu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2125458992; Wed, 28 Aug 2019 14:37:21 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 28 Aug 2019 14:37:27 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 28 Aug 2019 14:37:27 +0800
From:   Vic Wu <vic.wu@mediatek.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ryder Lee <ryder.lee@mediatek.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Vic Wu <vic.wu@mediatek.com>
Subject: [PATCH 2/5] crypto: mediatek: fix uninitialized value of gctx->textlen
Date:   Wed, 28 Aug 2019 14:37:13 +0800
Message-ID: <20190828063716.22689-2-vic.wu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190828063716.22689-1-vic.wu@mediatek.com>
References: <20190828063716.22689-1-vic.wu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: F65AEE53D721DE43A7E2257D0A165C3D3E3FC6680F81F063306A834E96B04F1A2000:8
X-MTK:  N
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

Add a pre-computed text length to avoid uninitialized value in the check.

Fixes: e47270665b5f ("crypto: mediatek - Add empty messages check in GCM mode")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Vic Wu <vic.wu@mediatek.com>
---
 drivers/crypto/mediatek/mtk-aes.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 43fcc8b5..425d7f3f 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -896,14 +896,11 @@ static int mtk_aes_gcm_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 		aes->resume = mtk_aes_transfer_complete;
 		/* Compute total process length. */
 		aes->total = len + gctx->authsize;
-		/* Compute text length. */
-		gctx->textlen = req->cryptlen;
 		/* Hardware will append authenticated tag to output buffer */
 		scatterwalk_map_and_copy(tag, req->dst, len, gctx->authsize, 1);
 	} else {
 		aes->resume = mtk_aes_gcm_tag_verify;
 		aes->total = len;
-		gctx->textlen = req->cryptlen - gctx->authsize;
 	}
 
 	return mtk_aes_gcm_dma(cryp, aes, req->src, req->dst, len);
@@ -915,19 +912,22 @@ static int mtk_aes_gcm_crypt(struct aead_request *req, u64 mode)
 	struct mtk_aes_gcm_ctx *gctx = mtk_aes_gcm_ctx_cast(ctx);
 	struct mtk_aes_reqctx *rctx = aead_request_ctx(req);
 	struct mtk_cryp *cryp;
+	bool enc = !!(mode & AES_FLAGS_ENCRYPT);
 
 	cryp = mtk_aes_find_dev(ctx);
 	if (!cryp)
 		return -ENODEV;
 
+	/* Compute text length. */
+	gctx->textlen = req->cryptlen - (enc ? 0 : gctx->authsize);
+
 	/* Empty messages are not supported yet */
 	if (!gctx->textlen && !req->assoclen)
 		return -EINVAL;
 
 	rctx->mode = AES_FLAGS_GCM | mode;
 
-	return mtk_aes_handle_queue(cryp, !!(mode & AES_FLAGS_ENCRYPT),
-				    &req->base);
+	return mtk_aes_handle_queue(cryp, enc, &req->base);
 }
 
 /*
-- 
2.17.1

