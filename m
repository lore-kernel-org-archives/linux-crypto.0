From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v2] crypto: vmx - VMX crypto should depend on CONFIG_VSX
Date: Wed,  9 Sep 2015 18:22:35 +1000
Message-ID: <1441786955-6249-1-git-send-email-mpe@ellerman.id.au>
Cc: leosilva@linux.vnet.ibm.com, herbert@gondor.apana.org.au,
	Paul Mackerras <paulus@samba.org>, tim.gardner@canonical.com,
	linux-crypto@vger.kernel.org
To: <linuxppc-dev@ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:54618 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbbIIIWj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 04:22:39 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This code uses FP (floating point), Altivec and VSX (Vector-Scalar
Extension). It can just depend on CONFIG_VSX though, because that
already depends on FP and Altivec.

Otherwise we get lots of link errors such as:

  drivers/built-in.o: In function `.p8_aes_setkey':
  aes.c:(.text+0x2d325c): undefined reference to `.enable_kernel_altivec'
  aes.c:(.text+0x2d326c): undefined reference to `.enable_kernel_vsx'

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---

v2: Spell out VSX, and CC linux-crypto.

 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 07bc7aa6b224..d234719065a5 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -461,7 +461,7 @@ config CRYPTO_DEV_QCE
 
 config CRYPTO_DEV_VMX
 	bool "Support for VMX cryptographic acceleration instructions"
-	depends on PPC64
+	depends on PPC64 && VSX
 	help
 	  Support for VMX cryptographic acceleration instructions.
 
-- 
2.1.4
