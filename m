From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 1/3] dt-bindings: Document the STM32 HW RNG bindings
Date: Mon, 12 Oct 2015 09:21:28 +0100
Message-ID: <1444638090-22886-2-git-send-email-daniel.thompson@linaro.org>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
 <1444638090-22886-1-git-send-email-daniel.thompson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
 Daniel Thompson <daniel.thompson@linaro.org>, linaro-kernel@lists.linaro.org,
 Pawel Moll <pawel.moll@arm.com>, patches@linaro.org,
 Ian Campbell <ijc+devicetree@hellion.org.uk>, linux-kernel@vger.kernel.org,
 Rob Herring <robh+dt@kernel.org>, linux-crypto@vger.kernel.org,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>, Kumar Gala <galak@codeaurora.org>,
 linux-arm-kernel@lists.infradead.org
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1444638090-22886-1-git-send-email-daniel.thompson@linaro.org>
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

This adds documentation of device tree bindings for the STM32 hardware
random number generator.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/rng/st,stm32-rng.txt        | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/st,stm32-rng.txt

diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.txt b/Documentation/devicetree/bindings/rng/st,stm32-rng.txt
new file mode 100644
index 000000000000..47f04176f93b
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.txt
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
