From: Lionel Debieve <lionel.debieve@st.com>
Subject: [PATCH 1/2] dt-bindings: Document STM32 HASH bindings
Date: Thu, 13 Jul 2017 15:32:26 +0200
Message-ID: <1499952747-16423-2-git-send-email-lionel.debieve@st.com>
References: <1499952747-16423-1-git-send-email-lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ludovic Barre <ludovic.barre@st.com>,
 Lionel Debieve <lionel.debieve@st.com>,
 Benjamin Gaignard <benjamin.gaignard@st.com>,
 Fabien Dessenne <fabien.dessenne@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
 <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@st.com>,
 <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1499952747-16423-1-git-send-email-lionel.debieve@st.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

This adds documentation of device tree bindings for the STM32
HASH controller.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 .../devicetree/bindings/crypto/st,stm32-hash.txt   | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-hash.txt

diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-hash.txt b/Documentation/devicetree/bindings/crypto/st,stm32-hash.txt
new file mode 100644
index 0000000..04fc246
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-hash.txt
@@ -0,0 +1,30 @@
+* STMicroelectronics STM32 HASH
+
+Required properties:
+- compatible: Should contain entries for this and backward compatible
+  HASH versions:
+  - "st,stm32f456-hash" for stm32 F456.
+  - "st,stm32f756-hash" for stm32 F756.
+- reg: The address and length of the peripheral registers space
+- interrupts: the interrupt specifier for the HASH
+- clocks: The input clock of the HASH instance
+
+Optional properties:
+- resets: The input reset of the HASH instance
+- dmas: DMA specifiers for the HASH. See the DMA client binding,
+	 Documentation/devicetree/bindings/dma/dma.txt
+- dma-names: DMA request name. Should be "in" if a dma is present.
+- dma-maxburst: Set number of maximum dma burst supported
+
+Example:
+
+hash1: hash@50060400 {
+	compatible = "st,stm32f756-hash";
+	reg = <0x50060400 0x400>;
+	interrupts = <80>;
+	clocks = <&rcc 0 STM32F7_AHB2_CLOCK(HASH)>;
+	resets = <&rcc STM32F7_AHB2_RESET(HASH)>;
+	dmas = <&dma2 7 2 0x400 0x0>;
+	dma-names = "in";
+	dma-maxburst = <0>;
+};
-- 
2.7.4
