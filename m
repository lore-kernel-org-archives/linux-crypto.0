From: Fabien Dessenne <fabien.dessenne@st.com>
Subject: [PATCH v5 1/2] dt-bindings: Document STM32 CRYP bindings
Date: Thu, 19 Oct 2017 17:10:29 +0200
Message-ID: <1508425830-13565-2-git-send-email-fabien.dessenne@st.com>
References: <1508425830-13565-1-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Lionel Debieve <lionel.debieve@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508425830-13565-1-git-send-email-fabien.dessenne@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Document device tree bindings for the STM32 CRYP.

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/crypto/st,stm32-cryp.txt      | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt

diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt
new file mode 100644
index 0000000..970487f
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt
@@ -0,0 +1,19 @@
+* STMicroelectronics STM32 CRYP
+
+Required properties:
+- compatible: Should be "st,stm32f756-cryp".
+- reg: The address and length of the peripheral registers space
+- clocks: The input clock of the CRYP instance
+- interrupts: The CRYP interrupt
+
+Optional properties:
+- resets: The input reset of the CRYP instance
+
+Example:
+crypto@50060000 {
+	compatible = "st,stm32f756-cryp";
+	reg = <0x50060000 0x400>;
+	interrupts = <79>;
+	clocks = <&rcc 0 STM32F7_AHB2_CLOCK(CRYP)>;
+	resets = <&rcc STM32F7_AHB2_RESET(CRYP)>;
+};
-- 
2.7.4
