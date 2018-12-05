Return-Path: <SRS0=adZj=OO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbeLEGVg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Dec 2018 01:21:36 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>,
        Martin Willi <martin@strongswan.org>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/6] crypto: x86/chacha - yield the FPU occasionally
Date: Tue,  4 Dec 2018 22:20:05 -0800
Message-Id: <20181205062005.27727-7-ebiggers@kernel.org>
In-Reply-To: <20181205062005.27727-1-ebiggers@kernel.org>
References: <20181205062005.27727-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

To improve responsiveness, yield the FPU (temporarily re-enabling
preemption) every 4 KiB encrypted/decrypted, rather than keeping
preemption disabled during the entire encryption/decryption operation.

Alternatively we could do this for every skcipher_walk step, but steps
may be small in some cases, and yielding the FPU is expensive on x86.

Suggested-by: Martin Willi <martin@strongswan.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/chacha_glue.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index d19c2908be90..9b1d3fac4943 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -132,6 +132,7 @@ static int chacha_simd_stream_xor(struct skcipher_request *req,
 {
 	u32 *state, state_buf[16 + 2] __aligned(8);
 	struct skcipher_walk walk;
+	int next_yield = 4096; /* bytes until next FPU yield */
 	int err;
 
 	BUILD_BUG_ON(CHACHA_STATE_ALIGN != 16);
@@ -144,12 +145,21 @@ static int chacha_simd_stream_xor(struct skcipher_request *req,
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
 
-		if (nbytes < walk.total)
+		if (nbytes < walk.total) {
 			nbytes = round_down(nbytes, walk.stride);
+			next_yield -= nbytes;
+		}
 
 		chacha_dosimd(state, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes, ctx->nrounds);
 
+		if (next_yield <= 0) {
+			/* temporarily allow preemption */
+			kernel_fpu_end();
+			kernel_fpu_begin();
+			next_yield = 4096;
+		}
+
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
-- 
2.19.2
