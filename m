Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532B82BF99E;
	Tue, 13 May 2025 18:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747161676; cv=none; b=UxqfQFTGhQFp3Yopy1kVPu7vaQiJ06IiET8Zm6p8M/1xwAjPYSTgbwQWyC1M3mf1NZOtHZWLnGy+fKGze/sGc6/dm87U21cNEMX84rf4glkaOWUmdgXVWkib188kfc02boGgMbZcQnvL1Th4iRL/qO5uPUMax6nRfgYBltD5mXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747161676; c=relaxed/simple;
	bh=fwLdh4lh2c6wtLPAbIew5p1xVy3GijcP3Tc2MCzNs1I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FEPkehEBZwMpMguklkVVM1wDMBLgj2tyPWfvx0OGnpu1vtiCxrCUrJbPx32sd/lR2z2ZBvuXV8ZphggPtSV4ruELmZQKFJp0pYPWJBqnlqQQG++wgROF2HCwdTpXU8DW9WSUHGL/KzcWuyH3wQa3NV7t9alxvCJOBRPymEerxnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CaH2/HCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CaH2/HCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937CFC4CEE4;
	Tue, 13 May 2025 18:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747161674;
	bh=fwLdh4lh2c6wtLPAbIew5p1xVy3GijcP3Tc2MCzNs1I=;
	h=From:To:Cc:Subject:Date:From;
	b=CaH2/HCjKWzaYew92QlBEbX5Y8KvJJ4BEn+Wt2A49gJ1D4PYJBCiVosSt6PFP4lho
	 o1SlV9I5CP8azVeCYrhqsS+hqrLFuOCtPRH0S0lMkHouA4qSVzkDK4hEfY/o94HLp0
	 c3rwXSoA8mv6K6usZKDfBYw31eLs5G/12+jIq2slCZ4dzVvP8q6ABvaXwU1BuuJGLO
	 V05dKC20c3SjV1Ds2+q+oQf+S5O8zn/RZ6xPOcgRSeVohQjANL8imVP7P0oUO6795Y
	 MLmve4rUeImNXH2RVMmtyTpI0IqjTl7EJLnJ4XYYdmrNhBpKt8kgz+kZLDsqKXUH3w
	 pwECwpIv3vo0w==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: crypto: Convert hisilicon,hip0{6,7}-sec to DT schema
Date: Tue, 13 May 2025 13:41:10 -0500
Message-ID: <20250513184111.3052281-1-robh@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the HiSilicon HIP06/7 Security Accelerator binding to DT schema
format. It's a straight forward conversion.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/hisilicon,hip06-sec.yaml  | 134 ++++++++++++++++++
 .../bindings/crypto/hisilicon,hip07-sec.txt   |  67 ---------
 2 files changed, 134 insertions(+), 67 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt

