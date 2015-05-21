From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v9 3/5] crypto: drbg - add async seeding operation
Date: Thu, 21 May 2015 14:56:43 +0800
Message-ID: <20150521065643.GA21490@gondor.apana.org.au>
References: <3340545.QDDPvU7BuN@tachyon.chronox.de>
 <23102012.0an2QbkQix@tachyon.chronox.de>
 <20150521063618.GA21348@gondor.apana.org.au>
 <1887173.hBZISiAer1@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53101 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbbEUG4y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 02:56:54 -0400
Content-Disposition: inline
In-Reply-To: <1887173.hBZISiAer1@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 21, 2015 at 08:53:13AM +0200, Stephan Mueller wrote:
>
> Thank you for pointing that out - I have seen that too. But the crux is that 
> when using wait_event, the cancel function to serialize the destruction code 
> path will *not* return at all, even when the async callback function completed 
> successfully. Hence the choice for wait_event_interruptible

Why is that? It should return when the pool is initialised and
your work completes.  If it does not then that means either the
pool isn't initialising or somehow your code is racy and getting
stuck.

If it's racy then wait_event_interruptible is just hiding the
real problem.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
