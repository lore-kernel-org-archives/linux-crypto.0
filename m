From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Make CRYPTO_CBC select CRYPTO_ECHAINIV
Date: Fri, 8 Jan 2016 18:48:55 +0900
Message-ID: <20160108094855.GA3472@gondor.apana.org.au>
References: <568AC07B.8020605@gmx.de>
 <4445865.9O5pIU29W2@myon.chronox.de>
 <568AD989.8060802@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Thomas Egerer <hakke_007@gmx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49934 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbcAHJtL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jan 2016 04:49:11 -0500
Content-Disposition: inline
In-Reply-To: <568AD989.8060802@gmx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 04, 2016 at 09:43:53PM +0100, Thomas Egerer wrote:
> Similar to CTR mode selecting CRYPTO_SEQIV, CBC mode requires echainiv
> and has to select CRYPTO_ECHAINIV in order to work properly. This solves
> the issues caused by a misconfiguration as described in [1].
> 
> [1] https://lists.strongswan.org/pipermail/users/2015-December/009074.html
> 
> Signed-off-by: Thomas Egerer <hakke_007@gmx.de>

Please patch net/ipvX/Kconfig instead as ECHAINIV is only used
by IPsec.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
