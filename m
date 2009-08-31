From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v3] x86: Move kernel_fpu_using to irq_fpu_usable in
 asm/i387.h
Date: Mon, 31 Aug 2009 13:11:54 +0800
Message-ID: <1251695514.14648.344.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48641 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbZHaFL4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 31 Aug 2009 01:11:56 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This function measures whether the FPU/SSE state can be touched in
interrupt context. If the interrupted code is in user space or has no
valid FPU/SSE context (CR0.TS == 1), FPU/SSE state can be used in IRQ
or soft_irq context too.

This is used by AES-NI accelerated AES implementation and PCLMULQDQ
accelerated GHASH implementation.

v3:
 - Renamed to irq_fpu_usable to reflect the purpose of the function.

v2:
 - Renamed to irq_is_fpu_using to reflect the real situation.

Signed-off-by: Huang Ying <ying.huang@intel.com>
CC: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/crypto/aesni-intel_glue.c |   17 +++++------------
 arch/x86/include/asm/i387.h        |    8 ++++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -59,13 +59,6 @@ asmlinkage void aesni_cbc_enc(struct cry
 asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
-static inline int kernel_fpu_using(void)
-{
-	if (in_interrupt() && !(read_cr0() & X86_CR0_TS))
-		return 1;
-	return 0;
-}
-
 static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
 {
 	unsigned long addr = (unsigned long)raw_ctx;
@@ -89,7 +82,7 @@ static int aes_set_key_common(struct cry
 		return -EINVAL;
 	}
 
-	if (kernel_fpu_using())
+	if (irq_fpu_usable())
 		err = crypto_aes_expand_key(ctx, in_key, key_len);
 	else {
 		kernel_fpu_begin();
@@ -110,7 +103,7 @@ static void aes_encrypt(struct crypto_tf
 {
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
 
-	if (kernel_fpu_using())
+	if (irq_fpu_usable())
 		crypto_aes_encrypt_x86(ctx, dst, src);
 	else {
 		kernel_fpu_begin();
@@ -123,7 +116,7 @@ static void aes_decrypt(struct crypto_tf
 {
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
 
-	if (kernel_fpu_using())
+	if (irq_fpu_usable())
 		crypto_aes_decrypt_x86(ctx, dst, src);
 	else {
 		kernel_fpu_begin();
@@ -349,7 +342,7 @@ static int ablk_encrypt(struct ablkciphe
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct async_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 
-	if (kernel_fpu_using()) {
+	if (irq_fpu_usable()) {
 		struct ablkcipher_request *cryptd_req =
 			ablkcipher_request_ctx(req);
 		memcpy(cryptd_req, req, sizeof(*req));
@@ -370,7 +363,7 @@ static int ablk_decrypt(struct ablkciphe
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct async_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 
-	if (kernel_fpu_using()) {
+	if (irq_fpu_usable()) {
 		struct ablkcipher_request *cryptd_req =
 			ablkcipher_request_ctx(req);
 		memcpy(cryptd_req, req, sizeof(*req));
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -301,6 +301,14 @@ static inline void kernel_fpu_end(void)
 	preempt_enable();
 }
 
+static inline bool irq_fpu_usable(void)
+{
+	struct pt_regs *regs;
+
+	return !in_interrupt() || !(regs = get_irq_regs()) || \
+		user_mode(regs) || (read_cr0() & X86_CR0_TS);
+}
+
 /*
  * Some instructions like VIA's padlock instructions generate a spurious
  * DNA fault but don't modify SSE registers. And these instructions


