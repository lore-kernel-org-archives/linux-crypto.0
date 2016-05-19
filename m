From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v3 7/8] crypto: caam - add ARCH_LAYERSCAPE to supported architectures
Date: Thu, 19 May 2016 18:11:33 +0300
Message-ID: <1463670693-3140-1-git-send-email-horia.geanta@nxp.com>
References: <1463670405-1059-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0092.outbound.protection.outlook.com ([157.56.110.92]:53766
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754996AbcESPLm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 May 2016 11:11:42 -0400
In-Reply-To: <1463670405-1059-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This basically adds support for ls1043a platform.

Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
---
 drivers/crypto/caam/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index d2c2909a4020..ff54c42e6e51 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -1,6 +1,6 @@
 config CRYPTO_DEV_FSL_CAAM
 	tristate "Freescale CAAM-Multicore driver backend"
-	depends on FSL_SOC || ARCH_MXC
+	depends on FSL_SOC || ARCH_MXC || ARCH_LAYERSCAPE
 	help
 	  Enables the driver module for Freescale's Cryptographic Accelerator
 	  and Assurance Module (CAAM), also known as the SEC version 4 (SEC4)=
=2E
--=20
2.4.4
