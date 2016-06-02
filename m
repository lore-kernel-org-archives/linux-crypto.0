From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC] DRBG: which shall be default?
Date: Thu, 02 Jun 2016 11:31:22 +0200
Message-ID: <3243059.jE1At2qco9@tauon.atsec.com>
References: <1664837.3VbqQRUZed@positron.chronox.de> <1972759.dI50hI8gdY@tauon.atsec.com> <20160602084012.GC15226@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35698 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391AbcFBJbZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 05:31:25 -0400
In-Reply-To: <20160602084012.GC15226@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 2. Juni 2016, 16:40:12 schrieb Herbert Xu:

Hi Herbert,

> On Tue, May 31, 2016 at 01:23:21PM +0200, Stephan Mueller wrote:
> > Hence my question: shall we leave the HMAC DRBG as default or shall we use
> > the CTR DRBG as default?
> 
> I don't really care one way or another.
> 
> BTW why did you use the crypto_cipher aes interface instead of
> the crypto_skcipher ctr(aes) interface which would likely make
> your code run many orders-of-magnitude faster, especially with
> aesni-intel?

I considered such approach, but the crux is the following: for the CTR DRBG 
generate function, our state is 16 bytes (i.e. the AES block length). Out of 
those 16 bytes, we generate the random number by encrypting that block, 
incrementing the block by one and encrypt it again. In essence what we do here 
is the stream cipher part of the CTR mode which generates the data stream we 
use to XOR the input data with.

The skcipher API, however, wants to encrypt an entire input data stream. That 
means the skcipher API requires the length of the input data stream to 
generate an equally sized output data stream. But that is not what we have 
here -- there is no input data. I.e. the skcipher API invokes the CTR mode for 
the stream cipher and performs the final XOR of the CTR stream with the input 
data.

Currently I would not see a way how to access the CTR mode stream cipher part 
only via the skcipher API.

Ciao
Stephan
