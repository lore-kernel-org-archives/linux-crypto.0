Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UMvrM70d"
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19898D4F;
	Thu, 16 Nov 2023 10:06:48 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-5409bc907edso1635876a12.0;
        Thu, 16 Nov 2023 10:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700158006; x=1700762806; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yGuolYAuOJ9mG/TiRTbTUdmCZ4CIel/D0oAmSK+iTUM=;
        b=UMvrM70dl+effar28/CKD/DvErEKWQIcsmk1/2bcOwLPID6Z7T+Vk7gnyuugT7uWfB
         uGIf3D2Pw/MdxPiR4S6qPwWyZE3VM4pRy9LcKeHiypoD9zs0auS62bUQsIddB2j9BYxO
         SNtc8ho1pFOIVc+AI1cO3YdrwKa8vYw4RsoYbMJeyiF1TmqyhoLLbEoj11eL712feAYR
         WAtROSmtOmbZA1IkKpB1TSNz3QmY2j2ha7cdjdhyLiJbzRpcGAqcJM+5zirQ73BMaxws
         Tgsh0VBz/BZCCL3+MK7s67m6OhQzA0rt8wp6MPzPobTK009RbQSyT1JAatopfoz9w7eA
         R6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700158006; x=1700762806;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yGuolYAuOJ9mG/TiRTbTUdmCZ4CIel/D0oAmSK+iTUM=;
        b=lwftINa5OnPyf7AYhsTCxPv1/fpG3lmdIQxWhwfhoBCxsJGQ7+WZ4dNnTdGmOrN90z
         XSVCnrL1KKiPJN6pLVTEdmJt1S2HVtx0kUAtAhXxyravwqTB4MlRdiqEBnaevMurYdKB
         xvO1kpb+b6YMvCYAWpR1ilhSSY/M48O8lOCBgApWcNpMW/TuAzUBGqn01t5JxLyzmmyd
         uQY53Pm5VyoiHiPuhSHg/P8zqO1++cc2Oe2+JNg1krXLNn62scLK7aReyjEtjrMJl7Gb
         W23Kt7CPdzDIJLC2pcqyH2xfa07JCjENLJ7lbx2T1tdegZH8r4xz2JdAUGR2IPxyGBga
         gYTg==
X-Gm-Message-State: AOJu0YywoW4PKiahVOz0DxoRX9sSWjTA0vl28a0//kQP7iOTnDT/HfUD
	x2YfwEeq0p0l1j3w2adCduA=
X-Google-Smtp-Source: AGHT+IHqvVl4Ix2JgJUurJj5Fy4AY21stEqD3txM0qiceNd2moWcQx3nAzmPGORKD4YDsRR/Ua7ZqQ==
X-Received: by 2002:a17:906:cedd:b0:9e2:c6a7:447a with SMTP id si29-20020a170906cedd00b009e2c6a7447amr12449909ejb.45.1700158006219;
        Thu, 16 Nov 2023 10:06:46 -0800 (PST)
Received: from localhost.lan (031011218106.poznan.vectranet.pl. [31.11.218.106])
        by smtp.gmail.com with ESMTPSA id t25-20020a1709066bd900b0099c53c4407dsm8621877ejs.78.2023.11.16.10.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Nov 2023 10:06:45 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: Antoine Tenart <atenart@kernel.org>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2] dt-bindings: crypto: convert Inside Secure SafeXcel to the json-schema
Date: Thu, 16 Nov 2023 19:06:41 +0100
Message-Id: <20231116180641.29420-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafał Miłecki <rafal@milecki.pl>

This helps validating DTS files.

Cc: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Rename file to inside-secure,safexcel.yaml
    Drop minItems from interrupts
    Move additionalProperties down
    Improve condition in allOf

Sorry for those issues in V1. I hope I didn't miss anything this time.

 .../crypto/inside-secure,safexcel.yaml        | 86 +++++++++++++++++++
 .../crypto/inside-secure-safexcel.txt         | 40 ---------
 2 files changed, 86 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
new file mode 100644
index 000000000000..ef07258d16c1
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
@@ -0,0 +1,86 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/inside-secure,safexcel.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Inside Secure SafeXcel cryptographic engine
+
+maintainers:
+  - Antoine Tenart <atenart@kernel.org>
+
+properties:
+  compatible:
+    oneOf:
+      - const: inside-secure,safexcel-eip197b
+      - const: inside-secure,safexcel-eip197d
+      - const: inside-secure,safexcel-eip97ies
+      - const: inside-secure,safexcel-eip197
+        description: Equivalent of inside-secure,safexcel-eip197b
+        deprecated: true
+      - const: inside-secure,safexcel-eip97
+        description: Equivalent of inside-secure,safexcel-eip97ies
+        deprecated: true
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 6
+
+  interrupt-names:
+    items:
+      - const: ring0
+      - const: ring1
+      - const: ring2
+      - const: ring3
+      - const: eip
+      - const: mem
+
+  clocks:
+    minItems: 1
+    maxItems: 2
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: core
+      - const: reg
+
+required:
+  - reg
+  - interrupts
+  - interrupt-names
+
+allOf:
+  - if:
+      properties:
+        clocks:
+          minItems: 2
+    then:
+      properties:
+        clock-names:
+          minItems: 2
+      required:
+        - clock-names
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    crypto@800000 {
+        compatible = "inside-secure,safexcel-eip197b";
+        reg = <0x800000 0x200000>;
+        interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "ring0", "ring1", "ring2", "ring3", "eip", "mem";
+        clocks = <&cpm_syscon0 1 26>;
+        clock-names = "core";
+    };
diff --git a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
deleted file mode 100644
index 3bbf144c9988..000000000000
--- a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
+++ /dev/null
@@ -1,40 +0,0 @@
-Inside Secure SafeXcel cryptographic engine
-
-Required properties:
-- compatible: Should be "inside-secure,safexcel-eip197b",
-	      "inside-secure,safexcel-eip197d" or
-              "inside-secure,safexcel-eip97ies".
-- reg: Base physical address of the engine and length of memory mapped region.
-- interrupts: Interrupt numbers for the rings and engine.
-- interrupt-names: Should be "ring0", "ring1", "ring2", "ring3", "eip", "mem".
-
-Optional properties:
-- clocks: Reference to the crypto engine clocks, the second clock is
-          needed for the Armada 7K/8K SoCs.
-- clock-names: mandatory if there is a second clock, in this case the
-               name must be "core" for the first clock and "reg" for
-               the second one.
-
-Backward compatibility:
-Two compatibles are kept for backward compatibility, but shouldn't be used for
-new submissions:
-- "inside-secure,safexcel-eip197" is equivalent to
-  "inside-secure,safexcel-eip197b".
-- "inside-secure,safexcel-eip97" is equivalent to
-  "inside-secure,safexcel-eip97ies".
-
-Example:
-
-	crypto: crypto@800000 {
-		compatible = "inside-secure,safexcel-eip197b";
-		reg = <0x800000 0x200000>;
-		interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "mem", "ring0", "ring1", "ring2", "ring3",
-				  "eip";
-		clocks = <&cpm_syscon0 1 26>;
-	};
-- 
2.35.3

