Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28446C64EC4
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Mar 2023 09:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjCDJhc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Mar 2023 04:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjCDJhb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Mar 2023 04:37:31 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27B1B477;
        Sat,  4 Mar 2023 01:37:29 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pYOKH-000GYy-Rv; Sat, 04 Mar 2023 17:37:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 04 Mar 2023 17:37:13 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Sat, 04 Mar 2023 17:37:13 +0800
Subject: [v5 PATCH 3/7] crypto: stm32 - Simplify finup
References: <ZAMQjOdi8GfqDUQI@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Message-Id: <E1pYOKH-000GYy-Rv@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The current finup code is unnecessarily convoluted.  There is no
need to call update and final separately as update already does
all the necessary work on its own.

Simplify this by utilising the HASH_FLAGS_FINUP bit in rctx to
indicate only finup and use the HASH_FLAGS_FINAL bit instead to
signify processing common to both final and finup.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/stm32/stm32-hash.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 298cabd29e36..473809b26566 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -417,7 +417,7 @@ static int stm32_hash_update_cpu(struct stm32_hash_dev *hdev)
 
 	dev_dbg(hdev->dev, "%s flags %lx\n", __func__, rctx->flags);
 
-	final = (rctx->flags & HASH_FLAGS_FINUP);
+	final = rctx->flags & HASH_FLAGS_FINAL;
 
 	while ((rctx->total >= rctx->buflen) ||
 	       (rctx->bufcnt + rctx->total >= rctx->buflen)) {
@@ -761,6 +761,11 @@ static int stm32_hash_init(struct ahash_request *req)
 
 static int stm32_hash_update_req(struct stm32_hash_dev *hdev)
 {
+	struct stm32_hash_request_ctx *rctx = ahash_request_ctx(hdev->req);
+
+	if (!(rctx->flags & HASH_FLAGS_CPU))
+		return stm32_hash_dma_send(hdev);
+
 	return stm32_hash_update_cpu(hdev);
 }
 
@@ -768,17 +773,14 @@ static int stm32_hash_final_req(struct stm32_hash_dev *hdev)
 {
 	struct ahash_request *req = hdev->req;
 	struct stm32_hash_request_ctx *rctx = ahash_request_ctx(req);
-	int err;
 	int buflen = rctx->bufcnt;
 
-	rctx->bufcnt = 0;
+	if (rctx->flags & HASH_FLAGS_FINUP)
+		return stm32_hash_update_req(hdev);
 
-	if (!(rctx->flags & HASH_FLAGS_CPU))
-		err = stm32_hash_dma_send(hdev);
-	else
-		err = stm32_hash_xmit_cpu(hdev, rctx->buffer, buflen, 1);
+	rctx->bufcnt = 0;
 
-	return err;
+	return stm32_hash_xmit_cpu(hdev, rctx->buffer, buflen, 1);
 }
 
 static void stm32_hash_emptymsg_fallback(struct ahash_request *req)
@@ -1000,7 +1002,7 @@ static int stm32_hash_final(struct ahash_request *req)
 {
 	struct stm32_hash_request_ctx *rctx = ahash_request_ctx(req);
 
-	rctx->flags |= HASH_FLAGS_FINUP;
+	rctx->flags |= HASH_FLAGS_FINAL;
 
 	return stm32_hash_enqueue(req, HASH_OP_FINAL);
 }
@@ -1010,25 +1012,13 @@ static int stm32_hash_finup(struct ahash_request *req)
 	struct stm32_hash_request_ctx *rctx = ahash_request_ctx(req);
 	struct stm32_hash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
 	struct stm32_hash_dev *hdev = stm32_hash_find_dev(ctx);
-	int err1, err2;
 
 	rctx->flags |= HASH_FLAGS_FINUP;
 
 	if (hdev->dma_lch && stm32_hash_dma_aligned_data(req))
 		rctx->flags &= ~HASH_FLAGS_CPU;
 
-	err1 = stm32_hash_update(req);
-
-	if (err1 == -EINPROGRESS || err1 == -EBUSY)
-		return err1;
-
-	/*
-	 * final() has to be always called to cleanup resources
-	 * even if update() failed, except EINPROGRESS
-	 */
-	err2 = stm32_hash_final(req);
-
-	return err1 ?: err2;
+	return stm32_hash_final(req);
 }
 
 static int stm32_hash_digest(struct ahash_request *req)
