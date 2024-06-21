Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842BC53365;
	Fri, 21 Jun 2024 01:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718933119; cv=none; b=EH5RHI0CvBCnWvs+J4aEfUGH5qnslCDi71DInmBoF7vsk1ZvW+OcwGMWfj8tqJq0uy6f8Pvct9BTyU8nIxiVXtUZO113VAuQFlsIjvU50pEsdpwobXwNN9U36mhfXSBIQ/qOlkFtMg5UGZgbLPCPdRkoIX8G5ryfCttpIdA1310=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718933119; c=relaxed/simple;
	bh=2gjsgVzvaQDtMCl2CkkQ6nKcY61i5W0wo1CBAn5J1Is=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OEGS2ebwgD8q5EVY1flg5KillH5uFhHI2vtAq3g/XtFBzPEl+R0LstHJltaXHC60jWjBiBdc/gV8Ja74rtIBYj829GP6Lw3+kMtBE5MLOQ+2dHByYuZ4IGafgdTAD1g2jvt/kpY/pwt6VaaqMQnA+Vsvpgrkv6zBOCQSs//obRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.97.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1sKT1U-000000004e5-2USp;
	Fri, 21 Jun 2024 01:25:04 +0000
Date: Fri, 21 Jun 2024 02:25:01 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heikomemcpy_fromio Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@debian.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Anand Moon <linux.amoon@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] dt-bindings: RNG: Add Rockchip RNG bindings
Message-ID: <10f621d0711c80137afd93f62a03b1b10009715c.1718921174.git.daniel@makrotopia.org>
References: <cover.1718921174.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1718921174.git.daniel@makrotopia.org>

From: Aurelien Jarno <aurelien@aurel32.net>

Add the RNG bindings for the RK3568 SoC from Rockchip

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 .../bindings/rng/rockchip,rk3568-rng.yaml     | 60 +++++++++++++++++++
 MAINTAINERS                                   |  6 ++
 2 files changed, 66 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml b/Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
new file mode 100644
index 000000000000..d45f03683fbe
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
@@ -0,0 +1,61 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Rockchip TRNG
+
+description: True Random Number Generator on Rokchip RK3568 SoC
+
+maintainers:
+  - Aurelien Jarno <aurelien@aurel32.net>
+  - Daniel Golle <daniel@makrotopia.org>
+
+properties:
+  compatible:
+    enum:
+      - rockchip,rk3568-rng
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: TRNG clock
+      - description: TRNG AHB clock
+
+  clock-names:
+    items:
+      - const: core
+      - const: ahb
+
+  resets:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+  - resets
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/rk3568-cru.h>
+    bus {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      rng@fe388000 {
+        compatible = "rockchip,rk3568-rng";
+        reg = <0x0 0xfe388000 0x0 0x4000>;
+        clocks = <&cru CLK_TRNG_NS>, <&cru HCLK_TRNG_NS>;
+        clock-names = "core", "ahb";
+        resets = <&cru SRST_TRNG_NS>;
+      };
+    };
+
+...
diff --git a/MAINTAINERS b/MAINTAINERS
index f45881e982d2..77d449c89bf2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19488,6 +19488,12 @@ F:	Documentation/userspace-api/media/v4l/metafmt-rkisp1.rst
 F:	drivers/media/platform/rockchip/rkisp1
 F:	include/uapi/linux/rkisp1-config.h
 
+ROCKCHIP RANDOM NUMBER GENERATOR SUPPORT
+M:	Daniel Golle <daniel@makrotopia.org>
+M:	Aurelien Jarno <aurelien@aurel32.net>
+S:	Maintained
+F:	Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
+
 ROCKCHIP RASTER 2D GRAPHIC ACCELERATION UNIT DRIVER
 M:	Jacob Chen <jacob-chen@iotwrt.com>
 M:	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
-- 
2.45.2
