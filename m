From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH 0/3] Add optimized SHA-1 implementations for x86 and
	x86_64
Date: Mon, 11 Jun 2007 22:30:32 +0200
Message-ID: <20070611203032.GI3588@stusta.de>
References: <20070608214242.23949.30350.stgit@dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: akpm@linux-foundation.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59960 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752332AbXFKUaX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jun 2007 16:30:23 -0400
Content-Disposition: inline
In-Reply-To: <20070608214242.23949.30350.stgit@dev>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 08, 2007 at 05:42:42PM -0400, Benjamin Gilbert wrote:
> The following 3-part series adds assembly implementations of the SHA-1
> transform for x86 and x86_64.  For x86_64 the optimized code is always
> selected; on x86 it is selected if the kernel is compiled for i486 or above
> (since the code needs BSWAP).  These changes primarily improve the
> performance of the CryptoAPI SHA-1 module and of /dev/urandom.  I've
> included some performance data from my test boxes below.
> 
> This version incorporates feedback from Herbert Xu.  Andrew, I'm sending
> this to you because of the (admittedly tiny) intersection with arm and s390
> in part 1.
> 
> -
> 
> tcrypt performance tests:
> 
> === Pentium IV in 32-bit mode, average of 5 trials ===
> Test#  Bytes/  Bytes/  Cyc/B  Cyc/B  Change
>...
> I've also done informal tests on other boxes, and the performance
> improvement has been in the same ballpark.
> 
> On the aforementioned Pentium IV, /dev/urandom throughput goes from 3.7 MB/s
> to 5.6 MB/s with the patches; on the Core 2, it increases from 5.5 MB/s to
> 8.1 MB/s.
>...

With which gcc version and compiler flags?

And why is the C code slower?
Problems in the C code?
gcc problems?

Generally, I'd really prefer one C implementation that works good on all 
platforms over getting dozens of different assembler implemenations, 
each potentially with different bugs.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
