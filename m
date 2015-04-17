From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: DRBG seeding
Date: Fri, 17 Apr 2015 21:11:37 +0800
Message-ID: <20150417131137.GA27060@gondor.apana.org.au>
References: <20150416143617.GA17178@gondor.apana.org.au>
 <3303782.1Fl4anZ2PL@myon.chronox.de>
 <20150417021430.GA22835@gondor.apana.org.au>
 <2956307.5uMbChcz7z@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Steffen <andreas.steffen@strongswan.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59672 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbbDQNLo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 09:11:44 -0400
Content-Disposition: inline
In-Reply-To: <2956307.5uMbChcz7z@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 17, 2015 at 02:48:51PM +0200, Stephan Mueller wrote:
>
> Do you really think that this is possible? If the DRBG becomes the stdrng, you 
> would imply that those callers (e.g. IPSEC) may suffer from a long block (and 
> with long I mean not just seconds, but minutes).

It's only 49 bytes for every 64K so I think it's reasonable.
The only reason someone would use this is to comply with the
standard and this is what the standard requires so I don't see
how we can do anything else.
 
> Furthermore, I fail to see the difference between the current default stdrng 
> (krng -- which is just get_random_bytes in disguise). Thus, the current 
> situation with the DRBG seeding is not different from the non-DRBG use case.

The difference is that krng doesn't have to satisfy any standard.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
