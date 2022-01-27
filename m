Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BEA7C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 11:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240613AbiA0LgI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 06:36:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57578 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240586AbiA0LgE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 06:36:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C93F8B82226
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 11:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37BAC340EC;
        Thu, 27 Jan 2022 11:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643283362;
        bh=8I0vFwl7jIlkJwixn4W0hvpq0r+dj6iagIS+96CZZas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtkhUSCbJxIP9Mp818QsaQOFGBLKckx080CYs/UEgiT/N3Mc8yWgcY0vipQ5qgk9T
         c+LLtgDEUCzrIOwaV6C5cmm9bnhnh9KNJHeXDU3aukQFa+ayJaluqfv/0jfvsXhH/J
         fNbZFFoq4ctJ2ykOT7ufO1Sa8yV/5NT/9uudtcZ56X42pH2JwAsIOHh0Vn0hEiunGr
         nBXb7FtuYVD8dN83R/U11qyD6y8v0XoQI2hWjtp6Iywbdjm5Y51h5f8Yuy2gCV2HE2
         utUpCmVHZ0gtNzFFaT9Oa/pjpkzrnQ4vgCcXuBVkepfj7zNuNWJoOjCBbj+J56pLql
         kNQsa2n92Ea0w==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 3/3] crypto: arm64/aes-neonbs-xts - use plain NEON for non-power-of-2 input sizes
Date:   Thu, 27 Jan 2022 12:35:45 +0100
Message-Id: <20220127113545.7821-4-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127113545.7821-1-ardb@kernel.org>
References: <20220127113545.7821-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7646; h=from:subject; bh=8I0vFwl7jIlkJwixn4W0hvpq0r+dj6iagIS+96CZZas=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh8oORbslX4ebWO7XyJzrqU81MsjhJ3ohAqxwTPnZo 9rnoXU+JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfKDkQAKCRDDTyI5ktmPJDl+C/ wIH3rX5uHmVYQdItOghEOTDuS0uYWcTuKnqzrSFki/g/cSM9nFCVgpHd65a1gn8+SDJIUuKySt2KQX 8yAkWbI99n7YaBaNat3E5hcTbJPyaGZCFrwrdPABOrq8Y9kA6wnriUOTsxvc7mEqYBBeQZ1+wGRxHf 4n0Qe2xg0TywOcSIqfh6UPQWTxkHwUd3EB5NTAbhFy7mxcHFJUokDRL8quN1TxvKDhhlXUow0O4E5d pAsNyMaddBZp+YE74xTwqGWhhkqcKdi4NiuJ9q3SSQbSMlRUxLuSIS5opUCMpxdKpOne1ey3IRV6ZE ryzPbtMBob9tbN+tGnNtc+TGIpJCSUynyKZZtiVDEircbK/QtYQdjIN7iKVThklS57DX7CUUQi2hM/ ImRCPns9EYJWBBmncw6WH4IIPsPa+2W7FRrukQURAXsUl3V0+lZ7JpV2/afWyxHaCffQP5OvyOH3Yi 3gztJDxN2chfKL+3pT9hgHyP1kP5tJ7zPQrp3RI2KYpHg=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Even though the kernel's implementations of AES-XTS were updated to
implement ciphertext stealing and can operate on inputs of any size
larger than or equal to the AES block size, this feature is rarely used
in practice.

In fact, in the kernel, AES-XTS is only used to operate on 4096 or 512
byte blocks, which means that not only the ciphertext stealing is
effectively dead code, the logic in the bit sliced NEON implementation
to deal with fewer than 8 blocks at a time is also never used.

Since the bit-sliced NEON driver already depends on the plain NEON
version, which is slower but can operate on smaller data quantities more
straightforwardly, let's fallback to the plain NEON implementation of
XTS for any residual inputs that are not multiples of 128 bytes. This
allows us to remove a lot of complicated logic that rarely gets
exercised in practice.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-neonbs-core.S | 132 ++++++--------------
 arch/arm64/crypto/aes-neonbs-glue.c |  33 ++---
 2 files changed, 57 insertions(+), 108 deletions(-)

diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
index f2761481181d..d427f4556b6e 100644
--- a/arch/arm64/crypto/aes-neonbs-core.S
+++ b/arch/arm64/crypto/aes-neonbs-core.S
@@ -735,119 +735,67 @@ SYM_FUNC_END(aesbs_cbc_decrypt)
 	 *		     int blocks, u8 iv[])
 	 */
 SYM_FUNC_START_LOCAL(__xts_crypt8)
