From: Cosar Dindar <cosardindar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/5] dt-bindings : Document the STM32F4 CRC32 binding
Date: Sat, 20 May 2017 16:32:12 +0300
Message-ID: <bb672acb88667e9d27beb4d1e4fd8882f265ee47.1495285223.git.cosardindar@gmail.com>
References: <cover.1495285223.git.cosardindar@gmail.com>
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
        mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alexandre.torgue-qxv4g6HH51o@public.gmane.org,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        fabien.dessenne-qxv4g6HH51o@public.gmane.org, Cosar Dindar <cosardindar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1495285223.git.cosardindar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Add device tree binding for STM32F4.

Signed-off-by: Cosar Dindar <cosardindar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/devicetree/bindings/crypto/st,stm32-crc.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
index 3ba92a5..7b30f1e 100644
--- a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
@@ -1,7 +1,7 @@
 * STMicroelectronics STM32 CRC
 
 Required properties:
-- compatible: Should be "st,stm32f7-crc".
+- compatible: Can be either "st,stm32f7-crc" or "st,srm32f4-crc".
 - reg: The address and length of the peripheral registers space
 - clocks: The input clock of the CRC instance
 
@@ -10,7 +10,7 @@ Optional properties: none
 Example:
 
 crc: crc@40023000 {
-	compatible = "st,stm32f7-crc";
+	compatible = "st,stm32f7-crc", "st,stm32f4-crc";
 	reg = <0x40023000 0x400>;
 	clocks = <&rcc 0 12>;
 };
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
