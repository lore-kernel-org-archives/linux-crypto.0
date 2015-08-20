From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 0/8] zram: introduce crypto compress noctx API and use it on zram
Date: Thu, 20 Aug 2015 15:34:56 +0900
Message-ID: <1440052504-15442-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33701 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbbHTGfS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 02:35:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset makes zram to use crypto API in order to support
more compression algorithm.

The reason we need to support vairous compression algorithms is that
zram's performance is highly depend on workload and compression algorithm
and architecture. Every compression algorithm has it's own strong point.
For example, zlib is the best for compression ratio, but, it's
(de)compression speed is rather slow. Against my expectation, in my kernel
build test with zram swap, in low-memory condition on x86, zlib shows best
performance than others. In this case, I guess that compression ratio is
the most important factor. Unlike this situation, on ARM, maybe fast
(de)compression speed is the most important because it's computation speed
is slower than x86.

Anyway, there is a concern from Sergey to use crypto API in zram. Current
crypto API has a limitation that always require tfm object to (de)compress
something because some of (de)compression function requires scratch buffer
embedded on tfm even if some of (de)compression function doesn't
require it. Due to above reason, using crypto API rather than calling
compression library directly causes more memory footprint and this is
why zram doesn't use crypto API before.

In this patchset, crypto compress noctx API is introduced to reduce memory
footprint caused by maintaining multiple tfm and zram uses it. Before
noctx API, zram's performace is down-graded if tfm is insufficient. But,
after applying noctx API, performace is restored.

This addresses Sergey's concern perfectly and provides possibility to use
various compression algorithm in zram.

Following is zram's read performance number.

* iozone -t 4 -R -r 16K -s 60M -I +Z -i 0 -i 1
* max_stream is set to 1
* Output is in Kbytes/sec

zram-base vs zram-crypto vs zram-crypto-noctx

Read		10411701.88	6426911.62	9423894.38 
Re-read		10017386.62	6428218.88	11000063.50 

Thanks.

Joonsoo Kim (8):
  crypto: support (de)compression API that doesn't require tfm object
  crypto/lzo: support decompress_noctx
  crypyo/lz4: support decompress_noctx
  crypto/lz4hc: support decompress_noctx
  crypto/842: support decompress_noctx
  zram: change zcomp_compress interface
  zram: use crypto API for compression
  zram: use decompress_noctx

 crypto/842.c                   |  10 +++-
 crypto/compress.c              |  20 ++++++++
 crypto/crypto_null.c           |   4 +-
 crypto/deflate.c               |   4 +-
 crypto/lz4.c                   |  19 ++++++-
 crypto/lz4hc.c                 |  19 ++++++-
 crypto/lzo.c                   |  20 +++++++-
 drivers/block/zram/Kconfig     |  13 +----
 drivers/block/zram/Makefile    |   4 +-
 drivers/block/zram/zcomp.c     | 113 +++++++++++++++++++++++++----------------
 drivers/block/zram/zcomp.h     |  44 +++++++---------
 drivers/block/zram/zcomp_lz4.c |  47 -----------------
 drivers/block/zram/zcomp_lz4.h |  17 -------
 drivers/block/zram/zcomp_lzo.c |  47 -----------------
 drivers/block/zram/zcomp_lzo.h |  17 -------
 drivers/block/zram/zram_drv.c  |  29 +++++++----
 include/linux/crypto.h         |  31 +++++++++++
 17 files changed, 229 insertions(+), 229 deletions(-)
 delete mode 100644 drivers/block/zram/zcomp_lz4.c
 delete mode 100644 drivers/block/zram/zcomp_lz4.h
 delete mode 100644 drivers/block/zram/zcomp_lzo.c
 delete mode 100644 drivers/block/zram/zcomp_lzo.h

-- 
1.9.1
