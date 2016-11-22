From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 06/10] crypto: caam - remove unneded dependencies on CRYPTO_DEV_FSL_CAAM
Date: Tue, 22 Nov 2016 15:44:08 +0200
Message-ID: <1479822252-23833-7-git-send-email-horia.geanta@nxp.com>
References: <1479822252-23833-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0078.outbound.protection.outlook.com ([104.47.33.78]:43001
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754380AbcKVOBx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2016 09:01:53 -0500
In-Reply-To: <1479822252-23833-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove dependency on CRYPTO_DEV_FSL_CAAM where superfluous:
depends on CRYPTO_DEV_FSL_CAAM && CRYPTO_DEV_FSL_CAAM_JR
is equivalent to
depends on CRYPTO_DEV_FSL_CAAM_JR
since CRYPTO_DEV_FSL_CAAM_JR depends on CRYPTO_DEV_FSL_CAAM.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 64bf3024b680..ebeada75ab2d 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -74,7 +74,7 @@ config CRYPTO_DEV_FSL_CAAM_INTC_TIME_THLD
 
 config CRYPTO_DEV_FSL_CAAM_CRYPTO_API
 	tristate "Register algorithm implementations with the Crypto API"
-	depends on CRYPTO_DEV_FSL_CAAM && CRYPTO_DEV_FSL_CAAM_JR
+	depends on CRYPTO_DEV_FSL_CAAM_JR
 	default y
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
@@ -89,7 +89,7 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API
 
 config CRYPTO_DEV_FSL_CAAM_AHASH_API
 	tristate "Register hash algorithm implementations with Crypto API"
-	depends on CRYPTO_DEV_FSL_CAAM && CRYPTO_DEV_FSL_CAAM_JR
+	depends on CRYPTO_DEV_FSL_CAAM_JR
 	default y
 	select CRYPTO_HASH
 	help
@@ -101,7 +101,7 @@ config CRYPTO_DEV_FSL_CAAM_AHASH_API
 
 config CRYPTO_DEV_FSL_CAAM_PKC_API
         tristate "Register public key cryptography implementations with Crypto API"
-        depends on CRYPTO_DEV_FSL_CAAM && CRYPTO_DEV_FSL_CAAM_JR
+        depends on CRYPTO_DEV_FSL_CAAM_JR
         default y
         select CRYPTO_RSA
         help
@@ -113,7 +113,7 @@ config CRYPTO_DEV_FSL_CAAM_PKC_API
 
 config CRYPTO_DEV_FSL_CAAM_RNG_API
 	tristate "Register caam device for hwrng API"
-	depends on CRYPTO_DEV_FSL_CAAM && CRYPTO_DEV_FSL_CAAM_JR
+	depends on CRYPTO_DEV_FSL_CAAM_JR
 	default y
 	select CRYPTO_RNG
 	select HW_RANDOM
-- 
2.4.4
