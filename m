From: Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH] crypto: aesni-intel - Add ivsize to ablk_ecb_alg
Date: Thu, 11 Aug 2011 12:40:41 -0400
Message-ID: <20110811164040.GB2167@zod.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The ablkcipher structure in ablk_ecb_alg is lacking an ivsize setting.
This causes the algorithm to fail it's self-test when it's registered
with the error message:

[    0.806920] alg: skcipher: Failed to load transform for ecb-aes-aesni: -2

crypto_lookup_skcipher doesn't like a missing ivsize.  Adding the ivsize
allows the self-test lookup to pass.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 arch/x86/crypto/aesni-intel_glue.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index feee8ff..711cc3c 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -587,6 +587,7 @@ static struct crypto_alg ablk_ecb_alg = {
 		.ablkcipher = {
 			.min_keysize	= AES_MIN_KEY_SIZE,
 			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
 			.setkey		= ablk_set_key,
 			.encrypt	= ablk_encrypt,
 			.decrypt	= ablk_decrypt,
-- 
1.7.6
