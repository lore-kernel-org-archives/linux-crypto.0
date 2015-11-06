From: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: [PATCH v2 3/4] ARM: dts: rockchip: Add Crypto drivers for rk3288
Date: Fri,  6 Nov 2015 09:17:23 +0800
Message-ID: <1446772644-2352-4-git-send-email-zain.wang@rock-chips.com>
References: <1446772644-2352-1-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, eddie.cai-TNX95d0MmH7DzftRWevZcw@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: zhengsq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, hl-TNX95d0MmH7DzftRWevZcw@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
 davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org,
 pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
 galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Return-path: <linux-rockchip-bounces+glpar-linux-rockchip=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1446772644-2352-1-git-send-email-zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
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

Add Crypto drivers for rk3288 including crypto controller and dma clk.

Signed-off-by: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
---

Changed in v2:
- None

Changed in v1:
- remove the _crypto suffix
- use "rockchip,rk3288-crypto" instead of "rockchip,rk3288"

 arch/arm/boot/dts/rk3288.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 6a79c9c..7b7914e 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -170,6 +170,21 @@
 		};
 	};
 
+	crypto: cypto-controller@ff8a0000 {
+		compatible = "rockchip,rk3288-crypto";
+		reg = <0xff8a0000 0x4000>;
+		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru ACLK_CRYPTO>,
+			 <&cru HCLK_CRYPTO>,
+			 <&cru SCLK_CRYPTO>,
+			 <&cru ACLK_DMAC1>;
+		clock-names = "aclk",
+			      "hclk",
+			      "sclk",
+			      "apb_pclk";
+		status = "okay";
+	};
+
 	reserved-memory {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.9.1
