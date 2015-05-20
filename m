From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v7 1/5] random: Blocking API for accessing
 nonblocking_pool
Date: Thu, 21 May 2015 02:45:35 +0800
Message-ID: <20150520184535.GA15438@gondor.apana.org.au>
References: <1693038.ndeE0L22jl@tachyon.chronox.de>
 <143216583.t5fUODkLsI@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39334 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbbETSpt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 May 2015 14:45:49 -0400
Content-Disposition: inline
In-Reply-To: <143216583.t5fUODkLsI@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 20, 2015 at 07:44:39PM +0200, Stephan Mueller wrote:
>
> +	if (unlikely(nonblocking_pool.initialized == 0)) {
> +		do {
> +			rc = wait_event_interruptible(urandom_init_wait,
> +						nonblocking_pool.initialized);
> +		} while (rc == -ERESTARTSYS);

This is just a convoluted way of doing an uninterruptible sleep.
Either make it uninterruptible or allow the function to return
an error.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
