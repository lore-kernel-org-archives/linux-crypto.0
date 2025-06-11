Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1B226FD97;
	Wed, 11 Jun 2025 23:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749683455; cv=none; b=IMRAPIWRehdC6pYxbYv9RIhn0KoLhAtQKyCoBvvd9I9nEsdy+o7fJVrZ0MlU+A0O8k2S9CN/dKPpYpKm2N9VpA/3ZXZ+xWp4XGAqY0xwEifnfZg3quMykZPC96+YcKnl7WiYHZktGkkamfsO3OAUzoPG4d5y9h4ETlyulMXKwp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749683455; c=relaxed/simple;
	bh=OIY5YVjtFzYqxOGxmvGSX1Uxhgo9qPd7dxtB7RYtYSE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LbaZSLyHbzpSX7ChGi8VhtB9W82ylXL6NHMV15G7syoQDvE0feSCNw+g5dI9gbZS7ca/v5HxjKkZ1B4eqSWNt/WWk5GlNkMBzzpxm/eBnBPSwXJ0BI9qD+1hc4sH/9hr7C56LXsirk0sP6W2VLw1gYDvjENygLQuMS3pm2M/vag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XfJrw0ux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XfJrw0ux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3680AC4CEE3;
	Wed, 11 Jun 2025 23:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749683454;
	bh=OIY5YVjtFzYqxOGxmvGSX1Uxhgo9qPd7dxtB7RYtYSE=;
	h=From:To:Cc:Subject:Date:From;
	b=XfJrw0uxApuIyuxeUrqgxV/fX9I0dbo3P9FLM8QSExrPx+0k85O0mxd0JdH9r1ijX
	 ofSU4rwUnf/DfPGtX2LO7zQuGoaSO5z8YtwOOBIddxG529U/rhm9s5H5tMiIXI6/US
	 JnJFSjkLtPg4SVEnNTk8a37hvUpY+kcfBpntL/6+u9/2OPWVcRR6WDN6SOVX6kTD0A
	 KVzlLt/U3JqHJkfgMikYS/umlcIfgzL8wY4fN9EigfS6U4GRjQDjkefTiVxa4nuTPo
	 qazTUx4yo/ihHHZduEAfCKVQXl1xNBXU1GCWn/7S1QwauOTskJmd0IywN8v43c5+OS
	 vsXY8hNgOBBkg==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Andreas Kemnade <andreas@kemnade.info>,
	Kevin Hilman <khilman@baylibre.com>,
	Roger Quadros <rogerq@kernel.org>,
	Tony Lindgren <tony@atomide.com>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] dt-bindings: crypto: Convert ti,omap2-aes to DT schema
Date: Wed, 11 Jun 2025 18:10:45 -0500
Message-ID: <20250611231047.1400566-1-robh@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the TI OMAP AES binding to DT schema format. It's a straight
forward conversion.

Make "ti,hwmods" not required as it is deprecated and only used on
OMAP2.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
v2:
 - Drop ti,hwmods from required
 - Fix filename to be omap2, not omap4.
---
 .../devicetree/bindings/crypto/omap-aes.txt   | 31 ----------
 .../bindings/crypto/ti,omap2-aes.yaml         | 58 +++++++++++++++++++
 2 files changed, 58 insertions(+), 31 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/omap-aes.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,omap2-aes.yaml

diff --git a/Documentation/devicetree/bindings/crypto/omap-aes.txt b/Documentation/devicetree/bindings/crypto/omap-aes.txt
deleted file mode 100644
index fd9717653cbb..000000000000
--- a/Documentation/devicetree/bindings/crypto/omap-aes.txt
+++ /dev/null
@@ -1,31 +0,0 @@
-OMAP SoC AES crypto Module
-
-Required properties:
-
-- compatible : Should contain entries for this and backward compatible
-  AES versions:
-  - "ti,omap2-aes" for OMAP2.
-  - "ti,omap3-aes" for OMAP3.
-  - "ti,omap4-aes" for OMAP4 and AM33XX.
-  Note that the OMAP2 and 3 versions are compatible (OMAP3 supports
-  more algorithms) but they are incompatible with OMAP4.
-- ti,hwmods: Name of the hwmod associated with the AES module
-- reg : Offset and length of the register set for the module
-- interrupts : the interrupt-specifier for the AES module.
-
-Optional properties:
-- dmas: DMA specifiers for tx and rx dma. See the DMA client binding,
-	Documentation/devicetree/bindings/dma/dma.txt
-- dma-names: DMA request names should include "tx" and "rx" if present.
-
-Example:
-	/* AM335x */
-	aes: aes@53500000 {
-		compatible = "ti,omap4-aes";
-		ti,hwmods = "aes";
-		reg = <0x53500000 0xa0>;
-		interrupts = <102>;
-		dmas = <&edma 6>,
-		       <&edma 5>;
-		dma-names = "tx", "rx";
-	};
diff --git a/Documentation/devicetree/bindings/crypto/ti,omap2-aes.yaml b/Documentation/devicetree/bindings/crypto/ti,omap2-aes.yaml
new file mode 100644
index 000000000000..90e92050ad2e
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/ti,omap2-aes.yaml
@@ -0,0 +1,58 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ti,omap2-aes.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: OMAP SoC AES crypto Module
+
+maintainers:
+  - Aaro Koskinen <aaro.koskinen@iki.fi>
+  - Andreas Kemnade <andreas@kemnade.info>
+  - Kevin Hilman <khilman@baylibre.com>
+  - Roger Quadros <rogerq@kernel.org>
+  - Tony Lindgren <tony@atomide.com>
+
+properties:
+  compatible:
+    enum:
+      - ti,omap2-aes
+      - ti,omap3-aes
+      - ti,omap4-aes
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  dmas:
+    maxItems: 2
+
+  dma-names:
+    items:
+      - const: tx
+      - const: rx
+
+  ti,hwmods:
+    description: Name of the hwmod associated with the AES module
+    const: aes
+    deprecated: true
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    aes@53500000 {
+        compatible = "ti,omap4-aes";
+        reg = <0x53500000 0xa0>;
+        interrupts = <102>;
+        dmas = <&edma 6>,
+               <&edma 5>;
+        dma-names = "tx", "rx";
+    };
-- 
2.47.2

