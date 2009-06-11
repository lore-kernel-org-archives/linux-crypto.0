From: Huang Ying <ying.huang@intel.com>
Subject: [RFC 6/7] x86: Move kernel_fpu_using to asm/i387.h
Date: Thu, 11 Jun 2009 15:10:36 +0800
Message-ID: <1244704236.5320.129.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28492 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758666AbZFKHKl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 03:10:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is used by AES-NI accelerated AES implementation and PCLMULQDQ
accelerated GHASH implementation.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/crypto/aesni-intel_glue.c |    7 -------
 arch/x86/include/asm/i387.h        |    7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

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
