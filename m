From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC] crypto: drbg - lower reseed threshold if seed source
 is degraded
Date: Tue, 9 Jun 2015 22:25:25 +0800
Message-ID: <20150609142524.GA14316@gondor.apana.org.au>
References: <1546948.ChzZZVGUza@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: andreas.steffen@strongswan.org, Ted Tso <tytso@mit.edu>,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37756 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbbFIOZe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 10:25:34 -0400
Content-Disposition: inline
In-Reply-To: <1546948.ChzZZVGUza@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 07, 2015 at 12:04:17AM +0200, Stephan Mueller wrote:
> Hi,
> 
> may I ask for review of the following patch. I would like particular feedback
> to the initial threshold value, which the patch currently sets to 50 (requests
> by a caller to the DRBG for random numbers). Thank you.
> 
> I am not sure about this value because there are two conflicting issues
> revolving around this value:
> 
> 1. We have to ensure that the DRBG has a sufficiently entropic internal state.
> That would mean, I should set that value as low as possible.
> 
> 2. This is the more problematic one: when considering information theory, if
> you draw from a DRNG (which the nonblocking pool is in the worst case -- and
> the boot time discussed below is our worst case) that is not fully seeded, you
> reduce the entropy in that DRNG (contrary to conventional wisdom). For the
> discussion, let us assume the worst case that there is coming in one bit of
> entropy at a time into the discussed DRNG. In between the addition of each bit
> of entropy, an attacker can access the DRNG (i.e. the SHA1 output of the
> nonblocking_pool). When only one bit of entropy is added to the
> nonblocking_pool, the attack complexity would be 1 bit. When an attacker would
> access the nonblocking_pool after each received bit, in the worst case, the
> attack complexity is not 2**128 but rather 256 (i.e. 1 bit for each individual
> attack between the addition of one new bit of entropy). So, the total attack
> complexity is the sum of the individual attack complexities (i.e. the
> complexity added after the previous attack is performed). This issue is
> aggravated by the nonblocking pool as the entropy counter used for declaring
> that the threshold defining the that nonblocking pool is initialized is never
> decreased by requests, but only increased. So, with that issue in mind, we
> want to set the reseed threshold of the DRBG to rather a higher level.
> 
> Thus I am struggling to find the right(TM) initial value for the reseeding
> threshold.
> 
> Or maybe you can tell me that there is no need for the patch to begin with as
> the initial seed plus the async request to the nonblocking pool is good as is.
> :-)
> 
> Note, this patch is on top of the patch updating the async reseeding sent out 
> yesterday.

Well it makes perfect sense if you don't trust Jitter RNG to return
the amount of entropy it claims to return :)

Anyway, I'm happy to apply this.  However, the patch is corrupted
so please resend it without the white-space damage/line wrapping.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
