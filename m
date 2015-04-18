From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto: drbg - replace spinlock with mutex
Date: Sat, 18 Apr 2015 18:55:23 +0800
Message-ID: <20150418105523.GB5408@gondor.apana.org.au>
References: <1551177.C0RmlOO9iU@myon.chronox.de>
 <2415536.7nqArbGB13@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55608 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbbDRKz2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 18 Apr 2015 06:55:28 -0400
Content-Disposition: inline
In-Reply-To: <2415536.7nqArbGB13@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 17, 2015 at 02:55:28PM +0200, Stephan Mueller wrote:
>
> @@ -1349,7 +1348,9 @@ static int drbg_generate_long(struct drbg_state *drbg,
>  		unsigned int chunk = 0;
>  		slice = ((buflen - len) / drbg_max_request_bytes(drbg));
>  		chunk = slice ? drbg_max_request_bytes(drbg) : (buflen - len);
> +		mutex_lock(&drbg->drbg_mutex);
>  		tmplen = drbg_generate(drbg, buf + len, chunk, addtl);
> +		mutex_unlock(&drbg->drbg_mutex);
>  		if (0 >= tmplen)
>  			return tmplen;

BTW I just noticed that we always return 0 now so this is broken.

> @@ -1377,10 +1378,12 @@ static int drbg_generate_long(struct drbg_state *drbg,
>  static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
>  			    int coreref, bool pr)
>  {
> -	int ret = -ENOMEM;
> +	int ret = -EOPNOTSUPP;
>  
>  	pr_devel("DRBG: Initializing DRBG core %d with prediction resistance "
>  		 "%s\n", coreref, pr ? "enabled" : "disabled");
> +	mutex_init(&drbg->drbg_mutex);

This shouldn't be here because the reset function will call this
and break.  This needs to be moved to cra_init.

Incidentally the whole reset concept seems redundant as you could
always free and allocate a new RNG instead.  So I'm planning on
replacing it with a seed/reseed function instead.  IOW it will
keep the existing state and just add in new data if it's already
seeded.

This will change our user-space API semantically but as you're the
only user I hope we won't need to add any backwards compatibility
cruft.

This also means that cra_init will no longer seed this and the RNG
won't be usable until seed is called.

Cheers,
- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
