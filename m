From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC] DRBG: which shall be default?
Date: Wed, 08 Jun 2016 09:56:42 +0200
Message-ID: <7330387.0ZS018HYJD@positron.chronox.de>
References: <1664837.3VbqQRUZed@positron.chronox.de> <1580741.tpUX5Z7OKy@tauon.atsec.com> <20160608024140.GA12283@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36048 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526AbcFHH4p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2016 03:56:45 -0400
In-Reply-To: <20160608024140.GA12283@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 8. Juni 2016, 10:41:40 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Jun 02, 2016 at 02:06:55PM +0200, Stephan Mueller wrote:
> > I am working on it. During the analysis, I saw, however, that the DRBG
> > increments the counter before the encryption whereas the the CTR mode
> > increments it after the encryption.
> > 
> > I could of course adjust the handling in the code, but this would be a
> > real
> > hack IMHO.
> 
> Changing the order of increment is equivalent to changing the IV, no?

I finally got it working. All I needed to do is to add a crypto_inc(V) after a 
recalculation of V.

The performance with ctr-aes-aesni on 64 bit is as follows -- I used my LRNG 
implementation for testing for which I already have performance measurements:

- generating smaller lengths (I tested up to 128 bytes) of random numbers 
(which is the vast majority of random numbers to be generated), the 
performance is even worse by 10 to 15%

- generating larger lengths (tested with 4096 bytes) of random numbers, the 
performance increases by 3%

Using ctr(aes-aesni) on 32 bit, the numbers are generally worse by 5 to 10%.

So, with these numbers, I would conclude that switching to the CTR mode is not 
worthwhile.

Ciao
Stephan
