From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 02/16] crypto: add a new driver for Marvell's CESA
Date: Mon, 25 May 2015 16:05:47 +0800
Message-ID: <20150525080547.GB28689@gondor.apana.org.au>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
 <1432301642-11470-3-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43050 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbbEYIGe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 May 2015 04:06:34 -0400
Content-Disposition: inline
In-Reply-To: <1432301642-11470-3-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 22, 2015 at 03:33:48PM +0200, Boris Brezillon wrote:
>
> +struct ahash_alg mv_ahmac_sha1_alg = {
> +	.init = mv_cesa_ahmac_sha1_init,
> +	.update = mv_cesa_ahash_update,
> +	.final = mv_cesa_ahash_final,
> +	.finup = mv_cesa_ahash_finup,
> +	.digest = mv_cesa_ahmac_sha1_digest,
> +	.setkey = mv_cesa_ahmac_sha1_setkey,
> +	.halg = {
> +		.digestsize = SHA1_DIGEST_SIZE,
> +		.statesize = sizeof(struct sha1_state),
> +		.base = {
> +			.cra_name = "hmac(sha1)",
> +			.cra_driver_name = "mv-hmac-sha1",
> +			.cra_priority = 300,
> +			.cra_flags = CRYPTO_ALG_ASYNC |
> +				     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +			.cra_blocksize = SHA1_BLOCK_SIZE,
> +			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
> +			.cra_init = mv_cesa_ahmac_cra_init,
> +			.cra_module = THIS_MODULE,
> +		 }
> +	}
> +};

So your hmac implementation is purely done in software.  Since
you've already written the code, could you please generalise this
and make it a template?

When you're done just add it to crypto/hmac.c and have it operate
on ahash algorithms while the existing hmac can continue to oeprate
on shash ones.  For an example of a template that operates on two
different types of algorithms check out crypto/seqiv.c.  I'm happy
to help you with the glue code should you have any issues.

This way the next guy who comes along won't have to rewrite hmac
yet again.  Who knows one of our existing hash drivers may also
be doing things purely in software and then we can kill the duplicate
code.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
