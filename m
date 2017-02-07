From: George Cherian <george.cherian@cavium.com>
Subject: [PATCH v6 3/3] drivers: crypto: Enable CPT options crypto for build
Date: Tue, 7 Feb 2017 14:51:15 +0000
Message-ID: <1486479075-1813-4-git-send-email-george.cherian@cavium.com>
References: <1486479075-1813-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <david.daney@cavium.com>, <clabbe.montjoie@gmail.com>,
        <smueller@chronox.de>, <levinsasha928@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        George Cherian <george.cherian@cavium.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1486479075-1813-1-git-send-email-george.cherian@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add the CPT options in crypto Kconfig and update the
crypto Makefile

Update the MAINTAINERS file too.

Signed-off-by: George Cherian <george.cherian@cavium.com>
Reviewed-by: David Daney <david.daney@cavium.com>
---
 MAINTAINERS             | 7 +++++++
 drivers/crypto/Kconfig  | 1 +
 drivers/crypto/Makefile | 1 +
 3 files changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 187b961..386fc34 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2990,6 +2990,13 @@ W:     http://www.cavium.com
 S:     Supported
 F:     drivers/net/ethernet/cavium/liquidio/
 
+CAVIUM OCTEON-TX CRYPTO DRIVER
+M:	George Cherian <george.cherian@cavium.com>
+L:	linux-crypto@vger.kernel.org
+W:	http://www.cavium.com
+S:	Supported
+F:	drivers/crypto/cavium/cpt/
+
 CC2520 IEEE-802.15.4 RADIO DRIVER
 M:	Varka Bhadram <varkabhadram@gmail.com>
 L:	linux-wpan@vger.kernel.org
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 7956478..1603ac3 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -484,6 +484,7 @@ config CRYPTO_DEV_MXS_DCP
 	  will be called mxs-dcp.
 
 source "drivers/crypto/qat/Kconfig"
+source "drivers/crypto/cavium/cpt/Kconfig"
 
 config CRYPTO_DEV_QCE
 	tristate "Qualcomm crypto engine accelerator"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index bc53cb8..7add7fd 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA) += atmel-sha.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_TDES) += atmel-tdes.o
 obj-$(CONFIG_CRYPTO_DEV_BFIN_CRC) += bfin_crc.o
 obj-$(CONFIG_CRYPTO_DEV_CCP) += ccp/
+obj-$(CONFIG_CRYPTO_DEV_CPT) += cavium/cpt/
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam/
 obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) += hifn_795x.o
-- 
2.1.4
