From: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: [RESEND PATCH 4/4] crypto: rk_crypto - add DT bindings documentation
Date: Fri, 30 Oct 2015 16:22:49 +0800
Message-ID: <1446193369-4453-5-git-send-email-zain.wang@rock-chips.com>
References: <1446193369-4453-1-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 eddie.cai-TNX95d0MmH7DzftRWevZcw@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: zhengsq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, hl-TNX95d0MmH7DzftRWevZcw@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
 davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org,
 pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
 galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Return-path: <linux-rockchip-bounces+glpar-linux-rockchip=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1446193369-4453-1-git-send-email-zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-rockchip>,
 <mailto:linux-rockchip-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-rockchip/>
List-Post: <mailto:linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-rockchip-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-rockchip>,
 <mailto:linux-rockchip-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-rockchip" <linux-rockchip-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-rockchip-bounces+glpar-linux-rockchip=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Add DT bindings documentation for the rk3288 crypto drivers.

Signed-off-by: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
---
 .../devicetree/bindings/crypto/rk-crypto.txt       | 31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/rk-crypto.txt

diff --git a/Documentation/devicetree/bindings/crypto/rk-crypto.txt b/Documentation/devicetree/bindings/crypto/rk-crypto.txt
new file mode 100644
index 0000000..1e50768
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rk-crypto.txt
@@ -0,0 +1,31 @@
+Rockchip Electronics And Security Accelerator
+
+Required properties:
+- compatible: should be "rockchip,crypto"
+- reg: base physical address of the engine and length of memory mapped
+       region.
+- interrupts: interrupt number
+- clocks: clock specifiers
+- clock-names: "aclk_crypto" used to clock data
+			   "hclk_crypto" used to clock data
+			   "srst_crypto" used to clock crypto accelerator
+			   "apb_pclk"    used to clock dma
+-status: Enable
+
+Examples:
+
+	crypto: cypto-controller@ff8a0000 {
+		compatible = "rockchip,crypto";
+		reg = <0xff8a0000 0x4000>;
+		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru ACLK_CRYPTO>,
+			 <&cru HCLK_CRYPTO>,
+			 <&cru SRST_CRYPTO>,
+			 <&cru ACLK_DMAC1>;
+
+		clock-names = "aclk_crypto",
+			      "hclk_crypto",
+			      "srst_crypto",
+				  "apb_pclk";
+		status = "okay";
+	};
-- 
1.9.1
