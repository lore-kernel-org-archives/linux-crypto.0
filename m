From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: gcm - Filter out async ghash if necessary
Date: Wed, 15 Jun 2016 22:27:05 +0800
Message-ID: <20160615142705.GA18474@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33741 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370AbcFOO1I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 10:27:08 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As it is if you ask for a sync gcm you may actually end up with
an async one because it does not filter out async implementations
of ghash.

This patch fixes this by adding the necessary filter when looking
for ghash.

Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/gcm.c b/crypto/gcm.c
index bec329b..917b8fb 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -639,7 +639,9 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 
 	ghash_alg = crypto_find_alg(ghash_name, &crypto_ahash_type,
 				    CRYPTO_ALG_TYPE_HASH,
-				    CRYPTO_ALG_TYPE_AHASH_MASK);
+				    CRYPTO_ALG_TYPE_AHASH_MASK |
+				    crypto_requires_sync(algt->type,
+							 algt->mask));
 	if (IS_ERR(ghash_alg))
 		return PTR_ERR(ghash_alg);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
