Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0AC5C5517A
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Nov 2020 07:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52BE6208CA
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Nov 2020 07:58:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="h1eklgoa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgKJH6W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Nov 2020 02:58:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbgKJH6W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Nov 2020 02:58:22 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE9122080A;
        Tue, 10 Nov 2020 07:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604995101;
        bh=XyWnCCRqboN7ShlbLTs12iGG7x6q2Fg5mlE/bAWkn+I=;
        h=From:To:Cc:Subject:Date:From;
        b=h1eklgoaSdZdLiHkzHjs8sjqNH3zu3UpZwmN14Z1abnXTKSUrIIVkRIgNC9fg3At/
         +UlzTT/VIgXTPWMO9k5V/5u4a/Fk6beUn0TkH+IaLSuL/+Cgzi44HeXQx38UIQr4Ot
         OMi2psqE7ZqYEtbD6iO0oZX8vBbQT67fjIX35uBs=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: arm64/gcm - move authentication tag check to SIMD domain
Date:   Tue, 10 Nov 2020 08:58:10 +0100
Message-Id: <20201110075810.29050-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of copying the calculated authentication tag to memory and
calling crypto_memneq() to verify it, use vector bytewise compare and
min across vector instructions to decide whether the tag is valid. This
is more efficient, and given that the tag is only transiently held in a
NEON register, it is also safer, given that calculated tags for failed
decryptions should be withheld.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/ghash-ce-core.S | 15 ++++++++++
 arch/arm64/crypto/ghash-ce-glue.c | 46 +++++++++++++++++++------------
 2 files changed, 43 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index 6b958dcdf136..7868330dd54e 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -544,7 +544,22 @@ CPU_LE(	rev		w8, w8		)
 	ext		XL.16b, XL.16b, XL.16b, #8
 	rev64		XL.16b, XL.16b
 	eor		XL.16b, XL.16b, KS0.16b
+
+	.if		\enc == 1
 	st1		{XL.16b}, [x10]			// store tag
+	.else
+	ldp		x11, x12, [sp, #40]		// load tag pointer and authsize
+	adr_l		x17, .Lpermute_table
+	ld1		{KS0.16b}, [x11]		// load supplied tag
+	add		x17, x17, x12
+	ld1		{KS1.16b}, [x17]		// load permute vector
+
+	cmeq		XL.16b, XL.16b, KS0.16b		// compare tags
+	mvn		XL.16b, XL.16b			// -1 for fail, 0 for pass
+	tbl		XL.16b, {XL.16b}, KS1.16b	// keep authsize bytes only
+	sminv		b0, XL.16b			// signed minimum across XL
+	smov		w0, v0.b[0]			// return b0
+	.endif
 
 4:	ldp		x29, x30, [sp], #32
 	ret
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 8536008e3e35..405923e3be4a 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -55,10 +55,10 @@ asmlinkage void pmull_ghash_update_p8(int blocks, u64 dg[], const char *src,
 asmlinkage void pmull_gcm_encrypt(int bytes, u8 dst[], const u8 src[],
 				  u64 const h[][2], u64 dg[], u8 ctr[],
 				  u32 const rk[], int rounds, u8 tag[]);
-
-asmlinkage void pmull_gcm_decrypt(int bytes, u8 dst[], const u8 src[],
-				  u64 const h[][2], u64 dg[], u8 ctr[],
-				  u32 const rk[], int rounds, u8 tag[]);
+asmlinkage int pmull_gcm_decrypt(int bytes, u8 dst[], const u8 src[],
+				 u64 const h[][2], u64 dg[], u8 ctr[],
+				 u32 const rk[], int rounds, const u8 l[],
+				 const u8 tag[], u64 authsize);
 
 static int ghash_init(struct shash_desc *desc)
 {
@@ -458,6 +458,7 @@ static int gcm_decrypt(struct aead_request *req)
 	unsigned int authsize = crypto_aead_authsize(aead);
 	int nrounds = num_rounds(&ctx->aes_key);
 	struct skcipher_walk walk;
+	u8 otag[AES_BLOCK_SIZE];
 	u8 buf[AES_BLOCK_SIZE];
 	u8 iv[AES_BLOCK_SIZE];
 	u64 dg[2] = {};
@@ -474,9 +475,15 @@ static int gcm_decrypt(struct aead_request *req)
 	memcpy(iv, req->iv, GCM_IV_SIZE);
 	put_unaligned_be32(2, iv + GCM_IV_SIZE);
 
+	scatterwalk_map_and_copy(otag, req->src,
+				 req->assoclen + req->cryptlen - authsize,
+				 authsize, 0);
+
 	err = skcipher_walk_aead_decrypt(&walk, req, false);
 
 	if (likely(crypto_simd_usable())) {
+		int ret;
+
 		do {
 			const u8 *src = walk.src.virt.addr;
 			u8 *dst = walk.dst.virt.addr;
@@ -493,9 +500,10 @@ static int gcm_decrypt(struct aead_request *req)
 			}
 
 			kernel_neon_begin();
-			pmull_gcm_decrypt(nbytes, dst, src, ctx->ghash_key.h,
-					  dg, iv, ctx->aes_key.key_enc, nrounds,
-					  tag);
+			ret = pmull_gcm_decrypt(nbytes, dst, src,
+						ctx->ghash_key.h,
+						dg, iv, ctx->aes_key.key_enc,
+						nrounds, tag, otag, authsize);
 			kernel_neon_end();
 
 			if (unlikely(!nbytes))
@@ -507,6 +515,11 @@ static int gcm_decrypt(struct aead_request *req)
 
 			err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 		} while (walk.nbytes);
+
+		if (err)
+			return err;
+		if (ret)
+			return -EBADMSG;
 	} else {
 		while (walk.nbytes >= AES_BLOCK_SIZE) {
 			int blocks = walk.nbytes / AES_BLOCK_SIZE;
@@ -548,23 +561,20 @@ static int gcm_decrypt(struct aead_request *req)
 			err = skcipher_walk_done(&walk, 0);
 		}
 
+		if (err)
+			return err;
+
 		put_unaligned_be64(dg[1], tag);
 		put_unaligned_be64(dg[0], tag + 8);
 		put_unaligned_be32(1, iv + GCM_IV_SIZE);
 		aes_encrypt(&ctx->aes_key, iv, iv);
 		crypto_xor(tag, iv, AES_BLOCK_SIZE);
-	}
-
-	if (err)
-		return err;
 
-	/* compare calculated auth tag with the stored one */
-	scatterwalk_map_and_copy(buf, req->src,
-				 req->assoclen + req->cryptlen - authsize,
-				 authsize, 0);
-
-	if (crypto_memneq(tag, buf, authsize))
-		return -EBADMSG;
+		if (crypto_memneq(tag, otag, authsize)) {
+			memzero_explicit(tag, AES_BLOCK_SIZE));
+			return -EBADMSG;
+		}
+	}
 	return 0;
 }
 
-- 
2.17.1

