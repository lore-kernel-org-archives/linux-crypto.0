From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto: arm/aes - don't use IV buffer to return final keystream block
Date: Thu,  2 Feb 2017 11:38:56 +0000
Message-ID: <1486035536-895-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1486035536-895-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37125 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751019AbdBBLjJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2017 06:39:09 -0500
Received: by mail-wm0-f50.google.com with SMTP id v77so83711243wmv.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2017 03:39:08 -0800 (PST)
In-Reply-To: <1486035536-895-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The ARM bit sliced AES core code uses the IV buffer to pass the final
keystream block back to the glue code if the input is not a multiple of
the block size, so that the asm code does not have to deal with anything
except 16 byte blocks. This is done under the assumption that the outgoing
IV is meaningless anyway in this case, given that chaining is no longer
possible under these circumstances.

However, as it turns out, the CCM driver does expect the IV to retain
a value that is equal to the original IV except for the counter value,
and even interprets byte zero as a length indicator, which may result
in memory corruption if the IV is overwritten with something else.

So use a separate buffer to return the final keystream block.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-neonbs-core.S | 16 +++++++++-------
 arch/arm/crypto/aes-neonbs-glue.c |  9 +++++----
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/arm/crypto/aes-neonbs-core.S b/arch/arm/crypto/aes-neonbs-core.S
index c9477044fbba..2764edc56467 100644
--- a/arch/arm/crypto/aes-neonbs-core.S
+++ b/arch/arm/crypto/aes-neonbs-core.S
@@ -779,14 +779,15 @@ ENDPROC(aesbs_cbc_decrypt)
 
 	/*
 	 * aesbs_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],
-	 *		     int rounds, int blocks, u8 ctr[], bool final)
+	 *		     int rounds, int blocks, u8 ctr[], u8 final[])
 	 */
 ENTRY(aesbs_ctr_encrypt)
 	mov		ip, sp
 	push		{r4-r10, lr}
 
 	ldm		ip, {r5-r7}		// load args 4-6
-	add		r5, r5, r7		// one extra block if final == 1
+	teq		r7, #0
+	addne		r5, r5, #1		// one extra block if final != 0
 
 	vld1.8		{q0}, [r6]		// load counter
 	vrev32.8	q1, q0
@@ -865,19 +866,20 @@ ENTRY(aesbs_ctr_encrypt)
 	veor		q2, q2, q14
 	vst1.8		{q2}, [r0]!
 	teq		r4, #0			// skip last block if 'final'
-	W(bne)		4f
+	W(bne)		5f
 3:	veor		q5, q5, q15
 	vst1.8		{q5}, [r0]!
 
-	next_ctr	q0
+4:	next_ctr	q0
 
 	subs		r5, r5, #8
 	bgt		99b
 
-	vmov		q5, q0
-
-4:	vst1.8		{q5}, [r6]
+	vst1.8		{q0}, [r6]
 	pop		{r4-r10, pc}
+
+5:	vst1.8		{q5}, [r4]
+	b		4b
 ENDPROC(aesbs_ctr_encrypt)
 
 	.macro		next_tweak, out, in, const, tmp
diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index e262f99a44d3..2920b96dbd36 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -35,7 +35,7 @@ asmlinkage void aesbs_cbc_decrypt(u8 out[], u8 const in[], u8 const rk[],
 				  int rounds, int blocks, u8 iv[]);
 
 asmlinkage void aesbs_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],
-				  int rounds, int blocks, u8 ctr[], bool final);
+				  int rounds, int blocks, u8 ctr[], u8 final[]);
 
 asmlinkage void aesbs_xts_encrypt(u8 out[], u8 const in[], u8 const rk[],
 				  int rounds, int blocks, u8 iv[]);
@@ -186,6 +186,7 @@ static int ctr_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesbs_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk walk;
+	u8 buf[AES_BLOCK_SIZE];
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, true);
@@ -193,12 +194,12 @@ static int ctr_encrypt(struct skcipher_request *req)
 	kernel_neon_begin();
 	while (walk.nbytes > 0) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
-		bool final = (walk.total % AES_BLOCK_SIZE) != 0;
+		u8 *final = (walk.total % AES_BLOCK_SIZE) ? buf : NULL;
 
 		if (walk.nbytes < walk.total) {
 			blocks = round_down(blocks,
 					    walk.stride / AES_BLOCK_SIZE);
-			final = false;
+			final = NULL;
 		}
 
 		aesbs_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
@@ -210,7 +211,7 @@ static int ctr_encrypt(struct skcipher_request *req)
 
 			if (dst != src)
 				memcpy(dst, src, walk.total % AES_BLOCK_SIZE);
-			crypto_xor(dst, walk.iv, walk.total % AES_BLOCK_SIZE);
+			crypto_xor(dst, final, walk.total % AES_BLOCK_SIZE);
 
 			err = skcipher_walk_done(&walk, 0);
 			break;
-- 
2.7.4
