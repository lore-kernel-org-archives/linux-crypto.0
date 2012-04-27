From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 1/3] crypto: ux500: Add driver for CRYP hardware.
Date: Fri, 27 Apr 2012 11:33:15 +1000
Message-ID: <20120427013315.GC32567@gondor.apana.org.au>
References: <1335170935-12861-1-git-send-email-andreas.westin@stericsson.com>
 <1335170935-12861-2-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kim.phillips@freescale.com
To: Andreas Westin <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:48154 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758486Ab2D0BdV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Apr 2012 21:33:21 -0400
Content-Disposition: inline
In-Reply-To: <1335170935-12861-2-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 23, 2012 at 10:48:53AM +0200, Andreas Westin wrote:
>
> +config CRYPTO_DEV_UX500
> +	tristate "Driver for ST-Ericsson UX500 crypto hardware acceleration"
> +	#depends on ARCH_UX500
> +	select CRYPTO_ALGAPI
> +	help
> +	  Driver for ST-Ericsson UX500 crypto engine.

Please fix up the arch dependency so it doesn't break non-ux500
builds.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
