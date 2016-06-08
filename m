From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC] DRBG: which shall be default?
Date: Wed, 08 Jun 2016 11:07:42 +0200
Message-ID: <2066130.uIxle5Vnoa@tauon.atsec.com>
References: <1664837.3VbqQRUZed@positron.chronox.de> <16106560.DqOinPzzUs@positron.chronox.de> <20160608090354.GA14241@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36060 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422968AbcFHJHp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2016 05:07:45 -0400
In-Reply-To: <20160608090354.GA14241@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 8. Juni 2016, 17:03:54 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Jun 08, 2016 at 10:58:37AM +0200, Stephan Mueller wrote:
> > Indeed, I used ctr(aes-aesni) instead of ctr-aes-aesni according to the
> > refcnt in /proc/crypto. The reason was that I used the sync skcipher API
> > which naturally excludes the ctr-aes-aesni.
> > 
> > When changing it to really use ctr-aes-aesni, I get: between 450%
> > performance gains (for 4096 bytes -- 780 MB/s(!)) and 4% gain (for 16
> > bytes).
> > 
> > Though, on 32 bit with ctr(aes-aesni) -- which is a blkcipher -- I get a
> > performance degradation of 10% (4096 bytes) and 20% (16 bytes).
> > 
> > Any ideas on how to handle the blkcipher in a better way?
> 
> You should always use ctr-aes-aesni, ctr(aes-aesni) makes no sense.
> 
> So I don't quite understand why you need to handle blkcipher, does
> ctr-aes-aesni not work on 32-bit?

No, it does not:

#ifdef CONFIG_X86_64
}, {
        .cra_name               = "__ctr-aes-aesni",
        .cra_driver_name        = "__driver-ctr-aes-aesni",
...
}, {
        .cra_name               = "ctr(aes)",
        .cra_driver_name        = "ctr-aes-aesni",


==> ctr-aes-aesni is not available in 32 bit. Only aes-aesni is available in 
32 bit so the system defaults to ctr(aes-aesni).

Note, in my tests I use a generic code that requests ctr(aes). I am not arch-
specific in the code. The discussion above is the analysis of the kernel 
crypto API's decisions.

Ciao
Stephan
