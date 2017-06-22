From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH 1/7] drm/tilcdc: don't use volatile with iowrite64
Date: Thu, 22 Jun 2017 10:48:11 -0600
Message-ID: <20170622164817.25515-2-logang@deltatee.com>
References: <20170622164817.25515-1-logang@deltatee.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Jyri Sarha <jsarha@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        David Airlie <airlied@linux.ie>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-alpha@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170622164817.25515-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is a prep patch for adding a universal iowrite64.

The patch is to prevent compiler warnings when we add iowrite64 that
would occur because there is an unnecessary volatile in this driver.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Jyri Sarha <jsarha@ti.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: David Airlie <airlied@linux.ie>
---
 drivers/gpu/drm/tilcdc/tilcdc_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_regs.h b/drivers/gpu/drm/tilcdc/tilcdc_regs.h
index 9d528c0a67a4..e9ce725698a9 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_regs.h
+++ b/drivers/gpu/drm/tilcdc/tilcdc_regs.h
@@ -131,14 +131,14 @@ static inline void tilcdc_write(struct drm_device *dev, u32 reg, u32 data)
 static inline void tilcdc_write64(struct drm_device *dev, u32 reg, u64 data)
 {
 	struct tilcdc_drm_private *priv = dev->dev_private;
-	volatile void __iomem *addr = priv->mmio + reg;
+	void __iomem *addr = priv->mmio + reg;
 
 #ifdef iowrite64
 	iowrite64(data, addr);
 #else
 	__iowmb();
 	/* This compiles to strd (=64-bit write) on ARM7 */
-	*(volatile u64 __force *)addr = __cpu_to_le64(data);
+	*(u64 __force *)addr = __cpu_to_le64(data);
 #endif
 }
 
-- 
2.11.0
