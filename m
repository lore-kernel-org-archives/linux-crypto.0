Return-Path: <SRS0=KXmQ=WY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66119C3A5A1
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 06:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B7EA2189D
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 06:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfH1GhZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Aug 2019 02:37:25 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:55010 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726374AbfH1GhZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Aug 2019 02:37:25 -0400
X-UUID: bb68fcb6fa36483baf879d51d2ab477f-20190828
X-UUID: bb68fcb6fa36483baf879d51d2ab477f-20190828
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <vic.wu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1294171564; Wed, 28 Aug 2019 14:37:20 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 28 Aug 2019 14:37:26 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 28 Aug 2019 14:37:26 +0800
From:   Vic Wu <vic.wu@mediatek.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ryder Lee <ryder.lee@mediatek.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Vic Wu <vic.wu@mediatek.com>
Subject: [PATCH 1/5] crypto: mediatek: move mtk_aes_find_dev() to the right place
Date:   Wed, 28 Aug 2019 14:37:12 +0800
Message-ID: <20190828063716.22689-1-vic.wu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

Move mtk_aes_find_dev() to right functions as nobody uses the
'cryp' under current flows.

We can also avoid duplicate checks here and there in this way.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Vic Wu <vic.wu@mediatek.com>
---
 drivers/crypto/mediatek/mtk-aes.c | 39 +++++++++++--------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 72e4549e..43fcc8b5 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -658,14 +658,19 @@ static int mtk_aes_setkey(struct crypto_ablkcipher *tfm,
 
 static int mtk_aes_crypt(struct ablkcipher_request *req, u64 mode)
 {
-	struct mtk_aes_base_ctx *ctx;
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	struct mtk_aes_base_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
 	struct mtk_aes_reqctx *rctx;
+	struct mtk_cryp *cryp;
+
+	cryp = mtk_aes_find_dev(ctx);
+	if (!cryp)
+		return -ENODEV;
 
-	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
 	rctx = ablkcipher_request_ctx(req);
 	rctx->mode = mode;
 
-	return mtk_aes_handle_queue(ctx->cryp, !(mode & AES_FLAGS_ENCRYPT),
+	return mtk_aes_handle_queue(cryp, !(mode & AES_FLAGS_ENCRYPT),
 				    &req->base);
 }
 
@@ -702,13 +707,6 @@ static int mtk_aes_ctr_decrypt(struct ablkcipher_request *req)
 static int mtk_aes_cra_init(struct crypto_tfm *tfm)
 {
 	struct mtk_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct mtk_cryp *cryp = NULL;
-
-	cryp = mtk_aes_find_dev(&ctx->base);
-	if (!cryp) {
-		pr_err("can't find crypto device\n");
-		return -ENODEV;
-	}
 
 	tfm->crt_ablkcipher.reqsize = sizeof(struct mtk_aes_reqctx);
 	ctx->base.start = mtk_aes_start;
@@ -718,13 +716,6 @@ static int mtk_aes_cra_init(struct crypto_tfm *tfm)
 static int mtk_aes_ctr_cra_init(struct crypto_tfm *tfm)
 {
 	struct mtk_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct mtk_cryp *cryp = NULL;
-
-	cryp = mtk_aes_find_dev(&ctx->base);
-	if (!cryp) {
-		pr_err("can't find crypto device\n");
-		return -ENODEV;
-	}
 
 	tfm->crt_ablkcipher.reqsize = sizeof(struct mtk_aes_reqctx);
 	ctx->base.start = mtk_aes_ctr_start;
@@ -930,6 +921,11 @@ static int mtk_aes_gcm_crypt(struct aead_request *req, u64 mode)
 	struct mtk_aes_base_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct mtk_aes_gcm_ctx *gctx = mtk_aes_gcm_ctx_cast(ctx);
 	struct mtk_aes_reqctx *rctx = aead_request_ctx(req);
+	struct mtk_cryp *cryp;
+
+	cryp = mtk_aes_find_dev(ctx);
+	if (!cryp)
+		return -ENODEV;
 
 	/* Empty messages are not supported yet */
 	if (!gctx->textlen && !req->assoclen)
@@ -937,7 +933,7 @@ static int mtk_aes_gcm_crypt(struct aead_request *req, u64 mode)
 
 	rctx->mode = AES_FLAGS_GCM | mode;
 
-	return mtk_aes_handle_queue(ctx->cryp, !!(mode & AES_FLAGS_ENCRYPT),
+	return mtk_aes_handle_queue(cryp, !!(mode & AES_FLAGS_ENCRYPT),
 				    &req->base);
 }
 
@@ -1069,13 +1065,6 @@ static int mtk_aes_gcm_decrypt(struct aead_request *req)
 static int mtk_aes_gcm_init(struct crypto_aead *aead)
 {
 	struct mtk_aes_gcm_ctx *ctx = crypto_aead_ctx(aead);
-	struct mtk_cryp *cryp = NULL;
-
-	cryp = mtk_aes_find_dev(&ctx->base);
-	if (!cryp) {
-		pr_err("can't find crypto device\n");
-		return -ENODEV;
-	}
 
 	ctx->ctr = crypto_alloc_skcipher("ctr(aes)", 0,
 					 CRYPTO_ALG_ASYNC);
-- 
2.17.1

