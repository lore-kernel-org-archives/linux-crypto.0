From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 4/6] crypto: drbg - add async seeding operation
Date: Fri, 1 May 2015 11:13:31 +0800
Message-ID: <20150501031331.GA32741@gondor.apana.org.au>
References: <11175802.HG0pHJfshY@myon.chronox.de>
 <26987163.Lvcqt6Smju@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44976 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbbEADNs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Apr 2015 23:13:48 -0400
Content-Disposition: inline
In-Reply-To: <26987163.Lvcqt6Smju@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 28, 2015 at 05:00:03AM +0200, Stephan Mueller wrote:
>
> @@ -1081,6 +1115,11 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
>  		return -EINVAL;
>  	}
>  
> +	/* cancel any previously invoked seeding */
> +	mutex_unlock(&drbg->drbg_mutex);
> +	drbg_async_work_cancel(&drbg->seed_work);
> +	mutex_lock(&drbg->drbg_mutex);

This seems dangerous and unnecessary.  Releasing and reacquiring
the locks may invalidate previous checks.  Even if it doesn't
matter today if somebody modifies the callers later on this could
explode.

You can easily remove this by making get_blocking_random_bytes_cb
idempotent, i.e., do nothing if the work is already queued, which
is what it would do anyway if you simply move the INIT_WORK out of
it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
