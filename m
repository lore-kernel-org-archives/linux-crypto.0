From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v2 05/25] crypto: ansi_cprng - Eliminate ctx->I and ctx->last_rand_data
Date: 14 Dec 2014 14:22:40 -0500
Message-ID: <20141214192240.15011.qmail@ns.horizon.com>
References: <9785762.pgn7FGFVr8@tachyon.chronox.de>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:63467 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751068AbaLNTWm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Dec 2014 14:22:42 -0500
In-Reply-To: <9785762.pgn7FGFVr8@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Due to the huge number of diffs, I may have missed the following point. 
> Therefore, please help me:

No problem at all!  If you're doing me the kindness of actually reading
and reviewing this, I have *lots* of time to act as a tour guide.

I've just had my nose in this code, and your memory is presumably a bit
rustier on some details, even if you understand the larger system better
than I do.

(I hope that English figure of speech isn't too obscure for you.)

> Where do I see that priming?

It's in the same place as it always has been: in fips_cprng_reset,
just below the comment "this primes our continuity test".

Patch 12 changes the priming call from get_prng_bytes to
_get_more_prng_bytes in order to get rid of the "rdata" stack buffer.

Patches 5 and 21 make inconsequential syntactic changes to the area.

> Note, this priming should have an ability to be disabled for performing the 
> CAVS tests as they (as stupid as it may sound) want the very first random 
> number after the seeding.

In this regard, I didn't touch the existing code, which distinguishes the
functions "fips_cprng_reset" which does the priming, and "cprng_reset"
which doesn't, and exports two struct crypto_alg interfaces to make them
both available.
