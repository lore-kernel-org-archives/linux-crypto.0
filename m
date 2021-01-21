Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF2CFC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 13:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 666CD239FF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 13:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbhAUNJK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 08:09:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731811AbhAUNIb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 08:08:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B170E23A01;
        Thu, 21 Jan 2021 13:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611234466;
        bh=4b/pYk4J6MzzaZTZwxghjIKG4KMf+eslx5kHFd0kDGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlF3kisk8VrefkUgoh+bsTTE29xa2F1jp6BnAesZhPrme2MicxRqF4f+CTb42rFOG
         oh7e4QramOHlqeupJyw54iwho3mv9YS9OwQNIRhfW78KTDd15kCB0sPxj9EJPLlrcT
         3VOGIOy4EI6qte3m5ToglnA2Ky7X3ZqGB9deb5ClAwnleRWNHObgLcnniWhR7BFKSx
         3LldUs+/UpL36uFbyvkd6jGj1zNt9J70UdOyMiDnhEdz/D2MUo9n9xTW5iLjTQM03D
         wGez6r3rh1k8OS19+MIwK374AGSrh1W2nKrzB2VGVHFAuBOiKmDP5J8O/Yt02/OToX
         /PQ6zJw5UuBrw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/5] crypto: remove RIPE-MD 128 hash algorithm
Date:   Thu, 21 Jan 2021 14:07:29 +0100
Message-Id: <20210121130733.1649-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210121130733.1649-1-ardb@kernel.org>
References: <20210121130733.1649-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

RIPE-MD 128 is never referenced anywhere in the kernel, and unlikely
to be depended upon by userspace via AF_ALG. So let's remove it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Kconfig   |  13 -
 crypto/Makefile  |   1 -
 crypto/ripemd.h  |   3 -
 crypto/rmd128.c  | 323 --------------------
 crypto/tcrypt.c  |  18 +-
 crypto/testmgr.c |  12 -
 crypto/testmgr.h | 137 ---------
 7 files changed, 1 insertion(+), 506 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 94f0fde06b94..a14da8290abb 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -817,19 +817,6 @@ config CRYPTO_MICHAEL_MIC
 	  should not be used for other purposes because of the weakness
 	  of the algorithm.
 
-config CRYPTO_RMD128
-	tristate "RIPEMD-128 digest algorithm"
-	select CRYPTO_HASH
-	help
-	  RIPEMD-128 (ISO/IEC 10118-3:2004).
-
-	  RIPEMD-128 is a 128-bit cryptographic hash function. It should only
-	  be used as a secure replacement for RIPEMD. For other use cases,
-	  RIPEMD-160 should be used.
-
-	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-	  See <https://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
-
 config CRYPTO_RMD160
 	tristate "RIPEMD-160 digest algorithm"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index b279483fba50..c4d8f86a106c 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -67,7 +67,6 @@ obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
 obj-$(CONFIG_CRYPTO_NULL2) += crypto_null.o
 obj-$(CONFIG_CRYPTO_MD4) += md4.o
 obj-$(CONFIG_CRYPTO_MD5) += md5.o
-obj-$(CONFIG_CRYPTO_RMD128) += rmd128.o
 obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
 obj-$(CONFIG_CRYPTO_RMD256) += rmd256.o
 obj-$(CONFIG_CRYPTO_RMD320) += rmd320.o
diff --git a/crypto/ripemd.h b/crypto/ripemd.h
index 93edbf52197d..0f66e3c86a2b 100644
--- a/crypto/ripemd.h
+++ b/crypto/ripemd.h
@@ -6,9 +6,6 @@
 #ifndef _CRYPTO_RMD_H
 #define _CRYPTO_RMD_H
 
-#define RMD128_DIGEST_SIZE      16
-#define RMD128_BLOCK_SIZE       64
-
 #define RMD160_DIGEST_SIZE      20
 #define RMD160_BLOCK_SIZE       64
 
