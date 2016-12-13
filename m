From: George Cherian <george.cherian@cavium.com>
Subject: [PATCH v2 3/3] drivers: crypto: Enable CPT options crypto for build
Date: Tue, 13 Dec 2016 14:03:21 +0000
Message-ID: <1481637801-1076-4-git-send-email-george.cherian@cavium.com>
References: <1481637801-1076-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        George Cherian <george.cherian@cavium.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481637801-1076-1-git-send-email-george.cherian@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add the CPT options in crypto Kconfig and update the
crypto Makefile

Signed-off-by: George Cherian <george.cherian@cavium.com>
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
