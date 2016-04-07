From: Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/2] dt/bindings: Add bindings for hisilicon random number generator
Date: Thu, 7 Apr 2016 16:23:16 +0800
Message-ID: <1460017397-30996-2-git-send-email-wangkefeng.wang@huawei.com>
References: <1460017397-30996-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	<linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	<guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
To: <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
	"Rob Herring" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, <xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460017397-30996-1-git-send-email-wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Document the devicetree bindings for the random number generator found
on Hisilicon Hip04 and Hip05 soc.

Signed-off-by: Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 Documentation/devicetree/bindings/rng/hisi-rng.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/hisi-rng.txt

diff --git a/Documentation/devicetree/bindings/rng/hisi-rng.txt b/Documentation/devicetree/bindings/rng/hisi-rng.txt
new file mode 100644
index 0000000..72efcc1
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/hisi-rng.txt
@@ -0,0 +1,12 @@
+Hisilicon Random Number Generator
+
+Required properties:
+- compatible : Should be "hisilicon,rng"
+- reg : Offset and length of the register set of this block
+
+Example:
+
+rng@d1010000 {
+	compatible = "hisilicon,rng";
+	reg = <0xd1010000 0x100>;
+};
-- 
2.6.0.GIT

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
