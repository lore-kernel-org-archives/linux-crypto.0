Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92FFCC25B4E
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Jan 2023 09:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjAXJLQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Jan 2023 04:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbjAXJLQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Jan 2023 04:11:16 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E623E088
        for <linux-crypto@vger.kernel.org>; Tue, 24 Jan 2023 01:11:15 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pKFKh-003UsB-Ch; Tue, 24 Jan 2023 17:11:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 24 Jan 2023 17:11:11 +0800
Date:   Tue, 24 Jan 2023 17:11:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>
Subject: [PATCH] crypto: marvell/cesa - Use crypto_wait_req
Message-ID: <Y8+gr3A7zKWIxHYG@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch replaces the custom crypto completion function with
crypto_req_done.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index c72b0672fc71..8d84ad45571c 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -1104,47 +1104,27 @@ struct ahash_alg mv_sha256_alg = {
 	}
 };
 
-struct mv_cesa_ahash_result {
-	struct completion completion;
-	int error;
-};
-
-static void mv_cesa_hmac_ahash_complete(struct crypto_async_request *req,
-					int error)
-{
-	struct mv_cesa_ahash_result *result = req->data;
-
-	if (error == -EINPROGRESS)
-		return;
-
-	result->error = error;
-	complete(&result->completion);
-}
-
 static int mv_cesa_ahmac_iv_state_init(struct ahash_request *req, u8 *pad,
 				       void *state, unsigned int blocksize)
 {
-	struct mv_cesa_ahash_result result;
+	DECLARE_CRYPTO_WAIT(result);
 	struct scatterlist sg;
 	int ret;
 
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   mv_cesa_hmac_ahash_complete, &result);
+				   crypto_req_done, &result);
 	sg_init_one(&sg, pad, blocksize);
 	ahash_request_set_crypt(req, &sg, pad, blocksize);
-	init_completion(&result.completion);
 
 	ret = crypto_ahash_init(req);
 	if (ret)
 		return ret;
 
 	ret = crypto_ahash_update(req);
-	if (ret && ret != -EINPROGRESS)
-		return ret;
+	ret = crypto_wait_req(ret, &result);
 
-	wait_for_completion_interruptible(&result.completion);
-	if (result.error)
-		return result.error;
+	if (ret)
+		return ret;
 
 	ret = crypto_ahash_export(req, state);
 	if (ret)
@@ -1158,7 +1138,7 @@ static int mv_cesa_ahmac_pad_init(struct ahash_request *req,
 				  u8 *ipad, u8 *opad,
 				  unsigned int blocksize)
 {
-	struct mv_cesa_ahash_result result;
+	DECLARE_CRYPTO_WAIT(result);
 	struct scatterlist sg;
 	int ret;
 	int i;
@@ -1172,17 +1152,12 @@ static int mv_cesa_ahmac_pad_init(struct ahash_request *req,
 			return -ENOMEM;
 
 		ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-					   mv_cesa_hmac_ahash_complete,
-					   &result);
+					   crypto_req_done, &result);
 		sg_init_one(&sg, keydup, keylen);
 		ahash_request_set_crypt(req, &sg, ipad, keylen);
-		init_completion(&result.completion);
 
 		ret = crypto_ahash_digest(req);
-		if (ret == -EINPROGRESS) {
-			wait_for_completion_interruptible(&result.completion);
-			ret = result.error;
-		}
+		ret = crypto_wait_req(ret, &result);
 
 		/* Set the memory region to 0 to avoid any leak. */
 		kfree_sensitive(keydup);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
