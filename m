From: Fabien Dessenne <fabien.dessenne-qxv4g6HH51o@public.gmane.org>
Subject: [PATCH 1/4] dt-bindings: Document STM32 CRC bindings
Date: Tue, 14 Mar 2017 17:37:23 +0100
Message-ID: <1489509446-32283-2-git-send-email-fabien.dessenne@st.com>
References: <1489509446-32283-1-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Alexandre Torgue <alexandre.torgue-qxv4g6HH51o@public.gmane.org>,
        Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489509446-32283-1-git-send-email-fabien.dessenne-qxv4g6HH51o@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Document device tree bindings for the STM32 CRC (crypto CRC32)

Signed-off-by: Fabien Dessenne <fabien.dessenne-qxv4g6HH51o@public.gmane.org>
---
 .../devicetree/bindings/crypto/st,stm32-crc.txt          | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-crc.txt

diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
new file mode 100644
index 0000000..2312e8a
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
@@ -0,0 +1,16 @@
+* STMicroelectronics STM32 CRC
+
+Required properties:
+- compatible: shoudl be "st,stm32f7-crc".
+- reg: The address and length of the peripheral registers space
+- clocks: The input clock of the CRC instance
+
+Optional properties: none
+
+Example:
+
+crc: crc@40023000 {
+	compatible = "st,stm32f7-crc";
+	reg = <0x40023000 0x400>;
+	clocks = <&rcc 0 12>;
+};
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
