From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] AF_ALG interface for akcipher
Date: Thu, 23 Jul 2015 13:19:09 +0800
Message-ID: <20150723051909.GA11146@gondor.apana.org.au>
References: <3908391.JkjAozYBaW@tachyon.chronox.de>
 <20150722013241.GA31240@gondor.apana.org.au>
 <55AF19D0.5040700@intel.com>
 <55AF855A.9000202@freescale.com>
 <20150723015303.GA9777@gondor.apana.org.au>
 <55B07836.5050307@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org,
	Tudor =?utf-8?B?QW1ixINydciZ?= <tudor.ambarus@freescale.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39213 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbbGWFTR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jul 2015 01:19:17 -0400
Content-Disposition: inline
In-Reply-To: <55B07836.5050307@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 22, 2015 at 10:14:30PM -0700, Tadeusz Struk wrote:
>
> We can add a flag to akcipher_request to say if src/dst are SGs or buffers, but
> is this really necessary?

No it shouldn't be done as a flag.  If we are going to do SGs then
it needs to be part of the API.  That means replacing src/dst
pointers with SG lists.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
