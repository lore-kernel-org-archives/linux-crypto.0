Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442922620E5
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 04:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761886109; cv=none; b=rox0HXGFnZi78qH6DPKPqOeqoowVPJ9qU6XO0xWxzezx1ZZ+CLuWdZTNa0/WXDzIMVgJfiPTa5zTyew54N0pqydaJrVRkJIEFQ+gnMYBsQdppSLyHlrbRtLUJM+VOLbclWmI53okxrTAdYVmxkazC6LzNT+MzVT28a4qr2CJjb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761886109; c=relaxed/simple;
	bh=VqneJzSj6ZAncie4Pm4kr22vBIPcmTH6MVSrCpJuRgA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ic6IVrEp47GyaOfH3D8WFidEntBwKonm6LUNAA69T9NIQDYEH2H+pfRxzLHfvWTTiLEERz3PUpi+e+R0Xd5/D/9PAG0Dfr2xq/xZH1WmMyfIqP9b3gbvohvWH8i28pNkM5Nqmj93LzyWPvLXxO94RImum/TObjow3ce4mNNrA5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=obTet3uu; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="obTet3uu"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-340564186e0so1506946a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 Oct 2025 21:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1761886107; x=1762490907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhMtSPXj9mr8UNmQXgxlkL8r6YPZnmm760J+NfJOOMc=;
        b=obTet3uugPXpambmH203+b0HoH6vkCt97hvsBDPJAuc/DEzPbYA+BeFubWjFyvkmKM
         fhGtGKhBBvikSqT2kJrPiK3OE0y0xFvcFiKZ+xExrFyP+VMEUxFNmw98uDFqr5KUSJMI
         73ewlwsJ7wutmoSBHXN6ZDXE9p5SQTwvbyuz8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761886107; x=1762490907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhMtSPXj9mr8UNmQXgxlkL8r6YPZnmm760J+NfJOOMc=;
        b=GF/NHtyoU5rekKm5rc+3lNdjXOw12YRWAEdJmNOHGmtFTUiyBk4/q86kTmXWW+4cDq
         +Lm3NGIEbio+fuGabhMjbW4ICvpeWsHdFRJWIcoxUR0szN9nFMvMdEJPYA/D4yqOG08Z
         sJ+HyZLqZOB7BJ7nyWZjGELA7F0xd4lrRzU1dkURdOF9XhplooFvUxbl7gFVMg8JD8xQ
         fw8uD1zALiIUu503QUKQZgt1Ka3TQ6ajmUQ1AGbFZHYZRQ8ZpCMOn7OoMcY2AKemZtyE
         zAs3sYcWTx86x7EdHpeHP1YqxGoCB8XWYfvHJrMGA0cZpapzPJJjMtN/5LOCOUUjyK7c
         0cOg==
X-Gm-Message-State: AOJu0YxyYkuuKEwSSRj1Hqh+FwCPJmEsFbV6dGk3nuoIPIuWHW7WwxZ7
	YA8MrwDz39sfUJR1N2wsgPGBs4MUoFq3PV4o6q5Pc1jvozr/alfzvGnPYL23c+6OuTsL3oUW3u0
	gqMaL
X-Gm-Gg: ASbGncuTaRUBiMxbLJawEleM8Eqbb9DItSP8G+YSbR7fdYCqCjGf62eBg6yTlTyzky6
	S7FVV5NjnKvB6N+a3jZqDRhJsyBQX/alL7R6/hjEVaaKFGgz7qRNOv1C4bKONn6niRCX7x5SMka
	uRE6TVEPmu4Au4OtTpqjv2aU82DOnDpJJ86XMiAhH2na5PJ25GToKTCdYHuv8fw0ceSE7vNcB+5
	nRVEl0y5pWoKxbUqtCS2QBymBgLcGNSen63GjF1gFB1Vt67xkrLGZWdQT1+ZPWecSv5rMsnOILe
	+1+Exb2OJo+0bmnUrMru5Tl7fAoC0cRRVIN3hKROJY2y2xAdGokfkFVWWXfJQ22t6LJI4Rc2M61
	da3dMmOVmwgyQr8a+t6tjOQg7hiUrowp5c/Ihz1CzW3FAblKNueJKwPGLKry2xTkoj9e/FNSHTY
	Ash9hq+kKOSD4H004bQ3ZF9qgtqGtm3d5hsdu6GwT3ltp/9OHCrEJWagi4CmDarwiDhQ==
X-Google-Smtp-Source: AGHT+IFwFawjyprL+VHJsQfq2A4QRg6Hp0AFrY3h2r8j5KgsvmnqMgO6Eqm+eFSnxQRGXR21o0uvdQ==
X-Received: by 2002:a17:902:c943:b0:267:9aa5:f6a6 with SMTP id d9443c01a7336-2951a470f8emr31237585ad.19.1761886107292;
        Thu, 30 Oct 2025 21:48:27 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-295269bd2fesm7238875ad.105.2025.10.30.21.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 21:48:26 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk+dt@kernel.org,
	conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v8 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Fri, 31 Oct 2025 10:18:00 +0530
Message-Id: <20251031044803.400524-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251031044803.400524-1-pavitrakumarm@vayavyalabs.com>
References: <20251031044803.400524-1-pavitrakumarm@vayavyalabs.com>
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

Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/snps,dwc-spacc.yaml       | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml

diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
new file mode 100644
index 000000000000..857e5c6d97fc
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
@@ -0,0 +1,50 @@
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
+  The Synopsys DWC Security Protocol Accelerator (SPAcc), which is a
+  semiconductor IP designed to accelerate cryptographic operations,
+  such as encryption, decryption, and hashing.
+
+  In this configuration, the SPAcc IP is instantiated within the Synopsys
+  NSIMOSCI virtual SoC platform, a SystemC simulation environment used for
+  software development and testing. The device is accessed as a memory-mapped
+  peripheral and generates interrupts to the ARC interrupt controller.
+
+properties:
+  compatible:
+    items:
+      - const: snps,nsimosci-hs-spacc
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
+required:
+  - compatible
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    crypto@40000000 {
+        compatible = "snps,nsimosci-hs-spacc";
+        reg = <0x40000000 0x3ffff>;
+        interrupts = <28>;
+        clocks = <&clock>;
+    };
-- 
2.25.1

