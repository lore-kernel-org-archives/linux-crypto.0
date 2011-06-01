From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] crypto: UML build fixes
Date: Wed,  1 Jun 2011 16:13:11 +0200
Message-ID: <1306937591-21815-1-git-send-email-richard@nod.at>
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, Richard Weinberger <richard@nod.at>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

CRYPTO_GHASH_CLMUL_NI_INTEL and CRYPTO_AES_NI_INTEL cannot be used
on UML.
Commit 3e02e5cb and 54b6a1b enabled them by accident.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 crypto/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 87b22ca..2af8155 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -458,7 +458,7 @@ config CRYPTO_WP512
 
 config CRYPTO_GHASH_CLMUL_NI_INTEL
 	tristate "GHASH digest algorithm (CLMUL-NI accelerated)"
-	depends on (X86 || UML_X86) && 64BIT
+	depends on X86 && 64BIT
 	select CRYPTO_SHASH
 	select CRYPTO_CRYPTD
 	help
@@ -533,7 +533,7 @@ config CRYPTO_AES_X86_64
 
 config CRYPTO_AES_NI_INTEL
 	tristate "AES cipher algorithms (AES-NI)"
-	depends on (X86 || UML_X86)
+	depends on X86
 	select CRYPTO_AES_X86_64 if 64BIT
 	select CRYPTO_AES_586 if !64BIT
 	select CRYPTO_CRYPTD
-- 
1.7.5.3
