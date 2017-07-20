From: Lars Persson <lars.persson-VrBV9hrLPhE@public.gmane.org>
Subject: [PATCH 4/4] MAINTAINERS: Add ARTPEC crypto maintainer
Date: Thu, 20 Jul 2017 15:44:32 +0200
Message-ID: <9ad88f73147bef1079689c59b075e02c07beea07.1500557664.git.larper@axis.com>
References: <cover.1500557664.git.larper@axis.com>
Cc: Lars Persson <larper-VrBV9hrLPhE@public.gmane.org>
To: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
        robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1500557664.git.larper-VrBV9hrLPhE@public.gmane.org>
In-Reply-To: <cover.1500557664.git.larper-VrBV9hrLPhE@public.gmane.org>
References: <cover.1500557664.git.larper-VrBV9hrLPhE@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Assign the Axis kernel team as maintainer for crypto drivers under
drivers/crypto/axis.

Signed-off-by: Lars Persson <larper-VrBV9hrLPhE@public.gmane.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d5b6c71e783e..72186cf9820d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1129,6 +1129,7 @@ L:	linux-arm-kernel-VrBV9hrLPhE@public.gmane.org
 F:	arch/arm/mach-artpec
 F:	arch/arm/boot/dts/artpec6*
 F:	drivers/clk/axis
+F:	drivers/crypto/axis
 F:	drivers/pinctrl/pinctrl-artpec*
 F:	Documentation/devicetree/bindings/pinctrl/axis,artpec6-pinctrl.txt
 
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
