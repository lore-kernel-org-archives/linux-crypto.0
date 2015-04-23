From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Thu, 23 Apr 2015 09:37:24 +0800
Message-ID: <20150423013724.GC16834@gondor.apana.org.au>
References: <6218629.uO4632Hmli@myon.chronox.de>
 <20150422061354.GA8053@gondor.apana.org.au>
 <5036814.6LNlN5eOjK@myon.chronox.de>
 <12434918.9URe3Fjl50@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40858 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbbDWBh3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 21:37:29 -0400
Content-Disposition: inline
In-Reply-To: <12434918.9URe3Fjl50@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 22, 2015 at 04:11:08PM +0200, Stephan Mueller wrote:
>
> One more issue to consider: the key wrapping is an authenticated encryption / 
> decryption. Thus, decryption can return EBADMSG, a feature a normal blkcipher 
> does not do.

We currently have a givdecrypt function that's completely unused.
You could easily use that to do the check and then return EBADMSG
and zero the output.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
