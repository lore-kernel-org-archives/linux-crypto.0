From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 02/20] crypto: arm64/aes-ce-ccm - move kernel mode neon en/disable into loop
Date: Wed,  6 Dec 2017 19:43:28 +0000
Message-ID: <20171206194346.24393-3-ard.biesheuvel@linaro.org>
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
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38453 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbdLFToA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Dec 2017 14:44:00 -0500
Received: by mail-wm0-f66.google.com with SMTP id 64so9076569wme.3
        for <linux-crypto@vger.kernel.org>; Wed, 06 Dec 2017 11:44:00 -0800 (PST)
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
 arch/arm64/crypto/aes-ce-ccm-glue.c | 47 ++++++++++----------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index a1254036f2b1..68b11aa690e4 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -107,11 +107,13 @@ static int ccm_init_mac(struct aead_request *req, u8 maciv[], u32 msglen)
 }
 
 static void ccm_update_mac(struct crypto_aes_ctx *key, u8 mac[], u8 const in[],
-			   u32 abytes, u32 *macp, bool use_neon)
+			   u32 abytes, u32 *macp)
 {
-	if (likely(use_neon)) {
+	if (may_use_simd()) {
+		kernel_neon_begin();
 		ce_aes_ccm_auth_data(mac, in, abytes, macp, key->key_enc,
 				     num_rounds(key));
+		kernel_neon_end();
 	} else {
 		if (*macp > 0 && *macp < AES_BLOCK_SIZE) {
 			int added = min(abytes, AES_BLOCK_SIZE - *macp);
@@ -143,8 +145,7 @@ static void ccm_update_mac(struct crypto_aes_ctx *key, u8 mac[], u8 const in[],
 	}
 }
 
-static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[],
-				   bool use_neon)
+static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_aead_ctx(aead);
@@ -163,7 +164,7 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[],
 		ltag.len = 6;
 	}
 
-	ccm_update_mac(ctx, mac, (u8 *)&ltag, ltag.len, &macp, use_neon);
+	ccm_update_mac(ctx, mac, (u8 *)&ltag, ltag.len, &macp);
 	scatterwalk_start(&walk, req->src);
 
 	do {
@@ -175,7 +176,7 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[],
 			n = scatterwalk_clamp(&walk, len);
 		}
 		p = scatterwalk_map(&walk);
-		ccm_update_mac(ctx, mac, p, n, &macp, use_neon);
+		ccm_update_mac(ctx, mac, p, n, &macp);
 		len -= n;
 
 		scatterwalk_unmap(p);
@@ -242,43 +243,42 @@ static int ccm_encrypt(struct aead_request *req)
 	u8 __aligned(8) mac[AES_BLOCK_SIZE];
 	u8 buf[AES_BLOCK_SIZE];
 	u32 len = req->cryptlen;
-	bool use_neon = may_use_simd();
 	int err;
 
 	err = ccm_init_mac(req, mac, len);
 	if (err)
 		return err;
 
-	if (likely(use_neon))
-		kernel_neon_begin();
-
 	if (req->assoclen)
-		ccm_calculate_auth_mac(req, mac, use_neon);
+		ccm_calculate_auth_mac(req, mac);
 
 	/* preserve the original iv for the final round */
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
 	err = skcipher_walk_aead_encrypt(&walk, req, true);
 
-	if (likely(use_neon)) {
+	if (may_use_simd()) {
 		while (walk.nbytes) {
 			u32 tail = walk.nbytes % AES_BLOCK_SIZE;
 
 			if (walk.nbytes == walk.total)
 				tail = 0;
 
+			kernel_neon_begin();
 			ce_aes_ccm_encrypt(walk.dst.virt.addr,
 					   walk.src.virt.addr,
 					   walk.nbytes - tail, ctx->key_enc,
 					   num_rounds(ctx), mac, walk.iv);
+			kernel_neon_end();
 
 			err = skcipher_walk_done(&walk, tail);
 		}
-		if (!err)
+		if (!err) {
+			kernel_neon_begin();
 			ce_aes_ccm_final(mac, buf, ctx->key_enc,
 					 num_rounds(ctx));
-
-		kernel_neon_end();
+			kernel_neon_end();
+		}
 	} else {
 		err = ccm_crypt_fallback(&walk, mac, buf, ctx, true);
 	}
@@ -301,43 +301,42 @@ static int ccm_decrypt(struct aead_request *req)
 	u8 __aligned(8) mac[AES_BLOCK_SIZE];
 	u8 buf[AES_BLOCK_SIZE];
 	u32 len = req->cryptlen - authsize;
-	bool use_neon = may_use_simd();
 	int err;
 
 	err = ccm_init_mac(req, mac, len);
 	if (err)
 		return err;
 
-	if (likely(use_neon))
-		kernel_neon_begin();
-
 	if (req->assoclen)
-		ccm_calculate_auth_mac(req, mac, use_neon);
+		ccm_calculate_auth_mac(req, mac);
 
 	/* preserve the original iv for the final round */
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
 	err = skcipher_walk_aead_decrypt(&walk, req, true);
 
-	if (likely(use_neon)) {
+	if (may_use_simd()) {
 		while (walk.nbytes) {
 			u32 tail = walk.nbytes % AES_BLOCK_SIZE;
 
 			if (walk.nbytes == walk.total)
 				tail = 0;
 
+			kernel_neon_begin();
 			ce_aes_ccm_decrypt(walk.dst.virt.addr,
 					   walk.src.virt.addr,
 					   walk.nbytes - tail, ctx->key_enc,
 					   num_rounds(ctx), mac, walk.iv);
+			kernel_neon_end();
 
 			err = skcipher_walk_done(&walk, tail);
 		}
-		if (!err)
+		if (!err) {
+			kernel_neon_begin();
 			ce_aes_ccm_final(mac, buf, ctx->key_enc,
 					 num_rounds(ctx));
-
-		kernel_neon_end();
+			kernel_neon_end();
+		}
 	} else {
 		err = ccm_crypt_fallback(&walk, mac, buf, ctx, false);
 	}
-- 
2.11.0
