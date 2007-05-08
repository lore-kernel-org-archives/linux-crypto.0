From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: alignmask in the API
Date: Tue, 8 May 2007 19:17:01 +0200
Message-ID: <20070508171701.GB5234@Chamillionaire.breakpoint.cc>
References: <20070416212400.GA30547@Chamillionaire.breakpoint.cc> <E1HdgLJ-0004iw-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42955 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966217AbXEHRRI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 May 2007 13:17:08 -0400
Content-Disposition: inline
In-Reply-To: <E1HdgLJ-0004iw-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-04-17 15:35:05 [+1000]:

>It's the API's responsibility to guarantee alignment.  So in principle
>neither the user nor the algorithm need to worry about alignment.
>
>However, there is no point in doing an extra copy for the sake of
>alignment since the crypto API will do it for you anyway.

setkey() is for crypto user is defined as:
static inline int crypto_ablkcipher_setkey(struct crypto_ablkcipher
                *tfm,
                const u8 *key, unsigned int keylen)
{
        return crypto_ablkcipher_crt(tfm)->setkey(tfm, key, keylen);
}

If the key is not properly aligned by the caller, the cipher gets an
unaligned key.
What do you recommend?
 
>Cheers,
Sebastian
