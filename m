From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Alignment in the API, once again
Date: Thu, 2 Aug 2007 01:02:40 +0200
Message-ID: <20070801230240.GA18744@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41009 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350AbXHAXCu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Aug 2007 19:02:50 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Herbert, 

about the aligment in the crypto API, I'm lost once again.
In commit f10b7897ee29649fa7f0ccdc8d859ccd6ce7dbfd you extended the
alignment to be as wide as possible (i.e. algo specified 3, natural is
8, do 8).
Currently crypto_ctxsize(), what is used by __crypto_alloc_tfm() in
order to allocate space for tfm + priv ctx, looks like:

 len = alg->cra_alignmask & ~(crypto_tfm_ctx_alignment() - 1);
 if (type_obj)
        return len + type_obj->ctxsize(alg, type, mask);

Now, in my case alg->cra_alignmask is 15 and crypto_tfm_ctx_alignment()
returns 8 (ppc64). This makes 15 & ~(8-1) = 8 or too less. My mistake,
make it 16 instead of 15 and everything is fine again. aes.c + cbc.c
specify a mask of 3. The same thing once again: 3 & ~(8-1) = 0. This
makes me thing, that the line that calculates len, should maybe be 

 len = alg->cra_alignmask | (crypto_tfm_ctx_alignment() - 1);

or?
I noticed this, after my code did not work properly. The reason was,
that my private ctx was not retrieved with
crypto_ablkcipher_ctx_aligned() (attached) but with
crypto_ablkcipher_ctx() (and it was not properly aligned anymore).
My fault right? 
Shouldn't the behavior of crypto_blkcipher_ctx_aligned() (which is
currently unused) be the default one?

Sebastian
---

--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -160,6 +160,11 @@ static inline void *crypto_ablkcipher_ct
 	return crypto_tfm_ctx(&tfm->base);
 }
 
+static inline void *crypto_ablkcipher_ctx_aligned(struct crypto_ablkcipher *tfm)
+{
+	return crypto_tfm_ctx_aligned(&tfm->base);
+}
+
 static inline struct crypto_blkcipher *crypto_spawn_blkcipher(
 	struct crypto_spawn *spawn)
 {
