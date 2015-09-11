From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 6/6] MAINTAINERS: Add ST's Random Number Generator to the ST entry
Date: Fri, 11 Sep 2015 21:08:30 +0100
Message-ID: <1442002110-28733-7-git-send-email-lee.jones@linaro.org>
References: <1442002110-28733-1-git-send-email-lee.jones@linaro.org>
Cc: kernel@stlinux.com, mpm@selenic.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442002110-28733-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fd60784..b084d69 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1502,6 +1502,7 @@ W:	http://www.stlinux.com
 S:	Maintained
 F:	arch/arm/mach-sti/
 F:	arch/arm/boot/dts/sti*
+F:	drivers/char/hw_random/st-rng.c
 F:	drivers/clocksource/arm_global_timer.c
 F:	drivers/i2c/busses/i2c-st.c
 F:	drivers/media/rc/st_rc.c
-- 
1.9.1
