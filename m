From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 3/6] hwrng: OMAP: Remove duplicated function call
Date: Mon, 5 Aug 2013 20:17:20 +0530
Message-ID: <1375714043-23407-4-git-send-email-lokeshvutla@ti.com>
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

platform_set_drvdata() is called twice in driver probe.
Removing the duplicated call.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/char/hw_random/omap-rng.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 9c19396..5a2ab3b 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -125,7 +125,6 @@ static int omap_rng_probe(struct platform_device *pdev)
 		ret = PTR_ERR(priv->base);
 		goto err_ioremap;
 	}
-	platform_set_drvdata(pdev, priv);
 
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
-- 
1.7.9.5
