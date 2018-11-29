Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbeK3KKe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Nov 2018 05:10:34 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>,
        Martin Willi <martin@strongswan.org>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] crypto: x86/chacha20 - limit the preemption-disabled section
Date: Thu, 29 Nov 2018 15:02:14 -0800
Message-Id: <20181129230217.158038-4-ebiggers@kernel.org>
In-Reply-To: <20181129230217.158038-1-ebiggers@kernel.org>
References: <20181129230217.158038-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

To improve responsiveness, disable preemption for each step of the walk
(which is at most PAGE_SIZE) rather than for the entire
encryption/decryption operation.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/chacha20_glue.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index 773d075a1483..036de144aab6 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -135,26 +135,24 @@ static int chacha20_simd(struct skcipher_request *req)
 	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !may_use_simd())
 		return crypto_chacha_crypt(req);
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
 	crypto_chacha_init(state, ctx, walk.iv);
 
-	kernel_fpu_begin();
-
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
 
 		if (nbytes < walk.total)
 			nbytes = round_down(nbytes, walk.stride);
 
+		kernel_fpu_begin();
 		chacha20_dosimd(state, walk.dst.virt.addr, walk.src.virt.addr,
 				nbytes);
+		kernel_fpu_end();
 
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
-	kernel_fpu_end();
-
 	return err;
 }
 
-- 
2.20.0.rc0.387.gc7a69e6b6c-goog
