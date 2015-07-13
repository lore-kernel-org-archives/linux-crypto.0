From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/14] crypto: aead - Phase oute seqniv
Date: Mon, 13 Jul 2015 17:13:49 +0800
Message-ID: <20150713091349.GA9579@gondor.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
 <1566279.T44EXs4eLd@tauon.atsec.com>
 <20150711023918.GB24197@gondor.apana.org.au>
 <4183187.0RpMVHFSDO@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53065 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbbGMJNx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jul 2015 05:13:53 -0400
Content-Disposition: inline
In-Reply-To: <4183187.0RpMVHFSDO@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 13, 2015 at 11:09:34AM +0200, Stephan Mueller wrote:
>
> That code now works with rfc4106(gcm(aes)). But using that code now fails with 
> the "regular" GCM implementation as well as CCM. The regular GCM 
> implementation works when not providing the IV as part of the SGL/set_ad. Is 
> that difference between "regular" AEAD and RFC4106 AEAD intended?

Yes of course.  As RFC4106 specifies that the IV should not be part
of the AD.

> Apart from the GCM vs RFC4106 invocation, the code seemingly requires to 
> provide the IV twice -- once with the buffer/set_ad and once with the 
> set_crypt call. Is that intended? Providing the IV twice is visible in the 
> testmgr.h patch where .assoc now includes the previous .assoc plus the IV data 
> which is also set in .iv.

Yes it is intended.  I played with not requiring req->iv at all
and just getting it from the AD but the code turned out to be more
complicated because you have to jump through hoops to access the IV
which you need to to construct the full 16-byte IV.

Since the primary user IPsec easily provides us with both I think
that is the better setup.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
