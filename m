From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Fri, 24 Apr 2015 07:21:05 +0800
Message-ID: <20150423232105.GC26635@gondor.apana.org.au>
References: <6218629.uO4632Hmli@myon.chronox.de>
 <1470287.z00squjPAu@myon.chronox.de>
 <20150423025558.GA17870@gondor.apana.org.au>
 <2261126.vD1ovnGobO@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55218 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031132AbbDWXVK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Apr 2015 19:21:10 -0400
Content-Disposition: inline
In-Reply-To: <2261126.vD1ovnGobO@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 23, 2015 at 03:42:19PM +0200, Stephan Mueller wrote:
>
> Now, shall I kind of re-implement the chainiv ablkcipher wrapper into an IV 
> handler that just helps my code? That will be a lot of code for a simple 
> memcmp.

No no no.  You don't need to do a template for givencrypt.  chainiv
is a template because it can be used by any blkcipher.  In your case
your fixed IV is only used by you.  So just implement givencrypt and
givdecrypt directly in your blkcipher (or ablkcipher rather because
only ablkcipher supports givencrypt/givdecrypt).

If you really want to keep the underlying kw as a blkcipher for the
sake of simplicity you could go back to the wrapper idea and have
the rfc wrapper around kw as an ablkcipher so that you can add the
givencrypt/givdecrypt calls.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
