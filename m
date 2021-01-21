Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AED7C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 13:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6B2D23A00
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 13:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbhAUNJQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 08:09:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731823AbhAUNIb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 08:08:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF99D23A04;
        Thu, 21 Jan 2021 13:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611234470;
        bh=zzS4SQ4sI6C1k8Ip31eeISgVgdN+8hNPAoSBmUANfR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zs3j+uw0OJa9AVmmnCdJK4MaLS32EEgCEy/GB5vV0SVOGD5Jjl4atnQuuPYD+hIQr
         bAQLRwF18TLk2jhTpqLfo4Kp7KEftxX8LEb2ybRsREO9J7x/D+NM34Hb9a2RkzQTmh
         ZORIsBlkVsKTzH/xPJm766bnfet9aVxhTikeplmHUjNCsTFZGA/VAcVCA0e+16NTaX
         Ytn5ofeIgs0egRy34b+hb/6r9X3r43jvHBcZkad3ESdgtHioMbYx+HNzxryTUATfHt
         /amMUmvlnN/W4fhtdrUKI8BextA0m8LboL8UQNw144qsKc6X7OR5qF7U1N2h/ItySd
         9/y/8J0ncLvTA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/5] crypto: remove RIPE-MD 320 hash algorithm
Date:   Thu, 21 Jan 2021 14:07:31 +0100
Message-Id: <20210121130733.1649-4-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210121130733.1649-1-ardb@kernel.org>
References: <20210121130733.1649-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

RIPE-MD 320 is never referenced anywhere in the kernel, and unlikely
to be depended upon by userspace via AF_ALG. So let's remove it

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Kconfig   |  12 -
 crypto/ripemd.h  |   8 -
 crypto/rmd320.c  | 391 --------------------
 crypto/tcrypt.c  |  14 +-
 crypto/testmgr.c |   6 -
 crypto/testmgr.h |  64 ----
 6 files changed, 1 insertion(+), 494 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8e93dce161b0..a32e25cca2b4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -834,18 +834,6 @@ config CRYPTO_RMD160
 	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
 	  See <https://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
 
-config CRYPTO_RMD320
-	tristate "RIPEMD-320 digest algorithm"
-	select CRYPTO_HASH
-	help
-	  RIPEMD-320 is an optional extension of RIPEMD-160 with a
-	  320 bit hash. It is intended for applications that require
-	  longer hash-results, without needing a larger security level
-	  (than RIPEMD-160).
-
-	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-	  See <https://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
-
 config CRYPTO_SHA1
 	tristate "SHA1 digest algorithm"
 	select CRYPTO_HASH
diff --git a/crypto/ripemd.h b/crypto/ripemd.h
index a19c3c27a466..b977785e2a62 100644
--- a/crypto/ripemd.h
+++ b/crypto/ripemd.h
@@ -9,20 +9,12 @@
 #define RMD160_DIGEST_SIZE      20
 #define RMD160_BLOCK_SIZE       64
 
-#define RMD320_DIGEST_SIZE      40
-#define RMD320_BLOCK_SIZE       64
-
 /* initial values  */
 #define RMD_H0  0x67452301UL
 #define RMD_H1  0xefcdab89UL
 #define RMD_H2  0x98badcfeUL
 #define RMD_H3  0x10325476UL
 #define RMD_H4  0xc3d2e1f0UL
-#define RMD_H5  0x76543210UL
-#define RMD_H6  0xfedcba98UL
-#define RMD_H7  0x89abcdefUL
-#define RMD_H8  0x01234567UL
-#define RMD_H9  0x3c2d1e0fUL
 
 /* constants */
 #define RMD_K1  0x00000000UL
