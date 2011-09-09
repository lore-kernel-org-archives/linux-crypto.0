From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] aes_glue.c: quiet sparse noise about symbol not declared
Date: Fri, 9 Sep 2011 13:47:02 -0700
Message-ID: <201109091347.03199.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Include <asm/aes.h> to pick up the declarations for crypto_aes_encrypt_x86
and crypto_aes_decrypt_x86 to quiet the sparse noise:

warning: symbol 'crypto_aes_encrypt_x86' was not declared. Should it be static?
warning: symbol 'crypto_aes_decrypt_x86' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
"David S. Miller" <davem@davemloft.net>
Thomas Gleixner <tglx@linutronix.de>
Ingo Molnar <mingo@redhat.com>
"H. Peter Anvin" <hpa@zytor.com>

---

diff --git a/arch/x86/crypto/aes_glue.c b/arch/x86/crypto/aes_glue.c
index bdce3ee..8efcf42 100644
--- a/arch/x86/crypto/aes_glue.c
+++ b/arch/x86/crypto/aes_glue.c
@@ -5,6 +5,7 @@
 
 #include <linux/module.h>
 #include <crypto/aes.h>
+#include <asm/aes.h>
 
 asmlinkage void aes_enc_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
 asmlinkage void aes_dec_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
