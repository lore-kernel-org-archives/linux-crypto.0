From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 4/7] crypto: omap-aes: Remove cpu_is/omap_type check from driver
Date: Mon, 19 Nov 2012 12:03:49 -0700
Message-ID: <1353351832-6685-5-git-send-email-mgreer@animalcreek.com>
References: <1353351832-6685-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail20.dotsterhost.com ([66.11.232.73]:35864 "EHLO
	mail20.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab2KSTD6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Nov 2012 14:03:58 -0500
In-Reply-To: <1353351832-6685-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Mark A. Greer" <mgreer@animalcreek.com>

The omap-aes driver should not check the CPU class or the
type of OMAP device its on.  The platform code should do
that instead.

Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 drivers/crypto/omap-aes.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 093a8af..628c3cc 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -941,11 +941,6 @@ static int __init omap_aes_mod_init(void)
 {
 	pr_info("loading %s driver\n", "omap-aes");
 
-	if (!cpu_class_is_omap2() || omap_type() != OMAP2_DEVICE_TYPE_SEC) {
-		pr_err("Unsupported cpu\n");
-		return -ENODEV;
-	}
-
 	return  platform_driver_register(&omap_aes_driver);
 }
 
-- 
1.7.12
