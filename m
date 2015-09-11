From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/6] hwrng: st: Provide DT bindings for ST's Random Number
 Generator
Date: Fri, 11 Sep 2015 21:08:27 +0100
Message-ID: <1442002110-28733-4-git-send-email-lee.jones@linaro.org>
References: <1442002110-28733-1-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
 linux-crypto@vger.kernel.org, mpm@selenic.com,
 Lee Jones <lee.jones@linaro.org>, kernel@stlinux.com
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1442002110-28733-1-git-send-email-lee.jones@linaro.org>
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

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/rng/st,rng.txt | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/st,rng.txt

diff --git a/Documentation/devicetree/bindings/rng/st,rng.txt b/Documentation/devicetree/bindings/rng/st,rng.txt
new file mode 100644
index 0000000..dbc64e6
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/st,rng.txt
@@ -0,0 +1,15 @@
+STMicroelectronics HW Random Number Generator
+----------------------------------------------
+
+Required parameters:
+compatible	: Should be "st,rng"
+reg		: Base address and size of IP's register map.
+clocks		: Phandle to device's clock (See: ../clocks/clock-bindings.txt)
+
+Example:
+
+rng@0xfee80000 {
+	compatible      = "st,rng";
+	reg		= <0xfee80000 0x1000>;
+	clocks          = <&clk_sysin>;
+}
-- 
1.9.1
