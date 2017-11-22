From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 4/5] crypto: x86/chacha20 - Remove cra_alignmask
Date: Wed, 22 Nov 2017 11:51:38 -0800
Message-ID: <20171122195139.121269-5-ebiggers3@gmail.com>
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

Now that the generic ChaCha20 implementation no longer needs a
cra_alignmask, the x86 one doesn't either -- given that the x86
implementation doesn't need the alignment itself.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/chacha20_glue.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index 1e6af1b35f7b..dce7c5d39c2f 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -107,7 +107,6 @@ static struct skcipher_alg alg = {
 	.base.cra_priority	= 300,
 	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct chacha20_ctx),
-	.base.cra_alignmask	= sizeof(u32) - 1,
 	.base.cra_module	= THIS_MODULE,
 
 	.min_keysize		= CHACHA20_KEY_SIZE,
-- 
2.15.0.448.gf294e3d99a-goog
