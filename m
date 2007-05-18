From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] [CRYPTO] add alignment for setkey()
Date: Fri, 18 May 2007 16:30:01 +1000
Message-ID: <20070518063001.GA16171@gondor.apana.org.au>
References: <20070510095717.GD26502@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4053 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751908AbXERGaF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 May 2007 02:30:05 -0400
Content-Disposition: inline
In-Reply-To: <20070510095717.GD26502@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 10, 2007 at 11:57:17AM +0200, Sebastian Siewior wrote:
> setkey() in {cipher,blkcipher,ablkcipher,hash}.c does not respect the
> requested alignment by the algorithm. This patch fixes it.

Thanks for the patch!
  
> +static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen,
> +		unsigned long alignmask)
> +{
> +	struct cipher_alg *cia = &tfm->__crt_alg->cra_cipher;
> +	u8 buffer[keylen + alignmask];

Hmm, I'm not comfortable with this since keylen could be unbounded,
especially for hash algorithms.  How about getting the memory via
kmalloc instead?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
