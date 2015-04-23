From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Thu, 23 Apr 2015 15:42:19 +0200
Message-ID: <2261126.vD1ovnGobO@myon.chronox.de>
References: <6218629.uO4632Hmli@myon.chronox.de> <1470287.z00squjPAu@myon.chronox.de> <20150423025558.GA17870@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34288 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbbDWNn7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Apr 2015 09:43:59 -0400
In-Reply-To: <20150423025558.GA17870@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 23. April 2015, 10:55:58 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Apr 23, 2015 at 04:51:56AM +0200, Stephan Mueller wrote:
> > Encrypt input: IV, plaintext
> > 
> > Encrypt output: processed IV, ciphertext
> > 
> > Decrypt input: processed IV, ciphertext, IV to use for compare operation
> > 
> > Decrypt output: plaintext
> 
> Actually it is
> 
> Decrypt input: processed IV, ciphertext
> Decrypt output: IV, plaintext
> 
> > How do you propose I send 2 IVs to blkcipher?
> 
> As I suggested earlier, you can use the currently unused givdecrypt
> interface for the fixed IV case as specified in the RFC.  The giv
> interfaces provide space for two IVs.
> 
> If givdecrypt fails the comparison, then you can return EBADMSG
> and zap the decrypted key.
> 
> For the normal decrypt path, just return the IV and plaintet.

The conversion to blkcipher is done and the math still works. As CBC or others 
it is a blkcipher and not an ablkcipher.

Now, shall I kind of re-implement the chainiv ablkcipher wrapper into an IV 
handler that just helps my code? That will be a lot of code for a simple 
memcmp.

-- 
Ciao
Stephan
