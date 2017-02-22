From: Steve Lin <steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/1] ARM: dts: NSP: Add crypto (SPU) to dtsi
Date: Wed, 22 Feb 2017 16:22:23 -0500
Message-ID: <1487798543-34229-1-git-send-email-steven.lin1@broadcom.com>
Cc: bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
        linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, ray.jui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org,
        scott.branden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, jon.mason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org,
        f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Adds crypto hardware (SPU) to Northstar Plus device tree file.

Signed-off-by: Steve Lin <steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

---
Code changes for this addition were submitted previously by Rob
Rice: https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=9d12ba86f818aa9cfe9f01b750336aa441f2ffa2
---
 arch/arm/boot/dts/bcm-nsp.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index b6142bd..9bac0c8 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -241,6 +241,12 @@
 			brcm,nand-has-wp;
 		};
 
+		crypto@2f000 {
+			compatible = "brcm,spum-nsp-crypto";
+			reg = <0x2f000 0x900>;
+			mboxes = <&mailbox 0>;
+		};
+
 		gpiob: gpio@30000 {
 			compatible = "brcm,iproc-nsp-gpio", "brcm,iproc-gpio";
 			reg = <0x30000 0x50>;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
