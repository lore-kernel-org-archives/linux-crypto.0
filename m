Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF692C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 09:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiA0JwW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 04:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbiA0JwW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 04:52:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E96C061714
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 01:52:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77FB2B8220C
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 09:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1209CC340E4;
        Thu, 27 Jan 2022 09:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643277138;
        bh=v1Blsz2V7sYxbUQ8KidsVciJBOMw0sywuPGvR7agG90=;
        h=From:To:Cc:Subject:Date:From;
        b=umUoaCqsJkWBc93F5ggmp89Lqi6dkgD+nzjVEyEI0pme4RiM2LdG/5kUvUvrxdeqk
         lAJgaG6mjLjqo8eHqGoc74mEtqnThh3g4NAOMQYM3yIEpn1rhZy6XCNPl27vcOar6H
         nmhKFPN3UTduDx6q+5pUTshGgXZYF2nGrSP0/1CUkURpIskYiUhr7fZkEe66rzIFoV
         9lN3Ua8VuB8xP+G5ZpIGi+Z2d7PMyso8HPwSdc/GTPcqusfR7bdt8n0gNl+TOjgIxN
         qI2IZYNx7E6PrT4EHANLPmbQTixN6TbRRTuGkn7iECJoeWyJh6LAnf2Q8/hEEo6KqK
         /MIkMZ3+OZnhQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Nathan Huckleberry <nhuck@google.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH] crypto: arm64/aes-neon-ctr - improve handling of single tail block
Date:   Thu, 27 Jan 2022 10:52:11 +0100
Message-Id: <20220127095211.3481959-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4476; h=from:subject; bh=v1Blsz2V7sYxbUQ8KidsVciJBOMw0sywuPGvR7agG90=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh8mtKjNG5+bn+818J2xsLq2U9O1o0tVk1rTnvGkMq nBUnHHmJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfJrSgAKCRDDTyI5ktmPJPCEC/ 9iqDG05O1SCcm7VYdh4vAQoeJbFPZlvcEz2qVqaeKXPzGIV2au4L9FfxdXue7rIm0dqTcnoFQu11m1 vGY/4tO0DlEhgiRWEEaSQItaxPxPpsfO3GRDeqGjCbGWnc0U3VJKPw923WpfH97gGyuVM8Q3knrdcH Nj6DVqHM9YMxbsxcXzavZlzCcITJop40qkBfgW/MJ2H56Z54OUdET2+ObfV92/Txh45rPQ6HCHLRSe Mo6Qmp/54AULKGvmLeajPsggjU1rmpEvBhj1e/Ja0E+pXC6YRr8mkwKk7R9hx/dkQE6W3/Xb+0rQiL Hy7bKNFTkTK0MUszsO64G/0hrHXPH5vjxfAdHd8eQ8s5vc5RA4pj6XFgt4UyIMDebYhN0hiMobLRjD kqpGMz/8twsLvhShLEn8W/ZJTvENE1YgYCQamKYXXPhRnDskkYcJ9gW9VK4m6j6CqkxKeWDCHzWF7Y tdegkWg3NKXBSADS1rZUbJW8/SPYSMWVXqFK4SC5MWDgM=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of falling back to C code to do a memcpy of the output of the
last block, handle this in the asm code directly if possible, which is
the case if the entire input is longer than 16 bytes.

Cc: Nathan Huckleberry <nhuck@google.com>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-glue.c  | 21 +++++++-------------
 arch/arm64/crypto/aes-modes.S | 18 ++++++++++++-----
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 30b7cc6a7079..7d66f8babb1d 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -24,7 +24,6 @@
 #ifdef USE_V8_CRYPTO_EXTENSIONS
 #define MODE			"ce"
 #define PRIO			300
-#define STRIDE			5
 #define aes_expandkey		ce_aes_expandkey
 #define aes_ecb_encrypt		ce_aes_ecb_encrypt
 #define aes_ecb_decrypt		ce_aes_ecb_decrypt
@@ -42,7 +41,6 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 #else
 #define MODE			"neon"
 #define PRIO			200
-#define STRIDE			4
 #define aes_ecb_encrypt		neon_aes_ecb_encrypt
 #define aes_ecb_decrypt		neon_aes_ecb_decrypt
 #define aes_cbc_encrypt		neon_aes_cbc_encrypt
@@ -89,7 +87,7 @@ asmlinkage void aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
 				int rounds, int bytes, u8 const iv[]);
 
 asmlinkage void aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
