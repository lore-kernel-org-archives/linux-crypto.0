From: gcherianv@gmail.com
Subject: [PATCH 3/3] drivers: crypto: Enable CPT options crypto for build
Date: Fri, 18 Nov 2016 15:00:09 +0000
Message-ID: <1479481209-11475-4-git-send-email-gcherianv@gmail.com>
References: <1479481209-11475-1-git-send-email-gcherianv@gmail.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        George Cherian <george.cherian@cavium.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34504 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753308AbcKRPAg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2016 10:00:36 -0500
In-Reply-To: <1479481209-11475-1-git-send-email-gcherianv@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: George Cherian <george.cherian@cavium.com>

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
