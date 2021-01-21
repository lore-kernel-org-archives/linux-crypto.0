Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52391C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 13:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06500239FF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 13:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbhAUNJA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 08:09:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731810AbhAUNIa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 08:08:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 550A823A00;
        Thu, 21 Jan 2021 13:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611234468;
        bh=UbKmCjmt6fAcN8xgMdQJ1W7K3dbhfNz9wrE81vYZQtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPuRM6WP7oZm0BrDg0Bzvv5DKrTJ/FfZAQlwfTIz1g2Uz8LNUCoUArpNXNn9I7ywA
         t6pyN03T2aPCys5p9s3+e5KCz+MYSFyQ/PYGNeZcnhjtDV9p7VgaZZAHFP5KaX99Bs
         /ykk/5CQ+l0KhpryztkPj2DWjdz78TnWJfpDGisQnm9GwGojDNw/KexX37shEUpNPk
         lsGXxQMjuUNv2FE3BAF2Yi+XzMBZcufyBoXIupMns6ROSHcmFcPS51L+fCTxR+UJUm
         CNOZ876qqFtY5jccHI8Of3M5kTwN5kHWdXmyPoHdtVdCRwhimzqLsHeY/BYhpX2fxp
         CnGSzQBryZYeQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/5] crypto: remove RIPE-MD 256 hash algorithm
Date:   Thu, 21 Jan 2021 14:07:30 +0100
Message-Id: <20210121130733.1649-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210121130733.1649-1-ardb@kernel.org>
References: <20210121130733.1649-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

RIPE-MD 256 is never referenced anywhere in the kernel, and unlikely
to be depended upon by userspace via AF_ALG. So let's remove it

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Kconfig   |  12 -
 crypto/Makefile  |   1 -
 crypto/ripemd.h  |   3 -
 crypto/rmd256.c  | 342 --------------------
 crypto/tcrypt.c  |  14 +-
 crypto/testmgr.c |   6 -
 crypto/testmgr.h |  64 ----
 7 files changed, 1 insertion(+), 441 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a14da8290abb..8e93dce161b0 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -834,18 +834,6 @@ config CRYPTO_RMD160
 	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
 	  See <https://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
 
-config CRYPTO_RMD256
-	tristate "RIPEMD-256 digest algorithm"
-	select CRYPTO_HASH
-	help
-	  RIPEMD-256 is an optional extension of RIPEMD-128 with a
-	  256 bit hash. It is intended for applications that require
-	  longer hash-results, without needing a larger security level
-	  (than RIPEMD-128).
-
-	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-	  See <https://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
-
 config CRYPTO_RMD320
 	tristate "RIPEMD-320 digest algorithm"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index c4d8f86a106c..946e821f1874 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -68,7 +68,6 @@ obj-$(CONFIG_CRYPTO_NULL2) += crypto_null.o
 obj-$(CONFIG_CRYPTO_MD4) += md4.o
 obj-$(CONFIG_CRYPTO_MD5) += md5.o
 obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
-obj-$(CONFIG_CRYPTO_RMD256) += rmd256.o
 obj-$(CONFIG_CRYPTO_RMD320) += rmd320.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
diff --git a/crypto/ripemd.h b/crypto/ripemd.h
index 0f66e3c86a2b..a19c3c27a466 100644
--- a/crypto/ripemd.h
+++ b/crypto/ripemd.h
@@ -9,9 +9,6 @@
 #define RMD160_DIGEST_SIZE      20
 #define RMD160_BLOCK_SIZE       64
 
-#define RMD256_DIGEST_SIZE      32
-#define RMD256_BLOCK_SIZE       64
-
 #define RMD320_DIGEST_SIZE      40
 #define RMD320_BLOCK_SIZE       64
 
