From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AF_ALG: hash returns -ENOKEY
Date: Wed, 27 Jan 2016 00:16:37 +0800
Message-ID: <20160126161637.GA24423@gondor.apana.org.au>
References: <6333443.68gdEOIkbe@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48441 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964834AbcAZQQl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 11:16:41 -0500
Content-Disposition: inline
In-Reply-To: <6333443.68gdEOIkbe@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 25, 2016 at 10:22:36PM +0100, Stephan Mueller wrote:
> Hi Herbert,
> 
> during testing of the current cryptodev-2.6 key, the AF_ALG hash does not seem 
> to work as it used to.

Oops, looks like I screwed up shash.

---8<---
Subject: crypto: shash - Fix has_key setting

The has_key logic is wrong for shash algorithms as they always
have a setkey function.  So we should instead be testing against
shash_no_setkey.

Fixes: a5596d633278 ("crypto: hash - Add crypto_ahash_has_setkey")
Cc: stable@vger.kernel.org
Reported-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/shash.c b/crypto/shash.c
index 88a27de..3597545 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -354,11 +354,10 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	crt->final = shash_async_final;
 	crt->finup = shash_async_finup;
 	crt->digest = shash_async_digest;
+	crt->setkey = shash_async_setkey;
+
+	crt->has_setkey = alg->setkey != shash_no_setkey;
 
-	if (alg->setkey) {
-		crt->setkey = shash_async_setkey;
-		crt->has_setkey = true;
-	}
 	if (alg->export)
 		crt->export = shash_async_export;
 	if (alg->import)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
