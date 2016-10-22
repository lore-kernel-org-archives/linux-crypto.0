From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] nvmem: sunxi-sid: SID content is not a valid source of randomness
Date: Sat, 22 Oct 2016 15:53:28 +0200
Message-ID: <1477144408-15896-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: srinivas.kandagatla@linaro.org, maxime.ripard@free-electrons.com,
        wens@csie.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Since SID's content is constant over reboot, it must not be used
as source of randomness.

This patch remove the use of SID content as source of randomness.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/nvmem/sunxi_sid.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/nvmem/sunxi_sid.c b/drivers/nvmem/sunxi_sid.c
index 1567ccc..c82d5d1 100644
--- a/drivers/nvmem/sunxi_sid.c
+++ b/drivers/nvmem/sunxi_sid.c
@@ -21,8 +21,6 @@
 #include <linux/nvmem-provider.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/slab.h>
-#include <linux/random.h>
 
 static struct nvmem_config econfig = {
 	.name = "sunxi-sid",
@@ -70,8 +68,6 @@ static int sunxi_sid_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct nvmem_device *nvmem;
 	struct sunxi_sid *sid;
-	int ret, i, size;
-	char *randomness;
 
 	sid = devm_kzalloc(dev, sizeof(*sid), GFP_KERNEL);
 	if (!sid)
@@ -82,7 +78,6 @@ static int sunxi_sid_probe(struct platform_device *pdev)
 	if (IS_ERR(sid->base))
 		return PTR_ERR(sid->base);
 
-	size = resource_size(res) - 1;
 	econfig.size = resource_size(res);
 	econfig.dev = dev;
 	econfig.reg_read = sunxi_sid_read;
@@ -91,25 +86,9 @@ static int sunxi_sid_probe(struct platform_device *pdev)
 	if (IS_ERR(nvmem))
 		return PTR_ERR(nvmem);
 
-	randomness = kzalloc(sizeof(u8) * (size), GFP_KERNEL);
-	if (!randomness) {
-		ret = -EINVAL;
-		goto err_unreg_nvmem;
-	}
-
-	for (i = 0; i < size; i++)
-		randomness[i] = sunxi_sid_read_byte(sid, i);
-
-	add_device_randomness(randomness, size);
-	kfree(randomness);
-
 	platform_set_drvdata(pdev, nvmem);
 
 	return 0;
-
-err_unreg_nvmem:
-	nvmem_unregister(nvmem);
-	return ret;
 }
 
 static int sunxi_sid_remove(struct platform_device *pdev)
-- 
2.7.3
