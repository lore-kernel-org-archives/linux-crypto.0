From: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Subject: [PATCH] crypto: brcm - remove BCM_PDC_MBOX dependency in Kconfig
Date: Tue, 11 Jul 2017 15:50:06 +0530
Message-ID: <1499768406-8342-1-git-send-email-raveendra.padasalagi@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Steve Lin <steven.lin1@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        stable@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Rice <rob.rice@broadcom.com>, linux-crypto@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

SPU driver is dependent on generic MAILBOX API's to
communicate with underlying DMA engine driver.

So this patch removes BCM_PDC_MBOX "depends on" for SPU driver
in Kconfig and adds MAILBOX as dependent module.

Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Reviewed-by: Ray Jui <ray.jui@broadcom.com>
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Cc: stable@vger.kernel.org
---
 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index fb1e60f..778fc1b 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -629,7 +629,7 @@ source "drivers/crypto/virtio/Kconfig"
 config CRYPTO_DEV_BCM_SPU
 	tristate "Broadcom symmetric crypto/hash acceleration support"
 	depends on ARCH_BCM_IPROC
-	depends on BCM_PDC_MBOX
+	depends on MAILBOX
 	default m
 	select CRYPTO_DES
 	select CRYPTO_MD5
-- 
1.9.1