-				int rounds, int bytes, u8 ctr[], u8 finalbuf[]);
+				int rounds, int bytes, u8 ctr[]);
 
 asmlinkage void aes_xts_encrypt(u8 out[], u8 const in[], u32 const rk1[],
 				int rounds, int bytes, u32 const rk2[], u8 iv[],
@@ -458,26 +456,21 @@ static int __maybe_unused ctr_encrypt(struct skcipher_request *req)
 		unsigned int nbytes = walk.nbytes;
 		u8 *dst = walk.dst.virt.addr;
 		u8 buf[AES_BLOCK_SIZE];
-		unsigned int tail;
 
 		if (unlikely(nbytes < AES_BLOCK_SIZE))
-			src = memcpy(buf, src, nbytes);
+			src = dst = memcpy(buf + sizeof(buf) - nbytes,
+					   src, nbytes);
 		else if (nbytes < walk.total)
 			nbytes &= ~(AES_BLOCK_SIZE - 1);
 
 		kernel_neon_begin();
 		aes_ctr_encrypt(dst, src, ctx->key_enc, rounds, nbytes,
-				walk.iv, buf);
+				walk.iv);
 		kernel_neon_end();
 
-		tail = nbytes % (STRIDE * AES_BLOCK_SIZE);
-		if (tail > 0 && tail < AES_BLOCK_SIZE)
-			/*
-			 * The final partial block could not be returned using
-			 * an overlapping store, so it was passed via buf[]
-			 * instead.
-			 */
-			memcpy(dst + nbytes - tail, buf, tail);
+		if (unlikely(nbytes < AES_BLOCK_SIZE))
+			memcpy(walk.dst.virt.addr,
+			       buf + sizeof(buf) - nbytes, nbytes);
 
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index ff01f0167ba2..dc35eb0245c5 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -321,7 +321,7 @@ AES_FUNC_END(aes_cbc_cts_decrypt)
 
 	/*
 	 * aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
-	 *		   int bytes, u8 ctr[], u8 finalbuf[])
+	 *		   int bytes, u8 ctr[])
 	 */
 
 AES_FUNC_START(aes_ctr_encrypt)
@@ -414,8 +414,8 @@ ST5(	st1		{v4.16b}, [x0], #16		)
 .Lctrtail:
 	/* XOR up to MAX_STRIDE * 16 - 1 bytes of in/output with v0 ... v3/v4 */
 	mov		x16, #16
-	ands		x13, x4, #0xf
-	csel		x13, x13, x16, ne
+	ands		x6, x4, #0xf
+	csel		x13, x6, x16, ne
 
 ST5(	cmp		w4, #64 - (MAX_STRIDE << 4)	)
 ST5(	csel		x14, x16, xzr, gt		)
@@ -424,10 +424,10 @@ ST5(	csel		x14, x16, xzr, gt		)
 	cmp		w4, #32 - (MAX_STRIDE << 4)
 	csel		x16, x16, xzr, gt
 	cmp		w4, #16 - (MAX_STRIDE << 4)
-	ble		.Lctrtail1x
 
 	adr_l		x12, .Lcts_permute_table
 	add		x12, x12, x13
+	ble		.Lctrtail1x
 
 ST5(	ld1		{v5.16b}, [x1], x14		)
 	ld1		{v6.16b}, [x1], x15
@@ -462,11 +462,19 @@ ST5(	st1		{v5.16b}, [x0], x14		)
 	b		.Lctrout
 
 .Lctrtail1x:
-	csel		x0, x0, x6, eq		// use finalbuf if less than a full block
+	sub		x7, x6, #16
+	csel		x6, x6, x7, eq
+	add		x1, x1, x6
+	add		x0, x0, x6
 	ld1		{v5.16b}, [x1]
+	ld1		{v6.16b}, [x0]
 ST5(	mov		v3.16b, v4.16b			)
 	encrypt_block	v3, w3, x2, x8, w7
+	ld1		{v10.16b-v11.16b}, [x12]
+	tbl		v3.16b, {v3.16b}, v10.16b
+	sshr		v11.16b, v11.16b, #7
 	eor		v5.16b, v5.16b, v3.16b
+	bif		v5.16b, v6.16b, v11.16b
 	st1		{v5.16b}, [x0]
 	b		.Lctrout
 AES_FUNC_END(aes_ctr_encrypt)
-- 
2.30.2

