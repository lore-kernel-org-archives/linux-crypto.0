From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 00/10] Introduce new async/sync compression APIs
Date: Tue, 26 Jan 2016 17:15:02 +0900
Message-ID: <1453796112-14273-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Weigang Li <weigang.li@intel.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Dan Streetman <ddstreet@ieee.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34637 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbcAZIPZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 03:15:25 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset introduces new compression APIs. This work is started
to support crypto compression in zram [1]. I will restart that work
after this patchset is mereged. Major point of new APIs is that it is
now stateless. Instead of legacy compression API, tfm objects doesn't
embedded any context so we can de/compress concurrently with one tfm
object. Instead, this de/compression context is coupled with the request.
This architecture change will make APIs more flexible and we can naturally
use asynchronous APIs as front-end of synchronous compression algorithm.

Moreover, thanks to this change, we can decompress without context buffer
if algorithm supports it. In this case, we can achieve maximum parallelism
without memory overhead caused by context buffer.

Please let know if there is a problem.

Thanks.

[1]: https://lkml.org/lkml/2015/10/14/83

Joonsoo Kim (9):
  crypto/compress: remove unused pcomp interface
  crypto: add algorithm type specific flag, CRYPTO_ALG_PRIVATE
  crypto/compress: introduce sychronuous compression API
  crypto/lzo: support new compression APIs
  crypto/lz4: support new compression APIs
  crypto/lz4hc: support new compression APIs
  crypto/842: support new compression APIs
  crypto/deflate: support new compression APIs
  crypto/testmgr: add new compression APIs test

Weigang Li (1):
  crypto/compress: add asynchronous compression support

 crypto/842.c                       |  85 +++++++-
 crypto/Kconfig                     |  23 +-
 crypto/Makefile                    |   4 +-
 crypto/acompress.c                 | 164 ++++++++++++++
 crypto/deflate.c                   | 110 +++++++++-
 crypto/lz4.c                       |  91 +++++++-
 crypto/lz4hc.c                     |  91 +++++++-
 crypto/lzo.c                       |  95 ++++++--
 crypto/pcompress.c                 | 115 ----------
 crypto/scompress.c                 | 284 ++++++++++++++++++++++++
 crypto/testmgr.c                   | 428 ++++++++++++++++++-------------------
 crypto/testmgr.h                   | 144 -------------
 crypto/zlib.c                      | 381 ---------------------------------
 include/crypto/compress.h          | 375 ++++++++++++++++++++++++--------
 include/crypto/internal/compress.h |  32 +--
 include/linux/crypto.h             |   9 +-
 16 files changed, 1387 insertions(+), 1044 deletions(-)
 create mode 100644 crypto/acompress.c
 delete mode 100644 crypto/pcompress.c
 create mode 100644 crypto/scompress.c
 delete mode 100644 crypto/zlib.c

-- 
1.9.1
