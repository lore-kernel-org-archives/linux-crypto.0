From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crash in ppc4xx-rng on canyonland
Date: Tue, 5 Apr 2016 20:11:19 +0800
Message-ID: <20160405121118.GA12591@gondor.apana.org.au>
References: <2309246.SDn0H6XuZk@debian64>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	jwboyer@linux.vnet.ibm.com, mpm@selenic.com
To: Christian Lamparter <chunkeey@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52539 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724AbcDEML0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2016 08:11:26 -0400
Content-Disposition: inline
In-Reply-To: <2309246.SDn0H6XuZk@debian64>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> wrote:
>
> The crash is caused by a bad read in ppc4xx_rng_enable [0]. From what I
> can tell, the driver is mapping the crypto control registers. The
> problem is that they are claimed by the main crypto driver: crypto4xx [1].
> 
> I'm not sure what to do in this case. In my opinion the crypto4xx driver
> should just initialize the trng [see patch]. I would like to move the
> trng into the crypto-ppc4xx, but given that this breaks some of the DTS
> out there I'm not sure.

I think you'll also need to ensure that the crypto module is
successfully loaded before the RNG is accessed.

It's probably easier to just merge the two drivers but still
maintaining the original driver names.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
