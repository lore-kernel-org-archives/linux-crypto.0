From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 4/5] [crypto] geode: add fallback for unsupported modes.
Date: Sun, 21 Oct 2007 16:31:58 +0800
Message-ID: <20071021083158.GD9397@gondor.apana.org.au>
References: <1192788233-14968-1-git-send-email-linux-crypto@ml.breakpoint.cc> <1192788233-14968-5-git-send-email-linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1662 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751203AbXJUIcB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Oct 2007 04:32:01 -0400
Content-Disposition: inline
In-Reply-To: <1192788233-14968-5-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 19, 2007 at 12:03:52PM +0200, Sebastian Siewior wrote:
> From: Sebastian Siewior <sebastian@breakpoint.cc>
> 
> The Geode AES crypto engine supports only 128 bit long key. This
> patch adds fallback for other key sizes which are required by the
> AES standard.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Thanks for working on this!

> +	if (type == CRYPTO_ALG_TYPE_BLKCIPHER) {
> +		op->fallback.blk = crypto_alloc_blkcipher(name, 0,
> +				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
> +
> +	} else if (type == CRYPTO_ALG_TYPE_CIPHER) {
> +		op->fallback.cip = crypto_alloc_cipher(name, 0,
> +				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
> +	} else {
> +		printk(KERN_ERR "%s is neither a cipher nor a block cipher: %x\n",
> +				name, type);
> +		return -EINVAL;
> +	}

This looks really icky though.  Couldn't we just have different
functions for each case (blkcipher vs. cipher)?

>  static struct crypto_alg geode_ecb_alg = {
>  	.cra_name		=	"ecb(aes)",
> -	.cra_driver_name	=	"ecb-aes-geode-128",
> -	.cra_priority		=	400,
> -	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
> +	.cra_driver_name	=	"ecb-aes-geode",
> +	.cra_priority		=	300,

What's with the priority decrease?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
