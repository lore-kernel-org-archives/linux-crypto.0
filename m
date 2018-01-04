From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v10 1/8] drm/tilcdc: ensure nonatomic iowrite64 is not used
Date: Thu,  4 Jan 2018 12:16:38 -0700
Message-ID: <20180104191645.10006-2-logang@deltatee.com>
References: <20180104191645.10006-1-logang@deltatee.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Jyri Sarha <jsarha@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        David Airlie <airlied@linux.ie>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180104191645.10006-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add a check to ensure iowrite64 is only used if it is atomic.

It was decided in [1] that the tilcdc driver should not be using an
atomic operation (so it was left out of this patchset). However, it turns
out that through the drm code, a nonatomic header is actually included:

include/linux/io-64-nonatomic-lo-hi.h
is included from include/drm/drm_os_linux.h:9:0,
            from include/drm/drmP.h:74,
            from include/drm/drm_modeset_helper.h:26,
            from include/drm/drm_atomic_helper.h:33,
            from drivers/gpu/drm/tilcdc/tilcdc_crtc.c:19:

And thus, without this change, this patchset would inadvertantly
change the behaviour of the tilcdc driver.

[1] lkml.kernel.org/r/CAK8P3a2HhO_zCnsTzq7hmWSz5La5Thu19FWZpun16iMnyyNreQ@mail.gmail.com

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Jyri Sarha <jsarha@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: David Airlie <airlied@linux.ie>
---
 drivers/gpu/drm/tilcdc/tilcdc_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_regs.h b/drivers/gpu/drm/tilcdc/tilcdc_regs.h
index 9d528c0a67a4..5048ebb86835 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_regs.h
+++ b/drivers/gpu/drm/tilcdc/tilcdc_regs.h
@@ -133,7 +133,7 @@ static inline void tilcdc_write64(struct drm_device *dev, u32 reg, u64 data)
 	struct tilcdc_drm_private *priv = dev->dev_private;
 	volatile void __iomem *addr = priv->mmio + reg;
 
-#ifdef iowrite64
+#if defined(iowrite64) && !defined(iowrite64_is_nonatomic)
 	iowrite64(data, addr);
 #else
 	__iowmb();
-- 
2.11.0
