From: Huang Ying <ying.huang@intel.com>
Subject: [BUGFIX] Fix irq_fpu_usable usage in aesni
Date: Mon, 19 Oct 2009 10:00:17 +0800
Message-ID: <1255917617.1951.33.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42705 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbZJSCAO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2009 22:00:14 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When renaming kernel_fpu_using to irq_fpu_usable, the semantics of the
function is changed too, from mesuring whether kernel is using FPU,
that is, the FPU is NOT available, to measuring whether FPU is usable,
that is, the FPU is available.

But the usage of irq_fpu_usable in aesni-intel_glue.c is not changed
accordingly. This patch fixes this.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/crypto/aesni-intel_glue.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -82,7 +82,7 @@ static int aes_set_key_common(struct cry
 		return -EINVAL;
 	}
 
-	if (irq_fpu_usable())
+	if (!irq_fpu_usable())
 		err = crypto_aes_expand_key(ctx, in_key, key_len);
 	else {
 		kernel_fpu_begin();
@@ -103,7 +103,7 @@ static void aes_encrypt(struct crypto_tf
 {
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
 
-	if (irq_fpu_usable())
+	if (!irq_fpu_usable())
 		crypto_aes_encrypt_x86(ctx, dst, src);
 	else {
 		kernel_fpu_begin();
@@ -116,7 +116,7 @@ static void aes_decrypt(struct crypto_tf
 {
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
 
-	if (irq_fpu_usable())
+	if (!irq_fpu_usable())
 		crypto_aes_decrypt_x86(ctx, dst, src);
 	else {
 		kernel_fpu_begin();
@@ -342,7 +342,7 @@ static int ablk_encrypt(struct ablkciphe
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct async_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 
-	if (irq_fpu_usable()) {
+	if (!irq_fpu_usable()) {
 		struct ablkcipher_request *cryptd_req =
 			ablkcipher_request_ctx(req);
 		memcpy(cryptd_req, req, sizeof(*req));
@@ -363,7 +363,7 @@ static int ablk_decrypt(struct ablkciphe
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct async_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 
-	if (irq_fpu_usable()) {
+	if (!irq_fpu_usable()) {
 		struct ablkcipher_request *cryptd_req =
 			ablkcipher_request_ctx(req);
 		memcpy(cryptd_req, req, sizeof(*req));


