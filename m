From: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 3/4] crypto: jz4780-rng: Add RNG node to jz4780.dtsi
Date: Wed, 23 Aug 2017 08:27:06 +0530
Message-ID: <20170823025707.27888-4-prasannatsmkumar@gmail.com>
References: <20170823025707.27888-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
        robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org,
        paul-icTtO2rgO2OTuSrc4Mpeew@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org,
        malat-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org, noloader-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170823025707.27888-1-prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Add RNG node to jz4780 dtsi. This driver uses registers that are part of
the register set used by Ingenic CGU driver. Make RNG node as child of
CGU node.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
* Add "syscon" in CGU node's compatible section
* Make RNG child node of CGU.

 arch/mips/boot/dts/ingenic/jz4780.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/mips/boot/dts/ingenic/jz4780.dtsi b/arch/mips/boot/dts/ingenic/jz4780.dtsi
index 4853ef6..411e16c 100644
--- a/arch/mips/boot/dts/ingenic/jz4780.dtsi
+++ b/arch/mips/boot/dts/ingenic/jz4780.dtsi
@@ -35,13 +35,17 @@
 	};
 
 	cgu: jz4780-cgu@10000000 {
-		compatible = "ingenic,jz4780-cgu";
+		compatible = "ingenic,jz4780-cgu", "syscon";
 		reg = <0x10000000 0x100>;
 
 		clocks = <&ext>, <&rtc>;
 		clock-names = "ext", "rtc";
 
 		#clock-cells = <1>;
+
+		rng: rng@d8 {
+			compatible = "ingenic,jz480-rng";
+		};
 	};
 
 	pinctrl: pin-controller@10010000 {
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
