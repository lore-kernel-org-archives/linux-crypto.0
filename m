From: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/2] crypto: mediatek - update DT binding documentation
Date: Fri, 26 May 2017 17:43:09 +0800
Message-ID: <1495791789-19230-2-git-send-email-ryder.lee@mediatek.com>
References: <1495791789-19230-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1495791789-19230-1-git-send-email-ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
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

This patch removes unnecessary clock in binding file.

Signed-off-by: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 Documentation/devicetree/bindings/crypto/mediatek-crypto.txt | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt b/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
index c204725..450da36 100644
--- a/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
+++ b/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
@@ -6,8 +6,7 @@ Required properties:
 - interrupts: Should contain the five crypto engines interrupts in numeric
 	order. These are global system and four descriptor rings.
 - clocks: the clock used by the core
-- clock-names: the names of the clock listed in the clocks property. These are
-	"ethif", "cryp"
+- clock-names: Must contain "cryp".
 - power-domains: Must contain a reference to the PM domain.
 
 
@@ -20,8 +19,7 @@ Example:
 			     <GIC_SPI 84 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_SPI 91 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_SPI 97 IRQ_TYPE_LEVEL_LOW>;
-		clocks = <&topckgen CLK_TOP_ETHIF_SEL>,
-			 <&ethsys CLK_ETHSYS_CRYPTO>;
-		clock-names = "ethif","cryp";
+		clocks = <&ethsys CLK_ETHSYS_CRYPTO>;
+		clock-names = "cryp";
 		power-domains = <&scpsys MT2701_POWER_DOMAIN_ETH>;
 	};
-- 
1.9.1