diff --git a/crypto/rmd320.c b/crypto/rmd320.c
deleted file mode 100644
index c919ad6c4705..000000000000
--- a/crypto/rmd320.c
+++ /dev/null
@@ -1,391 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Cryptographic API.
- *
- * RIPEMD-320 - RACE Integrity Primitives Evaluation Message Digest.
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
-struct rmd320_ctx {
-	u64 byte_count;
-	u32 state[10];
-	__le32 buffer[16];
-};
-
-#define K1  RMD_K1
-#define K2  RMD_K2
-#define K3  RMD_K3
-#define K4  RMD_K4
-#define K5  RMD_K5
-#define KK1 RMD_K6
-#define KK2 RMD_K7
-#define KK3 RMD_K8
-#define KK4 RMD_K9
-#define KK5 RMD_K1
-
-#define F1(x, y, z) (x ^ y ^ z)		/* XOR */
-#define F2(x, y, z) (z ^ (x & (y ^ z)))	/* x ? y : z */
-#define F3(x, y, z) ((x | ~y) ^ z)
-#define F4(x, y, z) (y ^ (z & (x ^ y)))	/* z ? x : y */
-#define F5(x, y, z) (x ^ (y | ~z))
-
-#define ROUND(a, b, c, d, e, f, k, x, s)  { \
-	(a) += f((b), (c), (d)) + le32_to_cpup(&(x)) + (k); \
-	(a) = rol32((a), (s)) + (e); \
-	(c) = rol32((c), 10); \
-}
-
-static void rmd320_transform(u32 *state, const __le32 *in)
-{
-	u32 aa, bb, cc, dd, ee, aaa, bbb, ccc, ddd, eee;
-
-	/* Initialize left lane */
-	aa = state[0];
-	bb = state[1];
-	cc = state[2];
-	dd = state[3];
-	ee = state[4];
-
-	/* Initialize right lane */
-	aaa = state[5];
-	bbb = state[6];
-	ccc = state[7];
-	ddd = state[8];
-	eee = state[9];
-
-	/* round 1: left lane */
-	ROUND(aa, bb, cc, dd, ee, F1, K1, in[0],  11);
-	ROUND(ee, aa, bb, cc, dd, F1, K1, in[1],  14);
-	ROUND(dd, ee, aa, bb, cc, F1, K1, in[2],  15);
-	ROUND(cc, dd, ee, aa, bb, F1, K1, in[3],  12);
-	ROUND(bb, cc, dd, ee, aa, F1, K1, in[4],   5);
-	ROUND(aa, bb, cc, dd, ee, F1, K1, in[5],   8);
-	ROUND(ee, aa, bb, cc, dd, F1, K1, in[6],   7);
-	ROUND(dd, ee, aa, bb, cc, F1, K1, in[7],   9);
-	ROUND(cc, dd, ee, aa, bb, F1, K1, in[8],  11);
-	ROUND(bb, cc, dd, ee, aa, F1, K1, in[9],  13);
-	ROUND(aa, bb, cc, dd, ee, F1, K1, in[10], 14);
-	ROUND(ee, aa, bb, cc, dd, F1, K1, in[11], 15);
-	ROUND(dd, ee, aa, bb, cc, F1, K1, in[12],  6);
-	ROUND(cc, dd, ee, aa, bb, F1, K1, in[13],  7);
-	ROUND(bb, cc, dd, ee, aa, F1, K1, in[14],  9);
-	ROUND(aa, bb, cc, dd, ee, F1, K1, in[15],  8);
-
-	/* round 1: right lane */
-	ROUND(aaa, bbb, ccc, ddd, eee, F5, KK1, in[5],   8);
-	ROUND(eee, aaa, bbb, ccc, ddd, F5, KK1, in[14],  9);
-	ROUND(ddd, eee, aaa, bbb, ccc, F5, KK1, in[7],   9);
-	ROUND(ccc, ddd, eee, aaa, bbb, F5, KK1, in[0],  11);
-	ROUND(bbb, ccc, ddd, eee, aaa, F5, KK1, in[9],  13);
-	ROUND(aaa, bbb, ccc, ddd, eee, F5, KK1, in[2],  15);
-	ROUND(eee, aaa, bbb, ccc, ddd, F5, KK1, in[11], 15);
-	ROUND(ddd, eee, aaa, bbb, ccc, F5, KK1, in[4],   5);
-	ROUND(ccc, ddd, eee, aaa, bbb, F5, KK1, in[13],  7);
-	ROUND(bbb, ccc, ddd, eee, aaa, F5, KK1, in[6],   7);
-	ROUND(aaa, bbb, ccc, ddd, eee, F5, KK1, in[15],  8);
-	ROUND(eee, aaa, bbb, ccc, ddd, F5, KK1, in[8],  11);
-	ROUND(ddd, eee, aaa, bbb, ccc, F5, KK1, in[1],  14);
-	ROUND(ccc, ddd, eee, aaa, bbb, F5, KK1, in[10], 14);
-	ROUND(bbb, ccc, ddd, eee, aaa, F5, KK1, in[3],  12);
-	ROUND(aaa, bbb, ccc, ddd, eee, F5, KK1, in[12],  6);
-
-	/* Swap contents of "a" registers */
-	swap(aa, aaa);
-
-	/* round 2: left lane" */
-	ROUND(ee, aa, bb, cc, dd, F2, K2, in[7],   7);
-	ROUND(dd, ee, aa, bb, cc, F2, K2, in[4],   6);
-	ROUND(cc, dd, ee, aa, bb, F2, K2, in[13],  8);
-	ROUND(bb, cc, dd, ee, aa, F2, K2, in[1],  13);
-	ROUND(aa, bb, cc, dd, ee, F2, K2, in[10], 11);
-	ROUND(ee, aa, bb, cc, dd, F2, K2, in[6],   9);
-	ROUND(dd, ee, aa, bb, cc, F2, K2, in[15],  7);
-	ROUND(cc, dd, ee, aa, bb, F2, K2, in[3],  15);
-	ROUND(bb, cc, dd, ee, aa, F2, K2, in[12],  7);
-	ROUND(aa, bb, cc, dd, ee, F2, K2, in[0],  12);
-	ROUND(ee, aa, bb, cc, dd, F2, K2, in[9],  15);
-	ROUND(dd, ee, aa, bb, cc, F2, K2, in[5],   9);
-	ROUND(cc, dd, ee, aa, bb, F2, K2, in[2],  11);
-	ROUND(bb, cc, dd, ee, aa, F2, K2, in[14],  7);
-	ROUND(aa, bb, cc, dd, ee, F2, K2, in[11], 13);
-	ROUND(ee, aa, bb, cc, dd, F2, K2, in[8],  12);
-
-	/* round 2: right lane */
-	ROUND(eee, aaa, bbb, ccc, ddd, F4, KK2, in[6],   9);
-	ROUND(ddd, eee, aaa, bbb, ccc, F4, KK2, in[11], 13);
-	ROUND(ccc, ddd, eee, aaa, bbb, F4, KK2, in[3],  15);
-	ROUND(bbb, ccc, ddd, eee, aaa, F4, KK2, in[7],   7);
-	ROUND(aaa, bbb, ccc, ddd, eee, F4, KK2, in[0],  12);
-	ROUND(eee, aaa, bbb, ccc, ddd, F4, KK2, in[13],  8);
-	ROUND(ddd, eee, aaa, bbb, ccc, F4, KK2, in[5],   9);
-	ROUND(ccc, ddd, eee, aaa, bbb, F4, KK2, in[10], 11);
-	ROUND(bbb, ccc, ddd, eee, aaa, F4, KK2, in[14],  7);
-	ROUND(aaa, bbb, ccc, ddd, eee, F4, KK2, in[15],  7);
-	ROUND(eee, aaa, bbb, ccc, ddd, F4, KK2, in[8],  12);
-	ROUND(ddd, eee, aaa, bbb, ccc, F4, KK2, in[12],  7);
-	ROUND(ccc, ddd, eee, aaa, bbb, F4, KK2, in[4],   6);
-	ROUND(bbb, ccc, ddd, eee, aaa, F4, KK2, in[9],  15);
-	ROUND(aaa, bbb, ccc, ddd, eee, F4, KK2, in[1],  13);
-	ROUND(eee, aaa, bbb, ccc, ddd, F4, KK2, in[2],  11);
-
-	/* Swap contents of "b" registers */
-	swap(bb, bbb);
-
-	/* round 3: left lane" */
-	ROUND(dd, ee, aa, bb, cc, F3, K3, in[3],  11);
-	ROUND(cc, dd, ee, aa, bb, F3, K3, in[10], 13);
-	ROUND(bb, cc, dd, ee, aa, F3, K3, in[14],  6);
-	ROUND(aa, bb, cc, dd, ee, F3, K3, in[4],   7);
-	ROUND(ee, aa, bb, cc, dd, F3, K3, in[9],  14);
-	ROUND(dd, ee, aa, bb, cc, F3, K3, in[15],  9);
-	ROUND(cc, dd, ee, aa, bb, F3, K3, in[8],  13);
-	ROUND(bb, cc, dd, ee, aa, F3, K3, in[1],  15);
-	ROUND(aa, bb, cc, dd, ee, F3, K3, in[2],  14);
-	ROUND(ee, aa, bb, cc, dd, F3, K3, in[7],   8);
-	ROUND(dd, ee, aa, bb, cc, F3, K3, in[0],  13);
-	ROUND(cc, dd, ee, aa, bb, F3, K3, in[6],   6);
-	ROUND(bb, cc, dd, ee, aa, F3, K3, in[13],  5);
-	ROUND(aa, bb, cc, dd, ee, F3, K3, in[11], 12);
-	ROUND(ee, aa, bb, cc, dd, F3, K3, in[5],   7);
-	ROUND(dd, ee, aa, bb, cc, F3, K3, in[12],  5);
-
-	/* round 3: right lane */
-	ROUND(ddd, eee, aaa, bbb, ccc, F3, KK3, in[15],  9);
-	ROUND(ccc, ddd, eee, aaa, bbb, F3, KK3, in[5],   7);
-	ROUND(bbb, ccc, ddd, eee, aaa, F3, KK3, in[1],  15);
-	ROUND(aaa, bbb, ccc, ddd, eee, F3, KK3, in[3],  11);
-	ROUND(eee, aaa, bbb, ccc, ddd, F3, KK3, in[7],   8);
-	ROUND(ddd, eee, aaa, bbb, ccc, F3, KK3, in[14],  6);
-	ROUND(ccc, ddd, eee, aaa, bbb, F3, KK3, in[6],   6);
-	ROUND(bbb, ccc, ddd, eee, aaa, F3, KK3, in[9],  14);
-	ROUND(aaa, bbb, ccc, ddd, eee, F3, KK3, in[11], 12);
-	ROUND(eee, aaa, bbb, ccc, ddd, F3, KK3, in[8],  13);
-	ROUND(ddd, eee, aaa, bbb, ccc, F3, KK3, in[12],  5);
-	ROUND(ccc, ddd, eee, aaa, bbb, F3, KK3, in[2],  14);
-	ROUND(bbb, ccc, ddd, eee, aaa, F3, KK3, in[10], 13);
-	ROUND(aaa, bbb, ccc, ddd, eee, F3, KK3, in[0],  13);
-	ROUND(eee, aaa, bbb, ccc, ddd, F3, KK3, in[4],   7);
-	ROUND(ddd, eee, aaa, bbb, ccc, F3, KK3, in[13],  5);
-
-	/* Swap contents of "c" registers */
-	swap(cc, ccc);
-
-	/* round 4: left lane" */
-	ROUND(cc, dd, ee, aa, bb, F4, K4, in[1],  11);
-	ROUND(bb, cc, dd, ee, aa, F4, K4, in[9],  12);
-	ROUND(aa, bb, cc, dd, ee, F4, K4, in[11], 14);
-	ROUND(ee, aa, bb, cc, dd, F4, K4, in[10], 15);
-	ROUND(dd, ee, aa, bb, cc, F4, K4, in[0],  14);
-	ROUND(cc, dd, ee, aa, bb, F4, K4, in[8],  15);
-	ROUND(bb, cc, dd, ee, aa, F4, K4, in[12],  9);
-	ROUND(aa, bb, cc, dd, ee, F4, K4, in[4],   8);
-	ROUND(ee, aa, bb, cc, dd, F4, K4, in[13],  9);
-	ROUND(dd, ee, aa, bb, cc, F4, K4, in[3],  14);
-	ROUND(cc, dd, ee, aa, bb, F4, K4, in[7],   5);
-	ROUND(bb, cc, dd, ee, aa, F4, K4, in[15],  6);
-	ROUND(aa, bb, cc, dd, ee, F4, K4, in[14],  8);
-	ROUND(ee, aa, bb, cc, dd, F4, K4, in[5],   6);
-	ROUND(dd, ee, aa, bb, cc, F4, K4, in[6],   5);
-	ROUND(cc, dd, ee, aa, bb, F4, K4, in[2],  12);
-
-	/* round 4: right lane */
-	ROUND(ccc, ddd, eee, aaa, bbb, F2, KK4, in[8],  15);
-	ROUND(bbb, ccc, ddd, eee, aaa, F2, KK4, in[6],   5);
-	ROUND(aaa, bbb, ccc, ddd, eee, F2, KK4, in[4],   8);
-	ROUND(eee, aaa, bbb, ccc, ddd, F2, KK4, in[1],  11);
-	ROUND(ddd, eee, aaa, bbb, ccc, F2, KK4, in[3],  14);
-	ROUND(ccc, ddd, eee, aaa, bbb, F2, KK4, in[11], 14);
-	ROUND(bbb, ccc, ddd, eee, aaa, F2, KK4, in[15],  6);
-	ROUND(aaa, bbb, ccc, ddd, eee, F2, KK4, in[0],  14);
-	ROUND(eee, aaa, bbb, ccc, ddd, F2, KK4, in[5],   6);
-	ROUND(ddd, eee, aaa, bbb, ccc, F2, KK4, in[12],  9);
-	ROUND(ccc, ddd, eee, aaa, bbb, F2, KK4, in[2],  12);
-	ROUND(bbb, ccc, ddd, eee, aaa, F2, KK4, in[13],  9);
-	ROUND(aaa, bbb, ccc, ddd, eee, F2, KK4, in[9],  12);
-	ROUND(eee, aaa, bbb, ccc, ddd, F2, KK4, in[7],   5);
-	ROUND(ddd, eee, aaa, bbb, ccc, F2, KK4, in[10], 15);
-	ROUND(ccc, ddd, eee, aaa, bbb, F2, KK4, in[14],  8);
-
-	/* Swap contents of "d" registers */
-	swap(dd, ddd);
-
-	/* round 5: left lane" */
-	ROUND(bb, cc, dd, ee, aa, F5, K5, in[4],   9);
-	ROUND(aa, bb, cc, dd, ee, F5, K5, in[0],  15);
-	ROUND(ee, aa, bb, cc, dd, F5, K5, in[5],   5);
-	ROUND(dd, ee, aa, bb, cc, F5, K5, in[9],  11);
-	ROUND(cc, dd, ee, aa, bb, F5, K5, in[7],   6);
-	ROUND(bb, cc, dd, ee, aa, F5, K5, in[12],  8);
-	ROUND(aa, bb, cc, dd, ee, F5, K5, in[2],  13);
-	ROUND(ee, aa, bb, cc, dd, F5, K5, in[10], 12);
-	ROUND(dd, ee, aa, bb, cc, F5, K5, in[14],  5);
-	ROUND(cc, dd, ee, aa, bb, F5, K5, in[1],  12);
-	ROUND(bb, cc, dd, ee, aa, F5, K5, in[3],  13);
-	ROUND(aa, bb, cc, dd, ee, F5, K5, in[8],  14);
-	ROUND(ee, aa, bb, cc, dd, F5, K5, in[11], 11);
-	ROUND(dd, ee, aa, bb, cc, F5, K5, in[6],   8);
-	ROUND(cc, dd, ee, aa, bb, F5, K5, in[15],  5);
-	ROUND(bb, cc, dd, ee, aa, F5, K5, in[13],  6);
-
-	/* round 5: right lane */
-	ROUND(bbb, ccc, ddd, eee, aaa, F1, KK5, in[12],  8);
-	ROUND(aaa, bbb, ccc, ddd, eee, F1, KK5, in[15],  5);
-	ROUND(eee, aaa, bbb, ccc, ddd, F1, KK5, in[10], 12);
-	ROUND(ddd, eee, aaa, bbb, ccc, F1, KK5, in[4],   9);
-	ROUND(ccc, ddd, eee, aaa, bbb, F1, KK5, in[1],  12);
-	ROUND(bbb, ccc, ddd, eee, aaa, F1, KK5, in[5],   5);
-	ROUND(aaa, bbb, ccc, ddd, eee, F1, KK5, in[8],  14);
-	ROUND(eee, aaa, bbb, ccc, ddd, F1, KK5, in[7],   6);
-	ROUND(ddd, eee, aaa, bbb, ccc, F1, KK5, in[6],   8);
-	ROUND(ccc, ddd, eee, aaa, bbb, F1, KK5, in[2],  13);
-	ROUND(bbb, ccc, ddd, eee, aaa, F1, KK5, in[13],  6);
-	ROUND(aaa, bbb, ccc, ddd, eee, F1, KK5, in[14],  5);
-	ROUND(eee, aaa, bbb, ccc, ddd, F1, KK5, in[0],  15);
-	ROUND(ddd, eee, aaa, bbb, ccc, F1, KK5, in[3],  13);
-	ROUND(ccc, ddd, eee, aaa, bbb, F1, KK5, in[9],  11);
-	ROUND(bbb, ccc, ddd, eee, aaa, F1, KK5, in[11], 11);
-
-	/* Swap contents of "e" registers */
-	swap(ee, eee);
-
-	/* combine results */
-	state[0] += aa;
-	state[1] += bb;
-	state[2] += cc;
-	state[3] += dd;
-	state[4] += ee;
-	state[5] += aaa;
-	state[6] += bbb;
-	state[7] += ccc;
-	state[8] += ddd;
-	state[9] += eee;
-}
-
-static int rmd320_init(struct shash_desc *desc)
-{
-	struct rmd320_ctx *rctx = shash_desc_ctx(desc);
-
-	rctx->byte_count = 0;
-
-	rctx->state[0] = RMD_H0;
-	rctx->state[1] = RMD_H1;
-	rctx->state[2] = RMD_H2;
-	rctx->state[3] = RMD_H3;
-	rctx->state[4] = RMD_H4;
-	rctx->state[5] = RMD_H5;
-	rctx->state[6] = RMD_H6;
-	rctx->state[7] = RMD_H7;
-	rctx->state[8] = RMD_H8;
-	rctx->state[9] = RMD_H9;
-
-	memset(rctx->buffer, 0, sizeof(rctx->buffer));
-
-	return 0;
-}
-
-static int rmd320_update(struct shash_desc *desc, const u8 *data,
-			 unsigned int len)
-{
-	struct rmd320_ctx *rctx = shash_desc_ctx(desc);
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
-	rmd320_transform(rctx->state, rctx->buffer);
-	data += avail;
-	len -= avail;
-
-	while (len >= sizeof(rctx->buffer)) {
-		memcpy(rctx->buffer, data, sizeof(rctx->buffer));
-		rmd320_transform(rctx->state, rctx->buffer);
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
-static int rmd320_final(struct shash_desc *desc, u8 *out)
-{
-	struct rmd320_ctx *rctx = shash_desc_ctx(desc);
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
-	rmd320_update(desc, padding, padlen);
-
-	/* Append length */
-	rmd320_update(desc, (const u8 *)&bits, sizeof(bits));
-
-	/* Store state in digest */
-	for (i = 0; i < 10; i++)
-		dst[i] = cpu_to_le32p(&rctx->state[i]);
-
-	/* Wipe context */
-	memset(rctx, 0, sizeof(*rctx));
-
-	return 0;
-}
-
-static struct shash_alg alg = {
-	.digestsize	=	RMD320_DIGEST_SIZE,
-	.init		=	rmd320_init,
-	.update		=	rmd320_update,
-	.final		=	rmd320_final,
-	.descsize	=	sizeof(struct rmd320_ctx),
-	.base		=	{
-		.cra_name	 =	"rmd320",
-		.cra_driver_name =	"rmd320-generic",
-		.cra_blocksize	 =	RMD320_BLOCK_SIZE,
-		.cra_module	 =	THIS_MODULE,
-	}
-};
-
-static int __init rmd320_mod_init(void)
-{
-	return crypto_register_shash(&alg);
-}
-
-static void __exit rmd320_mod_fini(void)
-{
-	crypto_unregister_shash(&alg);
-}
-
-subsys_initcall(rmd320_mod_init);
-module_exit(rmd320_mod_fini);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Adrian-Ken Rueegsegger <ken@codelabs.ch>");
-MODULE_DESCRIPTION("RIPEMD-320 Message Digest");
-MODULE_ALIAS_CRYPTO("rmd320");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 3fb842cb2c67..a231df72ca7d 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -71,7 +71,7 @@ static const char *check[] = {
 	"blowfish", "twofish", "serpent", "sha384", "sha512", "md4", "aes",
 	"cast6", "arc4", "michael_mic", "deflate", "crc32c", "tea", "xtea",
 	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
-	"camellia", "seed", "salsa20", "rmd160", "rmd320",
+	"camellia", "seed", "salsa20", "rmd160",
 	"lzo", "lzo-rle", "cts", "sha3-224", "sha3-256", "sha3-384",
 	"sha3-512", "streebog256", "streebog512",
 	NULL
@@ -1871,10 +1871,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		ret += tcrypt_test("rmd160");
 		break;
 
-	case 42:
-		ret += tcrypt_test("rmd320");
-		break;
-
 	case 43:
 		ret += tcrypt_test("ecb(seed)");
 		break;
@@ -2401,10 +2397,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_hash_speed("rmd160", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
-	case 317:
-		test_hash_speed("rmd320", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
 	case 318:
 		klen = 16;
 		test_hash_speed("ghash", sec, generic_hash_speed_template);
@@ -2517,10 +2509,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_ahash_speed("rmd160", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
-	case 417:
-		test_ahash_speed("rmd320", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
 	case 418:
 		test_ahash_speed("sha3-224", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index c35de56fc25a..d12cec6ab003 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5275,12 +5275,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.hash = __VECS(rmd160_tv_template)
 		}
-	}, {
-		.alg = "rmd320",
-		.test = alg_test_hash,
-		.suite = {
-			.hash = __VECS(rmd320_tv_template)
-		}
 	}, {
 		.alg = "rsa",
 		.test = alg_test_akcipher,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 86abd1f79aab..5625164cda54 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -3200,70 +3200,6 @@ static const struct hash_testvec rmd160_tv_template[] = {
 	}
 };
 
-/*
- * RIPEMD-320 test vectors
- */
-static const struct hash_testvec rmd320_tv_template[] = {
-	{
-		.digest	= "\x22\xd6\x5d\x56\x61\x53\x6c\xdc\x75\xc1"
-			  "\xfd\xf5\xc6\xde\x7b\x41\xb9\xf2\x73\x25"
-			  "\xeb\xc6\x1e\x85\x57\x17\x7d\x70\x5a\x0e"
-			  "\xc8\x80\x15\x1c\x3a\x32\xa0\x08\x99\xb8",
-	}, {
-		.plaintext = "a",
-		.psize	= 1,
-		.digest	= "\xce\x78\x85\x06\x38\xf9\x26\x58\xa5\xa5"
-			  "\x85\x09\x75\x79\x92\x6d\xda\x66\x7a\x57"
-			  "\x16\x56\x2c\xfc\xf6\xfb\xe7\x7f\x63\x54"
-			  "\x2f\x99\xb0\x47\x05\xd6\x97\x0d\xff\x5d",
-	}, {
-		.plaintext = "abc",
-		.psize	= 3,
-		.digest	= "\xde\x4c\x01\xb3\x05\x4f\x89\x30\xa7\x9d"
-			  "\x09\xae\x73\x8e\x92\x30\x1e\x5a\x17\x08"
-			  "\x5b\xef\xfd\xc1\xb8\xd1\x16\x71\x3e\x74"
-			  "\xf8\x2f\xa9\x42\xd6\x4c\xdb\xc4\x68\x2d",
-	}, {
-		.plaintext = "message digest",
-		.psize	= 14,
-		.digest	= "\x3a\x8e\x28\x50\x2e\xd4\x5d\x42\x2f\x68"
-			  "\x84\x4f\x9d\xd3\x16\xe7\xb9\x85\x33\xfa"
-			  "\x3f\x2a\x91\xd2\x9f\x84\xd4\x25\xc8\x8d"
-			  "\x6b\x4e\xff\x72\x7d\xf6\x6a\x7c\x01\x97",
-	}, {
-		.plaintext = "abcdefghijklmnopqrstuvwxyz",
-		.psize	= 26,
-		.digest	= "\xca\xbd\xb1\x81\x0b\x92\x47\x0a\x20\x93"
-			  "\xaa\x6b\xce\x05\x95\x2c\x28\x34\x8c\xf4"
-			  "\x3f\xf6\x08\x41\x97\x51\x66\xbb\x40\xed"
-			  "\x23\x40\x04\xb8\x82\x44\x63\xe6\xb0\x09",
-	}, {
-		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcde"
-			     "fghijklmnopqrstuvwxyz0123456789",
-		.psize	= 62,
-		.digest	= "\xed\x54\x49\x40\xc8\x6d\x67\xf2\x50\xd2"
-			  "\x32\xc3\x0b\x7b\x3e\x57\x70\xe0\xc6\x0c"
-			  "\x8c\xb9\xa4\xca\xfe\x3b\x11\x38\x8a\xf9"
-			  "\x92\x0e\x1b\x99\x23\x0b\x84\x3c\x86\xa4",
-	}, {
-		.plaintext = "1234567890123456789012345678901234567890"
-			     "1234567890123456789012345678901234567890",
-		.psize	= 80,
-		.digest	= "\x55\x78\x88\xaf\x5f\x6d\x8e\xd6\x2a\xb6"
-			  "\x69\x45\xc6\xd2\xa0\xa4\x7e\xcd\x53\x41"
-			  "\xe9\x15\xeb\x8f\xea\x1d\x05\x24\x95\x5f"
-			  "\x82\x5d\xc7\x17\xe4\xa0\x08\xab\x2d\x42",
-	}, {
-		.plaintext = "abcdbcdecdefdefgefghfghighij"
-			     "hijkijkljklmklmnlmnomnopnopq",
-		.psize	= 56,
-		.digest	= "\xd0\x34\xa7\x95\x0c\xf7\x22\x02\x1b\xa4"
-			  "\xb8\x4d\xf7\x69\xa5\xde\x20\x60\xe2\x59"
-			  "\xdf\x4c\x9b\xb4\xa4\x26\x8c\x0e\x93\x5b"
-			  "\xbc\x74\x70\xa9\x69\xc9\xd0\x72\xa1\xac",
-	}
-};
-
 static const struct hash_testvec crct10dif_tv_template[] = {
 	{
 		.plaintext	= "abc",
-- 
2.17.1

