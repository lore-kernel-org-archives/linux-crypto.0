From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto driver -DCP
Date: Fri, 29 May 2015 21:30:18 +0800
Message-ID: <20150529133018.GB20596@gondor.apana.org.au>
References: <554BBD05.3050807@freescale.com>
 <201505290329.59713.marex@denx.de>
 <20150529013211.GA15566@gondor.apana.org.au>
 <201505291502.59208.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jay Monkman <jay.monkman@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34894 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbbE2Na1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2015 09:30:27 -0400
Content-Disposition: inline
In-Reply-To: <201505291502.59208.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 29, 2015 at 03:02:59PM +0200, Marek Vasut wrote:
>
> This does look somewhat hacky to me. Wouldn't it make more sense to
> add a CRYPTO_TFM_REQ flag ?

What are you going to do when you have more than one hard-coded
key? A flag is a non-starter.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
