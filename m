Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAD4F4FB;
	Wed, 26 Jun 2024 01:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719365830; cv=none; b=GgWc5RIdYamz3melpvXQVMnPmyHo9FRrQuIgyRSYlpgdsScjrGbQQ47yW+RC9Rml08GdLSLHyZaMw2a+0Lngc4p82KstKqJc3PyQlcJPNJNF8OKqT1NwQ202z5vAhwXOIBQOUt62ZB58E+K50hhEqik9lczfkGDXymlky56rT08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719365830; c=relaxed/simple;
	bh=n6AZYHoFFVfqhN/MgUSOXC9SuO5XiqI57kP7hnQ3xwM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LAokyducm+8r00nkop7f+tUht90J8+E1AZwaYt52Nzn5HnYiVMP3ekMnzqTcrxtDLo932lRrNvL9a+YyiX10cLVayVNQPB9vQR29iwwjISgWQt8se9NH1FL9IFL6sIXrQ5sMFQicYP7ywGjGKIq3/ejKCg6fyPm3+/8OzCtywis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.97.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1sMHaY-000000005bF-1jWs;
	Wed, 26 Jun 2024 01:36:46 +0000
Date: Wed, 26 Jun 2024 02:36:42 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@debian.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Martin Kaiser <martin@kaiser.cx>, Tony Luck <tony.luck@intel.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/3] dt-bindings: rng: Add Rockchip RK3568 TRNG
Message-ID: <edcbe260f9ebe71c901cf3788ccf572cb15b9728.1719365406.git.daniel@makrotopia.org>
References: <cover.1719365405.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1719365405.git.daniel@makrotopia.org>

From: Aurelien Jarno <aurelien@aurel32.net>

Add the True Random Number Generator on the Rockchip RK3568 SoC.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 .../bindings/rng/rockchip,rk3568-rng.yaml     | 61 +++++++++++++++++++
 MAINTAINERS                                   |  6 ++
 2 files changed, 67 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml b/Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
new file mode 100644
index 000000000000..ad3648b96f82
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
@@ -0,0 +1,61 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Rockchip RK3568 TRNG
+
+description: True Random Number Generator on Rockchip RK3568 SoC
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
index 807feae089c4..aef74047de1b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19498,6 +19498,12 @@ F:	Documentation/userspace-api/media/v4l/metafmt-rkisp1.rst
 F:	drivers/media/platform/rockchip/rkisp1
 F:	include/uapi/linux/rkisp1-config.h
 
+ROCKCHIP RK3568 RANDOM NUMBER GENERATOR SUPPORT
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
