From: George Cherian <george.cherian@cavium.com>
Subject: [PATCH v5 3/3] drivers: crypto: Enable CPT options crypto for build
Date: Mon, 30 Jan 2017 12:30:44 +0000
Message-ID: <1485779444-4332-4-git-send-email-george.cherian@cavium.com>
References: <1485779444-4332-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <david.daney@cavium.com>, <clabbe.montjoie@gmail.com>,
        <smueller@chronox.de>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>,
        George Cherian <george.cherian@cavium.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0086.outbound.protection.outlook.com ([104.47.36.86]:23979
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753215AbdA3Mbk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2017 07:31:40 -0500
In-Reply-To: <1485779444-4332-1-git-send-email-george.cherian@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add the CPT options in crypto Kconfig and update the
crypto Makefile

Signed-off-by: George Cherian <george.cherian@cavium.com>
Reviewed-by: David Daney <david.daney@cavium.com>
---
 drivers/crypto/Kconfig  | 1 +
 drivers/crypto/Makefile | 1 +
 2 files changed, 2 insertions(+)

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
index bc53cb8..b43a1c1 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_CRYPTO_DEV_ATMEL_TDES) += atmel-tdes.o
 obj-$(CONFIG_CRYPTO_DEV_BFIN_CRC) += bfin_crc.o
 obj-$(CONFIG_CRYPTO_DEV_CCP) += ccp/
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam/
+obj-$(CONFIG_CRYPTO_DEV_CPT) += cavium/cpt/
 obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) += hifn_795x.o
 obj-$(CONFIG_CRYPTO_DEV_IMGTEC_HASH) += img-hash.o
-- 
2.1.4
