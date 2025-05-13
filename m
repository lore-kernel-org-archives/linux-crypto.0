Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A912BE112;
	Tue, 13 May 2025 18:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747161655; cv=none; b=PiC5P0o4j6kHPCwNM4+4RAgk57mA2Zu8pLCw/5F1SxJoEomijYhsqw3FxR8kDt9f0QJkwZPWH7DEcg9jm5UBP+/8aLfhsS11xj90ZPkFPt04cHTx09TKFrrQz0so4DcaPiFFoxIMaTHbbyjkKNdgLoZ1X3bZvJbfhV0xoId4VPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747161655; c=relaxed/simple;
	bh=CSxkHxtvf4bYVU+fLSgMiZJYTokFhZtPbi+1wA+zwjU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XlalHmZx8nupTg3MopprWaizhuAspr3ab7OIObNaj/MIC2EAIiP9veq0hBYuvc373EG6A59dM1fRCh67ImI6GXNUU9aVzLx0fW7ckZFvpmDRZcwstWCqBzRo1X4TcElYaNfU+5J+PRXHgES6BgB5fN0geF1BJAaY3Yi2L4z4g18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CuIn+iTz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CuIn+iTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26716C4CEEF;
	Tue, 13 May 2025 18:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747161654;
	bh=CSxkHxtvf4bYVU+fLSgMiZJYTokFhZtPbi+1wA+zwjU=;
	h=From:To:Cc:Subject:Date:From;
	b=CuIn+iTzBb6WjGeKGyGTW/Zig6waVxrbOARl1iA7/rBaZ1i4QhuJbPMT+diTPR2h5
	 GNM8WcKDnDYLK1mehq317Kh3I87fr3gy3ElPZW3gEH4/3o1onTZkW63hF7M5GT/1/K
	 k9z/aOZwsxfYS+KaTNol5zvP6q7yGvWzQyCv6/yKqOA5pivPrCD2QgVAgn0toTE0r8
	 jrARz2HcYYc4+3Z/jDyp2xK+n5hw56rYs6eAVp9W+RfhIZoJH2l7oqPmhUouk79pUc
	 yU0T5xxfgeCUZI2lhEutcyAtHlJMR3k5yuCQXxrW2q/59nIbP2TmwNWkNzJlO4Cuqt
	 3O0K/KqFbsLEw==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: crypto: Convert amd,ccp-seattle-v1a to DT schema
Date: Tue, 13 May 2025 13:40:50 -0500
Message-ID: <20250513184051.3051660-1-robh@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the AMD Cryptographic Coprocessor binding to DT schema format.
It's a straight forward conversion.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/amd,ccp-seattle-v1a.yaml  | 38 +++++++++++++++++++
 .../devicetree/bindings/crypto/amd-ccp.txt    | 17 ---------
 2 files changed, 38 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/amd,ccp-seattle-v1a.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/amd-ccp.txt

diff --git a/Documentation/devicetree/bindings/crypto/amd,ccp-seattle-v1a.yaml b/Documentation/devicetree/bindings/crypto/amd,ccp-seattle-v1a.yaml
new file mode 100644
index 000000000000..32bf3a1c3b42
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/amd,ccp-seattle-v1a.yaml
@@ -0,0 +1,38 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/amd,ccp-seattle-v1a.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: AMD Cryptographic Coprocessor (ccp)
+
+maintainers:
+  - Tom Lendacky <thomas.lendacky@amd.com>
+
+properties:
+  compatible:
+    const: amd,ccp-seattle-v1a
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  dma-coherent: true
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
+    crypto@e0100000 {
+        compatible = "amd,ccp-seattle-v1a";
+        reg = <0xe0100000 0x10000>;
+        interrupts = <0 3 4>;
+        dma-coherent;
+    };
diff --git a/Documentation/devicetree/bindings/crypto/amd-ccp.txt b/Documentation/devicetree/bindings/crypto/amd-ccp.txt
deleted file mode 100644
index d87579d63da6..000000000000
--- a/Documentation/devicetree/bindings/crypto/amd-ccp.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-* AMD Cryptographic Coprocessor driver (ccp)
-
-Required properties:
-- compatible: Should be "amd,ccp-seattle-v1a"
-- reg: Address and length of the register set for the device
-- interrupts: Should contain the CCP interrupt
-
-Optional properties:
-- dma-coherent: Present if dma operations are coherent
-
-Example:
-	ccp@e0100000 {
-		compatible = "amd,ccp-seattle-v1a";
-		reg = <0 0xe0100000 0 0x10000>;
-		interrupt-parent = <&gic>;
-		interrupts = <0 3 4>;
-	};
-- 
2.47.2

