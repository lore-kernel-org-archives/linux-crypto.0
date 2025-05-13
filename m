Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942EC2BF3DF;
	Tue, 13 May 2025 18:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747161660; cv=none; b=m3B6xknBbHvaVb0lu78U/cD2glcU9GR0KWrUrcmor3s7nqARPS+nYlh2JrR66pzDxQasXBSgMwe7JYhAaqQmU0DkZ0R7E9kEzr6v0GW8nFJzMfZzWXY7Ty5MNaxAYjsv/73jZafzm9uDvrgBCq+ma/y6X4XuORg2adNVwdO2wuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747161660; c=relaxed/simple;
	bh=UjbOxESnG6tf03x1OO+100wXYdQSBKoDKQOKqD7ypas=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bTrMFLeTI66eQYJg+5Z3+7p1sBVt9UWxAQtgcBa0TEUDEicP3U3V3dKPNkYH7juGFTope7kr5VJe1PbJ6gcNfsLjJD+NDe1uPu9mq2BdQ4OLZsR6+yzz6ziOqv+6BG0kXNpsPfPEA7y7k0wjP84uO2iqrLngTSDnqUqBnVBgyQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2HGve1k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2HGve1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54ACC4CEE4;
	Tue, 13 May 2025 18:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747161660;
	bh=UjbOxESnG6tf03x1OO+100wXYdQSBKoDKQOKqD7ypas=;
	h=From:To:Cc:Subject:Date:From;
	b=l2HGve1kTkXeUh7COs1K4h0uasm5ahzvWCfoE5aADQNL/0IilEUY3OZUR1KS1ShN7
	 AajntNOk2mQxNhscGUqJdZp12zDBJIKKUsM066TSx7G+m0c7I84om2MCYL7kJozS+0
	 0PIjjjgS9H/8z7svA2B/xCXXuqgvdCgn2g1lfWmf4hK3EWJFk1aCX43A7hItNCm2Zn
	 kMMyYZPSpSh2e+QU8LR8sapQiUrfWJDfJHMrSvy8Zvmc38xEKGs4mbtkAhmAXAd1p8
	 acmd5ngHwdTgGNixLwKQWggb5+BCAHvs5eRON1HIK1Rvb1Pj2Z5qWa7v2Yd9nkzWJE
	 IUt2J+6QlMyRA==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Lars Persson <lars.persson@axis.com>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: crypto: Convert axis,artpec6-crypto to DT schema
Date: Tue, 13 May 2025 13:40:56 -0500
Message-ID: <20250513184057.3051854-1-robh@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the Axis Crypto engine binding to DT schema format. It's a
straight forward conversion.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/artpec6-crypto.txt        | 16 --------
 .../bindings/crypto/axis,artpec6-crypto.yaml  | 39 +++++++++++++++++++
 2 files changed, 39 insertions(+), 16 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/artpec6-crypto.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/axis,artpec6-crypto.yaml

diff --git a/Documentation/devicetree/bindings/crypto/artpec6-crypto.txt b/Documentation/devicetree/bindings/crypto/artpec6-crypto.txt
deleted file mode 100644
index d9cca4875bd6..000000000000
--- a/Documentation/devicetree/bindings/crypto/artpec6-crypto.txt
+++ /dev/null
@@ -1,16 +0,0 @@
-Axis crypto engine with PDMA interface.
-
-Required properties:
-- compatible : Should be one of the following strings:
-	"axis,artpec6-crypto" for the version in the Axis ARTPEC-6 SoC
-	"axis,artpec7-crypto" for the version in the Axis ARTPEC-7 SoC.
-- reg: Base address and size for the PDMA register area.
-- interrupts: Interrupt handle for the PDMA interrupt line.
-
-Example:
-
-crypto@f4264000 {
-	compatible = "axis,artpec6-crypto";
-	reg = <0xf4264000 0x1000>;
-	interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
-};
diff --git a/Documentation/devicetree/bindings/crypto/axis,artpec6-crypto.yaml b/Documentation/devicetree/bindings/crypto/axis,artpec6-crypto.yaml
new file mode 100644
index 000000000000..c91f81e3c39e
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/axis,artpec6-crypto.yaml
@@ -0,0 +1,39 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/axis,artpec6-crypto.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Axis ARTPEC6 crypto engine with PDMA interface
+
+maintainers:
+  - Lars Persson <lars.persson@axis.com>
+
+properties:
+  compatible:
+    enum:
+      - axis,artpec6-crypto
+      - axis,artpec7-crypto
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
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
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    crypto@f4264000 {
+        compatible = "axis,artpec6-crypto";
+        reg = <0xf4264000 0x1000>;
+        interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
+    };
-- 
2.47.2

