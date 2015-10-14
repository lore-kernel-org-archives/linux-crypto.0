From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v4 0/8] zram: introduce contextless compression API and use it on zram
Date: Wed, 14 Oct 2015 16:38:16 +0900
Message-ID: <1444808304-29320-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36450 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbbJNHib (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 03:38:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset introduce contextless compression API and use it on zram in
order to support more compression algorithm without more overhead.

The reason we need to support vairous compression algorithms is that
zram's performance is highly depend on workload and compression algorithm
and architecture. Every compression algorithm has it's own strong point.
For example, zlib is the best for compression ratio, but, it's
(de)compression speed is rather slow. Against my expectation, in my kernel
build test with zram swap, in low-memory condition on x86, zlib shows best
performance than others. In this case, I guess that compression ratio is
the most important factor.

Kernel build elapsed time in QEMU 8 CPUs 448 MB with zram swap
lzo : deflate
188.3 s : 181.9 s
(3% improvement)

Unlike this situation, on ARM, maybe fast (de)compression speed is
the most important because it's computation speed is slower than x86.

Anyway, there is a concern from Sergey to use crypto API in zram. Current
crypto API has a limitation that always require tfm object to (de)compress
something because some of (de)compression function requires scratch buffer
embedded on tfm even if some of (de)compression function doesn't
require it. Due to above reason, using crypto API rather than calling
compression library directly causes more memory footprint and this is
why zram doesn't use crypto API before.

To solve this problem, this patchset introduce contextless compression API.
This new compression API doesn't require user to use tfm one by one.
Tfm is only used for distinguishing compression algorithm and maybe
keeping algorithm parameter so can be used concurrently. Context is now
separate from tfm and user needs to allocate and manage it separately.
With this separation, we can save memory in some cases and get the best
performance.

This patchset solves Sergey's concern perfectly and provides possibility
to use various compression algorithm in zram.

Thanks.

Joonsoo Kim (6):
  crypto/compress: introduce contextless compression and remove unused
    pcomp
  crypto/lzo: support contextless compression API
  crypto/lz4: support contextless compressiona API
  crypto/deflate: support contextless compression API
  zram: use crypto contextless compression API to (de)compress
  zram: enable contextless compression alg in zram

Sergey Senozhatsky (2):
  zram: make stream find and release functions static
  zram: pass zstrm down to decompression path

 Documentation/blockdev/zram.txt    |  29 ++-
 crypto/Kconfig                     |  18 +-
 crypto/Makefile                    |   3 +-
 crypto/ccompress.c                 |  95 +++++++++
 crypto/deflate.c                   |  96 +++++++++-
 crypto/lz4.c                       |  77 +++++++-
 crypto/lzo.c                       |  81 ++++++--
 crypto/pcompress.c                 | 115 -----------
 crypto/zlib.c                      | 381 -------------------------------------
 drivers/block/zram/Kconfig         |  13 +-
 drivers/block/zram/Makefile        |   4 +-
 drivers/block/zram/zcomp.c         | 104 ++++++----
 drivers/block/zram/zcomp.h         |  32 ++--
 drivers/block/zram/zram_drv.c      |  33 +++-
 include/crypto/compress.h          | 118 ++++--------
 include/crypto/internal/compress.h |  28 ---
 include/linux/crypto.h             |   2 +-
 17 files changed, 488 insertions(+), 741 deletions(-)
 create mode 100644 crypto/ccompress.c
 delete mode 100644 crypto/pcompress.c
 delete mode 100644 crypto/zlib.c
 delete mode 100644 include/crypto/internal/compress.h

-- 
1.9.1
