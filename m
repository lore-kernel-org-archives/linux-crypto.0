From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 04/20] crypto: arm64/aes-bs - move kernel mode neon en/disable into loop
Date: Wed,  6 Dec 2017 19:43:30 +0000
Message-ID: <20171206194346.24393-5-ard.biesheuvel@linaro.org>
References: <20171206194346.24393-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-rt-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:46897 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752119AbdLFToH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Dec 2017 14:44:07 -0500
Received: by mail-wr0-f193.google.com with SMTP id x49so5090772wrb.13
        for <linux-crypto@vger.kernel.org>; Wed, 06 Dec 2017 11:44:06 -0800 (PST)
In-Reply-To: <20171206194346.24393-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When kernel mode NEON was first introduced on arm64, the preserve and
restore of the userland NEON state was completely unoptimized, and
involved saving all registers on each call to kernel_neon_begin(),
and restoring them on each call to kernel_neon_end(). For this reason,
the NEON crypto code that was introduced at the time keeps the NEON
enabled throughout the execution of the crypto API methods, which may
include calls back into the crypto API that could result in memory
allocation or other actions that we should avoid when running with
preemption disabled.

Since then, we have optimized the kernel mode NEON handling, which now
restores lazily (upon return to userland), and so the preserve action
is only costly the first time it is called after entering the kernel.

So let's put the kernel_neon_begin() and kernel_neon_end() calls around
the actual invocations of the NEON crypto code, and run the remainder of
the code with kernel mode NEON disabled (and preemption enabled)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-neonbs-glue.c | 36 +++++++++-----------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index 9d823c77ec84..e7a95a566462 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -99,9 +99,8 @@ static int __ecb_crypt(struct skcipher_request *req,
 	struct skcipher_walk walk;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_neon_begin();
 	while (walk.nbytes >= AES_BLOCK_SIZE) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
 
@@ -109,12 +108,13 @@ static int __ecb_crypt(struct skcipher_request *req,
 			blocks = round_down(blocks,
 					    walk.stride / AES_BLOCK_SIZE);
 
+		kernel_neon_begin();
 		fn(walk.dst.virt.addr, walk.src.virt.addr, ctx->rk,
 		   ctx->rounds, blocks);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk,
 					 walk.nbytes - blocks * AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 
 	return err;
 }
@@ -158,19 +158,19 @@ static int cbc_encrypt(struct skcipher_request *req)
 	struct skcipher_walk walk;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_neon_begin();
 	while (walk.nbytes >= AES_BLOCK_SIZE) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
 
 		/* fall back to the non-bitsliced NEON implementation */
+		kernel_neon_begin();
 		neon_aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				     ctx->enc, ctx->key.rounds, blocks,
 				     walk.iv);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 	return err;
 }
 
@@ -181,9 +181,8 @@ static int cbc_decrypt(struct skcipher_request *req)
 	struct skcipher_walk walk;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_neon_begin();
 	while (walk.nbytes >= AES_BLOCK_SIZE) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
 
@@ -191,13 +190,14 @@ static int cbc_decrypt(struct skcipher_request *req)
 			blocks = round_down(blocks,
 					    walk.stride / AES_BLOCK_SIZE);
 
+		kernel_neon_begin();
 		aesbs_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				  ctx->key.rk, ctx->key.rounds, blocks,
 				  walk.iv);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk,
 					 walk.nbytes - blocks * AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 
 	return err;
 }
@@ -229,9 +229,8 @@ static int ctr_encrypt(struct skcipher_request *req)
 	u8 buf[AES_BLOCK_SIZE];
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_neon_begin();
 	while (walk.nbytes > 0) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
 		u8 *final = (walk.total % AES_BLOCK_SIZE) ? buf : NULL;
@@ -242,8 +241,10 @@ static int ctr_encrypt(struct skcipher_request *req)
 			final = NULL;
 		}
 
+		kernel_neon_begin();
 		aesbs_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				  ctx->rk, ctx->rounds, blocks, walk.iv, final);
+		kernel_neon_end();
 
 		if (final) {
 			u8 *dst = walk.dst.virt.addr + blocks * AES_BLOCK_SIZE;
@@ -258,8 +259,6 @@ static int ctr_encrypt(struct skcipher_request *req)
 		err = skcipher_walk_done(&walk,
 					 walk.nbytes - blocks * AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
-
 	return err;
 }
 
@@ -304,12 +303,11 @@ static int __xts_crypt(struct skcipher_request *req,
 	struct skcipher_walk walk;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
 	kernel_neon_begin();
-
-	neon_aes_ecb_encrypt(walk.iv, walk.iv, ctx->twkey,
-			     ctx->key.rounds, 1);
+	neon_aes_ecb_encrypt(walk.iv, walk.iv, ctx->twkey, ctx->key.rounds, 1);
+	kernel_neon_end();
 
 	while (walk.nbytes >= AES_BLOCK_SIZE) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
@@ -318,13 +316,13 @@ static int __xts_crypt(struct skcipher_request *req,
 			blocks = round_down(blocks,
 					    walk.stride / AES_BLOCK_SIZE);
 
+		kernel_neon_begin();
 		fn(walk.dst.virt.addr, walk.src.virt.addr, ctx->key.rk,
 		   ctx->key.rounds, blocks, walk.iv);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk,
 					 walk.nbytes - blocks * AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
-
 	return err;
 }
 
-- 
2.11.0
