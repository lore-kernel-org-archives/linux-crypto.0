From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] ixp4xx_crypto: avoid firmware loading during module
	initialisation
Date: Thu, 30 Oct 2008 12:27:56 +0800
Message-ID: <20081030042756.GA28753@gondor.apana.org.au>
References: <20080818064455.GK22567@mail3.prorata.de> <E1KVJFO-0007Vh-00@gondolin.me.apana.org.au> <20081023122832.GC16037@mail3.prorata.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Christian Hohnstaedt <christian@hohnstaedt.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:35383 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751573AbYJ3E2D (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Oct 2008 00:28:03 -0400
Content-Disposition: inline
In-Reply-To: <20081023122832.GC16037@mail3.prorata.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 23, 2008 at 02:28:32PM +0200, Christian Hohnstaedt wrote:
>
>  	atomic_set(&ctx->configuring, 0);
> +	switch ((image_id>>16) & 0xff) {
> +		case 3:
> +			if (cipher_cfg_enc(tfm) & MOD_AES) {
> +				printk(KERN_ERR "Firmware of %s lacks AES "
> +					"support\n", npe_name(npe_c));
> +				return -ENODEV;
> +			}
> +		case 4:
> +		case 5:
> +			break;
> +		default:
> +			printk(KERN_ERR "Firmware of %s lacks crypto support\n",
> +				npe_name(npe_c));
> +			return -ENODEV;
> +	}

By the time you're in init_tfm, it's too late to decide that
your hardware doesn't support AES since the API cannot fall
back to another algorithm at this point.

You need to determine whether AES is supported before you register
your algorithm.

Indeed, if the objective was to avoid loading the firmware during
module initialisation, then this patch doesn't actually achieve
that because we now test the algorithm at registration time so
init_tfm will be called during module initialisation.

In any case, firmware loading during module initialisation happens
for all sorts of hardware so I don't see why you're trying to
avoid it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
