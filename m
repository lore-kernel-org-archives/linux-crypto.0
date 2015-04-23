From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Thu, 23 Apr 2015 09:46:09 +0800
Message-ID: <20150423014609.GA17267@gondor.apana.org.au>
References: <6218629.uO4632Hmli@myon.chronox.de>
 <5036814.6LNlN5eOjK@myon.chronox.de>
 <20150423013337.GB16834@gondor.apana.org.au>
 <2382170.NBi3QxkUu4@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60890 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbbDWBqO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 21:46:14 -0400
Content-Disposition: inline
In-Reply-To: <2382170.NBi3QxkUu4@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 23, 2015 at 03:39:11AM +0200, Stephan Mueller wrote:
>
> The KW does not return an IV. The IV is used for encryption to stir the 
> encryption a bit. The resulting ciphertext now contains the mixed in IV. For 
> decryption, the IV is only used to verify that the one block in the decryption 
> operation matches the IV.
> 
> So, there is no IV returned by the encryption.

Of course there is.  The first 8 bytes of the ciphertext is the
output IV.

If you really want to pedantic then make a function wrapper around
the whole thing and copy the IV in there.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