diff --git a/crypto/rmd256.c b/crypto/rmd256.c
deleted file mode 100644
index 3c730e9de5fd..000000000000
--- a/crypto/rmd256.c
+++ /dev/null
@@ -1,342 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Cryptographic API.
- *
- * RIPEMD-256 - RACE Integrity Primitives Evaluation Message Digest.
- *
- * Based on the reference implementation by Antoon Bosselaers, ESAT-COSIC
- *
- * Copyright (c) 2008 Adrian-Ken Rueegsegger <ken@codelabs.ch>
- */
-#include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
-#include <asm/byteorder.h>
-
-#include "ripemd.h"
-
-struct rmd256_ctx {
-	u64 byte_count;
-	u32 state[8];
-	__le32 buffer[16];
-};
-
-#define K1  RMD_K1
-#define K2  RMD_K2
-#define K3  RMD_K3
-#define K4  RMD_K4
-#define KK1 RMD_K6
-#define KK2 RMD_K7
-#define KK3 RMD_K8
-#define KK4 RMD_K1
-
-#define F1(x, y, z) (x ^ y ^ z)		/* XOR */
-#define F2(x, y, z) (z ^ (x & (y ^ z)))	/* x ? y : z */
-#define F3(x, y, z) ((x | ~y) ^ z)
-#define F4(x, y, z) (y ^ (z & (x ^ y)))	/* z ? x : y */
-
-#define ROUND(a, b, c, d, f, k, x, s)  { \
-	(a) += f((b), (c), (d)) + le32_to_cpup(&(x)) + (k); \
-	(a) = rol32((a), (s)); \
-}
-
-static void rmd256_transform(u32 *state, const __le32 *in)
-{
-	u32 aa, bb, cc, dd, aaa, bbb, ccc, ddd;
-
-	/* Initialize left lane */
-	aa = state[0];
-	bb = state[1];
-	cc = state[2];
-	dd = state[3];
-
-	/* Initialize right lane */
-	aaa = state[4];
-	bbb = state[5];
-	ccc = state[6];
-	ddd = state[7];
-
-	/* round 1: left lane */
-	ROUND(aa, bb, cc, dd, F1, K1, in[0],  11);
-	ROUND(dd, aa, bb, cc, F1, K1, in[1],  14);
-	ROUND(cc, dd, aa, bb, F1, K1, in[2],  15);
-	ROUND(bb, cc, dd, aa, F1, K1, in[3],  12);
-	ROUND(aa, bb, cc, dd, F1, K1, in[4],   5);
-	ROUND(dd, aa, bb, cc, F1, K1, in[5],   8);
-	ROUND(cc, dd, aa, bb, F1, K1, in[6],   7);
-	ROUND(bb, cc, dd, aa, F1, K1, in[7],   9);
-	ROUND(aa, bb, cc, dd, F1, K1, in[8],  11);
-	ROUND(dd, aa, bb, cc, F1, K1, in[9],  13);
-	ROUND(cc, dd, aa, bb, F1, K1, in[10], 14);
-	ROUND(bb, cc, dd, aa, F1, K1, in[11], 15);
-	ROUND(aa, bb, cc, dd, F1, K1, in[12],  6);
-	ROUND(dd, aa, bb, cc, F1, K1, in[13],  7);
-	ROUND(cc, dd, aa, bb, F1, K1, in[14],  9);
-	ROUND(bb, cc, dd, aa, F1, K1, in[15],  8);
-
-	/* round 1: right lane */
-	ROUND(aaa, bbb, ccc, ddd, F4, KK1, in[5],   8);
-	ROUND(ddd, aaa, bbb, ccc, F4, KK1, in[14],  9);
-	ROUND(ccc, ddd, aaa, bbb, F4, KK1, in[7],   9);
-	ROUND(bbb, ccc, ddd, aaa, F4, KK1, in[0],  11);
-	ROUND(aaa, bbb, ccc, ddd, F4, KK1, in[9],  13);
-	ROUND(ddd, aaa, bbb, ccc, F4, KK1, in[2],  15);
-	ROUND(ccc, ddd, aaa, bbb, F4, KK1, in[11], 15);
-	ROUND(bbb, ccc, ddd, aaa, F4, KK1, in[4],   5);
-	ROUND(aaa, bbb, ccc, ddd, F4, KK1, in[13],  7);
-	ROUND(ddd, aaa, bbb, ccc, F4, KK1, in[6],   7);
-	ROUND(ccc, ddd, aaa, bbb, F4, KK1, in[15],  8);
-	ROUND(bbb, ccc, ddd, aaa, F4, KK1, in[8],  11);
-	ROUND(aaa, bbb, ccc, ddd, F4, KK1, in[1],  14);
-	ROUND(ddd, aaa, bbb, ccc, F4, KK1, in[10], 14);
-	ROUND(ccc, ddd, aaa, bbb, F4, KK1, in[3],  12);
-	ROUND(bbb, ccc, ddd, aaa, F4, KK1, in[12],  6);
-
-	/* Swap contents of "a" registers */
-	swap(aa, aaa);
-
-	/* round 2: left lane */
-	ROUND(aa, bb, cc, dd, F2, K2, in[7],   7);
-	ROUND(dd, aa, bb, cc, F2, K2, in[4],   6);
-	ROUND(cc, dd, aa, bb, F2, K2, in[13],  8);
-	ROUND(bb, cc, dd, aa, F2, K2, in[1],  13);
-	ROUND(aa, bb, cc, dd, F2, K2, in[10], 11);
-	ROUND(dd, aa, bb, cc, F2, K2, in[6],   9);
-	ROUND(cc, dd, aa, bb, F2, K2, in[15],  7);
-	ROUND(bb, cc, dd, aa, F2, K2, in[3],  15);
-	ROUND(aa, bb, cc, dd, F2, K2, in[12],  7);
-	ROUND(dd, aa, bb, cc, F2, K2, in[0],  12);
-	ROUND(cc, dd, aa, bb, F2, K2, in[9],  15);
-	ROUND(bb, cc, dd, aa, F2, K2, in[5],   9);
-	ROUND(aa, bb, cc, dd, F2, K2, in[2],  11);
-	ROUND(dd, aa, bb, cc, F2, K2, in[14],  7);
-	ROUND(cc, dd, aa, bb, F2, K2, in[11], 13);
-	ROUND(bb, cc, dd, aa, F2, K2, in[8],  12);
-
-	/* round 2: right lane */
-	ROUND(aaa, bbb, ccc, ddd, F3, KK2, in[6],   9);
-	ROUND(ddd, aaa, bbb, ccc, F3, KK2, in[11], 13);
-	ROUND(ccc, ddd, aaa, bbb, F3, KK2, in[3],  15);
-	ROUND(bbb, ccc, ddd, aaa, F3, KK2, in[7],   7);
-	ROUND(aaa, bbb, ccc, ddd, F3, KK2, in[0],  12);
-	ROUND(ddd, aaa, bbb, ccc, F3, KK2, in[13],  8);
-	ROUND(ccc, ddd, aaa, bbb, F3, KK2, in[5],   9);
-	ROUND(bbb, ccc, ddd, aaa, F3, KK2, in[10], 11);
-	ROUND(aaa, bbb, ccc, ddd, F3, KK2, in[14],  7);
-	ROUND(ddd, aaa, bbb, ccc, F3, KK2, in[15],  7);
-	ROUND(ccc, ddd, aaa, bbb, F3, KK2, in[8],  12);
-	ROUND(bbb, ccc, ddd, aaa, F3, KK2, in[12],  7);
-	ROUND(aaa, bbb, ccc, ddd, F3, KK2, in[4],   6);
-	ROUND(ddd, aaa, bbb, ccc, F3, KK2, in[9],  15);
-	ROUND(ccc, ddd, aaa, bbb, F3, KK2, in[1],  13);
-	ROUND(bbb, ccc, ddd, aaa, F3, KK2, in[2],  11);
-
-	/* Swap contents of "b" registers */
-	swap(bb, bbb);
-
-	/* round 3: left lane */
-	ROUND(aa, bb, cc, dd, F3, K3, in[3],  11);
-	ROUND(dd, aa, bb, cc, F3, K3, in[10], 13);
-	ROUND(cc, dd, aa, bb, F3, K3, in[14],  6);
-	ROUND(bb, cc, dd, aa, F3, K3, in[4],   7);
-	ROUND(aa, bb, cc, dd, F3, K3, in[9],  14);
-	ROUND(dd, aa, bb, cc, F3, K3, in[15],  9);
-	ROUND(cc, dd, aa, bb, F3, K3, in[8],  13);
-	ROUND(bb, cc, dd, aa, F3, K3, in[1],  15);
-	ROUND(aa, bb, cc, dd, F3, K3, in[2],  14);
-	ROUND(dd, aa, bb, cc, F3, K3, in[7],   8);
-	ROUND(cc, dd, aa, bb, F3, K3, in[0],  13);
-	ROUND(bb, cc, dd, aa, F3, K3, in[6],   6);
-	ROUND(aa, bb, cc, dd, F3, K3, in[13],  5);
-	ROUND(dd, aa, bb, cc, F3, K3, in[11], 12);
-	ROUND(cc, dd, aa, bb, F3, K3, in[5],   7);
-	ROUND(bb, cc, dd, aa, F3, K3, in[12],  5);
-
-	/* round 3: right lane */
-	ROUND(aaa, bbb, ccc, ddd, F2, KK3, in[15],  9);
-	ROUND(ddd, aaa, bbb, ccc, F2, KK3, in[5],   7);
-	ROUND(ccc, ddd, aaa, bbb, F2, KK3, in[1],  15);
-	ROUND(bbb, ccc, ddd, aaa, F2, KK3, in[3],  11);
-	ROUND(aaa, bbb, ccc, ddd, F2, KK3, in[7],   8);
-	ROUND(ddd, aaa, bbb, ccc, F2, KK3, in[14],  6);
-	ROUND(ccc, ddd, aaa, bbb, F2, KK3, in[6],   6);
-	ROUND(bbb, ccc, ddd, aaa, F2, KK3, in[9],  14);
-	ROUND(aaa, bbb, ccc, ddd, F2, KK3, in[11], 12);
-	ROUND(ddd, aaa, bbb, ccc, F2, KK3, in[8],  13);
-	ROUND(ccc, ddd, aaa, bbb, F2, KK3, in[12],  5);
-	ROUND(bbb, ccc, ddd, aaa, F2, KK3, in[2],  14);
-	ROUND(aaa, bbb, ccc, ddd, F2, KK3, in[10], 13);
-	ROUND(ddd, aaa, bbb, ccc, F2, KK3, in[0],  13);
-	ROUND(ccc, ddd, aaa, bbb, F2, KK3, in[4],   7);
-	ROUND(bbb, ccc, ddd, aaa, F2, KK3, in[13],  5);
-
-	/* Swap contents of "c" registers */
-	swap(cc, ccc);
-
-	/* round 4: left lane */
-	ROUND(aa, bb, cc, dd, F4, K4, in[1],  11);
-	ROUND(dd, aa, bb, cc, F4, K4, in[9],  12);
-	ROUND(cc, dd, aa, bb, F4, K4, in[11], 14);
-	ROUND(bb, cc, dd, aa, F4, K4, in[10], 15);
-	ROUND(aa, bb, cc, dd, F4, K4, in[0],  14);
-	ROUND(dd, aa, bb, cc, F4, K4, in[8],  15);
-	ROUND(cc, dd, aa, bb, F4, K4, in[12],  9);
-	ROUND(bb, cc, dd, aa, F4, K4, in[4],   8);
-	ROUND(aa, bb, cc, dd, F4, K4, in[13],  9);
-	ROUND(dd, aa, bb, cc, F4, K4, in[3],  14);
-	ROUND(cc, dd, aa, bb, F4, K4, in[7],   5);
-	ROUND(bb, cc, dd, aa, F4, K4, in[15],  6);
-	ROUND(aa, bb, cc, dd, F4, K4, in[14],  8);
-	ROUND(dd, aa, bb, cc, F4, K4, in[5],   6);
-	ROUND(cc, dd, aa, bb, F4, K4, in[6],   5);
-	ROUND(bb, cc, dd, aa, F4, K4, in[2],  12);
-
-	/* round 4: right lane */
-	ROUND(aaa, bbb, ccc, ddd, F1, KK4, in[8],  15);
-	ROUND(ddd, aaa, bbb, ccc, F1, KK4, in[6],   5);
-	ROUND(ccc, ddd, aaa, bbb, F1, KK4, in[4],   8);
-	ROUND(bbb, ccc, ddd, aaa, F1, KK4, in[1],  11);
-	ROUND(aaa, bbb, ccc, ddd, F1, KK4, in[3],  14);
-	ROUND(ddd, aaa, bbb, ccc, F1, KK4, in[11], 14);
-	ROUND(ccc, ddd, aaa, bbb, F1, KK4, in[15],  6);
-	ROUND(bbb, ccc, ddd, aaa, F1, KK4, in[0],  14);
-	ROUND(aaa, bbb, ccc, ddd, F1, KK4, in[5],   6);
-	ROUND(ddd, aaa, bbb, ccc, F1, KK4, in[12],  9);
-	ROUND(ccc, ddd, aaa, bbb, F1, KK4, in[2],  12);
-	ROUND(bbb, ccc, ddd, aaa, F1, KK4, in[13],  9);
-	ROUND(aaa, bbb, ccc, ddd, F1, KK4, in[9],  12);
-	ROUND(ddd, aaa, bbb, ccc, F1, KK4, in[7],   5);
-	ROUND(ccc, ddd, aaa, bbb, F1, KK4, in[10], 15);
-	ROUND(bbb, ccc, ddd, aaa, F1, KK4, in[14],  8);
-
-	/* Swap contents of "d" registers */
-	swap(dd, ddd);
-
-	/* combine results */
-	state[0] += aa;
-	state[1] += bb;
-	state[2] += cc;
-	state[3] += dd;
-	state[4] += aaa;
-	state[5] += bbb;
-	state[6] += ccc;
-	state[7] += ddd;
-}
-
-static int rmd256_init(struct shash_desc *desc)
-{
-	struct rmd256_ctx *rctx = shash_desc_ctx(desc);
-
-	rctx->byte_count = 0;
-
-	rctx->state[0] = RMD_H0;
-	rctx->state[1] = RMD_H1;
-	rctx->state[2] = RMD_H2;
-	rctx->state[3] = RMD_H3;
-	rctx->state[4] = RMD_H5;
-	rctx->state[5] = RMD_H6;
-	rctx->state[6] = RMD_H7;
-	rctx->state[7] = RMD_H8;
-
-	memset(rctx->buffer, 0, sizeof(rctx->buffer));
-
-	return 0;
-}
-
-static int rmd256_update(struct shash_desc *desc, const u8 *data,
-			 unsigned int len)
-{
-	struct rmd256_ctx *rctx = shash_desc_ctx(desc);
-	const u32 avail = sizeof(rctx->buffer) - (rctx->byte_count & 0x3f);
-
-	rctx->byte_count += len;
-
-	/* Enough space in buffer? If so copy and we're done */
-	if (avail > len) {
-		memcpy((char *)rctx->buffer + (sizeof(rctx->buffer) - avail),
-		       data, len);
-		goto out;
-	}
-
-	memcpy((char *)rctx->buffer + (sizeof(rctx->buffer) - avail),
-	       data, avail);
-
-	rmd256_transform(rctx->state, rctx->buffer);
-	data += avail;
-	len -= avail;
-
-	while (len >= sizeof(rctx->buffer)) {
-		memcpy(rctx->buffer, data, sizeof(rctx->buffer));
-		rmd256_transform(rctx->state, rctx->buffer);
-		data += sizeof(rctx->buffer);
-		len -= sizeof(rctx->buffer);
-	}
-
-	memcpy(rctx->buffer, data, len);
-
-out:
-	return 0;
-}
-
-/* Add padding and return the message digest. */
-static int rmd256_final(struct shash_desc *desc, u8 *out)
-{
-	struct rmd256_ctx *rctx = shash_desc_ctx(desc);
-	u32 i, index, padlen;
-	__le64 bits;
-	__le32 *dst = (__le32 *)out;
-	static const u8 padding[64] = { 0x80, };
-
-	bits = cpu_to_le64(rctx->byte_count << 3);
-
-	/* Pad out to 56 mod 64 */
-	index = rctx->byte_count & 0x3f;
-	padlen = (index < 56) ? (56 - index) : ((64+56) - index);
-	rmd256_update(desc, padding, padlen);
-
-	/* Append length */
-	rmd256_update(desc, (const u8 *)&bits, sizeof(bits));
-
-	/* Store state in digest */
-	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_le32p(&rctx->state[i]);
-
-	/* Wipe context */
-	memset(rctx, 0, sizeof(*rctx));
-
-	return 0;
-}
-
-static struct shash_alg alg = {
-	.digestsize	=	RMD256_DIGEST_SIZE,
-	.init		=	rmd256_init,
-	.update		=	rmd256_update,
-	.final		=	rmd256_final,
-	.descsize	=	sizeof(struct rmd256_ctx),
-	.base		=	{
-		.cra_name	 =	"rmd256",
-		.cra_driver_name =	"rmd256-generic",
-		.cra_blocksize	 =	RMD256_BLOCK_SIZE,
-		.cra_module	 =	THIS_MODULE,
-	}
-};
-
-static int __init rmd256_mod_init(void)
-{
-	return crypto_register_shash(&alg);
-}
-
-static void __exit rmd256_mod_fini(void)
-{
-	crypto_unregister_shash(&alg);
-}
-
-subsys_initcall(rmd256_mod_init);
-module_exit(rmd256_mod_fini);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Adrian-Ken Rueegsegger <ken@codelabs.ch>");
-MODULE_DESCRIPTION("RIPEMD-256 Message Digest");
-MODULE_ALIAS_CRYPTO("rmd256");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index bc9e2910f5c3..3fb842cb2c67 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -71,7 +71,7 @@ static const char *check[] = {
 	"blowfish", "twofish", "serpent", "sha384", "sha512", "md4", "aes",
 	"cast6", "arc4", "michael_mic", "deflate", "crc32c", "tea", "xtea",
 	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
-	"camellia", "seed", "salsa20", "rmd160", "rmd256", "rmd320",
+	"camellia", "seed", "salsa20", "rmd160", "rmd320",
 	"lzo", "lzo-rle", "cts", "sha3-224", "sha3-256", "sha3-384",
 	"sha3-512", "streebog256", "streebog512",
 	NULL
@@ -1871,10 +1871,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		ret += tcrypt_test("rmd160");
 		break;
 
-	case 41:
-		ret += tcrypt_test("rmd256");
-		break;
-
 	case 42:
 		ret += tcrypt_test("rmd320");
 		break;
@@ -2405,10 +2401,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_hash_speed("rmd160", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
-	case 316:
-		test_hash_speed("rmd256", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
 	case 317:
 		test_hash_speed("rmd320", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
@@ -2525,10 +2517,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_ahash_speed("rmd160", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
-	case 416:
-		test_ahash_speed("rmd256", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
 	case 417:
 		test_ahash_speed("rmd320", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f8a5cec614d6..c35de56fc25a 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5275,12 +5275,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.hash = __VECS(rmd160_tv_template)
 		}
-	}, {
-		.alg = "rmd256",
-		.test = alg_test_hash,
-		.suite = {
-			.hash = __VECS(rmd256_tv_template)
-		}
 	}, {
 		.alg = "rmd320",
 		.test = alg_test_hash,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 05807872846c..86abd1f79aab 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -3200,70 +3200,6 @@ static const struct hash_testvec rmd160_tv_template[] = {
 	}
 };
 
-/*
- * RIPEMD-256 test vectors
- */
-static const struct hash_testvec rmd256_tv_template[] = {
-	{
-		.digest	= "\x02\xba\x4c\x4e\x5f\x8e\xcd\x18"
-			  "\x77\xfc\x52\xd6\x4d\x30\xe3\x7a"
-			  "\x2d\x97\x74\xfb\x1e\x5d\x02\x63"
-			  "\x80\xae\x01\x68\xe3\xc5\x52\x2d",
-	}, {
-		.plaintext = "a",
-		.psize	= 1,
-		.digest	= "\xf9\x33\x3e\x45\xd8\x57\xf5\xd9"
-			  "\x0a\x91\xba\xb7\x0a\x1e\xba\x0c"
-			  "\xfb\x1b\xe4\xb0\x78\x3c\x9a\xcf"
-			  "\xcd\x88\x3a\x91\x34\x69\x29\x25",
-	}, {
-		.plaintext = "abc",
-		.psize	= 3,
-		.digest	= "\xaf\xbd\x6e\x22\x8b\x9d\x8c\xbb"
-			  "\xce\xf5\xca\x2d\x03\xe6\xdb\xa1"
-			  "\x0a\xc0\xbc\x7d\xcb\xe4\x68\x0e"
-			  "\x1e\x42\xd2\xe9\x75\x45\x9b\x65",
-	}, {
-		.plaintext = "message digest",
-		.psize	= 14,
-		.digest	= "\x87\xe9\x71\x75\x9a\x1c\xe4\x7a"
-			  "\x51\x4d\x5c\x91\x4c\x39\x2c\x90"
-			  "\x18\xc7\xc4\x6b\xc1\x44\x65\x55"
-			  "\x4a\xfc\xdf\x54\xa5\x07\x0c\x0e",
-	}, {
-		.plaintext = "abcdefghijklmnopqrstuvwxyz",
-		.psize	= 26,
-		.digest	= "\x64\x9d\x30\x34\x75\x1e\xa2\x16"
-			  "\x77\x6b\xf9\xa1\x8a\xcc\x81\xbc"
-			  "\x78\x96\x11\x8a\x51\x97\x96\x87"
-			  "\x82\xdd\x1f\xd9\x7d\x8d\x51\x33",
-	}, {
-		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcde"
-			     "fghijklmnopqrstuvwxyz0123456789",
-		.psize	= 62,
-		.digest	= "\x57\x40\xa4\x08\xac\x16\xb7\x20"
-			  "\xb8\x44\x24\xae\x93\x1c\xbb\x1f"
-			  "\xe3\x63\xd1\xd0\xbf\x40\x17\xf1"
-			  "\xa8\x9f\x7e\xa6\xde\x77\xa0\xb8",
-	}, {
-		.plaintext = "1234567890123456789012345678901234567890"
-			     "1234567890123456789012345678901234567890",
-		.psize	= 80,
-		.digest	= "\x06\xfd\xcc\x7a\x40\x95\x48\xaa"
-			  "\xf9\x13\x68\xc0\x6a\x62\x75\xb5"
-			  "\x53\xe3\xf0\x99\xbf\x0e\xa4\xed"
-			  "\xfd\x67\x78\xdf\x89\xa8\x90\xdd",
-	}, {
-		.plaintext = "abcdbcdecdefdefgefghfghighij"
-			     "hijkijkljklmklmnlmnomnopnopq",
-		.psize	= 56,
-		.digest	= "\x38\x43\x04\x55\x83\xaa\xc6\xc8"
-			  "\xc8\xd9\x12\x85\x73\xe7\xa9\x80"
-			  "\x9a\xfb\x2a\x0f\x34\xcc\xc3\x6e"
-			  "\xa9\xe7\x2f\x16\xf6\x36\x8e\x3f",
-	}
-};
-
 /*
  * RIPEMD-320 test vectors
  */
-- 
2.17.1

