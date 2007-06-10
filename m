From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
Date: Sat, 09 Jun 2007 20:33:25 -0400
Message-ID: <466B46D5.1020004@cs.cmu.edu>
References: <20070608214242.23949.30350.stgit@dev> <20070608214253.23949.40465.stgit@dev> <20070609201159.GC11166@waste.org> <466B0C3F.3040300@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Matt Mackall <mpm@selenic.com>, akpm@linux-foundation.org,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from CHOKECHERRY.SRV.CS.CMU.EDU ([128.2.185.41]:49236 "EHLO
	chokecherry.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304AbXFJAeI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Jun 2007 20:34:08 -0400
In-Reply-To: <466B0C3F.3040300@garzik.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Jeff Garzik wrote:
> Matt Mackall wrote:
>> Have you benchmarked this against lib/sha1.c? Please post the results.
>> Until then, I'm frankly skeptical that your unrolled version is faster
>> because when I introduced lib/sha1.c the rolled version therein won by
>> a significant margin and had 1/10th the cache footprint.

See the benchmark tables in patch 0 at the head of this thread. 
Performance improved by at least 25% in every test, and 40-60% was more 
common for the 32-bit version (on a Pentium IV).

It's not just the loop unrolling; it's the register allocation and 
spilling.  For comparison, I built SHATransform() from the 
drivers/char/random.c in 2.6.11, using gcc 3.3.5 with -O2 and 
SHA_CODE_SIZE == 3 (i.e., fully unrolled); I'm guessing this is pretty 
close to what you tested back then.  The resulting code is 49% MOV 
instructions, and 80% of *those* involve memory.  gcc4 is somewhat 
better, but it still spills a whole lot, both for the 2.6.11 unrolled 
code and for the current lib/sha1.c.

In contrast, the assembly implementation in this patch only has to go to 
memory for data and workspace (with one small exception in the F3 
rounds), and the workspace has a fifth of the cache footprint of the 
default implementation.

> Yes. And it also depends on the CPU as well.  Testing on a server-class 
> x86 CPU (often with bigger L2, and perhaps even L1, cache) will produce 
> different result than from popular but less-capable "value" CPUs.

Good point.  I benchmarked the 32-bit assembly code on a couple more boxes:

=== AMD Duron, average of 5 trials ===
Test#  Bytes/  Bytes/  Cyc/B  Cyc/B  Change
         block  update    (C)  (asm)
     0      16      16    104     72     31%
     1      64      16     52     36     31%
     2      64      64     45     29     36%
     3     256      16     33     23     30%
     4     256      64     27     17     37%
     5     256     256     24     14     42%
     6    1024      16     29     20     31%
     7    1024     256     20     11     45%
     8    1024    1024     19     11     42%
     9    2048      16     28     20     29%
    10    2048     256     19     11     42%
    11    2048    1024     18     10     44%
    12    2048    2048     18     10     44%
    13    4096      16     28     19     32%
    14    4096     256     18     10     44%
    15    4096    1024     18     10     44%
    16    4096    4096     18     10     44%
    17    8192      16     27     19     30%
    18    8192     256     18     10     44%
    19    8192    1024     18     10     44%
    20    8192    4096     17     10     41%
    21    8192    8192     17     10     41%

=== Classic Pentium, average of 5 trials ===
Test#  Bytes/  Bytes/  Cyc/B  Cyc/B  Change
         block  update    (C)  (asm)
     0      16      16    145    144      1%
     1      64      16     72     61     15%
     2      64      64     65     52     20%
     3     256      16     46     39     15%
     4     256      64     39     32     18%
     5     256     256     36     29     19%
     6    1024      16     40     33     18%
     7    1024     256     30     23     23%
     8    1024    1024     29     23     21%
     9    2048      16     39     32     18%
    10    2048     256     29     22     24%
    11    2048    1024     28     22     21%
    12    2048    2048     28     22     21%
    13    4096      16     38     32     16%
    14    4096     256     28     22     21%
    15    4096    1024     28     21     25%
    16    4096    4096     27     21     22%
    17    8192      16     38     32     16%
    18    8192     256     28     22     21%
    19    8192    1024     28     21     25%
    20    8192    4096     27     21     22%
    21    8192    8192     27     21     22%

The improvement isn't as good, but it's still noticeable.

--Benjamin Gilbert
