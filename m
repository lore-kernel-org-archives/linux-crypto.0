Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EFF8C61DA4
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Mar 2023 09:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjCKJnL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Mar 2023 04:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjCKJmt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Mar 2023 04:42:49 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ABD13FF0F;
        Sat, 11 Mar 2023 01:42:26 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pavE1-002xZy-2G; Sat, 11 Mar 2023 17:09:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 11 Mar 2023 17:09:13 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Sat, 11 Mar 2023 17:09:13 +0800
Subject: [v7 PATCH 2/8] crypto: stm32 - Move polling into do_one_request
References: <ZAxFBR3TdA7jUAgJ@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Message-Id: <E1pavE1-002xZy-2G@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is no need to poll separate for update and final.  We could
merge them into do_one_request.

Also fix the error handling so that we don't poll (and overwrite
the error) when an error has already occurred.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/stm32/stm32-hash.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index bde2b40a6a32..298cabd29e36 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -425,6 +425,8 @@ static int stm32_hash_update_cpu(struct stm32_hash_dev *hdev)
 		bufcnt = rctx->bufcnt;
 		rctx->bufcnt = 0;
 		err = stm32_hash_xmit_cpu(hdev, rctx->buffer, bufcnt, 0);
+		if (err)
+			return err;
 	}
 
 	stm32_hash_append_sg(rctx);
@@ -433,14 +435,6 @@ static int stm32_hash_update_cpu(struct stm32_hash_dev *hdev)
 		bufcnt = rctx->bufcnt;
 		rctx->bufcnt = 0;
 		err = stm32_hash_xmit_cpu(hdev, rctx->buffer, bufcnt, 1);
-
-		/* If we have an IRQ, wait for that, else poll for completion */
-		if (hdev->polled) {
-			if (stm32_hash_wait_busy(hdev))
-				return -ETIMEDOUT;
-			hdev->flags |= HASH_FLAGS_OUTPUT_READY;
-			err = 0;
-		}
 	}
 
 	return err;
@@ -784,15 +778,6 @@ static int stm32_hash_final_req(struct stm32_hash_dev *hdev)
 	else
 		err = stm32_hash_xmit_cpu(hdev, rctx->buffer, buflen, 1);
 
-	/* If we have an IRQ, wait for that, else poll for completion */
-	if (hdev->polled) {
-		if (stm32_hash_wait_busy(hdev))
-			return -ETIMEDOUT;
-		hdev->flags |= HASH_FLAGS_OUTPUT_READY;
-		/* Caller will call stm32_hash_finish_req() */
-		err = 0;
-	}
-
 	return err;
 }
 
@@ -964,6 +949,16 @@ static int stm32_hash_one_request(struct crypto_engine *engine, void *areq)
 	else if (rctx->op == HASH_OP_FINAL)
 		err = stm32_hash_final_req(hdev);
 
+	/* If we have an IRQ, wait for that, else poll for completion */
+	if (err == -EINPROGRESS && hdev->polled) {
+		if (stm32_hash_wait_busy(hdev))
+			err = -ETIMEDOUT;
+		else {
+			hdev->flags |= HASH_FLAGS_OUTPUT_READY;
+			err = 0;
+		}
+	}
+
 	if (err != -EINPROGRESS)
 	/* done task will not finish it, so do it here */
 		stm32_hash_finish_req(req, err);
