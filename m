From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 06/19] crypto: arm64/ghash - move kernel mode neon en/disable into loop
Date: Mon,  4 Dec 2017 12:26:32 +0000
Message-ID: <20171204122645.31535-7-ard.biesheuvel@linaro.org>
References: <20171204122645.31535-1-ard.biesheuvel@linaro.org>
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
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20171204122645.31535-1-ard.biesheuvel@linaro.org>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
 arch/arm64/crypto/ghash-ce-glue.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index cfc9c92814fd..cb39503673d4 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -368,26 +368,28 @@ static int gcm_encrypt(struct aead_request *req)
 		pmull_gcm_encrypt_block(ks, iv, NULL,
 					num_rounds(&ctx->aes_key));
 		put_unaligned_be32(3, iv + GCM_IV_SIZE);
+		kernel_neon_end();
 
-		err = skcipher_walk_aead_encrypt(&walk, req, true);
+		err = skcipher_walk_aead_encrypt(&walk, req, false);
 
 		while (walk.nbytes >= AES_BLOCK_SIZE) {
 			int blocks = walk.nbytes / AES_BLOCK_SIZE;
 
+			kernel_neon_begin();
 			pmull_gcm_encrypt(blocks, dg, walk.dst.virt.addr,
 					  walk.src.virt.addr, &ctx->ghash_key,
 					  iv, num_rounds(&ctx->aes_key), ks);
+			kernel_neon_end();
 
 			err = skcipher_walk_done(&walk,
 						 walk.nbytes % AES_BLOCK_SIZE);
 		}
-		kernel_neon_end();
 	} else {
 		__aes_arm64_encrypt(ctx->aes_key.key_enc, tag, iv,
 				    num_rounds(&ctx->aes_key));
 		put_unaligned_be32(2, iv + GCM_IV_SIZE);
 
-		err = skcipher_walk_aead_encrypt(&walk, req, true);
+		err = skcipher_walk_aead_encrypt(&walk, req, false);
 
 		while (walk.nbytes >= AES_BLOCK_SIZE) {
 			int blocks = walk.nbytes / AES_BLOCK_SIZE;
@@ -467,15 +469,18 @@ static int gcm_decrypt(struct aead_request *req)
 		pmull_gcm_encrypt_block(tag, iv, ctx->aes_key.key_enc,
 					num_rounds(&ctx->aes_key));
 		put_unaligned_be32(2, iv + GCM_IV_SIZE);
+		kernel_neon_end();
 
-		err = skcipher_walk_aead_decrypt(&walk, req, true);
+		err = skcipher_walk_aead_decrypt(&walk, req, false);
 
 		while (walk.nbytes >= AES_BLOCK_SIZE) {
 			int blocks = walk.nbytes / AES_BLOCK_SIZE;
 
+			kernel_neon_begin();
 			pmull_gcm_decrypt(blocks, dg, walk.dst.virt.addr,
 					  walk.src.virt.addr, &ctx->ghash_key,
 					  iv, num_rounds(&ctx->aes_key));
+			kernel_neon_end();
 
 			err = skcipher_walk_done(&walk,
 						 walk.nbytes % AES_BLOCK_SIZE);
@@ -483,14 +488,12 @@ static int gcm_decrypt(struct aead_request *req)
 		if (walk.nbytes)
 			pmull_gcm_encrypt_block(iv, iv, NULL,
 						num_rounds(&ctx->aes_key));
-
-		kernel_neon_end();
 	} else {
 		__aes_arm64_encrypt(ctx->aes_key.key_enc, tag, iv,
 				    num_rounds(&ctx->aes_key));
 		put_unaligned_be32(2, iv + GCM_IV_SIZE);
 
-		err = skcipher_walk_aead_decrypt(&walk, req, true);
+		err = skcipher_walk_aead_decrypt(&walk, req, false);
 
 		while (walk.nbytes >= AES_BLOCK_SIZE) {
 			int blocks = walk.nbytes / AES_BLOCK_SIZE;
-- 
2.11.0

