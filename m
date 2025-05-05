Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C6C24A066
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 12:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746449819; cv=none; b=D4zsB/GanOL/E/+5D7VJzkGAHj7xg1ntG0HUbvwpH1i/tt7ByLEu/vJDMPKv+Nx6ZPIcVPWZ/45a/vV7rtI5hrDJ/6x8AwtyF3Wrkn46rD1RYDxb6l/gD3LZ2g2Wut0lKZ/le69Ob3NHiv5bpxlZBJPP61YlD55jbJWc9GwGd/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746449819; c=relaxed/simple;
	bh=FiWexGFg8BIBHrmY4WuERV+Gwq585xDO5l34UTSccv8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d34uTaeIP0Hee5vhyDc3zSA1HOUqEKvhPgWBKg8EWmpOcui0OcsrSp5/rQ5p1ZSwMFoINRHfC1SRotNYDyTpPo/tRNi4v2ErTndgnl+Jf96NBp7Awdxgj7rAUDW3E1psG6NRDEUg8vVAJvxgDRIDtzuE6X8C/nj6zsiOmcWaBEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=FIJC5iMs; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="FIJC5iMs"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22928d629faso39630395ad.3
        for <linux-crypto@vger.kernel.org>; Mon, 05 May 2025 05:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1746449816; x=1747054616; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZfE2hNbMHbAZropHJ6kfzfLxfS9KqaoJbdRhtwFnTQ8=;
        b=FIJC5iMsMu+MG+pc/wTMicpKaOR6G5x2gqR9H3NMTGZOETGlFlNf3/4qaJ6B6ekk5s
         5X/VxptHgRnO0Pr2/5+Gia2tYEqDp+Ha+xpIGDt66u0zGv0OOsfQi1VuCa641cO9fDhm
         0NwL6IGNCl6/zoZ+dX88oYY11ksV88WU6iTQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746449816; x=1747054616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZfE2hNbMHbAZropHJ6kfzfLxfS9KqaoJbdRhtwFnTQ8=;
        b=bW1jajlzR70b9c4Bg658st6LA3R5Cs6zgSaj2P9h5Swh7nol1AFC3Ukzgyh6//IcEO
         RM3nU/v1vjLI2CArrsyQheXcZbaBAPVJnesralcKkLsFhjsQPT8Yy7F9wt3I8Q7QB56n
         zozGis1FNjTNOCCvEYlfwDmpcioCoFClJ+NEeL/dwxIKxDhsLtAuKm9FzKRQA2REzgeo
         ESTO3PywXMyQyMvR2lpXxtKYLis34cwFi0PAyf7JF0c3dsq2bWWriV3SghfU2APeA1zl
         jONHT4RmsBAODDAXOlChmvVo6zcm5r/N4TBh2jvxiABETd6ezw7KUbBIpGMzTpUanJEv
         +vWw==
X-Gm-Message-State: AOJu0Yx7LiqqtIn7Q46DDhSCSQrli6/g+X33nK62bcneTcsaclOC5eTf
	KZ2gn0sqVlrTC2el4Y84/3lbj+TU+b7apD4YBGERZUQ65Y6HWErIDoBQQVaFFnq2nyWwufGTmOo
	C
X-Gm-Gg: ASbGncvUUNuYtPpF+nouqLg57BnzOQX9oXY7Bi30KvCdPevEg2IVzQNpFQVA18uuJGM
	xVsHaerq++qi7a9ePZOSAKVb+x+7KME4uRBblXACLloOUbcPay4hwcV2YdCTAmn2WTvwBFIBvgN
	oJ1pI2L3leq7Lu4EDEluK12iFxtAl7rMyz1qKel9A24KmSXU3LeACzsC3/XARBBnEBA9DUhoIi4
	ZvK6hbsrgzUMOjXs/h7V3AmZlm1wyCv92uTCoCNRlYlMjvmnkHyNnDHUuU9/YGYDI2kGYljOB70
	HRideJncwYo+giVps/wTutTD2HAl6jSoVNZzhTCiUnApDPceMNjoPqAReEt3ZJpNRLxw9pPAZxs
	=
X-Google-Smtp-Source: AGHT+IG90imdHFa9iItNR6oHqRLpczzLfNkn2baiZ/BsA5RMwoC4leyNhTFUEmpPnrWHVK6cYpzDvQ==
X-Received: by 2002:a17:902:f543:b0:224:2a6d:55ae with SMTP id d9443c01a7336-22e1eac1872mr131071505ad.48.1746449816284;
        Mon, 05 May 2025 05:56:56 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1521fc6fsm53559565ad.145.2025.05.05.05.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 05:56:55 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Subject: [PATCH v2 1/6] dt-bindings: crypto: Document support for SPAcc
Date: Mon,  5 May 2025 18:25:33 +0530
Message-Id: <20250505125538.2991314-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250505125538.2991314-1-pavitrakumarm@vayavyalabs.com>
References: <20250505125538.2991314-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>

Add DT bindings related to the SPAcc driver for Documentation.
DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
Engine is a crypto IP designed by Synopsys.

Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 .../bindings/crypto/snps,dwc-spacc.yaml       | 81 +++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml

diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
new file mode 100644
index 000000000000..190c0a3f6d6a
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
@@ -0,0 +1,81 @@
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
+description: |
+  This binding describes the Synopsys DWC Security Protocol Accelerator (SPAcc),
+  which is a hardware IP designed to accelerate cryptographic operations, such
+  as encryption, decryption, and hashing.
+
+  The SPAcc supports virtualization where a single physical SPAcc can be
+  accessed as multiple virtual SPAcc instances, each with its own register set.
+  These virtual instances can be assigned different priorities for hardware
+  arbitration of crypto operation processing.
+
+  The SPAcc IP has been instantiated in programmable logic (PL) of Xilinx
+  ZynqMP(zcu-104), connected as a memory-mapped peripheral on the system bus,
+  and accessed through a standard interrupt routed to the GIC. This binding
+  describes a standalone instantiation of SPAcc IP, without SoC-specific
+  customization.
+
+properties:
+  compatible:
+    items:
+      - const: snps,dwc-spacc
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
+  snps,vspacc-id:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      Virtual SPAcc instance identifier.
+      The SPAcc hardware supports multiple virtual instances (determined by
+      ELP_SPACC_CONFIG_VSPACC_CNT parameter), and this ID is used to identify
+      which virtual instance this node represents.
+    minimum: 0
+    maximum: 7
+
+  snps,spacc-internal-counter:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      Hardware counter that generates an interrupt based on a count value.
+      This counter starts ticking when there is a completed job sitting on
+      the status fifo to be serviced. This makes sure that no jobs are
+      starved of processing.
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
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    crypto@40000000 {
+        compatible = "snps,dwc-spacc";
+        reg = <0x40000000 0x3FFFF>;
+        interrupt-parent = <&gic>;
+        interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&clock>;
+        snps,spacc-internal-counter = <0x20000>;
+        snps,vspacc-id = <0>;
+    };
-- 
2.25.1

