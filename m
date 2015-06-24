From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: aesni - fix failing setkey for rfc4106-gcm-aesni
Date: Wed, 24 Jun 2015 07:14:21 -0700
Message-ID: <20150624141421.30466.28034.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbbFXOOk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jun 2015 10:14:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

rfc4106(gcm(aes)) uses cbc(aes) to generate hash key. cbc(aes) needs
chainiv, but the chainiv gets initialized after aesni_intel when both
are statically linked so the setkey fails.
This patch forces aesni_intel to be initialized after chainiv.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 arch/x86/crypto/aesni-intel_glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index ebcb981d..cb630a8 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1537,7 +1537,7 @@ static void __exit aesni_exit(void)
 	crypto_fpu_exit();
 }
 
-module_init(aesni_init);
+late_initcall(aesni_init);
 module_exit(aesni_exit);
 
 MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm, Intel AES-NI instructions optimized");
