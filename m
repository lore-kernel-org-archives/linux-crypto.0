Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2CA2135AC;
	Tue,  4 Feb 2025 15:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738683435; cv=pass; b=a/MMAthTldDxZBJluAiey/FVUnsC8pxqM8uwGdU8vwbFkgFQDp/5fMJwX3LNl2V6x87UUQkKPAW/EyPrwFhQ36RCpwn9iYJpDtZk7uc4lmGkqR5wtIfBrIkKDSNAMrH4Rdhdt0HMfj3WxEid+xHdoh/v7s2z6dOcpIm30Y1NQpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738683435; c=relaxed/simple;
	bh=GOGm11sRPOYDq+rSF7CW2hn9yV9YO1okPmKvtWYw2dk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Iom8VcBZ0XFqwW3ThoFrElbXQOhRVcQxljiCMHQtEHXRs5ZUOV2I2Z9EtejsRAQGmS/dunA4iomnw/2n9ub7P41nuBXcWq1Lvrd7D7jo599I3kxfJBLa/tTQWx8AgYJ7npgcODA8V7805twxZf7wP476yr1QEtD1Cm0d8gBP4qg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=J9/2K7qS; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="J9/2K7qS"
ARC-Seal: i=1; a=rsa-sha256; t=1738683394; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=FCCrn7rt/hyApxgVhrNFa9vlIKjS2pVstKkmdUoHTG3MQuaeO0dKSeFVCiXXEEFRqgSHro6N6m77k8q047auNUFdoLigifwV/TX+8Pyi+WmKVQniUPjzBeBBO6WvRa57xVeLYCUJi+UD80NNFgxqzaRfkA+guCzcKOcGGXLcvV8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1738683394; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=IQ88Lc7jy4KrjXd7lzXYnMLf0r8HvwMftDwOg1D5Sc8=; 
	b=McYRL0Wb2ksa3hzGfI9STseBRBFl5ZLzKszc2vN0lZfDZHcIQaAxm1V4i12IsjC8DVyiSf7RqsoH5ArHoqQ0VBQ2B2CJ1KLEhL90p3u4fi3YFGmKF7378AcvFuJr0LMjFOisfwjBB5mTTHXcbt3Tvop0ndKf81mRHWXlEzfb5Yc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1738683394;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=IQ88Lc7jy4KrjXd7lzXYnMLf0r8HvwMftDwOg1D5Sc8=;
	b=J9/2K7qSFzylb8HTaoHJelwnKdVvVIj8kUj+wZaqA+RxGgI/TTMVjpa1kKGdKJ7r
	4UG2lDx58G4Q2txiR5U0815V+U3nSkm6GrWVWtYEhnPfKnUcFdHMjkkGjz1Xt9LV4Jx
	79xKM0eMYGF6RpiyLwJCPw/fHR/4Fz7c5ozsTe/I=
Received: by mx.zohomail.com with SMTPS id 1738683391897570.4999954323046;
	Tue, 4 Feb 2025 07:36:31 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Tue, 04 Feb 2025 16:35:47 +0100
Subject: [PATCH v2 2/7] dt-bindings: rng: add binding for Rockchip RK3588
 RNG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250204-rk3588-trng-submission-v2-2-608172b6fd91@collabora.com>
References: <20250204-rk3588-trng-submission-v2-0-608172b6fd91@collabora.com>
In-Reply-To: <20250204-rk3588-trng-submission-v2-0-608172b6fd91@collabora.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>, 
 kernel@collabora.com, devicetree@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.2

The Rockchip RK3588 SoC has two hardware RNGs accessible to the
non-secure world: an RNG in the Crypto IP, and a standalone RNG that is
new to this SoC.

Add a binding for this new standalone RNG. It is distinct hardware from
the existing rockchip,rk3568-rng, and therefore gets its own binding as
the two hardware IPs are unrelated other than both being made by the
same vendor.

The RNG is capable of firing an interrupt when entropy is ready.

The reset is optional, as the hardware does a power-on reset, and
functions without the software manually resetting it.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 .../bindings/rng/rockchip,rk3588-rng.yaml          | 60 ++++++++++++++++++++++
 MAINTAINERS                                        |  1 +
 2 files changed, 61 insertions(+)

diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
new file mode 100644
index 0000000000000000000000000000000000000000..757967212f553eebce12a896d78bbeeb8c6fc0ec
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
@@ -0,0 +1,60 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/rockchip,rk3588-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Rockchip RK3588 TRNG
+
+description: True Random Number Generator on Rockchip RK3588 SoC
+
+maintainers:
+  - Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
+
+properties:
+  compatible:
+    enum:
+      - rockchip,rk3588-rng
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: TRNG AHB clock
+
+  interrupts:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/rockchip,rk3588-cru.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/reset/rockchip,rk3588-cru.h>
+    bus {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      rng@fe378000 {
+        compatible = "rockchip,rk3588-rng";
+        reg = <0x0 0xfe378000 0x0 0x200>;
+        interrupts = <GIC_SPI 400 IRQ_TYPE_LEVEL_HIGH 0>;
+        clocks = <&scmi_clk SCMI_HCLK_SECURE_NS>;
+        resets = <&scmi_reset SCMI_SRST_H_TRNG_NS>;
+        status = "okay";
+      };
+    };
+
+...
diff --git a/MAINTAINERS b/MAINTAINERS
index bc8ce7af3303f747e0ef028e5a7b29b0bbba99f4..256d0217196586d179197393e46a1e78da850712 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20422,6 +20422,7 @@ M:	Daniel Golle <daniel@makrotopia.org>
 M:	Aurelien Jarno <aurelien@aurel32.net>
 S:	Maintained
 F:	Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
+F:	Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
 F:	drivers/char/hw_random/rockchip-rng.c
 
 ROCKCHIP RASTER 2D GRAPHIC ACCELERATION UNIT DRIVER

-- 
2.48.1