diff --git a/Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml b/Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml
new file mode 100644
index 000000000000..2bfac9d1c020
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml
@@ -0,0 +1,134 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/hisilicon,hip06-sec.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Hisilicon hip06/hip07 Security Accelerator
+
+maintainers:
+  - Jonathan Cameron <Jonathan.Cameron@huawei.com>
+
+properties:
+  compatible:
+    enum:
+      - hisilicon,hip06-sec
+      - hisilicon,hip07-sec
+
+  reg:
+    items:
+      - description: Registers for backend processing engines
+      - description: Registers for common functionality
+      - description: Registers for queue 0
+      - description: Registers for queue 1
+      - description: Registers for queue 2
+      - description: Registers for queue 3
+      - description: Registers for queue 4
+      - description: Registers for queue 5
+      - description: Registers for queue 6
+      - description: Registers for queue 7
+      - description: Registers for queue 8
+      - description: Registers for queue 9
+      - description: Registers for queue 10
+      - description: Registers for queue 11
+      - description: Registers for queue 12
+      - description: Registers for queue 13
+      - description: Registers for queue 14
+      - description: Registers for queue 15
+
+  interrupts:
+    items:
+      - description: SEC unit error queue interrupt
+      - description: Completion interrupt for queue 0
+      - description: Error interrupt for queue 0
+      - description: Completion interrupt for queue 1
+      - description: Error interrupt for queue 1
+      - description: Completion interrupt for queue 2
+      - description: Error interrupt for queue 2
+      - description: Completion interrupt for queue 3
+      - description: Error interrupt for queue 3
+      - description: Completion interrupt for queue 4
+      - description: Error interrupt for queue 4
+      - description: Completion interrupt for queue 5
+      - description: Error interrupt for queue 5
+      - description: Completion interrupt for queue 6
+      - description: Error interrupt for queue 6
+      - description: Completion interrupt for queue 7
+      - description: Error interrupt for queue 7
+      - description: Completion interrupt for queue 8
+      - description: Error interrupt for queue 8
+      - description: Completion interrupt for queue 9
+      - description: Error interrupt for queue 9
+      - description: Completion interrupt for queue 10
+      - description: Error interrupt for queue 10
+      - description: Completion interrupt for queue 11
+      - description: Error interrupt for queue 11
+      - description: Completion interrupt for queue 12
+      - description: Error interrupt for queue 12
+      - description: Completion interrupt for queue 13
+      - description: Error interrupt for queue 13
+      - description: Completion interrupt for queue 14
+      - description: Error interrupt for queue 14
+      - description: Completion interrupt for queue 15
+      - description: Error interrupt for queue 15
+
+  dma-coherent: true
+
+  iommus:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - dma-coherent
+
+additionalProperties: false
+
+examples:
+  - |
+    bus {
+        #address-cells = <2>;
+        #size-cells = <2>;
+
+        crypto@400d2000000 {
+            compatible = "hisilicon,hip07-sec";
+            reg = <0x400 0xd0000000 0x0 0x10000
+                  0x400 0xd2000000 0x0 0x10000
+                  0x400 0xd2010000 0x0 0x10000
+                  0x400 0xd2020000 0x0 0x10000
+                  0x400 0xd2030000 0x0 0x10000
+                  0x400 0xd2040000 0x0 0x10000
+                  0x400 0xd2050000 0x0 0x10000
+                  0x400 0xd2060000 0x0 0x10000
+                  0x400 0xd2070000 0x0 0x10000
+                  0x400 0xd2080000 0x0 0x10000
+                  0x400 0xd2090000 0x0 0x10000
+                  0x400 0xd20a0000 0x0 0x10000
+                  0x400 0xd20b0000 0x0 0x10000
+                  0x400 0xd20c0000 0x0 0x10000
+                  0x400 0xd20d0000 0x0 0x10000
+                  0x400 0xd20e0000 0x0 0x10000
+                  0x400 0xd20f0000 0x0 0x10000
+                  0x400 0xd2100000 0x0 0x10000>;
+            interrupts = <576 4>,
+                        <577 1>, <578 4>,
+                        <579 1>, <580 4>,
+                        <581 1>, <582 4>,
+                        <583 1>, <584 4>,
+                        <585 1>, <586 4>,
+                        <587 1>, <588 4>,
+                        <589 1>, <590 4>,
+                        <591 1>, <592 4>,
+                        <593 1>, <594 4>,
+                        <595 1>, <596 4>,
+                        <597 1>, <598 4>,
+                        <599 1>, <600 4>,
+                        <601 1>, <602 4>,
+                        <603 1>, <604 4>,
+                        <605 1>, <606 4>,
+                        <607 1>, <608 4>;
+            dma-coherent;
+            iommus = <&p1_smmu_alg_a 0x600>;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt b/Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt
deleted file mode 100644
index d28fd1af01b4..000000000000
--- a/Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt
+++ /dev/null
@@ -1,67 +0,0 @@
-* Hisilicon hip07 Security Accelerator (SEC)
-
-Required properties:
-- compatible: Must contain one of
-  - "hisilicon,hip06-sec"
-  - "hisilicon,hip07-sec"
-- reg: Memory addresses and lengths of the memory regions through which
-  this device is controlled.
-  Region 0 has registers to control the backend processing engines.
-  Region 1 has registers for functionality common to all queues.
-  Regions 2-18 have registers for the 16 individual queues which are isolated
-  both in hardware and within the driver.
-- interrupts: Interrupt specifiers.
-  Refer to interrupt-controller/interrupts.txt for generic interrupt client node
-  bindings.
-  Interrupt 0 is for the SEC unit error queue.
-  Interrupt 2N + 1 is the completion interrupt for queue N.
-  Interrupt 2N + 2 is the error interrupt for queue N.
-- dma-coherent:  The driver assumes coherent dma is possible.
-
-Optional properties:
-- iommus: The SEC units are behind smmu-v3 iommus.
-  Refer to iommu/arm,smmu-v3.txt for more information.
-
-Example:
-
-p1_sec_a: crypto@400d2000000 {
-	compatible = "hisilicon,hip07-sec";
-	reg = <0x400 0xd0000000 0x0 0x10000
-	       0x400 0xd2000000 0x0 0x10000
-	       0x400 0xd2010000 0x0 0x10000
-	       0x400 0xd2020000 0x0 0x10000
-	       0x400 0xd2030000 0x0 0x10000
-	       0x400 0xd2040000 0x0 0x10000
-	       0x400 0xd2050000 0x0 0x10000
-	       0x400 0xd2060000 0x0 0x10000
-	       0x400 0xd2070000 0x0 0x10000
-	       0x400 0xd2080000 0x0 0x10000
-	       0x400 0xd2090000 0x0 0x10000
-	       0x400 0xd20a0000 0x0 0x10000
-	       0x400 0xd20b0000 0x0 0x10000
-	       0x400 0xd20c0000 0x0 0x10000
-	       0x400 0xd20d0000 0x0 0x10000
-	       0x400 0xd20e0000 0x0 0x10000
-	       0x400 0xd20f0000 0x0 0x10000
-	       0x400 0xd2100000 0x0 0x10000>;
-	interrupt-parent = <&p1_mbigen_sec_a>;
-	iommus = <&p1_smmu_alg_a 0x600>;
-	dma-coherent;
-	interrupts = <576 4>,
-		     <577 1>, <578 4>,
-		     <579 1>, <580 4>,
-		     <581 1>, <582 4>,
-		     <583 1>, <584 4>,
-		     <585 1>, <586 4>,
-		     <587 1>, <588 4>,
-		     <589 1>, <590 4>,
-		     <591 1>, <592 4>,
-		     <593 1>, <594 4>,
-		     <595 1>, <596 4>,
-		     <597 1>, <598 4>,
-		     <599 1>, <600 4>,
-		     <601 1>, <602 4>,
-		     <603 1>, <604 4>,
-		     <605 1>, <606 4>,
-		     <607 1>, <608 4>;
-};
-- 
2.47.2

