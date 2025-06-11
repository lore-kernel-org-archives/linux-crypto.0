Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8A326FD97;
	Wed, 11 Jun 2025 23:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749683462; cv=none; b=f80ebQundTOXeVNbbbqVMj1G/8i/AEEwU80snyYh6nNIodAq7aTeJOInpbRRwK/pur2dpHP4FYBWkTsDCQ0JKU5mbwLDp7YKHOymP71+XMGaEU2usxDGiJhxmExpfXe5EL70vmsesqzMpIYjDggNn/PpmDPsXW5gFM/xp4diZog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749683462; c=relaxed/simple;
	bh=PPOQ2Yu36v3jhlsfz9cZWbbLLvrpvc/LawIo3AJ6cPo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mjOHbzypbfmxI7Qh5090TS4NvpQ1hTfFRw2WWFGccjTZbti5QgmBs7izVhPaDq7doRvEGRFPx+BtwfzBk6fCG+s4D2TOxBAjAHQkUf2kYdJd+jtCMRS+fYmgtWtzoI0FPjl7Hn9sXrJWnusvzda+h1DSd1H4PmtCSR/qvob5Ljs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gE1zqRQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gE1zqRQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA65C4CEE3;
	Wed, 11 Jun 2025 23:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749683462;
	bh=PPOQ2Yu36v3jhlsfz9cZWbbLLvrpvc/LawIo3AJ6cPo=;
	h=From:To:Cc:Subject:Date:From;
	b=gE1zqRQqOa7N6l9dV/03MJkX+Cl5osC9V+hLyghQpUvn4YMbAa77sdL9LxW/UlCpo
	 HO8Qy+YW9CcB19sviPM5uxKd13cl0bFYDzphLxKg/KTl/9/65iRn85ZAd7Izj2xU9t
	 Vufa0ogXbaKWtm9Rmga79EKTPD+ORw8WFZgC9zeaf6yicJxLJ2v9dpYCoplKatNE1g
	 e0KqL3lXaBN6j5beWA0q1ABWzgsDGiAF8Zqnmsf1bX6XnTLYecoCBC8AxMrGnlknWt
	 VATEx/SErN+NmTHE9cHPJN6HRl5o0WmX7f/yxGJkUWQeXibzk+FW1JPoEqHfR3fww8
	 V0d1YmT++gP9A==
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
Subject: [PATCH v2] dt-bindings: crypto: Convert ti,omap4-des to DT schema
Date: Wed, 11 Jun 2025 18:10:56 -0500
Message-ID: <20250611231058.1402457-1-robh@kernel.org>
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
v2:
 - Drop ti,hwmods from required too
---
 .../devicetree/bindings/crypto/omap-des.txt   | 30 ---------
 .../bindings/crypto/ti,omap4-des.yaml         | 65 +++++++++++++++++++
 2 files changed, 65 insertions(+), 30 deletions(-)
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
index 000000000000..f02f1e141218
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/ti,omap4-des.yaml
@@ -0,0 +1,65 @@
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

