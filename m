From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: DRBG seeding
Date: Sat, 18 Apr 2015 09:36:18 +0800
Message-ID: <20150418013618.GC1329@gondor.apana.org.au>
References: <20150416143617.GA17178@gondor.apana.org.au>
 <2278042.JS7c5BLrbA@myon.chronox.de>
 <20150418012744.GA1329@gondor.apana.org.au>
 <3151046.CNv2ChE2Gl@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Steffen <andreas.steffen@strongswan.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49969 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbbDRBgZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 21:36:25 -0400
Content-Disposition: inline
In-Reply-To: <3151046.CNv2ChE2Gl@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 18, 2015 at 03:32:03AM +0200, Stephan Mueller wrote:
>
> In any case, I am almost ready with the patch for an async seeding. Though, I 
> want to give it a thorough testing.

I don't see the point of async seeding, unless you're also making
all generate calls block until the seeding is complete.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
