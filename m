From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
Date: Sun, 10 Jun 2007 12:47:19 -0400
Message-ID: <466C2B17.8000708@cs.cmu.edu>
References: <20070608214242.23949.30350.stgit@dev> <20070608214253.23949.40465.stgit@dev> <20070609201159.GC11166@waste.org> <466B0C3F.3040300@garzik.org> <466B46D5.1020004@cs.cmu.edu> <20070610135956.GS11115@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from JACKFRUIT.SRV.CS.CMU.EDU ([128.2.201.16]:56878 "EHLO
	jackfruit.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458AbXFJQsk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Jun 2007 12:48:40 -0400
In-Reply-To: <20070610135956.GS11115@waste.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Matt Mackall wrote:
> On Sat, Jun 09, 2007 at 08:33:25PM -0400, Benjamin Gilbert wrote:
>> It's not just the loop unrolling; it's the register allocation and 
>> spilling.  For comparison, I built SHATransform() from the 
>> drivers/char/random.c in 2.6.11, using gcc 3.3.5 with -O2 and 
>> SHA_CODE_SIZE == 3 (i.e., fully unrolled); I'm guessing this is pretty 
>> close to what you tested back then.  The resulting code is 49% MOV 
>> instructions, and 80% of *those* involve memory.  gcc4 is somewhat 
>> better, but it still spills a whole lot, both for the 2.6.11 unrolled 
>> code and for the current lib/sha1.c.
> 
> Wait, your benchmark is comparing against the unrolled code?

No, it's comparing the current lib/sha1.c to the optimized code in the 
patch.  I was just pointing out that the unrolled code you were likely 
testing against, back then, may not have been very good.  (Though I 
assumed that you were talking about the unrolled code in random.c, not 
the code in CryptoAPI, so that might change the numbers some.  It 
appears from the post you linked below that the unrolled CryptoAPI code 
still beat the rolled version?)

> How big is the -code- footprint?

About 3700 bytes for the 32-bit version of sha_transform().

> Whoa. We've regressed something horrible here:
> 
> http://groups.google.com/group/linux.kernel/msg/fba056363c99d4f9?dmode=source&hl=en
> 
> In 2003, I was getting 17MB/s out of my Athlon. Now I'm getting 2.7MB/s.
> Were your tests with or without the latest /dev/urandom fixes? This
> one in particular:
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.21.y.git;a=commitdiff;h=374f167dfb97c1785515a0c41e32a66b414859a8

I'm not in front of that machine right now; I can check tomorrow.  For 
what it's worth, I've seen equivalent performance (a few MB/s) on a 
range of fairly-recent kernels.

--Benjamin Gilbert
