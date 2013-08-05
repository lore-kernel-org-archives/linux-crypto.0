From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 5/6] ARM: OMAP2+: Only manually add hwmod data when DT not used.
Date: Mon, 5 Aug 2013 20:17:22 +0530
Message-ID: <1375714043-23407-6-git-send-email-lokeshvutla@ti.com>
References: <1375714043-23407-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <mpm@selenic.com>,
	<herbert@gondor.hengli.com.au>, <dsaxena@plexity.net>,
	<linux-crypto@vger.kernel.org>, Lokesh Vutla <lokeshvutla@ti.com>,
	Tony Lindgren <tony@atomide.com>
To: <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:54884 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325Ab3HEOsR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Aug 2013 10:48:17 -0400
In-Reply-To: <1375714043-23407-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The omap_init_rng() routine in devices.c only needs to be
called when there is no device tree present.

Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 arch/arm/mach-omap2/devices.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 3c1279f..afc2017 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -570,12 +570,12 @@ static int __init omap2_init_devices(void)
 		omap_init_mcspi();
 		omap_init_sham();
 		omap_init_aes();
+		omap_init_rng();
 	} else {
 		/* These can be removed when bindings are done */
 		omap_init_wl12xx_of();
 	}
 	omap_init_sti();
-	omap_init_rng();
 	omap_init_vout();
 
 	return 0;
-- 
1.7.9.5
