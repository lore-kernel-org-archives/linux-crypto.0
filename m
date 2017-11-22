From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 1/5] crypto: chacha20 - Fix unaligned access when loading constants
Date: Wed, 22 Nov 2017 11:51:35 -0800
Message-ID: <20171122195139.121269-2-ebiggers3@gmail.com>
References: <20171122195139.121269-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Martin Willi <martin@strongswan.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171122195139.121269-1-ebiggers3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The four 32-bit constants for the initial state of ChaCha20 were loaded
from a char array which is not guaranteed to have the needed alignment.

Fix it by just assigning the constants directly instead.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/chacha20_generic.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
index 4a45fa4890c0..ec84e7837aac 100644
--- a/crypto/chacha20_generic.c
+++ b/crypto/chacha20_generic.c
@@ -41,12 +41,10 @@ static void chacha20_docrypt(u32 *state, u8 *dst, const u8 *src,
 
 void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv)
 {
-	static const char constant[16] = "expand 32-byte k";
-
-	state[0]  = le32_to_cpuvp(constant +  0);
-	state[1]  = le32_to_cpuvp(constant +  4);
-	state[2]  = le32_to_cpuvp(constant +  8);
-	state[3]  = le32_to_cpuvp(constant + 12);
+	state[0]  = 0x61707865; /* "expa" */
+	state[1]  = 0x3320646e; /* "nd 3" */
+	state[2]  = 0x79622d32; /* "2-by" */
+	state[3]  = 0x6b206574; /* "te k" */
 	state[4]  = ctx->key[0];
 	state[5]  = ctx->key[1];
 	state[6]  = ctx->key[2];
-- 
2.15.0.448.gf294e3d99a-goog
