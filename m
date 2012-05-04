From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v7 0/3] crypto: ux500 crypto and hash driver
Date: Fri, 4 May 2012 19:56:52 +1000
Message-ID: <20120504095651.GA6994@gondor.apana.org.au>
References: <1335773479-10441-1-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kim.phillips@freescale.com
To: Andreas Westin <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:50397 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752293Ab2EDJ5B (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 May 2012 05:57:01 -0400
Content-Disposition: inline
In-Reply-To: <1335773479-10441-1-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 30, 2012 at 10:11:16AM +0200, Andreas Westin wrote:
> Resending, something seems to have gone wrong the first time.
> 
> Changed config to depend on correct ARCH, also removed an
> unnecessary if statement check in the hash driver.
> 
> This adds a driver for the ST-Ericsson ux500 crypto hardware
> module. It supports AES, DES and 3DES, the driver implements
> support for AES-ECB,CBC and CTR.
> 
> Patches are also available at: http://www.df.lth.se/~triad/ux500-crypto/

All applied to cryptodev.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
