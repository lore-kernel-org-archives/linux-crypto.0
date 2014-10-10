From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/2] crypto: caam - add support for rfc4106(gcm(aes))
Date: Fri, 10 Oct 2014 09:43:43 -0500
Message-ID: <20141010094343.24d567d9bc110549fdd981cf@freescale.com>
References: <1412866450-22587-1-git-send-email-tudor.ambarus@freescale.com>
	<1412866450-22587-2-git-send-email-tudor.ambarus@freescale.com>
	<20141009194358.dd99e22634005c93f462274d@freescale.com>
	<d162838411ed444f82f75bb211653b5a@DM2PR0301MB0720.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: Ambarus Tudor-Dan-B38632 <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0138.outbound.protection.outlook.com ([157.56.111.138]:24412
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752077AbaJJOtB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Oct 2014 10:49:01 -0400
In-Reply-To: <d162838411ed444f82f75bb211653b5a@DM2PR0301MB0720.namprd03.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 10 Oct 2014 05:10:55 -0500
Ambarus Tudor-Dan-B38632 <tudor.ambarus@freescale.com> wrote:

> On Thu, 9 Oct 2014 17:54:10 +0300
> Tudor Ambarus <tudor.ambarus@freescale.com> wrote:
> > +static int rfc4106_setauthsize(struct crypto_aead *authenc,
> > +			       unsigned int authsize)
> > +{
> > +	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
> > +
> > +	switch (authsize) {
> > +	case 8:
> > +	case 12:
> > +	case 16:
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> 
> the h/w can handle more authsizes than that, so we
> shouldn't be blocking it from doing so here.
> 
> [TA] rfc4106 says that "Implementations MUST support a full-length 16-octet ICV, and MAY support 8 or 12 octet ICVs, and MUST NOT support other ICV lengths."
> Do we want to support other ICV lengths?

how much the linux kernel wants to enforce the RFC is up to the
higher levels in its crypto API and other front end interfaces such
as XFRM. So those checks for RFC compliance should be performed
before they reach the implementation (driver).

Meanwhile, drivers themselves should accurately represent the h/w
capabilities, whether they meet and/or exceed the RFC's constraints
or not, IMO.  This way, if/when the RFC gets extended to become
open to a wider range of values, the driver needs no changes.

> > @@ -2601,6 +2986,23 @@ static struct caam_alg_template driver_algs[] = {
> >  				   OP_ALG_AAI_HMAC_PRECOMP,
> >  		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
> >  	},
> > +	{
> > +		.name = "rfc4106(gcm(aes))",
> > +		.driver_name = "rfc4106-gcm-aes-caam",
> > +		.blocksize = 1,
> > +		.type = CRYPTO_ALG_TYPE_AEAD,
> > +		.template_aead = {
> > +			.setkey = rfc4106_setkey,
> > +			.setauthsize = rfc4106_setauthsize,
> > +			.encrypt = aead_encrypt,
> > +			.decrypt = aead_decrypt,
> > +			.givencrypt = aead_givencrypt,
> > +			.geniv = "<built-in>",
> > +			.ivsize = 8,
> > +			.maxauthsize = 16,
> 
> AES_BLOCK_SIZE
> 
> [TA] I don't think we should change the blocksize value to AES_BLOCK_SIZE.

sorry, I meant just .maxauthsize = AES_BLOCK_SIZE.

Thanks,

Kim
