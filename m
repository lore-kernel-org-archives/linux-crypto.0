From: Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH] crypto: aesni-intel: fix crypto_fpu_exit() section mismatch
Date: Fri, 12 Jun 2015 21:56:40 -0700
Message-ID: <1434171400-10566-1-git-send-email-jmmahler@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jeremiah Mahler <jmmahler@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:32830 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbbFME5P (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 13 Jun 2015 00:57:15 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The '__init aesni_init()' function calls the '__exit crypto_fpu_exit()'
function directly.  Since they are in different sections, this generates
a warning.

  make CONFIG_DEBUG_SECTION_MISMATCH=y
  ...
  WARNING: arch/x86/crypto/aesni-intel.o(.init.text+0x12b): Section
  mismatch in reference from the function init_module() to the function
  .exit.text:crypto_fpu_exit()
  The function __init init_module() references
  a function __exit crypto_fpu_exit().
  This is often seen when error handling in the init function
  uses functionality in the exit path.
  The fix is often to remove the __exit annotation of
  crypto_fpu_exit() so it may be used outside an exit section.

Fix the warning by removing the __exit annotation.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 arch/x86/crypto/fpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/fpu.c b/arch/x86/crypto/fpu.c
index 5a2f30f..e7d679e 100644
--- a/arch/x86/crypto/fpu.c
+++ b/arch/x86/crypto/fpu.c
@@ -156,7 +156,7 @@ int __init crypto_fpu_init(void)
 	return crypto_register_template(&crypto_fpu_tmpl);
 }
 
-void __exit crypto_fpu_exit(void)
+void crypto_fpu_exit(void)
 {
 	crypto_unregister_template(&crypto_fpu_tmpl);
 }
-- 
2.1.4
