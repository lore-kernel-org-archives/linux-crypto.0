From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH v3 4/7] ARM: OMAP2+: Remove unnecessary message when no SHA IP is present
Date: Tue,  6 Nov 2012 19:57:10 -0700
Message-ID: <1352257033-32495-5-git-send-email-mgreer@animalcreek.com>
References: <1352257033-32495-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <1352257033-32495-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: "Mark A. Greer" <mgreer@animalcreek.com>

Remove the error message that prints when there is no SHA IP
present to make it consistent with all the other IPs.

CC: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 arch/arm/mach-omap2/devices.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index f38ac9d..f41c793 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -456,20 +456,15 @@ static void omap_init_rng(void)
 
 static void __init omap_init_sham(void)
 {
-	if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
-		struct omap_hwmod *oh;
-		struct platform_device *pdev;
+	struct omap_hwmod *oh;
+	struct platform_device *pdev;
 
-		oh = omap_hwmod_lookup("sham");
-		if (!oh)
-			return;
+	oh = omap_hwmod_lookup("sham");
+	if (!oh)
+		return;
 
-		pdev = omap_device_build("omap-sham", -1, oh, NULL, 0, NULL,
-					 0, 0);
-		WARN(IS_ERR(pdev), "Can't build omap_device for omap-sham\n");
-	} else {
-		pr_err("%s: platform not supported\n", __func__);
-	}
+	pdev = omap_device_build("omap-sham", -1, oh, NULL, 0, NULL, 0, 0);
+	WARN(IS_ERR(pdev), "Can't build omap_device for omap-sham\n");
 }
 
 #if defined(CONFIG_CRYPTO_DEV_OMAP_AES) || defined(CONFIG_CRYPTO_DEV_OMAP_AES_MODULE)
-- 
1.7.12

