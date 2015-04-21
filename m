From: Stephan Mueller <smueller@chronox.de>
Subject: Re: module ref count
Date: Tue, 21 Apr 2015 14:56:31 +0200
Message-ID: <2752017.WuurLylSds@myon.chronox.de>
References: <1513971.JRWYZvf2T6@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34230 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbbDUM7z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2015 08:59:55 -0400
In-Reply-To: <1513971.JRWYZvf2T6@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 21. April 2015, 14:35:47 schrieb Stephan Mueller:

Hi Stephan,

> Hi Herbert,
> 
> I am currently working on the template for SP800-38F key wrapping. The
> module is operational and calculates what I want.
> 
> However, I have one problem I am having difficulties to track down and I am
> wondering whether you could point me to the right direction.
> 
> When a caller calls
> 
> 	crypto_alloc_aead("kw(aes)", 0, 0);
> 
> somehow the refcount of the kernel module implementing the keywrapping is
> not increased. Once can see that in lsmod where the "Used by" value remains
> 0.
> 
> Then when the caller deallocates the cipher handle, the refcount is -1
> according to lsmod. With that, a second invocation of crypto_alloc_aead will
> fail and I even cannot remove the module from the kernel.
> 
> Who increases the refcount on the kernel crypto API side?

I think I hit an even bigger problem: while playing with other AEAD ciphers, I 
see the same thing now:

$ lsmod 
Module                  Size  Used by
ansi_cprng             12989  0 
drbg                   30255  0 
algif_rng              12753  0 
seqiv                  13003  -1 
ccm                    17731  -1 
gcm                    23371  -1

Allocation of these ciphers fail.


> 
> Thanks a lot


-- 
Ciao
Stephan
