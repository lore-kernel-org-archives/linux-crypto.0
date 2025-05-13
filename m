Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1B92BF976;
	Tue, 13 May 2025 18:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747161683; cv=none; b=EpPJuAnXSTAUKzrm4hdQZkPGUVVGEl5bB40ZnMtdKVAytG2xtpUoAgDTZXFywbe64Owon8SJf/wfYb5naZ8Vmi3etryBj1IDzxBeeJzAD0ej/rnFBnlUCQOLIFWjPQnjXrok+GrkbrOPX2PSSqUwxC6hfLNpRLarzfpdcdaYuNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747161683; c=relaxed/simple;
	bh=ZxjeGbjASaZfwtnXHdzTOFRIZEfBHZ1cfd7hEC2kbJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WMYT6BhxIW0Qr0+RmKz7eQmGqFP7mlTUPlhca0bV5MD3fv4nxnD6tuEGmhHmTpSSeFKDKUIgiOBWnEZeOLHuQ68SrU4ntOvuYx0d4QXwogEFwezSC/8jDydcLjY/GQfvGocPoYS1Xj/aKKzKtfpYBpnLWiURt8GivvdxnqBW1B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UNBFJm5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UNBFJm5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBFFC4CEE4;
	Tue, 13 May 2025 18:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747161682;
	bh=ZxjeGbjASaZfwtnXHdzTOFRIZEfBHZ1cfd7hEC2kbJ0=;
	h=From:To:Cc:Subject:Date:From;
	b=UNBFJm5nqmt05xCjSV/rOPZTe+s80ja5SgI3SpUiF26rUdfFsK7YInWc9meQp9mau
	 toNTcyq+loIyz9nGUuiYq4npGQ3zmr/hiPSKqrt1OwJ5LikI8DER+isXmFcZbA+JCi
	 lySuSJcxbgZClw3yzQ1PDiOQYqRzZhmzOAlmxJECgAHEkwFyPk6A0k0Hz45iB6d4ox
	 Td1G8OcRSSSsAttCamCCAbynXShYiz+l7Sy8ESybPJEZQfyNRgZOQlD6HiCxN0Cbq6
	 3rHj1N4i1XhtqlDXU/4vkpUNk3I9IBLPV7xuWmIu5Jf/hPQdMCRMi6COoV86sWTfnt
	 LiUltenw/NcyQ==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	James Hartley <james.hartley@imgtec.com>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: crypto: Convert img,hash-accelerator to DT schema
Date: Tue, 13 May 2025 13:41:16 -0500
Message-ID: <20250513184118.3052496-1-robh@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the Imagination Technologies hardware hash accelerator binding
to DT schema format. It's a straight forward conversion.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/img,hash-accelerator.yaml | 69 +++++++++++++++++++
 .../devicetree/bindings/crypto/img-hash.txt   | 27 --------
 2 files changed, 69 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/img,hash-accelerator.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/img-hash.txt

diff --git a/Documentation/devicetree/bindings/crypto/img,hash-accelerator.yaml b/Documentation/devicetree/bindings/crypto/img,hash-accelerator.yaml
new file mode 100644
index 000000000000..46617561ef94
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/img,hash-accelerator.yaml
@@ -0,0 +1,69 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/img,hash-accelerator.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Imagination Technologies hardware hash accelerator
+
+maintainers:
+  - James Hartley <james.hartley@imgtec.com>
+
+description:
+  The hash accelerator provides hardware hashing acceleration for
+  SHA1, SHA224, SHA256 and MD5 hashes.
+
+properties:
+  compatible:
+    const: img,hash-accelerator
+
+  reg:
+    items:
+      - description: Register base address and size
+      - description: DMA port specifier
+
+  interrupts:
+    maxItems: 1
+
+  dmas:
+    maxItems: 1
+
+  dma-names:
+    items:
+      - const: tx
+
+  clocks:
+    items:
+      - description: System clock for hash block registers
+      - description: Hash clock for data path
+
+  clock-names:
+    items:
+      - const: sys
+      - const: hash
+
+additionalProperties: false
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - dmas
+  - dma-names
+  - clocks
+  - clock-names
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/mips-gic.h>
+    #include <dt-bindings/clock/pistachio-clk.h>
+
+    hash@18149600 {
+        compatible = "img,hash-accelerator";
+        reg = <0x18149600 0x100>, <0x18101100 0x4>;
+        interrupts = <GIC_SHARED 59 IRQ_TYPE_LEVEL_HIGH>;
+        dmas = <&dma 8 0xffffffff 0>;
+        dma-names = "tx";
+        clocks = <&cr_periph SYS_CLK_HASH>, <&clk_periph PERIPH_CLK_ROM>;
+        clock-names = "sys", "hash";
+    };
diff --git a/Documentation/devicetree/bindings/crypto/img-hash.txt b/Documentation/devicetree/bindings/crypto/img-hash.txt
deleted file mode 100644
index 91a3d757d641..000000000000
--- a/Documentation/devicetree/bindings/crypto/img-hash.txt
+++ /dev/null
@@ -1,27 +0,0 @@
-Imagination Technologies hardware hash accelerator
-
-The hash accelerator provides hardware hashing acceleration for
-SHA1, SHA224, SHA256 and MD5 hashes
-
-Required properties:
-
-- compatible : "img,hash-accelerator"
-- reg : Offset and length of the register set for the module, and the DMA port
-- interrupts : The designated IRQ line for the hashing module.
-- dmas : DMA specifier as per Documentation/devicetree/bindings/dma/dma.txt
-- dma-names : Should be "tx"
-- clocks : Clock specifiers
-- clock-names : "sys" Used to clock the hash block registers
-		"hash" Used to clock data through the accelerator
-
-Example:
-
-	hash: hash@18149600 {
-	compatible = "img,hash-accelerator";
-		reg = <0x18149600 0x100>, <0x18101100 0x4>;
-		interrupts = <GIC_SHARED 59 IRQ_TYPE_LEVEL_HIGH>;
-		dmas = <&dma 8 0xffffffff 0>;
-		dma-names = "tx";
-		clocks = <&cr_periph SYS_CLK_HASH>, <&clk_periph PERIPH_CLK_ROM>;
-		clock-names = "sys", "hash";
-	};
-- 
2.47.2

