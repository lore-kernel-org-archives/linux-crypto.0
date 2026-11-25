Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=119.15.109.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795640746;
	b=ozSI8qExGU/rmX7c/GYA9adflKE+oeMr1OFsFnZ+cTYMRl3Ext5vFDxs7B1Mh+qx776B
	 NCpiqYpp1cFvWXqGkeFMoUNVdr1jYXhlELgZF7BrT8JZ/qMX77hp15Xz5e8+GMpm9sVM7
	 AJRobCSWUD/Bo19f8S1CmtfY45gdJm8tEgAT3txwMFAvmfQzJkpHX80RMQQsta+ewks4J
	 Ft3KylrxtBkFWAnQOfwNsmvQvXsVNI1ONuFDHcfDJp5uTaI8YaKn83BXTvxHHq1Y91bJj
	 R8RDa+L/VFN0nOywvk2AtUEGM93gD32MEv6BlXA8cGTr/BTK3wrhpOTjFSqQoxNV2sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795640746;
	h=DMARC-Filter:Received:DKIM-Signature:X-GPT-Reason:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZRjZOv/8i6ieYj7D2uL3BhEUUZX4Fu4OCFhUQZQpJ/Q=;
	b=ls+Wmb1mBbr9hVMsLIARxR8tNLVm4LLSyUZbU1rYikAGlOAjHpO0WNlbW8S8WK2X4MQx
	 gOvii4nd/xUS0mU4BAbfRJplaJ33MCn3c7T5XjBw0dklIOmLiPDzsXk/Ry4Vt2t910vX1
	 JfQeiET+khnBk/s4yhsS6bVB2AyliW80mDWTHc1kMsJOTEOj3MWGkS/40Upz8u/weynAN
	 wvfPxkZXI76K0i9dziZsOkpErsUgp2kXUFQEZVmrg81Nr2F3ra96LUA9HaoPFn7Fwsl5A
	 glAv08ylUR4GAbfeKCVFgXQCXwyk46oouWALTYhIRJXnH5A1AGl+ofipGd2KANmriig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=d-silva.org;
	spf=pass smtp.mailfrom=d-silva.org;
	dkim=pass header.d=d-silva.org header.i=@d-silva.org header.a=rsa-sha256 header.s=2025a header.b=qYrec4g2;
	arc=none smtp.remote-ip=119.15.109.137
Received: from www.nmnhosting.com (watt.d-silva.org [119.15.109.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A43C606A326;
	Wed, 25 Nov 2026 21:05:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A43C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=d-silva.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.a=rsa-sha256 header.s=2025a header.b=qYrec4g2
Received: from Hawking.lan (hawking.lan [10.0.1.4])
	by www.nmnhosting.com (Postfix) with ESMTP id 9F6E24C95E;
	Thu, 26 Nov 2026 08:05:38 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=d-silva.org; s=2025a;
	t=1795640738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZRjZOv/8i6ieYj7D2uL3BhEUUZX4Fu4OCFhUQZQpJ/Q=;
	b=qYrec4g2dcaHEqYhOV8PM6G85OTouIfVkJSHtEtMuqsAeEwbFyIVRPtA4i22qwHYVnDJls
	Cp9R5Xyp3NSxeRednoIKv0cRQUz/ugYNZJfJaIjR84HyTlqRbosxaplZuio8rm1kqlCIud
	i8592KtFCDhEjtJuP88QaMjSu3Kvxke5oea7l+K4RR4V4Kd2+ao5ol1DCzzDrEZbx6TWVk
	JfNp3Ks5nfiROgAGr6UToK2l+8JbflarEJVFKqM7ZzbIs3zd54hTr+6bwU6Eknm98lJ7Kv
	9ZihY1szrkqDVa3at+LDgCN+SVLzknRf/FI7SrzFVR5WqP9FhUbE210gMItRyw==
X-GPT-Reason: This is a legitimate personal/professional correspondence.
	The mailbox (alastair@d-silva.org) perfectly aligns with the sender
	domain (alastair@d-silva.org) and the content is a technical patch
	submission for a Linux kernel-related project. There are no phishing
	indicators, no urgency/fear tactics, and the subject line corresponds
	directly to the technical documentation provided in the body.
From: Alastair D'Silva <alastair@d-silva.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Olivia Mackall <olivia@selenic.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Alastair D'Silva <alastair@d-silva.org>
Subject: [PATCH 1/4] dt-bindings: crypto: Add Allwinner A523/A733 Crypto Engine
Date: Thu, 26 Nov 2026 08:05:29 +1100
Message-ID: <20261125210532.695823-2-alastair@d-silva.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261125210532.695823-1-alastair@d-silva.org>
References: <20261125210532.695823-1-alastair@d-silva.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the Allwinner Crypto Engine v5 on A523 and A733 SoCs.

The A733 block is register-compatible with A523 and adds an optional
low-power/entropy control register. The separate CE_SYS clock and reset
belong to the secure TEE instance and do not apply to this node.

Assisted-by: LLM
Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 .../crypto/allwinner,sun55i-a523-crypto.yaml  | 68 +++++++++++++++++++
 MAINTAINERS                                   |  6 ++
 2 files changed, 74 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun55i-a523-crypto.yaml

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun55i-a523-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun55i-a523-crypto.yaml
new file mode 100644
index 000000000000..00606c7dcfc9
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun55i-a523-crypto.yaml
@@ -0,0 +1,68 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/allwinner,sun55i-a523-crypto.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Allwinner Crypto Engine v5
+
+maintainers:
+  - Alastair D'Silva <alastair@d-silva.org>
+
+properties:
+  compatible:
+    oneOf:
+      - const: allwinner,sun55i-a523-crypto
+      - items:
+          - const: allwinner,sun60i-a733-crypto
+          - const: allwinner,sun55i-a523-crypto
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: Bus clock
+      - description: Module clock
+      - description: MBus clock
+      - description: TRNG clock
+
+  clock-names:
+    items:
+      - const: bus
+      - const: mod
+      - const: ram
+      - const: trng
+
+  resets:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - resets
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/allwinner,sun60i-a733-ccu.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/reset/allwinner,sun60i-a733-ccu.h>
+
+    crypto@4603000 {
+        compatible = "allwinner,sun60i-a733-crypto",
+                     "allwinner,sun55i-a523-crypto";
+        reg = <0x04603000 0x1000>;
+        interrupts = <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>,
+                 <&ccu CLK_MBUS_CE>, <&osc24M>;
+        clock-names = "bus", "mod", "ram", "trng";
+        resets = <&ccu RST_BUS_CE>;
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 782389bd5cd3..757ab4e59f61 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -892,6 +892,12 @@ T:	git git://linuxtv.org/media.git
 F:	Documentation/devicetree/bindings/media/allwinner,sun6i-a31-mipi-csi2.yaml
 F:	drivers/media/platform/sunxi/sun6i-mipi-csi2/
 
+ALLWINNER CE V5 TRNG DRIVER
+M:	Alastair D'Silva <alastair@d-silva.org>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/crypto/allwinner,sun55i-a523-crypto.yaml
+
 ALLWINNER CPUFREQ DRIVER
 M:	Yangtao Li <tiny.windzz@gmail.com>
 L:	linux-pm@vger.kernel.org
-- 
2.53.0

