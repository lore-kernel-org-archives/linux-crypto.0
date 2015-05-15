From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing
 nonblocking_pool
Date: Fri, 15 May 2015 14:46:26 +0800
Message-ID: <20150515064626.GA16704@gondor.apana.org.au>
References: <1921857.OvxEu6y28S@tachyon.chronox.de>
 <34087343.u7K3uzbyiZ@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <34087343.u7K3uzbyiZ@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 13, 2015 at 09:54:41PM +0200, Stephan Mueller wrote:
>  /*
> + * Equivalent function to get_random_bytes with the difference that this
> + * function blocks the request until the nonblocking_pool is initialized.
> + */
> +void get_blocking_random_bytes(void *buf, int nbytes)
> +{
> +	if (unlikely(nonblocking_pool.initialized == 0))
> +		wait_event_interruptible(urandom_init_wait,
> +					 nonblocking_pool.initialized);
> +	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);

So what if the wait was interrupted? You are going to extract
entropy from an empty pool.

Anyway, you still haven't addressed my primary concern with this
model which is the potential for dead-lock.  Sleeping for an open
period of time like this in a work queue is bad form.  It may also
lead to dead-locks if whatever you're waiting for happened to use
the same work thread.

That's why I think you should simply provide a function and data
pointer which random.c can then stash onto a list to call when
the pool is ready.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
