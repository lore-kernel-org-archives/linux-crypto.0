From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 1/6] hwrng: OMAP: Use module_platform_driver macro
Date: Mon, 5 Aug 2013 20:17:18 +0530
Message-ID: <1375714043-23407-2-git-send-email-lokeshvutla@ti.com>
References: <1375714043-23407-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: dsaxena@plexity.net, Lokesh Vutla <lokeshvutla@ti.com>,
 herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org, mpm@selenic.com,
 linux-arm-kernel@lists.infradead.org
To: <linux-omap@vger.kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1375714043-23407-1-git-send-email-lokeshvutla@ti.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

module_platform_driver() makes the code simpler.
Using the macro in the driver.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/char/hw_random/omap-rng.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 6843ec8..3e9a7ec 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -198,9 +198,6 @@ static SIMPLE_DEV_PM_OPS(omap_rng_pm, omap_rng_suspend, omap_rng_resume);
 
 #endif
 
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:omap_rng");
-
 static struct platform_driver omap_rng_driver = {
 	.driver = {
 		.name		= "omap_rng",
@@ -211,18 +208,7 @@ static struct platform_driver omap_rng_driver = {
 	.remove		= __exit_p(omap_rng_remove),
 };
 
-static int __init omap_rng_init(void)
-{
-	return platform_driver_register(&omap_rng_driver);
-}
-
-static void __exit omap_rng_exit(void)
-{
-	platform_driver_unregister(&omap_rng_driver);
-}
-
-module_init(omap_rng_init);
-module_exit(omap_rng_exit);
-
+module_platform_driver(omap_rng_driver);
+MODULE_ALIAS("platform:omap_rng");
 MODULE_AUTHOR("Deepak Saxena (and others)");
 MODULE_LICENSE("GPL");
-- 
1.7.9.5
