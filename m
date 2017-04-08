From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH v4 1/2] linux/kernel.h: Add ALIGN_DOWN macro
Date: Sat,  8 Apr 2017 15:32:44 +0200
Message-ID: <20170408133245.30147-2-krzk@kernel.org>
References: <20170408133245.30147-1-krzk@kernel.org>
To: James Hogan <james.hogan@imgtec.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Bernie Thompson <bernie@plugable.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        linux-kernel@vger.kernel.org, linux-metag@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org,
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752705AbdDHNda (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Apr 2017 09:33:30 -0400
In-Reply-To: <20170408133245.30147-1-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Few parts of kernel define their own macro for aligning down so provide
a common define for this, with the same usage and assumptions as existing
ALIGN.

Convert also three existing implementations to this one.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

The metag change was not even compiled due to lack of cross compiler.
---
 arch/metag/kernel/stacktrace.c | 2 --
 drivers/gpu/drm/udl/udl_fb.c   | 2 +-
 include/linux/kernel.h         | 1 +
 include/video/udlfb.h          | 2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/metag/kernel/stacktrace.c b/arch/metag/kernel/stacktrace.c
index 91ffc4b75c33..09d67b7f51ca 100644
--- a/arch/metag/kernel/stacktrace.c
+++ b/arch/metag/kernel/stacktrace.c
@@ -31,8 +31,6 @@ static void tbi_boing_init(void)
 }
 #endif
 
-#define ALIGN_DOWN(addr, size)  ((addr)&(~((size)-1)))
-
 /*
  * Unwind the current stack frame and store the new register values in the
  * structure passed as argument. Unwinding is equivalent to a function return,
diff --git a/drivers/gpu/drm/udl/udl_fb.c b/drivers/gpu/drm/udl/udl_fb.c
index d05abc69e305..4a6500362564 100644
--- a/drivers/gpu/drm/udl/udl_fb.c
+++ b/drivers/gpu/drm/udl/udl_fb.c
@@ -37,7 +37,7 @@ struct udl_fbdev {
 };
 
 #define DL_ALIGN_UP(x, a) ALIGN(x, a)
-#define DL_ALIGN_DOWN(x, a) ALIGN(x-(a-1), a)
+#define DL_ALIGN_DOWN(x, a) ALIGN_DOWN(x, a)
 
 /** Read the red component (0..255) of a 32 bpp colour. */
 #define DLO_RGB_GETRED(col) (uint8_t)((col) & 0xFF)
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4c26dc3a8295..3d9f8420f973 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -47,6 +47,7 @@
 
 /* @a is a power of 2 value */
 #define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
+#define ALIGN_DOWN(x, a)	__ALIGN_KERNEL((x) - ((a) - 1), (a))
 #define __ALIGN_MASK(x, mask)	__ALIGN_KERNEL_MASK((x), (mask))
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
 #define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
diff --git a/include/video/udlfb.h b/include/video/udlfb.h
index f9466fa54ba4..3ea90aea5617 100644
--- a/include/video/udlfb.h
+++ b/include/video/udlfb.h
@@ -92,6 +92,6 @@ struct dlfb_data {
 
 /* remove these once align.h patch is taken into kernel */
 #define DL_ALIGN_UP(x, a) ALIGN(x, a)
-#define DL_ALIGN_DOWN(x, a) ALIGN(x-(a-1), a)
+#define DL_ALIGN_DOWN(x, a) ALIGN_DOWN(x, a)
 
 #endif
-- 
2.9.3
