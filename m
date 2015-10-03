From: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/3] dt-bindings: Document the STM32 HW RNG bindings
Date: Sat,  3 Oct 2015 21:35:17 +0100
Message-ID: <1443904519-24012-2-git-send-email-daniel.thompson@linaro.org>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
Cc: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org,
	Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
To: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443904519-24012-1-git-send-email-daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This adds documenttaion of device tree binds for the STM32 hardware
random number generator.

Signed-off-by: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 .../devicetree/bindings/hwrng/stm32-rng.txt         | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwrng/stm32-rng.txt

diff --git a/Documentation/devicetree/bindings/hwrng/stm32-rng.txt b/Documentation/devicetree/bindings/hwrng/stm32-rng.txt
new file mode 100644
index 000000000000..47f04176f93b
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwrng/stm32-rng.txt
@@ -0,0 +1,21 @@
+STMicroelectronics STM32 HW RNG
+===============================
+
+The STM32 hardware random number generator is a simple fixed purpose IP and
+is fully separated from other crypto functions.
+
+Required properties:
+
+- compatible : Should be "st,stm32-rng"
+- reg : Should be register base and length as documented in the datasheet
+- interrupts : The designated IRQ line for the RNG
+- clocks : The clock needed to enable the RNG
+
+Example:
+
+	rng: rng@50060800 {
+		compatible = "st,stm32-rng";
+		reg = <0x50060800 0x400>;
+		interrupts = <80>;
+		clocks = <&rcc 0 38>;
+	};
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
