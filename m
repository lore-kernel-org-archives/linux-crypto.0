From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 05/19] crypto: arm64/chacha20 - move kernel mode neon en/disable into loop
Date: Mon,  4 Dec 2017 12:26:31 +0000
Message-ID: <20171204122645.31535-6-ard.biesheuvel@linaro.org>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:44482 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753142AbdLDM1L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Dec 2017 07:27:11 -0500
Received: by mail-wm0-f65.google.com with SMTP id t8so5453293wmc.3
        for <linux-crypto@vger.kernel.org>; Mon, 04 Dec 2017 04:27:11 -0800 (PST)
In-Reply-To: <20171204122645.31535-1-ard.biesheuvel@linaro.org>
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
 arch/arm64/crypto/chacha20-neon-glue.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/crypto/chacha20-neon-glue.c b/arch/arm64/crypto/chacha20-neon-glue.c
index cbdb75d15cd0..727579c93ded 100644
--- a/arch/arm64/crypto/chacha20-neon-glue.c
+++ b/arch/arm64/crypto/chacha20-neon-glue.c
@@ -37,12 +37,19 @@ static void chacha20_doneon(u32 *state, u8 *dst, const u8 *src,
 	u8 buf[CHACHA20_BLOCK_SIZE];
 
 	while (bytes >= CHACHA20_BLOCK_SIZE * 4) {
+		kernel_neon_begin();
 		chacha20_4block_xor_neon(state, dst, src);
+		kernel_neon_end();
 		bytes -= CHACHA20_BLOCK_SIZE * 4;
 		src += CHACHA20_BLOCK_SIZE * 4;
 		dst += CHACHA20_BLOCK_SIZE * 4;
 		state[12] += 4;
 	}
+
+	if (!bytes)
+		return;
+
+	kernel_neon_begin();
 	while (bytes >= CHACHA20_BLOCK_SIZE) {
 		chacha20_block_xor_neon(state, dst, src);
 		bytes -= CHACHA20_BLOCK_SIZE;
@@ -55,6 +62,7 @@ static void chacha20_doneon(u32 *state, u8 *dst, const u8 *src,
 		chacha20_block_xor_neon(state, buf, buf);
 		memcpy(dst, buf, bytes);
 	}
+	kernel_neon_end();
 }
 
 static int chacha20_neon(struct skcipher_request *req)
@@ -68,11 +76,10 @@ static int chacha20_neon(struct skcipher_request *req)
 	if (!may_use_simd() || req->cryptlen <= CHACHA20_BLOCK_SIZE)
 		return crypto_chacha20_crypt(req);
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
 	crypto_chacha20_init(state, ctx, walk.iv);
 
-	kernel_neon_begin();
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
 
@@ -83,7 +90,6 @@ static int chacha20_neon(struct skcipher_request *req)
 				nbytes);
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
-	kernel_neon_end();
 
 	return err;
 }
-- 
2.11.0
