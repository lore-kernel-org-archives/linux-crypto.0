From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3 08/17] crypto: talitos - add sub-choice in talitos CONFIG
 for SEC1
Date: Sat, 14 Mar 2015 14:29:23 +0100
Message-ID: <20150417142401.CB8331A242C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds a CONFIG option to select SEC1, SEC2+ or both.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/Kconfig | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 800bf41..8a76a01 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -222,6 +222,24 @@ config CRYPTO_DEV_TALITOS
 	  To compile this driver as a module, choose M here: the module
 	  will be called talitos.
 
+config CRYPTO_DEV_TALITOS1
+	bool "SEC1 (SEC 1.0 and SEC Lite 1.2)"
+	depends on CRYPTO_DEV_TALITOS
+	depends on PPC_8xx || PPC_82xx
+	default y
+	help
+	  Say 'Y' here to use the Freescale Security Engine (SEC) version 1.0
+	  found on MPC82xx or the Freescale Security Engine (SEC Lite)
+	  version 1.2 found on MPC8xx
+
+config CRYPTO_DEV_TALITOS2
+	bool "SEC2+ (SEC version 2.0 or upper)"
+	depends on CRYPTO_DEV_TALITOS
+	default y if !PPC_8xx
+	help
+	  Say 'Y' here to use the Freescale Security Engine (SEC)
+	  version 2 and following as found on MPC83xx, MPC85xx, etc ...
+
 config CRYPTO_DEV_IXP4XX
 	tristate "Driver for IXP4xx crypto hardware acceleration"
 	depends on ARCH_IXP4XX && IXP4XX_QMGR && IXP4XX_NPE
-- 
2.1.0
