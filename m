From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: ESP hardware acceleration
Date: Tue, 15 Sep 2009 12:12:52 -0500
Message-ID: <20090915171252.GA30986@gondor.apana.org.au>
References: <200909151754.15716.opurdila@ixiacom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dimitris@siganos.org, linux-crypto@vger.kernel.org,
	abadea@ixiacom.com, ddogaru@ixiacom.com
To: Octavian Purdila <opurdila@ixiacom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40884 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751668AbZIORMv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Sep 2009 13:12:51 -0400
Content-Disposition: inline
In-Reply-To: <200909151754.15716.opurdila@ixiacom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Octavian Purdila <opurdila@ixiacom.com> wrote:
>
> AFAK, the crypto interface is asynchronous but the hashing interface (as used 
> in IPSec) is synchronous.
> 
> There are two patches I've recently seen on the list, one for converting to 
> async hashing and one for parallel crypto/ipsec which will probably get in 
> 2.6.32.

Yes they're now in Linus's tree so both hsahing and ciphers are
now async.

> However, I think that the best results for hw accel will be obtained if you 
> accelerate the AEAD interface.

If your driver benefits from seeing both the hashing request and the
cipher request at the same time then by all means go for the AEAD
interface.  But don't feel compelled to use it just because it's
there :)

> Speaking of hw accel, we are also playing with it and we got moderately good 
> results. We are now running into two major software bottlenecks: memcpy 
> (because of the copy required by TCP traffic) and CRC computation.

What platform is this? And where does CRC come into this?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
