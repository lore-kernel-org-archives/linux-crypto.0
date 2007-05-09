From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: alignmask in the API
Date: Wed, 9 May 2007 13:40:24 +1000
Message-ID: <20070509034024.GA32283@gondor.apana.org.au>
References: <20070416212400.GA30547@Chamillionaire.breakpoint.cc> <E1HdgLJ-0004iw-00@gondolin.me.apana.org.au> <20070508171701.GB5234@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4450 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967364AbXEIDk3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 May 2007 23:40:29 -0400
Content-Disposition: inline
In-Reply-To: <20070508171701.GB5234@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 08, 2007 at 07:17:01PM +0200, Sebastian Siewior wrote:
> 
> setkey() is for crypto user is defined as:
> static inline int crypto_ablkcipher_setkey(struct crypto_ablkcipher
>                 *tfm,
>                 const u8 *key, unsigned int keylen)
> {
>         return crypto_ablkcipher_crt(tfm)->setkey(tfm, key, keylen);
> }
> 
> If the key is not properly aligned by the caller, the cipher gets an
> unaligned key.
> What do you recommend?

I recommend that you write a patch :)

We just need some code in {cipher,blkcipher,ablkcipher}.c to check the
alignment and copy it if necessary.  Check out how we deal with unaligned
IVs in blkcipher.c for example.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
