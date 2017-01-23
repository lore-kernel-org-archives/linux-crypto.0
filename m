From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 05/10] crypto: arm64/aes-blk - remove cra_alignmask
Date: Mon, 23 Jan 2017 14:05:21 +0000
Message-ID: <1485180326-25612-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1485180326-25612-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38832 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbdAWOFm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 09:05:42 -0500
Received: by mail-wm0-f53.google.com with SMTP id r144so156906950wme.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Jan 2017 06:05:42 -0800 (PST)
In-Reply-To: <1485180326-25612-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove the unnecessary alignmask: it is much more efficient to deal with
the misalignment in the core algorithm than relying on the crypto API to
copy the data to a suitably aligned buffer.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c  | 16 ++++++----------
 arch/arm64/crypto/aes-modes.S |  8 +++-----
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 5164aaf82c6a..8ee1fb7aaa4f 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -215,14 +215,15 @@ static int ctr_encrypt(struct skcipher_request *req)
 		u8 *tsrc = walk.src.virt.addr;
 
 		/*
-		 * Minimum alignment is 8 bytes, so if nbytes is <= 8, we need
-		 * to tell aes_ctr_encrypt() to only read half a block.
+		 * Tell aes_ctr_encrypt() to process a tail block.
 		 */
-		blocks = (nbytes <= 8) ? -1 : 1;
+		blocks = -1;
 
-		aes_ctr_encrypt(tail, tsrc, (u8 *)ctx->key_enc, rounds,
+		aes_ctr_encrypt(tail, NULL, (u8 *)ctx->key_enc, rounds,
 				blocks, walk.iv, first);
-		memcpy(tdst, tail, nbytes);
+		if (tdst != tsrc)
+			memcpy(tdst, tsrc, nbytes);
+		crypto_xor(tdst, tail, nbytes);
 		err = skcipher_walk_done(&walk, 0);
 	}
 	kernel_neon_end();
@@ -282,7 +283,6 @@ static struct skcipher_alg aes_algs[] = { {
 		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= AES_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
-		.cra_alignmask		= 7,
 		.cra_module		= THIS_MODULE,
 	},
 	.min_keysize	= AES_MIN_KEY_SIZE,
@@ -298,7 +298,6 @@ static struct skcipher_alg aes_algs[] = { {
 		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= AES_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
-		.cra_alignmask		= 7,
 		.cra_module		= THIS_MODULE,
 	},
 	.min_keysize	= AES_MIN_KEY_SIZE,
@@ -315,7 +314,6 @@ static struct skcipher_alg aes_algs[] = { {
 		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
-		.cra_alignmask		= 7,
 		.cra_module		= THIS_MODULE,
 	},
 	.min_keysize	= AES_MIN_KEY_SIZE,
@@ -332,7 +330,6 @@ static struct skcipher_alg aes_algs[] = { {
 		.cra_priority		= PRIO - 1,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
-		.cra_alignmask		= 7,
 		.cra_module		= THIS_MODULE,
 	},
 	.min_keysize	= AES_MIN_KEY_SIZE,
@@ -350,7 +347,6 @@ static struct skcipher_alg aes_algs[] = { {
 		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= AES_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct crypto_aes_xts_ctx),
-		.cra_alignmask		= 7,
 		.cra_module		= THIS_MODULE,
 	},
 	.min_keysize	= 2 * AES_MIN_KEY_SIZE,
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 838dad5c209f..92b982a8b112 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -337,7 +337,7 @@ AES_ENTRY(aes_ctr_encrypt)
 
 .Lctrcarrydone:
 	subs		w4, w4, #1
-	bmi		.Lctrhalfblock		/* blocks < 0 means 1/2 block */
+	bmi		.Lctrtailblock		/* blocks <0 means tail block */
 	ld1		{v3.16b}, [x1], #16
 	eor		v3.16b, v0.16b, v3.16b
 	st1		{v3.16b}, [x0], #16
@@ -348,10 +348,8 @@ AES_ENTRY(aes_ctr_encrypt)
 	FRAME_POP
 	ret
 
-.Lctrhalfblock:
-	ld1		{v3.8b}, [x1]
-	eor		v3.8b, v0.8b, v3.8b
-	st1		{v3.8b}, [x0]
+.Lctrtailblock:
+	st1		{v0.16b}, [x0]
 	FRAME_POP
 	ret
 
-- 
2.7.4
