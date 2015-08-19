From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: cbc(aes-aesni) a givcipher?
Date: Wed, 19 Aug 2015 20:47:39 +0800
Message-ID: <20150819124739.GB18321@gondor.apana.org.au>
References: <3211314.vIIIpsQc2S@myon.chronox.de>
 <1889024.x7b0Yn2QbV@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38326 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbbHSMrm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Aug 2015 08:47:42 -0400
Content-Disposition: inline
In-Reply-To: <1889024.x7b0Yn2QbV@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 19, 2015 at 12:31:13PM +0200, Stephan Mueller wrote:
> > 
> > with the latest cryptodev-2.6 tree I find the following:
> > 
> > name         : cbc(aes)
> > driver       : cbc(aes-aesni)
> > module       : kernel
> > priority     : 300
> > refcnt       : 1
> > selftest     : passed
> > internal     : no
> > type         : givcipher
> > async        : no
> > blocksize    : 16
> > min keysize  : 16
> > max keysize  : 32
> > ivsize       : 16
> > geniv        : eseqiv
> > 
> > name         : cbc(aes)
> > driver       : cbc(aes-aesni)
> > module       : cbc
> > priority     : 300
> > refcnt       : 1
> > selftest     : passed
> > internal     : no
> > type         : blkcipher
> > blocksize    : 16
> > min keysize  : 16
> > max keysize  : 32
> > ivsize       : 16
> > geniv        : <default>

This is how it's supposed to look like as ablkcipher also has
implicit IV generators like AEAD used to have.  I'm working on
a patch set to get rid of them just like what we did to AEAD.

> > Note the type of the ciphers. With this, an allocation of cbc(aes-aesni)
> > does not work (ENOENT).
>  
> Just a followup: I think I see how I triggered it; I used cbc(aes-aesni) with 
> crypto_alloc_aead due to an accident.

So are you saying that crypto_alloc_blkcipher is failing? If it's
only crypto_alloc_aead failing then I don't see the problem.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
