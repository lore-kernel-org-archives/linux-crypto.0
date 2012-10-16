From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 5/5] crypto: suspend/resume callbacks should be conditionally compiled on CONFIG_PM_SLEEP
Date: Tue, 16 Oct 2012 22:59:05 +0800
Message-ID: <1350399545-11179-5-git-send-email-yuanhan.liu@linux.intel.com>
References: <1350399545-11179-1-git-send-email-yuanhan.liu@linux.intel.com>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1350399545-11179-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This will fix warnings like following when CONFIG_PM_SLEEP is not set:

        warning: 'xxx_suspend' defined but not used [-Wunused-function]
        warning: 'xxx_resume' defined but not used [-Wunused-function]

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/crypto/ux500/cryp/cryp_core.c |    2 ++
 drivers/crypto/ux500/hash/hash_core.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index bc615cc..21b50ea 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1662,6 +1662,7 @@ static void ux500_cryp_shutdown(struct platform_device *pdev)
 
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int ux500_cryp_suspend(struct device *dev)
 {
 	int ret;
@@ -1742,6 +1743,7 @@ static int ux500_cryp_resume(struct device *dev)
 
 	return ret;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(ux500_cryp_pm, ux500_cryp_suspend, ux500_cryp_resume);
 
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 632c333..906559f 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1892,6 +1892,7 @@ static void ux500_hash_shutdown(struct platform_device *pdev)
 				__func__);
 }
 
+#ifdef CONFIG_PM_SLEEP
 /**
  * ux500_hash_suspend - Function that suspends the hash device.
  * @dev:	Device to suspend.
@@ -1959,6 +1960,7 @@ static int ux500_hash_resume(struct device *dev)
 
 	return ret;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(ux500_hash_pm, ux500_hash_suspend, ux500_hash_resume);
 
-- 
1.7.7.6
