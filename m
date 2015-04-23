From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Thu, 23 Apr 2015 10:55:58 +0800
Message-ID: <20150423025558.GA17870@gondor.apana.org.au>
References: <6218629.uO4632Hmli@myon.chronox.de>
 <2382170.NBi3QxkUu4@myon.chronox.de>
 <20150423014609.GA17267@gondor.apana.org.au>
 <1470287.z00squjPAu@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45783 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917AbbDWC4C (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 22:56:02 -0400
Content-Disposition: inline
In-Reply-To: <1470287.z00squjPAu@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 23, 2015 at 04:51:56AM +0200, Stephan Mueller wrote:
>
> Encrypt input: IV, plaintext
> 
> Encrypt output: processed IV, ciphertext
> 
> Decrypt input: processed IV, ciphertext, IV to use for compare operation
> 
> Decrypt output: plaintext

Actually it is

Decrypt input: processed IV, ciphertext
Decrypt output: IV, plaintext

> How do you propose I send 2 IVs to blkcipher?

As I suggested earlier, you can use the currently unused givdecrypt
interface for the fixed IV case as specified in the RFC.  The giv
interfaces provide space for two IVs.

If givdecrypt fails the comparison, then you can return EBADMSG
and zap the decrypted key.

For the normal decrypt path, just return the IV and plaintet.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
