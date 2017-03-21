From: Fabien Dessenne <fabien.dessenne@st.com>
Subject: [PATCH v2 1/5] dt-bindings: Document STM32 CRC bindings
Date: Tue, 21 Mar 2017 16:13:27 +0100
Message-ID: <1490109211-4869-2-git-send-email-fabien.dessenne@st.com>
References: <1490109211-4869-1-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
 <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@st.com>, Russell King
 <linux@armlinux.org.uk>, <linux-crypto@vger.kernel.org>,
 <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1490109211-4869-1-git-send-email-fabien.dessenne@st.com>
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

Document device tree bindings for the STM32 CRC (crypto CRC32)

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 .../devicetree/bindings/crypto/st,stm32-crc.txt          | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-crc.txt

diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
new file mode 100644
index 0000000..3ba92a5
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
@@ -0,0 +1,16 @@
+* STMicroelectronics STM32 CRC
+
+Required properties:
+- compatible: Should be "st,stm32f7-crc".
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
