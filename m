Return-Path: <SRS0=7Tml=NW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:33520 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbeKKTYs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Nov 2018 14:24:48 -0500
From: Martin Willi <martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: [PATCH 4/6] crypto: x86/chacha20 - Use larger block functions more aggressively
Date: Sun, 11 Nov 2018 10:36:28 +0100
Message-Id: <20181111093630.28107-5-martin@strongswan.org>
In-Reply-To: <20181111093630.28107-1-martin@strongswan.org>
References: <20181111093630.28107-1-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that all block functions support partial lengths, engage the wider
block sizes more aggressively. This prevents using smaller block
functions multiple times, where the next larger block function would
have been faster.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 arch/x86/crypto/chacha20_glue.c | 39 ++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index 882e8bf5965a..b541da71f11e 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -29,6 +29,12 @@ asmlinkage void chacha20_8block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
 static bool chacha20_use_avx2;
 #endif
 
+static unsigned int chacha20_advance(unsigned int len, unsigned int maxblocks)
+{
+	len = min(len, maxblocks * CHACHA20_BLOCK_SIZE);
+	return round_up(len, CHACHA20_BLOCK_SIZE) / CHACHA20_BLOCK_SIZE;
+}
+
 static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 			    unsigned int bytes)
 {
@@ -41,6 +47,11 @@ static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 			dst += CHACHA20_BLOCK_SIZE * 8;
 			state[12] += 8;
 		}
+		if (bytes > CHACHA20_BLOCK_SIZE * 4) {
+			chacha20_8block_xor_avx2(state, dst, src, bytes);
+			state[12] += chacha20_advance(bytes, 8);
+			return;
+		}
 	}
 #endif
 	while (bytes >= CHACHA20_BLOCK_SIZE * 4) {
@@ -50,15 +61,14 @@ static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 		dst += CHACHA20_BLOCK_SIZE * 4;
 		state[12] += 4;
 	}
-	while (bytes >= CHACHA20_BLOCK_SIZE) {
-		chacha20_block_xor_ssse3(state, dst, src, bytes);
-		bytes -= CHACHA20_BLOCK_SIZE;
-		src += CHACHA20_BLOCK_SIZE;
-		dst += CHACHA20_BLOCK_SIZE;
-		state[12]++;
+	if (bytes > CHACHA20_BLOCK_SIZE) {
+		chacha20_4block_xor_ssse3(state, dst, src, bytes);
+		state[12] += chacha20_advance(bytes, 4);
+		return;
 	}
 	if (bytes) {
 		chacha20_block_xor_ssse3(state, dst, src, bytes);
+		state[12]++;
 	}
 }
 
@@ -82,17 +92,16 @@ static int chacha20_simd(struct skcipher_request *req)
 
 	kernel_fpu_begin();
 
-	while (walk.nbytes >= CHACHA20_BLOCK_SIZE) {
-		chacha20_dosimd(state, walk.dst.virt.addr, walk.src.virt.addr,
-				rounddown(walk.nbytes, CHACHA20_BLOCK_SIZE));
-		err = skcipher_walk_done(&walk,
-					 walk.nbytes % CHACHA20_BLOCK_SIZE);
-	}
+	while (walk.nbytes > 0) {
+		unsigned int nbytes = walk.nbytes;
+
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
 
-	if (walk.nbytes) {
 		chacha20_dosimd(state, walk.dst.virt.addr, walk.src.virt.addr,
-				walk.nbytes);
-		err = skcipher_walk_done(&walk, 0);
+				nbytes);
+
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
 	kernel_fpu_end();
-- 
2.17.1
