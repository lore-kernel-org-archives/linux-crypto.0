Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EX0IGAZV"
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3577181;
	Thu, 16 Nov 2023 05:06:24 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-507bd64814fso1106539e87.1;
        Thu, 16 Nov 2023 05:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700139983; x=1700744783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q+bT5UY6cWuA1dImr/AZqypgBJe+23IFM6ce79AcpQ4=;
        b=EX0IGAZVviremp1JOJVb7SlSBXhb8Jb1F8OKl64l+tA+C9ZIapYJsjJ3Zatb4+kOHA
         RjyKe8VGDTtiObZDQ7unII49phFdEycnG2xMx6jaS6mYYS7yfYJ+HYpHO+G+Rx5w3VSi
         vFB+FUjZbm5BvGFwQsSu81fy0UpqscjNZ81il8CQyuUkmt0/2629uw6iM2U/8jwjZg/6
         Zy/ug2Lo7Jt9lh+JLHo7OEszwfzaKtZsVfiTIRblJObMSZ5BdVoLRzrnaPxHcBRuxHiu
         BfjL1mosrl4jW8B1Zl1WU2dqVYuGycJD3XxCQi7aAlrBlGO7u4WdwDtNgto18WzV+lTU
         s0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700139983; x=1700744783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q+bT5UY6cWuA1dImr/AZqypgBJe+23IFM6ce79AcpQ4=;
        b=bVxorbdnu8ycIYGYBVnSbGtZzHaYnpeSi4iQwcm2BH+cC5hQcUjm8KjimgiPhwglyP
         KIyhImaLCNrpqsdNZ5AvbVOub7Kk+Us51KXWjsss57qQQkGvymKopR6JNmjOCliCBGnH
         6ClimLuTPoZwLFOh+56uejZN+J9RFa8pkhx8oMUG+MzOkDH5ERozMQ8Fqb2LdrMCPWdA
         exSSSeN2RBOcZ8I1tj+k48rPkmdEzMtjwACcd8kYwZQAxKt5XlT0PtDjipOKEoUbayCo
         pClkxOFk+e4sfP73ZsgUdrQutT/Yn8kr4Rhgb+jihJhA2KNVYm0KC89OOIPvMpApJNLq
         LBGw==
X-Gm-Message-State: AOJu0YzW7qxGwuA37AwbdJDq6zdAYSNAzv9wcUxRFBcRAd6uTD6GKH2S
	Lq1oZqhL+pR1LVRwyiTqHZA=
X-Google-Smtp-Source: AGHT+IHml2gWvGcbtSH+yXUOO/F6HNXIl1dwjEC+PLCMLnlfBI2ejluNYcga9rM/1ggt2YHYzxyi8g==
X-Received: by 2002:a05:6512:e99:b0:507:ab6b:31ef with SMTP id bi25-20020a0565120e9900b00507ab6b31efmr2206843lfb.41.1700139982669;
        Thu, 16 Nov 2023 05:06:22 -0800 (PST)
Received: from localhost.lan (031011218106.poznan.vectranet.pl. [31.11.218.106])
        by smtp.gmail.com with ESMTPSA id v22-20020aa7d816000000b00533e915923asm7651138edq.49.2023.11.16.05.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Nov 2023 05:06:22 -0800 (PST)
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
Subject: [PATCH] dt-bindings: crypto: convert Inside Secure SafeXcel to the json-schema
Date: Thu, 16 Nov 2023 14:06:20 +0100
Message-Id: <20231116130620.4787-1-zajec5@gmail.com>
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
 .../crypto/inside-secure-safexcel.txt         | 40 ---------
 .../crypto/inside-secure-safexcel.yaml        | 84 +++++++++++++++++++
 2 files changed, 84 insertions(+), 40 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure-safexcel.yaml

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
diff --git a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.yaml b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.yaml
new file mode 100644
index 000000000000..4dfd5ddd90bb
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.yaml
@@ -0,0 +1,84 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/inside-secure-safexcel.yaml#
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
+    minItems: 6
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
+allOf:
+  - if:
+      properties:
+        clocks:
+          minItems: 2
+    then:
+      required:
+        - clock-names
+
+additionalProperties: false
+
+required:
+  - reg
+  - interrupts
+  - interrupt-names
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
-- 
2.35.3

