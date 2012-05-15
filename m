From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/3] Update for ux500 CRYP and HASH
Date: Tue, 15 May 2012 17:26:11 +1000
Message-ID: <20120515072610.GA24175@gondor.apana.org.au>
References: <1336637648-10064-1-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, arnd@arndb.de, sfr@canb.auug.org.au,
	lee.jones@linaro.org, linus.walleij@linaro.org
To: Andreas Westin <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:47041 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757110Ab2EOH0Z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 May 2012 03:26:25 -0400
Content-Disposition: inline
In-Reply-To: <1336637648-10064-1-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 10, 2012 at 10:14:05AM +0200, Andreas Westin wrote:
> Hi,
> 
> V2 of the patches.
> 
> * Removed symbol export
> * Removed usage of SOC specific functions in the drivers.
> * Readded overlooked config for DMA in mach-ux500.
> 
> After some internal discussion we felt that the now implemented
> hardware identification solution is cleaner than the suggested
> solution.
> 
> The hardware identification patch applies cleanly to
> the cryptodev tree.
> 
> Regards
> Andreas
> 
> Andreas Westin (3):
>   mach-ux500: Crypto: core support for CRYP/HASH module.
>   crypto: ux500: Update DMA handling for 3.4
>   crypto: ux500: Cleanup hardware identification

All applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
