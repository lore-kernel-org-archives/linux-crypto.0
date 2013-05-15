From: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 38/39] dmaengine: ste_dma40: Fetch the number of physical channels from DT
Date: Wed, 15 May 2013 10:52:01 +0100
Message-ID: <1368611522-9984-39-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, linus.walleij-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org,
	srinidhi.kasagar-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Dan Williams <djbw-b10kYP2dOMg@public.gmane.org>,
	Per Forlin <per.forlin-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org>,
	Rabin Vincent <rabin-66gdRtMMWGc@public.gmane.org>
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	balbi-l0cyMroinI0@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Some platforms insist on obscure physical channel availability. This
information is currently passed though platform data in internal BSP
kernels. Once those platforms land, they'll need to configure them
appropriately, so we may as well add the infrastructure.

Cc: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dan Williams <djbw-b10kYP2dOMg@public.gmane.org>
Cc: Per Forlin <per.forlin-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org>
Cc: Rabin Vincent <rabin-66gdRtMMWGc@public.gmane.org>
Signed-off-by: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/dma/ste_dma40.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ae462d3..4e528dd 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3482,7 +3482,7 @@ static int __init d40_of_probe(struct platform_device *pdev,
 			       struct device_node *np)
 {
 	struct stedma40_platform_data *pdata;
-	int num_memcpy = 0;
+	int num_phy = 0, num_memcpy = 0;
 	const const __be32 *list;
 
 	pdata = devm_kzalloc(&pdev->dev,
@@ -3491,6 +3491,11 @@ static int __init d40_of_probe(struct platform_device *pdev,
 	if (!pdata)
 		return -ENOMEM;
 
+	/* If absent this value will be obtained from h/w. */
+	of_property_read_u32(np, "dma-channels", &num_phy);
+	if (num_phy > 0)
+		pdata->num_of_phy_chans = num_phy;
+
 	list = of_get_property(np, "memcpy-channels", &num_memcpy);
 	num_memcpy /= sizeof(*list);
 
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
