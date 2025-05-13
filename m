Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427662BFC70;
	Tue, 13 May 2025 18:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747161691; cv=none; b=nbU+YDyZ5yy+b/0XlY+foFoTwC1KzxPtZlcJeWnZXH+BycVcZD0XzpM3weP2ch1UFeYqvpsjC8YF68shLsFfnxvqEpnSoZUHkc758rD3gFymn41yxBZwgOBrt1VkWEhXriqczGfQToqmmYjcMtOgi5L1H66j+ZqT9fw9wDt1CJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747161691; c=relaxed/simple;
	bh=mWjwPQab+dhArRDh85eKqU9teR4QKZ9UsfsO+NWBxcM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pRHrQGRxUTpngEUkhYJD2juTod5DBIqIygthjqshz0v/XnLv6LsxTo2gppfYQ18sCOngCymzGyvbsqUdO99gnIFGluZAILSNGvJYD77CGgNHYEOs/ongFCdzKc0dtfu6z2BKcfTJCkwJ6+W9KXgXGeFCQtDKB2a5vykup3Y1drg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTChnBqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTChnBqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11C3C4CEE4;
	Tue, 13 May 2025 18:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747161691;
	bh=mWjwPQab+dhArRDh85eKqU9teR4QKZ9UsfsO+NWBxcM=;
	h=From:To:Cc:Subject:Date:From;
	b=gTChnBqNVXEFLI39T8laz/+fcOAjaVQ87bhPL0cxQ76a+YZVpkGpkfSZC4uWrjYOA
	 HVC8oSH3ZtpayTU/iTg3UqKHdlatXU9pqEVOCnmNVYUo4Ot0eIOBrmHS2qr0hmhJHt
	 Ze+Jt7KpxRw0w/4Z1n3hhs9rj0+ONMD1YBd7+PvCbk0OUnMxIJSSy9innG+3Z9AxG+
	 /kdgWc/5uZc6Drnk5X/li5FiXSXDoO2t1n0IAfx9zaoMKMZ6FDoT7+rtElCsrjTPe5
	 oOV8eX8Tlhjd0443W9pn0qOv/VvzYiFkMzhhPtfT/EiKjMIm2kxcDQV0dV7VsaQrKH
	 kfgL/k5rYr6Sg==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Boris Brezillon <bbrezillon@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: crypto: Convert Marvell CESA to DT schema
Date: Tue, 13 May 2025 13:41:23 -0500
Message-ID: <20250513184125.3052705-1-robh@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the Marvell CESA binding to DT schema format. The
marvell-cesa.txt and mv_cesa.txt are duplicate bindings.

The clock properties are quite varied for each platform hence the
if/then schemas. The old binding was fairly accurate with reality.

The original binding didn't mention there is 1 interrupt per CESA
engine. Based on users, there's a maximum of 2 engines.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/marvell,orion-crypto.yaml | 133 ++++++++++++++++++
 .../bindings/crypto/marvell-cesa.txt          |  44 ------
 .../devicetree/bindings/crypto/mv_cesa.txt    |  32 -----
 3 files changed, 133 insertions(+), 76 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/marvell,orion-crypto.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/marvell-cesa.txt
 delete mode 100644 Documentation/devicetree/bindings/crypto/mv_cesa.txt

