From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing
 nonblocking_pool
Date: Wed, 20 May 2015 06:55:33 +0800
Message-ID: <20150519225533.GA5718@gondor.apana.org.au>
References: <1921857.OvxEu6y28S@tachyon.chronox.de>
 <1637466.ZUdUCXWXVs@tauon>
 <20150519143022.GC32663@gondor.apana.org.au>
 <1889464.W6X1COIBGJ@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, pebolle@tiscali.nl,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56258 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbbESWzp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 May 2015 18:55:45 -0400
Content-Disposition: inline
In-Reply-To: <1889464.W6X1COIBGJ@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 19, 2015 at 04:36:58PM +0200, Stephan Mueller wrote:
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 9cd6968..6f71354 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1245,6 +1245,20 @@ void get_random_bytes(void *buf, int nbytes)
>  EXPORT_SYMBOL(get_random_bytes);
>  
>  /*
> + * Equivalent function to get_random_bytes with the difference that this
> + * function blocks the request until the nonblocking_pool is initialized.
> + */
> +void get_blocking_random_bytes(void *buf, int nbytes)
> +{
> +       if (unlikely(nonblocking_pool.initialized == 0))
> +               wait_event_interruptible(urandom_init_wait,
> +                                        nonblocking_pool.initialized);
> +       extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
> +}
> +EXPORT_SYMBOL(get_blocking_random_bytes);

You still need to handle the case where wait_event_interruptible
returns an error.  Otherwise this looks fine.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
