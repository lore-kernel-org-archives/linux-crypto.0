From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v2] crypto: powerpc - CRYPT_CRC32C_VPMSUM should depend on ALTIVEC
Date: Tue,  9 Aug 2016 08:46:15 +1000
Message-ID: <1470696375-22023-1-git-send-email-mpe@ellerman.id.au>
Cc: <linuxppc-dev@ozlabs.org>, Anton Blanchard <anton@samba.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:43374 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbcHHWq2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 18:46:28 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The optimised crc32c implementation depends on VMX (aka. Altivec)
instructions, so the kernel must be built with Altivec support in order
for the crc32c code to build.

Fixes: 6dd7a82cc54e ("crypto: powerpc - Add POWER8 optimised crc32c")
Acked-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

v2: No change. Send to linux-crypto.

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a9377bef25e3..84d71482bf08 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -439,7 +439,7 @@ config CRYPTO_CRC32C_INTEL
 
 config CRYPT_CRC32C_VPMSUM
 	tristate "CRC32c CRC algorithm (powerpc64)"
-	depends on PPC64
+	depends on PPC64 && ALTIVEC
 	select CRYPTO_HASH
 	select CRC32
 	help
-- 
2.7.4
