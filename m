Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6BD2BF3DF;
	Tue, 13 May 2025 18:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747161667; cv=none; b=qGcA87Oc2JhARc9a8daPoPenBg9T/kGHeJdwX7y/iRSuigT59JHCL/PpvB/rOasM3pDNyMOD+bBUXkk4HiE3miPVjo/ckiDai4CBJ/GI6bVkXIvSnx3aCqAvM2myawq6vjtfC1/KiXojuPxk8p3Y0vBpKJsMFVkGM1Ap/BHwosU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747161667; c=relaxed/simple;
	bh=HE38JTAZL12iBR/aCrUBtPm9Iyx138wQdJe68mBjlXs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d6HMilhLgdGxyBPSWxGep9vTcjqvjnb3wCXFxepXFo8NRCl/sG+pEzBxjxbZrAKzEGbBkVH2NNu3/J9MVzB2VSEvYhVo2LjihOpn3BG59cNTLZzaMuWExVekVc7CmfHGR80+CVIZ1vAd2E3auNCtyj6uR5P04UH6UUGsevqeV28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lsMR1OVc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsMR1OVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54BCC4CEE4;
	Tue, 13 May 2025 18:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747161667;
	bh=HE38JTAZL12iBR/aCrUBtPm9Iyx138wQdJe68mBjlXs=;
	h=From:To:Cc:Subject:Date:From;
	b=lsMR1OVc9sTPCFnob3YHPzoiRA2/UjEf0jBIj99nygPWj85AAuWQVc2EhQ69Ghftv
	 KVW8lYoIBOYZNMWqomM4DCCuh2PWpOcskE8mJEaStmhddQZNjdQTNEcD3muh0/Q0cn
	 n8rvovH4zsbmzbh0dRZY8Y/dRBdSO14wUptp0QNHz+pwWn8YBZjyVSK8ZeXbK2q5QR
	 M8/cNWzjnfdLqgQ9c0MpAhS2L7fwTucIXbeP002droI+Lu2Esc1r2HpYjUTgroLSNE
	 PCbPpnAgrclbeH1elbHRGwMHaVibMHPyShostLDLBPA3T7drZ/uv2EfOijWHi2hUff
	 ewkGwrqJNN7dQ==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Rob Rice <rob.rice@broadcom.com>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: crypto: Convert brcm,spum-crypto to DT schema
Date: Tue, 13 May 2025 13:41:02 -0500
Message-ID: <20250513184103.3052055-1-robh@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the Broadcom SPUM/SPU2 binding to DT schema format. It's a
straight forward conversion.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/brcm,spu-crypto.txt       | 22 ----------
 .../bindings/crypto/brcm,spum-crypto.yaml     | 44 +++++++++++++++++++
 2 files changed, 44 insertions(+), 22 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/brcm,spum-crypto.yaml

diff --git a/Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt b/Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
deleted file mode 100644
index 29b6007568eb..000000000000
--- a/Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
+++ /dev/null
@@ -1,22 +0,0 @@
-The Broadcom Secure Processing Unit (SPU) hardware supports symmetric
-cryptographic offload for Broadcom SoCs. A SoC may have multiple SPU hardware
-blocks.
-
-Required properties:
-- compatible: Should be one of the following:
-  brcm,spum-crypto - for devices with SPU-M hardware
-  brcm,spu2-crypto - for devices with SPU2 hardware
-  brcm,spu2-v2-crypto - for devices with enhanced SPU2 hardware features like SHA3
-  and Rabin Fingerprint support
-  brcm,spum-nsp-crypto - for the Northstar Plus variant of the SPU-M hardware
-
-- reg: Should contain SPU registers location and length.
-- mboxes: The mailbox channel to be used to communicate with the SPU.
-  Mailbox channels correspond to DMA rings on the device.
-
-Example:
-	crypto@612d0000 {
-		compatible = "brcm,spum-crypto";
-		reg = <0 0x612d0000 0 0x900>;
-		mboxes = <&pdc0 0>;
-	};
diff --git a/Documentation/devicetree/bindings/crypto/brcm,spum-crypto.yaml b/Documentation/devicetree/bindings/crypto/brcm,spum-crypto.yaml
new file mode 100644
index 000000000000..9a5fb61727fa
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/brcm,spum-crypto.yaml
@@ -0,0 +1,44 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/brcm,spum-crypto.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom SPU Crypto Offload
+
+maintainers:
+  - Rob Rice <rob.rice@broadcom.com>
+
+description:
+  The Broadcom Secure Processing Unit (SPU) hardware supports symmetric
+  cryptographic offload for Broadcom SoCs. A SoC may have multiple SPU hardware
+  blocks.
+
+properties:
+  compatible:
+    enum:
+      - brcm,spum-crypto
+      - brcm,spu2-crypto
+      - brcm,spu2-v2-crypto     # enhanced SPU2 hardware features like SHA3 and Rabin Fingerprint support
+      - brcm,spum-nsp-crypto    # Northstar Plus variant of the SPU-M hardware
+
+  reg:
+    maxItems: 1
+
+  mboxes:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - mboxes
+
+additionalProperties: false
+
+examples:
+  - |
+    crypto@612d0000 {
+        compatible = "brcm,spum-crypto";
+        reg = <0x612d0000 0x900>;
+        mboxes = <&pdc0 0>;
+    };
-- 
2.47.2

