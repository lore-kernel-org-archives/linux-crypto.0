Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A041991D4
	for <linux-crypto@vger.kernel.org>; Thu,  5 Sep 2024 11:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725535599; cv=none; b=GZAfe3vhYMZXUEeWmy5B/xcqXJFuZ7KEvAxko77FmezFEI7w9r8370w3ReQDOlR6wUsv6zOQnfFZ5iylCxOKL021f2S94SNY+pcntiOH1CEaEAoFFyIb+y1a5w482eQbd1XYGZexKj8tBVS4Uaawi6AVHU9YlOGq9hgeAsvSgcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725535599; c=relaxed/simple;
	bh=uPKZajMj0+4NDMXOog9v35p92NDX8Zmoqti6dst4Gcw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n2mNoxMCH5rgxKVGhpD3iPVdFESXMv2x6/2Se0KjhObuqSGAQeR5VAqnpeLDpcPzZ7UT9zyGnRfzKmPHRJspXOOUCIom1W/y2xbjzSzaOSqVjBBvyl/9LA52MuGr0hCp3ill4uz5OcnqjlW0S14ES0l9LhC2NG039H10X3LdSpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=PJHlilPF; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="PJHlilPF"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20536dcc6e9so4789215ad.2
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2024 04:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1725535597; x=1726140397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6E6kzqN7sw0Bm/x9wPsmhlMXiVbetaL6tQQYNOBhsTk=;
        b=PJHlilPFtUFptyZYWqb1zp+47wMREy3qr8tVM31O1fUzzZnjoSKePLk1asTS0JXmm8
         Arux5+Yzd7duw6x7eyUgdlsH71DdSCqgLqsJpUOHPBsFSofTDTDa66ToP/cBWIZCitfU
         lmt9lER5n/cBeqc3t5mOW69SEtmuuNcmdXESI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725535597; x=1726140397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6E6kzqN7sw0Bm/x9wPsmhlMXiVbetaL6tQQYNOBhsTk=;
        b=Geo/Ss/Vp6O8sndHnrvBr59Nt+7Fao+F7FXeQgsVrIXCdaDGYa5r3Hx/oCBJngB6bF
         QhVczP+Wn3akJUL1ybiX1LSdynVVjh1YVbexDVYX7JC4kAC/Nb/l0hiA7ThNKcVqpRT/
         7lnF4xNwHRaarBZWvEqxrBcvCdd7faPUdekD6SPGhMFhjcye6UXYBLJBGvL9Tp34RTjy
         qmSmTdwO83lShi2pFsKuqHEcN4s/YF4+s7CgIAxCOWYzVWOnponNksIbYueMsabqhOEs
         0F99Et5JhhKjgmvmXxk+qiSAB0CMys6oO7zcsQi7Rey5lmZEbt2Ly7rVGJeynXOWFf4C
         r92g==
X-Forwarded-Encrypted: i=1; AJvYcCWk0jJK3p3hWd90oGeeCtNY3xpO5GRgA5z87PWDBSYZtbhkK9TMu/speObXQqf+XvPL9qP9TlI6fQl2KQU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQcUX3ih/+3iWj4TY3kxMQaeTQRn+9oFBiuNM3guAx3aFzovlC
	ZICZkFk4vRMFXR8wOIfgW6Co0IOBgm4GqenZcMsA591QJqnJNepDtKuEDshyWRQ=
X-Google-Smtp-Source: AGHT+IGDiAam5e5vgT9ZHTVv+6stZBUzL5d+scDc2Ygdburm03QlPWrwuyEUEv/WOqY+DXJe9IiFRA==
X-Received: by 2002:a17:903:2285:b0:205:4e15:54c8 with SMTP id d9443c01a7336-2054e15577fmr186548705ad.61.1725535597501;
        Thu, 05 Sep 2024 04:26:37 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206ae9138c0sm27445395ad.9.2024.09.05.04.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 04:26:37 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	robh@kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH 1/1] dt-bindings: crypto: Document support for SPAcc
Date: Thu,  5 Sep 2024 16:56:22 +0530
Message-Id: <20240905112622.237681-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240905112622.237681-1-pavitrakumarm@vayavyalabs.com>
References: <20240905112622.237681-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add DT bindings related to the SPAcc driver for Documentation.
DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
Engine is a crypto IP designed by Synopsys.

Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 .../bindings/crypto/snps,dwc-spacc.yaml       | 79 +++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml

diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
new file mode 100644
index 000000000000..dc5b38cd5e1e
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
@@ -0,0 +1,79 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/snps,dwc-spacc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Synopsys DesignWare Security Protocol Accelerator(SPAcc) Crypto Engine
+
+maintainers:
+  - Ruud Derwig <Ruud.Derwig@synopsys.com>
+
+description:
+  DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto Engine is
+  a crypto IP designed by Synopsys, that can accelerate cryptographic
+  operations.
+
+properties:
+  compatible:
+    contains:
+      enum:
+        - snps,dwc-spacc
+        - snps,dwc-spacc-6.0
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    maxItems: 1
+
+  little-endian: true
+
+  vspacc-priority:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Set priority mode on the Virtual SPAcc. This is Virtual SPAcc priority
+      weight. Its used in priority arbitration of the Virtual SPAccs.
+    minimum: 0
+    maximum: 15
+    default: 0
+
+  vspacc-index:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: Virtual spacc index for validation and driver functioning.
+    minimum: 0
+    maximum: 7
+
+  spacc-wdtimer:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: Watchdog timer count to replace the default value in driver.
+    minimum: 0x19000
+    maximum: 0xFFFFF
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
+    spacc@40000000 {
+        compatible = "snps,dwc-spacc";
+        reg = <0x40000000 0x3FFFF>;
+        interrupt-parent = <&gic>;
+        interrupts = <0 89 4>;
+        clocks = <&clock>;
+        clock-names = "ref_clk";
+        vspacc-priority = <4>;
+        spacc-wdtimer = <10000>;
+        vspacc-index = <0>;
+        little-endian;
+    };
-- 
2.25.1

