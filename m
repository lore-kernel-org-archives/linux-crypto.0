From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Make CRYPTO_CBC select CRYPTO_ECHAINIV
Date: Mon, 11 Jan 2016 18:38:15 +0800
Message-ID: <20160111103815.GA24286@gondor.apana.org.au>
References: <568AC07B.8020605@gmx.de>
 <4445865.9O5pIU29W2@myon.chronox.de>
 <568AD989.8060802@gmx.de>
 <20160108094855.GA3472@gondor.apana.org.au>
 <5692BC22.4010903@gmx.de>
 <20160111033349.GA21571@gondor.apana.org.au>
 <6AC38649-C3F5-4D2D-8ED3-395C163D5695@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Thomas Egerer <hakke_007@gmx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35571 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758191AbcAKKib (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jan 2016 05:38:31 -0500
Content-Disposition: inline
In-Reply-To: <6AC38649-C3F5-4D2D-8ED3-395C163D5695@gmx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 11, 2016 at 11:36:18AM +0100, Thomas Egerer wrote:
>
> I was under the impression that ECHAINIV was the default IV generator for CBC. At least that's what the help text said. Upon further investigation I found that the default is either chainiv or eseqiv (according to crypto_default_geniv). In this case it's true, net/ipvx/Kconfig files need to be patched.

Perhaps we also need to patch the help test.  Only IPsec uses
IV generation through echainiv/eseqiv.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
