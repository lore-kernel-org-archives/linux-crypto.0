From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: cts - Remove bogus use of seqiv
Date: Fri, 16 Jan 2015 18:09:21 +1100
Message-ID: <20150116070921.GA8992@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Kevin Coffman <kwc@citi.umich.edu>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:42530 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbAPHJ1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Jan 2015 02:09:27 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The seqiv generator is completely inappropriate for cts as it's
designed for IPsec algorithms.  Since cts users do not actually
use the IV generator we can just fall back to the default.
 
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/cts.c b/crypto/cts.c
index bd94058..6a8089c 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -307,8 +307,6 @@ static struct crypto_instance *crypto_cts_alloc(struct rtattr **tb)
 	inst->alg.cra_blkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
 	inst->alg.cra_blkcipher.max_keysize = alg->cra_blkcipher.max_keysize;
 
-	inst->alg.cra_blkcipher.geniv = "seqiv";
-
 	inst->alg.cra_ctxsize = sizeof(struct crypto_cts_ctx);
 
 	inst->alg.cra_init = crypto_cts_init_tfm;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