-	mov		x6, #1
-	lsl		x6, x6, x23
-	subs		w23, w23, #8
-	csel		x23, x23, xzr, pl
-	csel		x6, x6, xzr, mi
+	movi		v18.2s, #0x1
+	movi		v19.2s, #0x87
+	uzp1		v18.4s, v18.4s, v19.4s
+
+	ld1		{v0.16b-v3.16b}, [x1], #64
+	ld1		{v4.16b-v7.16b}, [x1], #64
+
+	next_tweak	v26, v25, v18, v19
+	next_tweak	v27, v26, v18, v19
+	next_tweak	v28, v27, v18, v19
+	next_tweak	v29, v28, v18, v19
+	next_tweak	v30, v29, v18, v19
+	next_tweak	v31, v30, v18, v19
+	next_tweak	v16, v31, v18, v19
+	next_tweak	v17, v16, v18, v19
 
-	ld1		{v0.16b}, [x20], #16
-	next_tweak	v26, v25, v30, v31
 	eor		v0.16b, v0.16b, v25.16b
-	tbnz		x6, #1, 0f
-
-	ld1		{v1.16b}, [x20], #16
-	next_tweak	v27, v26, v30, v31
 	eor		v1.16b, v1.16b, v26.16b
-	tbnz		x6, #2, 0f
-
-	ld1		{v2.16b}, [x20], #16
-	next_tweak	v28, v27, v30, v31
 	eor		v2.16b, v2.16b, v27.16b
-	tbnz		x6, #3, 0f
-
-	ld1		{v3.16b}, [x20], #16
-	next_tweak	v29, v28, v30, v31
 	eor		v3.16b, v3.16b, v28.16b
