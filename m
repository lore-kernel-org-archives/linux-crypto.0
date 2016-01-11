From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Make CRYPTO_CBC select CRYPTO_ECHAINIV
Date: Mon, 11 Jan 2016 11:33:49 +0800
Message-ID: <20160111033349.GA21571@gondor.apana.org.au>
References: <568AC07B.8020605@gmx.de>
 <4445865.9O5pIU29W2@myon.chronox.de>
 <568AD989.8060802@gmx.de>
 <20160108094855.GA3472@gondor.apana.org.au>
 <5692BC22.4010903@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Thomas Egerer <hakke_007@gmx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44181 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005AbcAKDeA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Jan 2016 22:34:00 -0500
Content-Disposition: inline
In-Reply-To: <5692BC22.4010903@gmx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 10, 2016 at 09:16:34PM +0100, Thomas Egerer wrote:
> On 01/08/2016 10:48 AM, Herbert Xu wrote:
>
> > Please patch net/ipvX/Kconfig instead as ECHAINIV is only used
> > by IPsec.
> This does not seem right to me. By depending on CRYPTO_CBC in a particular
> Kconfig, I would expect the 'default algorithm for CBC' to be transitively
> selected with it. It's what CRYPTO_CTR does. There are a couple of places
> that use select CRYPTO_CBC but not CRYPTO_ECHAINIV  (ext4, wusbcore, md
> to mention a few). Wouldn't these end up unusable too, if CBC-mode doesn't
> activate echainiv?

All of those other users should work without echainiv so why would
they need to select it?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
