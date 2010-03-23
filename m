From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Tue, 23 Mar 2010 19:32:39 +0800
Message-ID: <20100323113239.GA29837@gondor.apana.org.au>
References: <cover.1268830685.git.dmitry.kasatkin@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [216.59.3.182] ([216.59.3.182]:43546 "EHLO arnor.apana.org.au"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752019Ab0CWMNa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Mar 2010 08:13:30 -0400
Content-Disposition: inline
In-Reply-To: <cover.1268830685.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 17, 2010 at 03:12:49PM +0200, Dmitry Kasatkin wrote:
> Earlier kernel contained omap sha1 and md5 driver, which was not maintained,
> was not ported to new crypto APIs and removed from the source tree.
> 
> This driver implements async and sync crypto API.
> 
> It still contains pr_debug() for debugging purpose.
> Will be remove for integration.
> 
> Dmitry Kasatkin (2):
>   sec: omap sha1 & md5 driver
>   sec: Makefile/Kconfig update for omap sha1 md5 driver

It looks good to me as far as the Crypto API is concerned.

My only question is what's your plan with respect to HMAC? If
you're going to do it in hardware then it's fine as it is.

Otherwise you need to implement export/import and we also need
to add ahash support to hmac.c.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
