From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] crypto: aesni - fix XTS mode on x86-32,
 add wrapper function for asmlinkage aesni_enc()
Date: Thu, 18 Oct 2012 23:24:57 +0300
Message-ID: <20121018202457.30712.52079.stgit@localhost6.localdomain6>
References: <CA+55aFxKBQwU8TxvzS2XY=grM090Pw5zEcXg9BTyO2WYu91TYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: stable@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Krzysztof Kolasa <kkolasa@winsoft.pl>,
	Huang Ying <ying.huang@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:40939 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab2JRUZA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Oct 2012 16:25:00 -0400
In-Reply-To: <CA+55aFxKBQwU8TxvzS2XY=grM090Pw5zEcXg9BTyO2WYu91TYw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Calling convention for internal functions and 'asmlinkage' functions is
different on x86-32. Therefore do not directly cast aesni_enc as XTS tweak
function, but use wrapper function in between. Fixes crash with "XTS +
aesni_intel + x86-32" combination.

Cc: stable@vger.kernel.org
Reported-by: Krzysztof Kolasa <kkolasa@winsoft.pl>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/aesni-intel_glue.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 7c04d0d..1b9c22b 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -515,6 +515,11 @@ static int xts_aesni_setkey(struct crypto_tfm *tfm, const u8 *key,
 }
 
 
+static void aesni_xts_tweak(void *ctx, u8 *out, const u8 *in)
+{
+	aesni_enc(ctx, out, in);
+}
+
 static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
@@ -525,7 +530,7 @@ static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		.tbuflen = sizeof(buf),
 
 		.tweak_ctx = aes_ctx(ctx->raw_tweak_ctx),
-		.tweak_fn = XTS_TWEAK_CAST(aesni_enc),
+		.tweak_fn = aesni_xts_tweak,
 		.crypt_ctx = aes_ctx(ctx->raw_crypt_ctx),
 		.crypt_fn = lrw_xts_encrypt_callback,
 	};
@@ -550,7 +555,7 @@ static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		.tbuflen = sizeof(buf),
 
 		.tweak_ctx = aes_ctx(ctx->raw_tweak_ctx),
-		.tweak_fn = XTS_TWEAK_CAST(aesni_enc),
+		.tweak_fn = aesni_xts_tweak,
 		.crypt_ctx = aes_ctx(ctx->raw_crypt_ctx),
 		.crypt_fn = lrw_xts_decrypt_callback,
 	};
