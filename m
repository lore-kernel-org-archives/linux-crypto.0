From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Thu, 23 Apr 2015 09:33:37 +0800
Message-ID: <20150423013337.GB16834@gondor.apana.org.au>
References: <6218629.uO4632Hmli@myon.chronox.de>
 <20150422055324.GA7872@gondor.apana.org.au>
 <20150422061354.GA8053@gondor.apana.org.au>
 <5036814.6LNlN5eOjK@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33785 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbbDWBdn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 21:33:43 -0400
Content-Disposition: inline
In-Reply-To: <5036814.6LNlN5eOjK@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 22, 2015 at 02:23:04PM +0200, Stephan Mueller wrote:
>
> Isn't it a basic assumption to ablkcipher is that the ciphertext is equal in 
> size as the plaintext?

Not necessarily since a blkcipher also outputs IV which is exactly
what's happening in KW.

For the fixed IV value you could use givencrypt so you don't even
an rfc wrapper.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
