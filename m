Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3262BF994;
	Tue, 13 May 2025 18:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747161719; cv=none; b=XmHJbbuu+WJcEiUFs2H2p1fmTyyQOOWWNW4nyHcUFkjAjFK64JgEAAq3LTcpqnUFtOaWC/Eyw45sXI1/A68zLaaRCObRmOrS4tNVZTGoYoR1tHwfuXZpZgtynuY40V/Ngb80rU44VRJgTXJP7Aq/xj5vRDI1Y4W5wGo0jiv1C4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747161719; c=relaxed/simple;
	bh=CFT91F82VT+EMpgHl6KazJBs+hD3rAz6luZG0Q16PP8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nJeqAt1F62rCn0bIucth426EWa7Ea5cI7xY0a1xfTmyp1LoSL45p2yNEh+YtW0oKD0dGwEii+OJeERPqDIZY+wK5bRVmS3WpzlKvx9JF4bqZTG3YySt7bD8uZA+wFyYoAksmK3K8qs7HKtvUP0UTdr2DtWElRSwFmRLimBAaFgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l660l9PJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l660l9PJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D05EC4CEE4;
	Tue, 13 May 2025 18:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747161717;
	bh=CFT91F82VT+EMpgHl6KazJBs+hD3rAz6luZG0Q16PP8=;
	h=From:To:Cc:Subject:Date:From;
	b=l660l9PJO7esFL7D5tNaC7iNaaXBMciO+GnJc8rjnmeu/I8AbcVhIe4cf3JslO6Yk
	 GVbZJdKyHYqsKeZVsbSoe+nOPwZikJ67SQGFURnWHOdHKdlOqEDS+0CFZS1O+x/9Pb
	 99SiSwZesEBkHcNfyQNXsygCsaqkiXrqR8NeBPZoKbsv1SXeWsac/C7nGFjIev8kbR
	 TJHIfiqmD3VvtEsFVvR4LY8ymuvxnT4kOlaxkZgWy56pFrgsMvP8DJVu1V7G+VjcPz
	 j7W+y7dyDH/YorbSnp/hmr/DBt003JN8ppwLhBnYl4m3wVaALol3CrtFeCL1ReBm7Y
	 dLzvcpvkv0zlg==
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
Subject: [PATCH] dt-bindings: crypto: Convert ti,omap4-des to DT schema
Date: Tue, 13 May 2025 13:41:47 -0500
Message-ID: <20250513184148.3053317-1-robh@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the TI OMAP DES binding to DT schema format.

Drop "ti,hwmods" as it is not actually used for this binding. Only
OMAP2 platforms are using it.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../devicetree/bindings/crypto/omap-des.txt   | 30 ---------
 .../bindings/crypto/ti,omap4-des.yaml         | 66 +++++++++++++++++++
 2 files changed, 66 insertions(+), 30 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/omap-des.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,omap4-des.yaml

diff --git a/Documentation/devicetree/bindings/crypto/omap-des.txt b/Documentation/devicetree/bindings/crypto/omap-des.txt
deleted file mode 100644
index e8c63bf2e16d..000000000000
--- a/Documentation/devicetree/bindings/crypto/omap-des.txt
+++ /dev/null
@@ -1,30 +0,0 @@
-OMAP SoC DES crypto Module
-
-Required properties:
-
-- compatible : Should contain "ti,omap4-des"
-- ti,hwmods: Name of the hwmod associated with the DES module
-- reg : Offset and length of the register set for the module
-- interrupts : the interrupt-specifier for the DES module
-- clocks : A phandle to the functional clock node of the DES module
-           corresponding to each entry in clock-names
-- clock-names : Name of the functional clock, should be "fck"
-
-Optional properties:
-- dmas: DMA specifiers for tx and rx dma. See the DMA client binding,
-	Documentation/devicetree/bindings/dma/dma.txt
-	Each entry corresponds to an entry in dma-names
-- dma-names: DMA request names should include "tx" and "rx" if present
-
-Example:
-	/* DRA7xx SoC */
-	des: des@480a5000 {
-		compatible = "ti,omap4-des";
-		ti,hwmods = "des";
-		reg = <0x480a5000 0xa0>;
-		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
-		dmas = <&sdma 117>, <&sdma 116>;
-		dma-names = "tx", "rx";
-		clocks = <&l3_iclk_div>;
-		clock-names = "fck";
-	};
diff --git a/Documentation/devicetree/bindings/crypto/ti,omap4-des.yaml b/Documentation/devicetree/bindings/crypto/ti,omap4-des.yaml
new file mode 100644
index 000000000000..11a028cf8902
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/ti,omap4-des.yaml
@@ -0,0 +1,66 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ti,omap4-des.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: OMAP4 DES crypto Module
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
+    const: ti,omap4-des
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
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: fck
+
+dependencies:
+  dmas: [ dma-names ]
+
+required:
+  - compatible
+  - ti,hwmods
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    des@480a5000 {
+        compatible = "ti,omap4-des";
+        reg = <0x480a5000 0xa0>;
+        interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&l3_iclk_div>;
+        clock-names = "fck";
+        dmas = <&sdma 117>, <&sdma 116>;
+        dma-names = "tx", "rx";
+    };
-- 
2.47.2

