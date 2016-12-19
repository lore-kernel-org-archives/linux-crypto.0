From: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 2/2] crypto: mediatek - add DT bindings documentation
Date: Mon, 19 Dec 2016 10:20:45 +0800
Message-ID: <1482114045-18716-3-git-send-email-ryder.lee@mediatek.com>
References: <1482114045-18716-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>,
 Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Roy Luo <cheng-hao.luo-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, "David S. Miller"
 <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1482114045-18716-1-git-send-email-ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Add DT bindings documentation for the crypto driver

Signed-off-by: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 .../devicetree/bindings/crypto/mediatek-crypto.txt | 27 ++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/mediatek-crypto.txt

diff --git a/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt b/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
new file mode 100644
index 0000000..c204725
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
@@ -0,0 +1,27 @@
+MediaTek cryptographic accelerators
+
+Required properties:
+- compatible: Should be "mediatek,eip97-crypto"
+- reg: Address and length of the register set for the device
+- interrupts: Should contain the five crypto engines interrupts in numeric
+	order. These are global system and four descriptor rings.
+- clocks: the clock used by the core
+- clock-names: the names of the clock listed in the clocks property. These are
+	"ethif", "cryp"
+- power-domains: Must contain a reference to the PM domain.
+
+
+Example:
+	crypto: crypto@1b240000 {
+		compatible = "mediatek,eip97-crypto";
+		reg = <0 0x1b240000 0 0x20000>;
+		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_LOW>,
+			     <GIC_SPI 83 IRQ_TYPE_LEVEL_LOW>,
+			     <GIC_SPI 84 IRQ_TYPE_LEVEL_LOW>,
+			     <GIC_SPI 91 IRQ_TYPE_LEVEL_LOW>,
+			     <GIC_SPI 97 IRQ_TYPE_LEVEL_LOW>;
+		clocks = <&topckgen CLK_TOP_ETHIF_SEL>,
+			 <&ethsys CLK_ETHSYS_CRYPTO>;
+		clock-names = "ethif","cryp";
+		power-domains = <&scpsys MT2701_POWER_DOMAIN_ETH>;
+	};
-- 
1.9.1
