Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972282BF971;
	Tue, 13 May 2025 18:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747161706; cv=none; b=cJuM9Wje4Fzv1df3u3G/Kld0C3FklVyxExpKaV2GOJkk010kOFD4pFDowF1BM+9fw7/h1Ot/3iNmIXNkpSiI3QV+pzb92YikkaQxKtafRl0cQ/gG1QOgsFJUQXdZrNnet+Wwy8W7P6C+r4a8yeyuJhZG461b4xryPrC8jA7ytp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747161706; c=relaxed/simple;
	bh=165JhklFv9UqTdm9IdHtEUh5vbs2TkhUrrU5t+fIIvU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YFBJJn4ELJPmF78w2sEEFVRmYmj+3uv5ZXh5KWNcuFok6sTIWbZWVpBEraZgoxUK5uB5AzdmycTtipypBpWArZlEEknVpBqos8QZUNiBfUaD1gZu/FTLn8e7KXtIjhcwnlyx9/CoCniTrgVFChxvpESb5Y/cs/CLw1RhOPOECPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pq9jS5ER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pq9jS5ER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA89AC4CEE4;
	Tue, 13 May 2025 18:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747161706;
	bh=165JhklFv9UqTdm9IdHtEUh5vbs2TkhUrrU5t+fIIvU=;
	h=From:To:Cc:Subject:Date:From;
	b=pq9jS5ERSzGCWpLkE+gKCJUb1RqPNrFG20t4ncWaVr7jxjGPP5Z2hUrOK+BCH04ov
	 Z1e7Fn34DNpb+kNHQpMG3MZXrSuXHzTtGWagsJI6BxVeufEq6YDM3eq3yqGDgz7rV2
	 fcWgupQCRtfI3Ty1LJB044IXe7eI06xKUN+94pyN9QRIJ0h8uwxpR4rd15er/+r+aG
	 NahsZOS8muKpBihvouM4yefbitpq6xLDk3i+S9lkmJcHary8/1HsImaC8Mp7GrHAKG
	 9TMVgiNksAkH3GvRP+AiTExhQderu9uTutwMorJy2MikQdj71nKJfdY/V/NfOwhLs5
	 Vizo994nmoJ3A==
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
Subject: [PATCH] dt-bindings: crypto: Convert ti,omap2-aes to DT schema
Date: Tue, 13 May 2025 13:41:41 -0500
Message-ID: <20250513184142.3053112-1-robh@kernel.org>
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

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../devicetree/bindings/crypto/omap-aes.txt   | 31 ----------
 .../bindings/crypto/ti,omap4-aes.yaml         | 59 +++++++++++++++++++
 2 files changed, 59 insertions(+), 31 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/omap-aes.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,omap4-aes.yaml

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
diff --git a/Documentation/devicetree/bindings/crypto/ti,omap4-aes.yaml b/Documentation/devicetree/bindings/crypto/ti,omap4-aes.yaml
new file mode 100644
index 000000000000..fc7c9a714102
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/ti,omap4-aes.yaml
@@ -0,0 +1,59 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ti,omap4-aes.yaml#
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
+  - ti,hwmods
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

