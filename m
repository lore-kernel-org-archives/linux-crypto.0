From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing
 nonblocking_pool
Date: Mon, 18 May 2015 17:21:31 +0800
Message-ID: <20150518092131.GA18659@gondor.apana.org.au>
References: <1921857.OvxEu6y28S@tachyon.chronox.de>
 <34087343.u7K3uzbyiZ@tachyon.chronox.de>
 <20150515064626.GA16704@gondor.apana.org.au>
 <3672239.xqA2RrDaZY@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50715 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbbERJVr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 May 2015 05:21:47 -0400
Content-Disposition: inline
In-Reply-To: <3672239.xqA2RrDaZY@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 18, 2015 at 07:32:01AM +0200, Stephan Mueller wrote:
> 
> Thanks for the hint to the list. Before handing in another formal patch, may i ask for checking the following approach? I would think that this one should cover your concerns.

Yes this is definitely going in the right direction.

> +/*
> + * Equivalent function to get_random_bytes with the difference that this
> + * function blocks the request until the nonblocking_pool is initialized.
> + */
> +int get_blocking_random_bytes_cb(void *buf, int nbytes, void *private,
> +				 void (*cb)(void *buf, int buflen,
> +					    void *private))

You can simplify this further and get rid of buf/nbytes.  All
we need to know is whether the pool is ready.  Everything else
can come from private.

> +	struct random_work *rw = NULL;
> +	int ret = 0;

I think this function should return 0 if the pool is ready now,
-EINPROGRESS if it's not (indicating that the callback will be
called when it is ready) and otherwise an error.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
