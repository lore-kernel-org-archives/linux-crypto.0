From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] RNG: Add Pseudo Random Number Generator to kernel
Date: Wed, 16 Jul 2008 21:44:56 +0800
Message-ID: <20080716134456.GA16546@gondor.apana.org.au>
References: <20080703202102.GB5237@hmsendeavour.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34207 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756012AbYGPNpA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jul 2008 09:45:00 -0400
Content-Disposition: inline
In-Reply-To: <20080703202102.GB5237@hmsendeavour.rdu.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 03, 2008 at 04:21:02PM -0400, Neil Horman wrote:
>> +	/*
> +	 * Now update our DT value
> +	 */
> +	for (i=DEFAULT_BLK_SZ-1;i>0;i--) {
> +		ctx->DT[i] = ctx->DT[i-1];
> +	}
> +	ctx->DT[0] += 1;

Is there any reason behind using this algorithm as opposed to
a simple counter?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
