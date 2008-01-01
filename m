From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] xcbc: Fix algorithm leak when block size check fails
Date: Tue, 1 Jan 2008 15:50:04 +1100
Message-ID: <20080101045004.GA27410@gondor.apana.org.au>
References: <20080101044607.GA27124@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3081 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751150AbYAAEuI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 31 Dec 2007 23:50:08 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J9Z4n-0005PP-P5
	for <linux-crypto@vger.kernel.org>; Tue, 01 Jan 2008 15:50:06 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1J9Z4n-00078O-00
	for <linux-crypto@vger.kernel.org>; Tue, 01 Jan 2008 15:50:05 +1100
Content-Disposition: inline
In-Reply-To: <20080101044607.GA27124@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 01, 2008 at 03:46:07PM +1100, Herbert Xu wrote:
> 
> While back-porting xcbc I found this little buglet.

And here's another one:

[CRYPTO] xcbc: Remove bogus hash/cipher test

When setting the digest size xcbc tests to see if the underlying algorithm
is a hash.  This is silly because we don't allow it to be a hash and we've
specifically requested for a cipher.

This patch removes the bogus test.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index e3d9503..a82959d 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -321,10 +321,7 @@ static struct crypto_instance *xcbc_alloc(struct rtattr **tb)
 	inst->alg.cra_alignmask = alg->cra_alignmask;
 	inst->alg.cra_type = &crypto_hash_type;
 
-	inst->alg.cra_hash.digestsize =
-		(alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-		CRYPTO_ALG_TYPE_HASH ? alg->cra_hash.digestsize :
-				       alg->cra_blocksize;
+	inst->alg.cra_hash.digestsize = alg->cra_blocksize;
 	inst->alg.cra_ctxsize = sizeof(struct crypto_xcbc_ctx) +
 				ALIGN(inst->alg.cra_blocksize * 3, sizeof(void *));
 	inst->alg.cra_init = xcbc_init_tfm;

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
