From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v2 7/8] crypto: caam - add ARCH_LAYERSCAPE to supported architectures
Date: Thu, 5 May 2016 18:36:50 +0300
Message-ID: <1462462610-28106-1-git-send-email-horia.geanta@nxp.com>
References: <1462462435-27403-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Scott Wood <scott.wood@nxp.com>,
	"Alexandru Porosanu" <alexandru.porosanu@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	"Fabio Estevam" <fabio.estevam@nxp.com>,
	Steve Cornelius <steve.cornelius@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462462435-27403-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
