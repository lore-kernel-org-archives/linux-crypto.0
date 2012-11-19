From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 3/7] ARM: OMAP2+: Remove unnecessary message when no AES IP is present
Date: Mon, 19 Nov 2012 12:03:48 -0700
Message-ID: <1353351832-6685-4-git-send-email-mgreer@animalcreek.com>
References: <1353351832-6685-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail20.dotsterhost.com ([66.11.232.73]:35824 "EHLO
	mail20.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab2KSTD5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Nov 2012 14:03:57 -0500
In-Reply-To: <1353351832-6685-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Mark A. Greer" <mgreer@animalcreek.com>

Remove the error message that prints when there is no AES IP
present to make it consistent with all the other IPs.

CC: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 arch/arm/mach-omap2/devices.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 6a9152a..03c1b3a 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -470,20 +470,15 @@ static void __init omap_init_sham(void)
 
 static void __init omap_init_aes(void)
 {
-	if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
-		struct omap_hwmod *oh;
-		struct platform_device *pdev;
-
-		oh = omap_hwmod_lookup("aes");
-		if (!oh)
-			return;
-
-		pdev = omap_device_build("omap-aes", -1, oh, NULL, 0, NULL,
-					 0, 0);
-		WARN(IS_ERR(pdev), "Can't build omap_device for omap-aes\n");
-	} else {
-		pr_err("%s: platform not supported\n", __func__);
-	}
+	struct omap_hwmod *oh;
+	struct platform_device *pdev;
+
+	oh = omap_hwmod_lookup("aes");
+	if (!oh)
+		return;
+
+	pdev = omap_device_build("omap-aes", -1, oh, NULL, 0, NULL, 0, 0);
+	WARN(IS_ERR(pdev), "Can't build omap_device for omap-aes\n");
 }
 
 /*-------------------------------------------------------------------------*/
-- 
1.7.12
