From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: drbg - Use callback API for random readiness
Date: Tue, 9 Jun 2015 21:24:38 +0800
Message-ID: <20150609132438.GA12946@gondor.apana.org.au>
References: <20150609101830.GA10521@gondor.apana.org.au>
 <E1Z2GdB-0002mv-3N@gondolin.me.apana.org.au>
 <3448831.Xm980FM7Uq@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, andreas.steffen@strongswan.org,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57435 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbbFINYu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 09:24:50 -0400
Content-Disposition: inline
In-Reply-To: <3448831.Xm980FM7Uq@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 09, 2015 at 02:23:39PM +0200, Stephan Mueller wrote:
>
> I am wondering about the error here. The Jitter RNG has in its init function a 
> test to see whether the RNG really works on the hardware as there are still 
> systems out there that have no high-res timer (e.g. I have seen that on old 
> Android phones). If the Jitter RNG detects that the system is not appropriate, 
> it will not register.

If we have no jent and the pool isn't ready then we should at least
fail in FIPS mode.  If we weren't in FIPS mode we could block but
for now I'm going to go with the current behaviour of simply
continuing.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