-	tbnz		x6, #4, 0f
-
-	ld1		{v4.16b}, [x20], #16
-	str		q29, [sp, #.Lframe_local_offset]
 	eor		v4.16b, v4.16b, v29.16b
-	next_tweak	v29, v29, v30, v31
-	tbnz		x6, #5, 0f
-
-	ld1		{v5.16b}, [x20], #16
-	str		q29, [sp, #.Lframe_local_offset + 16]
-	eor		v5.16b, v5.16b, v29.16b
-	next_tweak	v29, v29, v30, v31
-	tbnz		x6, #6, 0f
+	eor		v5.16b, v5.16b, v30.16b
+	eor		v6.16b, v6.16b, v31.16b
+	eor		v7.16b, v7.16b, v16.16b
 
-	ld1		{v6.16b}, [x20], #16
-	str		q29, [sp, #.Lframe_local_offset + 32]
-	eor		v6.16b, v6.16b, v29.16b
-	next_tweak	v29, v29, v30, v31
-	tbnz		x6, #7, 0f
+	stp		q16, q17, [sp, #16]
 
-	ld1		{v7.16b}, [x20], #16
-	str		q29, [sp, #.Lframe_local_offset + 48]
-	eor		v7.16b, v7.16b, v29.16b
-	next_tweak	v29, v29, v30, v31
-
-0:	mov		bskey, x21
-	mov		rounds, x22
+	mov		bskey, x2
+	mov		rounds, x3
 	br		x16
 SYM_FUNC_END(__xts_crypt8)
 
 	.macro		__xts_crypt, do8, o0, o1, o2, o3, o4, o5, o6, o7
-	frame_push	6, 64
-
-	mov		x19, x0
-	mov		x20, x1
-	mov		x21, x2
-	mov		x22, x3
-	mov		x23, x4
-	mov		x24, x5
+	stp		x29, x30, [sp, #-48]!
+	mov		x29, sp
 
-	movi		v30.2s, #0x1
-	movi		v25.2s, #0x87
-	uzp1		v30.4s, v30.4s, v25.4s
-	ld1		{v25.16b}, [x24]
+	ld1		{v25.16b}, [x5]
 
-99:	adr		x16, \do8
+0:	adr		x16, \do8
 	bl		__xts_crypt8
 
-	ldp		q16, q17, [sp, #.Lframe_local_offset]
-	ldp		q18, q19, [sp, #.Lframe_local_offset + 32]
+	eor		v16.16b, \o0\().16b, v25.16b
+	eor		v17.16b, \o1\().16b, v26.16b
+	eor		v18.16b, \o2\().16b, v27.16b
+	eor		v19.16b, \o3\().16b, v28.16b
 
-	eor		\o0\().16b, \o0\().16b, v25.16b
-	eor		\o1\().16b, \o1\().16b, v26.16b
-	eor		\o2\().16b, \o2\().16b, v27.16b
-	eor		\o3\().16b, \o3\().16b, v28.16b
+	ldp		q24, q25, [sp, #16]
 
-	st1		{\o0\().16b}, [x19], #16
-	mov		v25.16b, v26.16b
-	tbnz		x6, #1, 1f
-	st1		{\o1\().16b}, [x19], #16
-	mov		v25.16b, v27.16b
-	tbnz		x6, #2, 1f
-	st1		{\o2\().16b}, [x19], #16
-	mov		v25.16b, v28.16b
-	tbnz		x6, #3, 1f
-	st1		{\o3\().16b}, [x19], #16
-	mov		v25.16b, v29.16b
-	tbnz		x6, #4, 1f
-
-	eor		\o4\().16b, \o4\().16b, v16.16b
-	eor		\o5\().16b, \o5\().16b, v17.16b
-	eor		\o6\().16b, \o6\().16b, v18.16b
-	eor		\o7\().16b, \o7\().16b, v19.16b
-
-	st1		{\o4\().16b}, [x19], #16
-	tbnz		x6, #5, 1f
-	st1		{\o5\().16b}, [x19], #16
-	tbnz		x6, #6, 1f
-	st1		{\o6\().16b}, [x19], #16
-	tbnz		x6, #7, 1f
-	st1		{\o7\().16b}, [x19], #16
+	eor		v20.16b, \o4\().16b, v29.16b
+	eor		v21.16b, \o5\().16b, v30.16b
+	eor		v22.16b, \o6\().16b, v31.16b
+	eor		v23.16b, \o7\().16b, v24.16b
 
-	cbz		x23, 1f
-	st1		{v25.16b}, [x24]
+	st1		{v16.16b-v19.16b}, [x0], #64
+	st1		{v20.16b-v23.16b}, [x0], #64
 
-	b		99b
+	subs		x4, x4, #8
+	b.gt		0b
 
-1:	st1		{v25.16b}, [x24]
-	frame_pop
+	st1		{v25.16b}, [x5]
+	ldp		x29, x30, [sp], #48
 	ret
 	.endm
 
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index 3189003e1cbe..bac4cabef607 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -302,23 +302,18 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 		return err;
 
 	while (walk.nbytes >= AES_BLOCK_SIZE) {
-		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
-
-		if (walk.nbytes < walk.total || walk.nbytes % AES_BLOCK_SIZE)
-			blocks = round_down(blocks,
-					    walk.stride / AES_BLOCK_SIZE);
-
+		int blocks = (walk.nbytes / AES_BLOCK_SIZE) & ~7;
 		out = walk.dst.virt.addr;
 		in = walk.src.virt.addr;
 		nbytes = walk.nbytes;
 
 		kernel_neon_begin();
-		if (likely(blocks > 6)) { /* plain NEON is faster otherwise */
-			if (first)
+		if (blocks >= 8) {
+			if (first == 1)
 				neon_aes_ecb_encrypt(walk.iv, walk.iv,
 						     ctx->twkey,
 						     ctx->key.rounds, 1);
-			first = 0;
+			first = 2;
 
 			fn(out, in, ctx->key.rk, ctx->key.rounds, blocks,
 			   walk.iv);
@@ -327,10 +322,17 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 			in += blocks * AES_BLOCK_SIZE;
 			nbytes -= blocks * AES_BLOCK_SIZE;
 		}
-
-		if (walk.nbytes == walk.total && nbytes > 0)
-			goto xts_tail;
-
+		if (walk.nbytes == walk.total && nbytes > 0) {
+			if (encrypt)
+				neon_aes_xts_encrypt(out, in, ctx->cts.key_enc,
+						     ctx->key.rounds, nbytes,
+						     ctx->twkey, walk.iv, first);
+			else
+				neon_aes_xts_decrypt(out, in, ctx->cts.key_dec,
+						     ctx->key.rounds, nbytes,
+						     ctx->twkey, walk.iv, first);
+			nbytes = first = 0;
+		}
 		kernel_neon_end();
 		err = skcipher_walk_done(&walk, nbytes);
 	}
@@ -355,13 +357,12 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 	nbytes = walk.nbytes;
 
 	kernel_neon_begin();
-xts_tail:
 	if (encrypt)
 		neon_aes_xts_encrypt(out, in, ctx->cts.key_enc, ctx->key.rounds,
-				     nbytes, ctx->twkey, walk.iv, first ?: 2);
+				     nbytes, ctx->twkey, walk.iv, first);
 	else
 		neon_aes_xts_decrypt(out, in, ctx->cts.key_dec, ctx->key.rounds,
-				     nbytes, ctx->twkey, walk.iv, first ?: 2);
+				     nbytes, ctx->twkey, walk.iv, first);
 	kernel_neon_end();
 
 	return skcipher_walk_done(&walk, 0);
-- 
2.30.2

