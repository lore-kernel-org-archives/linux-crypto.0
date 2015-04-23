From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Thu, 23 Apr 2015 10:03:08 +0800
Message-ID: <20150423020308.GA17431@gondor.apana.org.au>
References: <6218629.uO4632Hmli@myon.chronox.de>
 <2382170.NBi3QxkUu4@myon.chronox.de>
 <20150423014609.GA17267@gondor.apana.org.au>
 <3845789.gd1dJWGSe8@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40738 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbbDWCDM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 22:03:12 -0400
Content-Disposition: inline
In-Reply-To: <3845789.gd1dJWGSe8@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 23, 2015 at 03:58:37AM +0200, Stephan Mueller wrote:
>
> So we have another memcpy just to copy that block into the IV field just to 
> have the KW cipher implementation copy it to some other location again? I do 
> not see the value of it.

But you already do that extra copy anyway:

+       crypto_kw_scatterwalk_memcpy(&dst_walk, &dst_nbytes, block.A,
+                                         SEMIBSIZE, true);

If you did it with an IV, this memcpy would disappear from the
blkcipher code.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
