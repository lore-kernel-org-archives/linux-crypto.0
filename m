From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Subject: [PATCH 0/3] Add optimized SHA-1 implementations for x86 and x86_64
Date: Fri, 08 Jun 2007 17:42:42 -0400
Message-ID: <20070608214242.23949.30350.stgit@dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from CHOKECHERRY.SRV.CS.CMU.EDU ([128.2.185.41]:48377 "EHLO
	chokecherry.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbXFHW2F (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jun 2007 18:28:05 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The following 3-part series adds assembly implementations of the SHA-1
transform for x86 and x86_64.  For x86_64 the optimized code is always
selected; on x86 it is selected if the kernel is compiled for i486 or above
(since the code needs BSWAP).  These changes primarily improve the
performance of the CryptoAPI SHA-1 module and of /dev/urandom.  I've
included some performance data from my test boxes below.

This version incorporates feedback from Herbert Xu.  Andrew, I'm sending
this to you because of the (admittedly tiny) intersection with arm and s390
in part 1.

-

tcrypt performance tests:

=== Pentium IV in 32-bit mode, average of 5 trials ===
Test#  Bytes/  Bytes/  Cyc/B  Cyc/B  Change
        block  update    (C)  (asm)
    0      16      16    229    114     50%
    1      64      16    142     76     46%
    2      64      64     79     35     56%
    3     256      16     59     34     42%
    4     256      64     44     24     45%
    5     256     256     43     17     60%
    6    1024      16     51     36     29%
    7    1024     256     30     13     57%
    8    1024    1024     28     12     57%
    9    2048      16     66     30     55%
   10    2048     256     31     12     61%
   11    2048    1024     27     13     52%
   12    2048    2048     26     13     50%
   13    4096      16     49     30     39%
   14    4096     256     28     12     57%
   15    4096    1024     28     11     61%
   16    4096    4096     26     13     50%
   17    8192      16     49     29     41%
   18    8192     256     27     11     59%
   19    8192    1024     26     11     58%
   20    8192    4096     25     10     60%
   21    8192    8192     25     10     60%

=== Intel Core 2 in 64-bit mode, average of 5 trials ===
Test#  Bytes/  Bytes/  Cyc/B  Cyc/B  Change
        block  update    (C)  (asm)
    0      16      16    112     81     28%
    1      64      16     55     39     29%
    2      64      64     42     27     36%
    3     256      16     35     25     29%
    4     256      64     24     14     42%
    5     256     256     22     12     45%
    6    1024      16     31     22     29%
    7    1024     256     17      9     47%
    8    1024    1024     16      9     44%
    9    2048      16     30     22     27%
   10    2048     256     16      8     50%
   11    2048    1024     16      8     50%
   12    2048    2048     16      8     50%
   13    4096      16     29     21     28%
   14    4096     256     16      8     50%
   15    4096    1024     15      8     47%
   16    4096    4096     15      7     53%
   17    8192      16     29     22     24%
   18    8192     256     16      8     50%
   19    8192    1024     15      7     53%
   20    8192    4096     15      7     53%
   21    8192    8192     15      7     53%

I've also done informal tests on other boxes, and the performance
improvement has been in the same ballpark.

On the aforementioned Pentium IV, /dev/urandom throughput goes from 3.7 MB/s
to 5.6 MB/s with the patches; on the Core 2, it increases from 5.5 MB/s to
8.1 MB/s.

Signed-off-by: Benjamin Gilbert <bgilbert@cs.cmu.edu>
