From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v3 02/16] crypto: add a new driver for Marvell's CESA
Date: Mon, 25 May 2015 10:18:11 +0200
Message-ID: <20150525101811.0ecbf819@bbrezillon>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
	<1432301642-11470-3-git-send-email-boris.brezillon@free-electrons.com>
	<20150525080547.GB28689@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:55347 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750843AbbEYISP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 May 2015 04:18:15 -0400
In-Reply-To: <20150525080547.GB28689@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 25 May 2015 16:05:47 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Fri, May 22, 2015 at 03:33:48PM +0200, Boris Brezillon wrote:
> >
> > +struct ahash_alg mv_ahmac_sha1_alg = {
> > +	.init = mv_cesa_ahmac_sha1_init,
> > +	.update = mv_cesa_ahash_update,
> > +	.final = mv_cesa_ahash_final,
> > +	.finup = mv_cesa_ahash_finup,
> > +	.digest = mv_cesa_ahmac_sha1_digest,
> > +	.setkey = mv_cesa_ahmac_sha1_setkey,
> > +	.halg = {
> > +		.digestsize = SHA1_DIGEST_SIZE,
> > +		.statesize = sizeof(struct sha1_state),
> > +		.base = {
> > +			.cra_name = "hmac(sha1)",
> > +			.cra_driver_name = "mv-hmac-sha1",
> > +			.cra_priority = 300,
> > +			.cra_flags = CRYPTO_ALG_ASYNC |
> > +				     CRYPTO_ALG_KERN_DRIVER_ONLY,
> > +			.cra_blocksize = SHA1_BLOCK_SIZE,
> > +			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
> > +			.cra_init = mv_cesa_ahmac_cra_init,
> > +			.cra_module = THIS_MODULE,
> > +		 }
> > +	}
> > +};
> 
> So your hmac implementation is purely done in software.  Since
> you've already written the code, could you please generalise this
> and make it a template?

Hm, I'm not I understand what you mean: the CESA engine is supporting
hardware HMAC.
What makes you think I'm doing the HMAC operation in software (I guess
I haven't properly filled the ahash_alg structure :-)) ?


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
