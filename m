From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 1/5] random: Async and sync API for accessing
 nonblocking_pool
Date: Mon, 11 May 2015 14:57:14 +0800
Message-ID: <20150511065714.GA2598@gondor.apana.org.au>
References: <1887272.cxqymnQQZn@tachyon.chronox.de>
 <3264123.O3YfJV7UGj@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44432 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbbEKG5a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 02:57:30 -0400
Content-Disposition: inline
In-Reply-To: <3264123.O3YfJV7UGj@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 08, 2015 at 08:41:30AM +0200, Stephan Mueller wrote:
> The added API calls provide a synchronous function call
> get_blocking_random_bytes where the caller is blocked until
> the nonblocking_pool is initialized.
> 
> In addition, an asynchronous API call of get_blocking_random_bytes_cb
> is provided which returns immediately to the caller after submitting
> the request for random data. The caller-provided buffer that shall be
> filled with random data is filled up as available entropy permits. The
> caller may provide a callback function that is invoked once the
> request is completed.
> 
> A third API call, get_blocking_random_bytes_cancel, is provided to
> cancel the random number gathering operation.

There are two problems with this patch:

1) The interface is way too complicated for a once off wait used
only during boot.  Really there is no need for cancellations.

2) There is potential for deadlock because you schedule a work that
then sits around until the entropy is available.  What if whatever
is generating that entropy used the same work thread in future?

So I suggest instead an interface that simply schedules a work
when the entropy is available.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
