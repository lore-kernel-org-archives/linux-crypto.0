From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: x86/chacha20 - Manually align stack buffer
Date: Wed, 11 Jan 2017 20:08:16 +0800
Message-ID: <20170111120816.GA9004@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60827 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934160AbdAKMI2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Jan 2017 07:08:28 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The kernel on x86-64 cannot use gcc attribute align to align to
a 16-byte boundary.  This patch reverts to the old way of aligning
it by hand.

Incidentally the old way was actually broken in not allocating
enough space and would silently corrupt the stack.  This patch
fixes it by allocating an extra 8 bytes.

Fixes: 9ae433bc79f9 ("crypto: chacha20 - convert generic and...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index 78f75b0..054306d 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -67,10 +67,13 @@ static int chacha20_simd(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha20_ctx *ctx = crypto_skcipher_ctx(tfm);
-	u32 state[16] __aligned(CHACHA20_STATE_ALIGN);
+	u32 *state, state_buf[16 + 8] __aligned(8);
 	struct skcipher_walk walk;
 	int err;
 
+	BUILD_BUG_ON(CHACHA20_STATE_ALIGN != 16);
+	state = PTR_ALIGN(state_buf + 0, CHACHA20_STATE_ALIGN);
+
 	if (req->cryptlen <= CHACHA20_BLOCK_SIZE || !may_use_simd())
 		return crypto_chacha20_crypt(req);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
