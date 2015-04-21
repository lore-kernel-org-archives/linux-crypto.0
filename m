From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [v2 PATCH 0/11] rng: New style interface
Date: Tue, 21 Apr 2015 07:48:10 -0400
Message-ID: <20150421114810.GB25852@hmsreliant.think-freely.org>
References: <20150421024436.GA28057@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46171 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbbDULsR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2015 07:48:17 -0400
Content-Disposition: inline
In-Reply-To: <20150421024436.GA28057@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 21, 2015 at 10:44:36AM +0800, Herbert Xu wrote:
> This series converts the crypto_rng interface over to the "new"
> style.  I'm putting it in quotes because this style has been
> around since 2008.  In fact, RNG was the very last interface
> type added before the introduction of the new style.
> 
> Eventually all existing interfaces should be converted over but
> obviously it's taking some time to get there :)
> 
> v2 uses kzfree instead of free for the temporary seed.
> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


For the ansi_cprng bits
Acked-by: Neil Horman <nhorman@tuxdriver.com>
