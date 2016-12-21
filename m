From: <george.cherian@cavium.com>
Subject: [PATCH v3 3/3] drivers: crypto: Enable CPT options crypto for build
Date: Wed, 21 Dec 2016 11:56:13 +0000
Message-ID: <1482321373-407-4-git-send-email-george.cherian@cavium.com>
References: <1482321373-407-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <david.daney@cavium.com>,
        George Cherian <george.cherian@cavium.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0047.outbound.protection.outlook.com ([104.47.34.47]:12640
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756979AbcLUL47 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Dec 2016 06:56:59 -0500
In-Reply-To: <1482321373-407-1-git-send-email-george.cherian@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: George Cherian <george.cherian@cavium.com>

Add the CPT options in crypto Kconfig and update the
crypto Makefile

Signed-off-by: George Cherian <george.cherian@cavium.com>
Reviewed-by: David Daney <david.daney@cavium.com>
---
 drivers/crypto/Kconfig  | 1 +
 drivers/crypto/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 4d2b81f..15f9040 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -484,6 +484,7 @@ config CRYPTO_DEV_MXS_DCP
 	  will be called mxs-dcp.
 
 source "drivers/crypto/qat/Kconfig"
+source "drivers/crypto/cavium/cpt/Kconfig"
 
 config CRYPTO_DEV_QCE
 	tristate "Qualcomm crypto engine accelerator"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index ad7250f..dd33290 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -32,3 +32,4 @@ obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
 obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sunxi-ss/
 obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) += rockchip/
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO) += chelsio/
+obj-$(CONFIG_CRYPTO_DEV_CPT) += cavium/cpt/
-- 
2.1.4
