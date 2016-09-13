From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 3/8] hwrng: omap - Switch to non-obsolete read API
 implementation
Date: Tue, 13 Sep 2016 17:48:25 +0800
Message-ID: <20160913094825.GA30645@gondor.apana.org.au>
References: <20160907155743.6403-1-romain.perier@free-electrons.com>
 <20160907155743.6403-4-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dsaxena@plexity.net, mpm@selenic.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Yahuda Yitschak <yehuday@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Neta Zur Hershkovits <neta@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36223 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755891AbcIMJtT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 05:49:19 -0400
Content-Disposition: inline
In-Reply-To: <20160907155743.6403-4-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 07, 2016 at 05:57:38PM +0200, Romain Perier wrote:
> +
> +static int omap_rng_do_read(struct hwrng *rng, void *data, size_t max,
> +			    bool wait)
>  {
>  	struct omap_rng_dev *priv;
> -	int data, i;
>  
>  	priv = (struct omap_rng_dev *)rng->priv;
>  
> -	for (i = 0; i < 20; i++) {
> -		data = priv->pdata->data_present(priv);
> -		if (data || !wait)
> -			break;
> -		/* RNG produces data fast enough (2+ MBit/sec, even
> -		 * during "rngtest" loads, that these delays don't
> -		 * seem to trigger.  We *could* use the RNG IRQ, but
> -		 * that'd be higher overhead ... so why bother?
> -		 */
> -		udelay(10);

So in the wait case you're changing the driver's behaviour.  Instead
of waiting for 1us you'll now wait for 1s if there is no data.  Is
this what really what you want?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
