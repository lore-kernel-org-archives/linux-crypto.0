From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH RFC 0/7] Introduce new async/sync compression APIs
Date: Mon,  4 Jan 2016 13:46:51 +0900
Message-ID: <1451882819-2810-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Weigang Li <weigang.li@intel.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36845 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbcADErR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Jan 2016 23:47:17 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Happy New Year!

This patchset is to introduce new compression APIs. It supports async/sync
compression although there is no async compression driver yet. But, async
APIs can be used as front-end to sync compression algorithm. Major change
is that now APIs are stateless. Instead of previous implementation, tfm
objects doesn't embedded any context so we can de/compress concurrently
with one tfm object. Instead, this de/compression context is coupled with
the request. This architecture change will make APIs more flexible.

This is just a RFC so commit description isn't sufficient. If Herbert
confirms that this is what he expect, I will respin the series with proper
commit description and adding more algorithm support.

Thanks.

Joonsoo Kim (6):
  crypto/compress: remove unused pcomp interface
  crypto/compress: introduce sychronuous compression API
  crypto/lzo: support SCOMPRESS alg type
  crypto: testmgr: add scompress/acompress test
  crypto/compress: add algorithm type specific flag, DECOMP_NOCTX
  crypto/lzo: add CRYPTO_ALG_SCOMPRESS_DECOMP_NOCTX cra_flags

Weigang Li (1):
  crypto: add asynchronous compression support

 crypto/Kconfig                     |  19 +-
 crypto/Makefile                    |   4 +-
 crypto/acompress.c                 | 164 ++++++++++++++++
 crypto/lzo.c                       |  95 +++++++--
 crypto/pcompress.c                 | 115 -----------
 crypto/scompress.c                 | 283 +++++++++++++++++++++++++++
 crypto/testmgr.c                   | 376 +++++++++++++++---------------------
 crypto/testmgr.h                   | 142 --------------
 crypto/zlib.c                      | 381 -------------------------------------
 include/crypto/compress.h          | 354 +++++++++++++++++++++++++---------
 include/crypto/internal/compress.h |  32 +---
 include/linux/crypto.h             |  10 +-
 12 files changed, 969 insertions(+), 1006 deletions(-)
 create mode 100644 crypto/acompress.c
 delete mode 100644 crypto/pcompress.c
 create mode 100644 crypto/scompress.c
 delete mode 100644 crypto/zlib.c

-- 
1.9.1
