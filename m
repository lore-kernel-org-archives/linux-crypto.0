From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: use list to stage async seeding requests
Date: Tue, 9 Jun 2015 14:49:55 +0800
Message-ID: <20150609064955.GA8794@gondor.apana.org.au>
References: <1758927.bAziGtcHhF@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, andreas.steffen@strongswan.org,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60375 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbbFIGuI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 02:50:08 -0400
Content-Disposition: inline
In-Reply-To: <1758927.bAziGtcHhF@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 06, 2015 at 04:16:54AM +0200, Stephan Mueller wrote:
> This patch uses a list to track the asynchronous seeding requests until
> the nonblocking pool is fully initialized. The random.c is provided with
> two API calls: the get_blocking_random_bytes_cb allows the caller to
> provide a callback function that is triggered once the nonblocking pool
> is initialized. If the nonblocking pool is already initialized at the
> time of invocation, the function is a noop. The second API call of
> get_blocking_random_bytes_cancel allows the caller to cancel an
> outstanding request.
> 
> The previous approach used a waitqueue for maintaining the requests
> until the nonblocking pool is initialized. In some circumstances, the
> wait can be very long (in the orders of minutes) where the use of
> waitqueues is not appropriate.
> 
> The patch also removes the entropy buffer registered with the DRBG
> handle in favor of stack variables to hold the seed data.
> 
> CC: Andreas Steffen <andreas.steffen@strongswan.org>
> CC: Theodore Ts'o <tytso@mit.edu>
> CC: Sandy Harris <sandyinchina@gmail.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

This patch still has many issues with repsect to work cancellation.
I've decided to do this myself.  I will post the result once I have
done some testing.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
