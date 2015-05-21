From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v9 3/5] crypto: drbg - add async seeding operation
Date: Thu, 21 May 2015 14:36:18 +0800
Message-ID: <20150521063618.GA21348@gondor.apana.org.au>
References: <3340545.QDDPvU7BuN@tachyon.chronox.de>
 <12904468.qCSNRrkb6t@tachyon.chronox.de>
 <20150520214408.GA17264@gondor.apana.org.au>
 <23102012.0an2QbkQix@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58264 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbbEUGg3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 02:36:29 -0400
Content-Disposition: inline
In-Reply-To: <23102012.0an2QbkQix@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 21, 2015 at 08:10:13AM +0200, Stephan Mueller wrote:
>
> The cancel operation is needed as otherwise my drbg context handle will be 
> removed by the crypto API during the sleep. That is the whole reason why 
> wait_event_interruptible is used.
> 
> So, even when using an uninterruptible sleep, the crypto API has no knowledge 
> about it and I have to serialize the destruction code path with the async 
> callback.

I understand.  But if you use the uniterruptible version at least
you won't have to deal with bogus early returns.

The cancel by itself will *not* cause wait_event_interruptible
to return early.  Somebody has to send it a signal for that to
happen.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
