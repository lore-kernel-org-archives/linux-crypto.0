Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D0FC61DA3
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Feb 2023 05:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjBXFIp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Feb 2023 00:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBXFIo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Feb 2023 00:08:44 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0616C367D5
        for <linux-crypto@vger.kernel.org>; Thu, 23 Feb 2023 21:08:40 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pVQJv-00F7Zc-9h; Fri, 24 Feb 2023 13:08:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Feb 2023 13:08:35 +0800
Date:   Fri, 24 Feb 2023 13:08:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Subject: [PATCH] crypto: stm32 - Fix empty message checks
Message-ID: <Y/hGU7r56Phsz3wN@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The empty message checks may trigger on non-empty messages split
over an update operation followed by a final operation (where
req->nbytes can/should be set to zero).

Fixes: b56403a25af7 ("crypto: stm32/hash - Support Ux500 hash")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 7bf805563ac2..acf8bfc8de4b 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -148,6 +148,7 @@ struct stm32_hash_request_ctx {
 	int			nents;
 
 	u8			data_type;
+	bool			nonempty;
 
 	u8 buffer[HASH_BUFLEN] __aligned(sizeof(u32));
 
@@ -310,7 +311,7 @@ static void stm32_hash_write_ctrl(struct stm32_hash_dev *hdev, int bufcnt)
 		 * On the Ux500 we need to set a special flag to indicate that
 		 * the message is zero length.
 		 */
-		if (hdev->pdata->ux500 && bufcnt == 0)
+		if (hdev->pdata->ux500 && !rctx->nonempty)
 			reg |= HASH_CR_UX500_EMPTYMSG;
 
 		if (!hdev->polled)
@@ -754,6 +755,7 @@ static int stm32_hash_init(struct ahash_request *req)
 	rctx->total = 0;
 	rctx->offset = 0;
 	rctx->data_type = HASH_DATA_8_BITS;
+	rctx->nonempty = false;
 
 	memset(rctx->buffer, 0, HASH_BUFLEN);
 
@@ -832,7 +834,7 @@ static void stm32_hash_copy_hash(struct ahash_request *req)
 	__be32 *hash = (void *)rctx->digest;
 	unsigned int i, hashsize;
 
-	if (hdev->pdata->broken_emptymsg && !req->nbytes)
+	if (hdev->pdata->broken_emptymsg && !rctx->nonempty)
 		return stm32_hash_emptymsg_fallback(req);
 
 	switch (rctx->flags & HASH_FLAGS_ALGO_MASK) {
@@ -986,6 +988,8 @@ static int stm32_hash_update(struct ahash_request *req)
 {
 	struct stm32_hash_request_ctx *rctx = ahash_request_ctx(req);
 
+	rctx->nonempty = !!req->nbytes;
+
 	if (!req->nbytes || !(rctx->flags & HASH_FLAGS_CPU))
 		return 0;
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