diff --git a/Documentation/devicetree/bindings/crypto/marvell,orion-crypto.yaml b/Documentation/devicetree/bindings/crypto/marvell,orion-crypto.yaml
new file mode 100644
index 000000000000..b44d36c50ec4
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/marvell,orion-crypto.yaml
@@ -0,0 +1,133 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/marvell,orion-crypto.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Marvell Cryptographic Engines And Security Accelerator
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Boris Brezillon <bbrezillon@kernel.org>
+
+description: |
+  Marvell Cryptographic Engines And Security Accelerator
+
+properties:
+  compatible:
+    enum:
+      - marvell,armada-370-crypto
+      - marvell,armada-xp-crypto
+      - marvell,armada-375-crypto
+      - marvell,armada-38x-crypto
+      - marvell,dove-crypto
+      - marvell,kirkwood-crypto
+      - marvell,orion-crypto
+
+  reg:
+    minItems: 1
+    items:
+      - description: Registers region
+      - description: SRAM region
+        deprecated: true
+
+  reg-names:
+    minItems: 1
+    items:
+      - const: regs
+      - const: sram
+        deprecated: true
+
+  interrupts:
+    description: One interrupt for each CESA engine
+    minItems: 1
+    maxItems: 2
+
+  clocks:
+    description: One or two clocks for each CESA engine
+    minItems: 1
+    maxItems: 4
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: cesa0
+      - const: cesa1
+      - const: cesaz0
+      - const: cesaz1
+
+  marvell,crypto-srams:
+    description: Phandle(s) to crypto SRAM.
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    minItems: 1
+    maxItems: 2
+    items:
+      maxItems: 1
+
+  marvell,crypto-sram-size:
+    description: SRAM size reserved for crypto operations.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 0x800
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - interrupts
+  - marvell,crypto-srams
+
+allOf:
+  - if:
+      not:
+        properties:
+          compatible:
+            enum:
+              - marvell,kirkwood-crypto
+              - marvell,orion-crypto
+    then:
+      required:
+        - clocks
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - marvell,armada-370-crypto
+              - marvell,armada-375-crypto
+              - marvell,armada-38x-crypto
+              - marvell,armada-xp-crypto
+    then:
+      required:
+        - clock-names
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - marvell,armada-375-crypto
+              - marvell,armada-38x-crypto
+    then:
+      properties:
+        clocks:
+          minItems: 4
+        clock-names:
+          minItems: 4
+    else:
+      properties:
+        clocks:
+          maxItems: 2
+        clock-names:
+          maxItems: 2
+
+additionalProperties: false
+
+examples:
+  - |
+    crypto@30000 {
+        compatible = "marvell,orion-crypto";
+        reg = <0x30000 0x10000>;
+        reg-names = "regs";
+        interrupts = <22>;
+        marvell,crypto-srams = <&crypto_sram>;
+        marvell,crypto-sram-size = <0x600>;
+    };
diff --git a/Documentation/devicetree/bindings/crypto/marvell-cesa.txt b/Documentation/devicetree/bindings/crypto/marvell-cesa.txt
deleted file mode 100644
index 28d3f2496b89..000000000000
--- a/Documentation/devicetree/bindings/crypto/marvell-cesa.txt
+++ /dev/null
@@ -1,44 +0,0 @@
-Marvell Cryptographic Engines And Security Accelerator
-
-Required properties:
-- compatible: should be one of the following string
-	      "marvell,orion-crypto"
-	      "marvell,kirkwood-crypto"
-	      "marvell,dove-crypto"
-	      "marvell,armada-370-crypto"
-	      "marvell,armada-xp-crypto"
-	      "marvell,armada-375-crypto"
-	      "marvell,armada-38x-crypto"
-- reg: base physical address of the engine and length of memory mapped
-       region. Can also contain an entry for the SRAM attached to the CESA,
-       but this representation is deprecated and marvell,crypto-srams should
-       be used instead
-- reg-names: "regs". Can contain an "sram" entry, but this representation
-	     is deprecated and marvell,crypto-srams should be used instead
-- interrupts: interrupt number
-- clocks: reference to the crypto engines clocks. This property is not
-	  required for orion and kirkwood platforms
-- clock-names: "cesaX" and "cesazX", X should be replaced by the crypto engine
-	       id.
-	       This property is not required for the orion and kirkwoord
-	       platforms.
-	       "cesazX" clocks are not required on armada-370 platforms
-- marvell,crypto-srams: phandle to crypto SRAM definitions
-
-Optional properties:
-- marvell,crypto-sram-size: SRAM size reserved for crypto operations, if not
-			    specified the whole SRAM is used (2KB)
-
-
-Examples:
-
-	crypto@90000 {
-		compatible = "marvell,armada-xp-crypto";
-		reg = <0x90000 0x10000>;
-		reg-names = "regs";
-		interrupts = <48>, <49>;
-		clocks = <&gateclk 23>, <&gateclk 23>;
-		clock-names = "cesa0", "cesa1";
-		marvell,crypto-srams = <&crypto_sram0>, <&crypto_sram1>;
-		marvell,crypto-sram-size = <0x600>;
-	};
diff --git a/Documentation/devicetree/bindings/crypto/mv_cesa.txt b/Documentation/devicetree/bindings/crypto/mv_cesa.txt
deleted file mode 100644
index d9b92e2f3138..000000000000
--- a/Documentation/devicetree/bindings/crypto/mv_cesa.txt
+++ /dev/null
@@ -1,32 +0,0 @@
-Marvell Cryptographic Engines And Security Accelerator
-
-Required properties:
-- compatible: should be one of the following string
-	      "marvell,orion-crypto"
-	      "marvell,kirkwood-crypto"
-	      "marvell,dove-crypto"
-- reg: base physical address of the engine and length of memory mapped
-       region. Can also contain an entry for the SRAM attached to the CESA,
-       but this representation is deprecated and marvell,crypto-srams should
-       be used instead
-- reg-names: "regs". Can contain an "sram" entry, but this representation
-	     is deprecated and marvell,crypto-srams should be used instead
-- interrupts: interrupt number
-- clocks: reference to the crypto engines clocks. This property is only
-	  required for Dove platforms
-- marvell,crypto-srams: phandle to crypto SRAM definitions
-
-Optional properties:
-- marvell,crypto-sram-size: SRAM size reserved for crypto operations, if not
-			    specified the whole SRAM is used (2KB)
-
-Examples:
-
-	crypto@30000 {
-		compatible = "marvell,orion-crypto";
-		reg = <0x30000 0x10000>;
-		reg-names = "regs";
-		interrupts = <22>;
-		marvell,crypto-srams = <&crypto_sram>;
-		marvell,crypto-sram-size = <0x600>;
-	};
-- 
2.47.2

