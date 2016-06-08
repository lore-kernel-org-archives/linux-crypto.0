From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC] DRBG: which shall be default?
Date: Wed, 08 Jun 2016 10:58:37 +0200
Message-ID: <16106560.DqOinPzzUs@positron.chronox.de>
References: <1664837.3VbqQRUZed@positron.chronox.de> <7330387.0ZS018HYJD@positron.chronox.de> <20160608080055.GA13686@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36056 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932551AbcFHI6k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2016 04:58:40 -0400
In-Reply-To: <20160608080055.GA13686@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 8. Juni 2016, 16:00:55 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Jun 08, 2016 at 09:56:42AM +0200, Stephan Mueller wrote:
> > The performance with ctr-aes-aesni on 64 bit is as follows -- I used my
> > LRNG implementation for testing for which I already have performance
> > measurements:
> > 
> > - generating smaller lengths (I tested up to 128 bytes) of random numbers
> > (which is the vast majority of random numbers to be generated), the
> > performance is even worse by 10 to 15%
> > 
> > - generating larger lengths (tested with 4096 bytes) of random numbers,
> > the
> > performance increases by 3%
> > 
> > Using ctr(aes-aesni) on 32 bit, the numbers are generally worse by 5 to
> > 10%.
> ctr(aes-aesni) is not the same thing as ctr-aes-aesni, the former
> being just another way of doing what you were doing.  So did you
> actually test the real optimised version which is ctr-aes-aesni?

Indeed, I used ctr(aes-aesni) instead of ctr-aes-aesni according to the refcnt 
in /proc/crypto. The reason was that I used the sync skcipher API which 
naturally excludes the ctr-aes-aesni.

When changing it to really use ctr-aes-aesni, I get: between 450% performance 
gains (for 4096 bytes -- 780 MB/s(!)) and 4% gain (for 16 bytes).

Though, on 32 bit with ctr(aes-aesni) -- which is a blkcipher -- I get a 
performance degradation of 10% (4096 bytes) and 20% (16 bytes).

Any ideas on how to handle the blkcipher in a better way?

Ciao
Stephan
