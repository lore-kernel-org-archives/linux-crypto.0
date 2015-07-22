From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: ixp4xx - Remove bogus BUG_ON on scattered dst buffer
Date: Wed, 22 Jul 2015 18:05:35 +0800
Message-ID: <20150722100535.GA2871@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Christian Hohnstaedt <chohnstaedt@innominate.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38670 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303AbbGVKFl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 06:05:41 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes a bogus BUG_ON in the ablkcipher path that
triggers when the destination buffer is different from the source
buffer and is scattered.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 7ba495f..402631a 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -905,7 +905,6 @@ static int ablk_perform(struct ablkcipher_request *req, int encrypt)
 		crypt->mode |= NPE_OP_NOT_IN_PLACE;
 		/* This was never tested by Intel
 		 * for more than one dst buffer, I think. */
-		BUG_ON(req->dst->length < nbytes);
 		req_ctx->dst = NULL;
 		if (!chainup_buffers(dev, req->dst, nbytes, &dst_hook,
 					flags, DMA_FROM_DEVICE))
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