diff --git a/crypto/rmd128.c b/crypto/rmd128.c
deleted file mode 100644
index 29308fb97e7e..000000000000
--- a/crypto/rmd128.c
+++ /dev/null
@@ -1,323 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Cryptographic API.
- *
- * RIPEMD-128 - RACE Integrity Primitives Evaluation Message Digest.
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
-struct rmd128_ctx {
-	u64 byte_count;
-	u32 state[4];
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
-	(a) += f((b), (c), (d)) + le32_to_cpup(&(x)) + (k);	\
-	(a) = rol32((a), (s)); \
-}
-
-static void rmd128_transform(u32 *state, const __le32 *in)
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
-	aaa = state[0];
-	bbb = state[1];
-	ccc = state[2];
-	ddd = state[3];
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
-	/* combine results */
-	ddd += cc + state[1];		/* final result for state[0] */
-	state[1] = state[2] + dd + aaa;
-	state[2] = state[3] + aa + bbb;
-	state[3] = state[0] + bb + ccc;
-	state[0] = ddd;
-}
-
-static int rmd128_init(struct shash_desc *desc)
-{
-	struct rmd128_ctx *rctx = shash_desc_ctx(desc);
-
-	rctx->byte_count = 0;
-
-	rctx->state[0] = RMD_H0;
-	rctx->state[1] = RMD_H1;
-	rctx->state[2] = RMD_H2;
-	rctx->state[3] = RMD_H3;
-
-	memset(rctx->buffer, 0, sizeof(rctx->buffer));
-
-	return 0;
-}
-
-static int rmd128_update(struct shash_desc *desc, const u8 *data,
-			 unsigned int len)
-{
-	struct rmd128_ctx *rctx = shash_desc_ctx(desc);
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
-	rmd128_transform(rctx->state, rctx->buffer);
-	data += avail;
-	len -= avail;
-
-	while (len >= sizeof(rctx->buffer)) {
-		memcpy(rctx->buffer, data, sizeof(rctx->buffer));
-		rmd128_transform(rctx->state, rctx->buffer);
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
-static int rmd128_final(struct shash_desc *desc, u8 *out)
-{
-	struct rmd128_ctx *rctx = shash_desc_ctx(desc);
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
-	rmd128_update(desc, padding, padlen);
-
-	/* Append length */
-	rmd128_update(desc, (const u8 *)&bits, sizeof(bits));
-
-	/* Store state in digest */
-	for (i = 0; i < 4; i++)
-		dst[i] = cpu_to_le32p(&rctx->state[i]);
-
-	/* Wipe context */
-	memset(rctx, 0, sizeof(*rctx));
-
-	return 0;
-}
-
-static struct shash_alg alg = {
-	.digestsize	=	RMD128_DIGEST_SIZE,
-	.init		=	rmd128_init,
-	.update		=	rmd128_update,
-	.final		=	rmd128_final,
-	.descsize	=	sizeof(struct rmd128_ctx),
-	.base		=	{
-		.cra_name	 =	"rmd128",
-		.cra_driver_name =	"rmd128-generic",
-		.cra_blocksize	 =	RMD128_BLOCK_SIZE,
-		.cra_module	 =	THIS_MODULE,
-	}
-};
-
-static int __init rmd128_mod_init(void)
-{
-	return crypto_register_shash(&alg);
-}
-
-static void __exit rmd128_mod_fini(void)
-{
-	crypto_unregister_shash(&alg);
-}
-
-subsys_initcall(rmd128_mod_init);
-module_exit(rmd128_mod_fini);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Adrian-Ken Rueegsegger <ken@codelabs.ch>");
-MODULE_DESCRIPTION("RIPEMD-128 Message Digest");
-MODULE_ALIAS_CRYPTO("rmd128");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index a4a11d2b57bd..bc9e2910f5c3 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -71,7 +71,7 @@ static const char *check[] = {
 	"blowfish", "twofish", "serpent", "sha384", "sha512", "md4", "aes",
 	"cast6", "arc4", "michael_mic", "deflate", "crc32c", "tea", "xtea",
 	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
-	"camellia", "seed", "salsa20", "rmd128", "rmd160", "rmd256", "rmd320",
+	"camellia", "seed", "salsa20", "rmd160", "rmd256", "rmd320",
 	"lzo", "lzo-rle", "cts", "sha3-224", "sha3-256", "sha3-384",
 	"sha3-512", "streebog256", "streebog512",
 	NULL
@@ -1867,10 +1867,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		ret += tcrypt_test("cts(cbc(aes))");
 		break;
 
-        case 39:
-		ret += tcrypt_test("rmd128");
-		break;
-
         case 40:
 		ret += tcrypt_test("rmd160");
 		break;
@@ -1955,10 +1951,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		ret += tcrypt_test("xcbc(aes)");
 		break;
 
-	case 107:
-		ret += tcrypt_test("hmac(rmd128)");
-		break;
-
 	case 108:
 		ret += tcrypt_test("hmac(rmd160)");
 		break;
@@ -2409,10 +2401,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_hash_speed("sha224", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
-	case 314:
-		test_hash_speed("rmd128", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
 	case 315:
 		test_hash_speed("rmd160", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
@@ -2533,10 +2521,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_ahash_speed("sha224", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
-	case 414:
-		test_ahash_speed("rmd128", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
 	case 415:
 		test_ahash_speed("rmd160", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a896d77e9611..f8a5cec614d6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4957,12 +4957,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.hash = __VECS(hmac_md5_tv_template)
 		}
-	}, {
-		.alg = "hmac(rmd128)",
-		.test = alg_test_hash,
-		.suite = {
-			.hash = __VECS(hmac_rmd128_tv_template)
-		}
 	}, {
 		.alg = "hmac(rmd160)",
 		.test = alg_test_hash,
@@ -5275,12 +5269,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 				.aad_iv = 1,
 			}
 		}
-	}, {
-		.alg = "rmd128",
-		.test = alg_test_hash,
-		.suite = {
-			.hash = __VECS(rmd128_tv_template)
-		}
 	}, {
 		.alg = "rmd160",
 		.test = alg_test_hash,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 8c83811c0e35..05807872846c 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -3140,66 +3140,6 @@ static const struct hash_testvec md5_tv_template[] = {
 
 };
 
-/*
- * RIPEMD-128 test vectors from ISO/IEC 10118-3:2004(E)
- */
-static const struct hash_testvec rmd128_tv_template[] = {
-	{
-		.digest	= "\xcd\xf2\x62\x13\xa1\x50\xdc\x3e"
-			  "\xcb\x61\x0f\x18\xf6\xb3\x8b\x46",
-	}, {
-		.plaintext = "a",
-		.psize	= 1,
-		.digest	= "\x86\xbe\x7a\xfa\x33\x9d\x0f\xc7"
-			  "\xcf\xc7\x85\xe7\x2f\x57\x8d\x33",
-	}, {
-		.plaintext = "abc",
-		.psize	= 3,
-		.digest	= "\xc1\x4a\x12\x19\x9c\x66\xe4\xba"
-			  "\x84\x63\x6b\x0f\x69\x14\x4c\x77",
-	}, {
-		.plaintext = "message digest",
-		.psize	= 14,
-		.digest	= "\x9e\x32\x7b\x3d\x6e\x52\x30\x62"
-			  "\xaf\xc1\x13\x2d\x7d\xf9\xd1\xb8",
-	}, {
-		.plaintext = "abcdefghijklmnopqrstuvwxyz",
-		.psize	= 26,
-		.digest	= "\xfd\x2a\xa6\x07\xf7\x1d\xc8\xf5"
-			  "\x10\x71\x49\x22\xb3\x71\x83\x4e",
-	}, {
-		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcde"
-			     "fghijklmnopqrstuvwxyz0123456789",
-		.psize	= 62,
-		.digest	= "\xd1\xe9\x59\xeb\x17\x9c\x91\x1f"
-			  "\xae\xa4\x62\x4c\x60\xc5\xc7\x02",
-	}, {
-		.plaintext = "1234567890123456789012345678901234567890"
-			     "1234567890123456789012345678901234567890",
-		.psize	= 80,
-		.digest	= "\x3f\x45\xef\x19\x47\x32\xc2\xdb"
-			  "\xb2\xc4\xa2\xc7\x69\x79\x5f\xa3",
-	}, {
-		.plaintext = "abcdbcdecdefdefgefghfghighij"
-			     "hijkijkljklmklmnlmnomnopnopq",
-		.psize	= 56,
-		.digest	= "\xa1\xaa\x06\x89\xd0\xfa\xfa\x2d"
-			  "\xdc\x22\xe8\x8b\x49\x13\x3a\x06",
-	}, {
-		.plaintext = "abcdefghbcdefghicdefghijdefghijkefghijklfghi"
-			     "jklmghijklmnhijklmnoijklmnopjklmnopqklmnopqr"
-			     "lmnopqrsmnopqrstnopqrstu",
-		.psize	= 112,
-		.digest	= "\xd4\xec\xc9\x13\xe1\xdf\x77\x6b"
-			  "\xf4\x8d\xe9\xd5\x5b\x1f\x25\x46",
-	}, {
-		.plaintext = "abcdbcdecdefdefgefghfghighijhijk",
-		.psize	= 32,
-		.digest	= "\x13\xfc\x13\xe8\xef\xff\x34\x7d"
-			  "\xe1\x93\xff\x46\xdb\xac\xcf\xd4",
-	}
-};
-
 /*
  * RIPEMD-160 test vectors from ISO/IEC 10118-3:2004(E)
  */
@@ -5452,83 +5392,6 @@ static const struct hash_testvec hmac_md5_tv_template[] =
 	},
 };
 
-/*
- * HMAC-RIPEMD128 test vectors from RFC2286
- */
-static const struct hash_testvec hmac_rmd128_tv_template[] = {
-	{
-		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
-		.ksize	= 16,
-		.plaintext = "Hi There",
-		.psize	= 8,
-		.digest	= "\xfb\xf6\x1f\x94\x92\xaa\x4b\xbf"
-			  "\x81\xc1\x72\xe8\x4e\x07\x34\xdb",
-	}, {
-		.key	= "Jefe",
-		.ksize	= 4,
-		.plaintext = "what do ya want for nothing?",
-		.psize	= 28,
-		.digest	= "\x87\x5f\x82\x88\x62\xb6\xb3\x34"
-			  "\xb4\x27\xc5\x5f\x9f\x7f\xf0\x9b",
-	}, {
-		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa",
-		.ksize	= 16,
-		.plaintext = "\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd"
-			"\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd"
-			"\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd"
-			"\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd",
-		.psize	= 50,
-		.digest	= "\x09\xf0\xb2\x84\x6d\x2f\x54\x3d"
-			  "\xa3\x63\xcb\xec\x8d\x62\xa3\x8d",
-	}, {
-		.key	= "\x01\x02\x03\x04\x05\x06\x07\x08"
-			  "\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10"
-			  "\x11\x12\x13\x14\x15\x16\x17\x18\x19",
-		.ksize	= 25,
-		.plaintext = "\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
-			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
-			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
-			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd",
-		.psize	= 50,
-		.digest	= "\xbd\xbb\xd7\xcf\x03\xe4\x4b\x5a"
-			  "\xa6\x0a\xf8\x15\xbe\x4d\x22\x94",
-	}, {
-		.key	= "\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c",
-		.ksize	= 16,
-		.plaintext = "Test With Truncation",
-		.psize	= 20,
-		.digest	= "\xe7\x98\x08\xf2\x4b\x25\xfd\x03"
-			  "\x1c\x15\x5f\x0d\x55\x1d\x9a\x3a",
-	}, {
-		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
-			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
-			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
-			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
-			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
-			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
-			"\xaa\xaa",
-		.ksize	= 80,
-		.plaintext = "Test Using Larger Than Block-Size Key - Hash Key First",
-		.psize	= 54,
-		.digest	= "\xdc\x73\x29\x28\xde\x98\x10\x4a"
-			  "\x1f\x59\xd3\x73\xc1\x50\xac\xbb",
-	}, {
-		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
-			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
-			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
-			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
-			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
-			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
-			"\xaa\xaa",
-		.ksize	= 80,
-		.plaintext = "Test Using Larger Than Block-Size Key and Larger Than One "
-			   "Block-Size Data",
-		.psize	= 73,
-		.digest	= "\x5c\x6b\xec\x96\x79\x3e\x16\xd4"
-			  "\x06\x90\xc2\x37\x63\x5f\x30\xc5",
-	},
-};
-
 /*
  * HMAC-RIPEMD160 test vectors from RFC2286
  */
-- 
2.17.1

