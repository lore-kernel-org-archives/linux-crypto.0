Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5F619F49E
	for <linux-crypto@vger.kernel.org>; Thu,  5 Sep 2024 15:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725548967; cv=none; b=LOdlAUydXIiO3ZQSywl4zB2GXy5qF+HKx/7FnGtOsQUDj8RH0INazUeHl9xtq6EysMsBUYzjawuqqf5SL3pRS9qYBJLopt8JqHH/w7SiawEYCOMzuxBrT4k+EdWVl/g62wv9yJd7XqAhqKBCoHQNRfVDiWVzPW1K6DFCAP7YJrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725548967; c=relaxed/simple;
	bh=P9RokBVbyl/jxIL39jzH27oNSYIsI3t6ZGlI2++0Mzw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r66l8qniOr90VlFczuWHc56VV/Nma927X5fFGjPMEW2fvo848tmSAZdnefND7WSywJ88jLGZGbHaHblFBnV1WHeO9e/OS6MkJlX/bU/aCbedOimyohg7AqAKK4x+np3n31YKRzlPNPYkwjs0YeW11AS5Mx7rkwswU8kIkZWRSKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=csFAmD5+; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="csFAmD5+"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20551e2f1f8so9301035ad.2
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2024 08:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1725548965; x=1726153765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WeKZzC3h8KzAK+YZsDD+0U9LzB2BKdgLrWi7Aw3zIhI=;
        b=csFAmD5+PjSd6hEss/J37zJwBQiLLF1piIM1M8nU8jSUT7tZ2FMvNxj2YDTkyWiFD9
         jUoVCUf2IHQDaWb3qHkJnmifdcjen1n2D1ynbI5hcGjq45B+QZJ4ChZiem2QlTxq8XU0
         Vcj02QqBACiFIwAcEGbjbu9qeUMkN2S6POYOo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725548965; x=1726153765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WeKZzC3h8KzAK+YZsDD+0U9LzB2BKdgLrWi7Aw3zIhI=;
        b=FK0yvYqwf4MV/z2lfaIG7Xf1PaSArCBesHA6xET+oJqz8dw2lnbOtW/FqZURne6Maz
         jv7ilrB4TBAvZN2YykysNMKz4YXnQb/mTf35aE0E6JodM7mEqECsKHKFDF6MldgbzWfD
         O3DdxdVWx08lCEpVp08EbkIOSa6uAB+cptLmszZCdTSwEeSIgSL9LgnOq64Lh2/kWTJT
         hSQqjCi8/kRu6jI0/TM+aTiegc9vOPbH/4JpWoBCUe4O63qMrg9hoG02fKFfQLKrszm+
         cOrZAb8wKZQXqNRm2HIMpCPHa7cTn8mzwEOPwJqAk5Aq+6WYY1PDo7pV55NAKowE+JEc
         icYg==
X-Forwarded-Encrypted: i=1; AJvYcCUpBdj+omcVj/2B+ghAduIbXfBJY1l6dByLbN41ClE4EW5I6wXxz1nIc5XPiJj/Wx4Kzxuj9Jl6hL/mGNg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzD0b7E5DjXbTVr/QxrN0BjdGCl53vznLDm/Ih41esQCASmOIBk
	2BIi6ATzIqd0JHhDfXAtV1BZHd3zaYTStiM02UR5xFaCYnNFY1ZBIDIQ/4mwRBw=
X-Google-Smtp-Source: AGHT+IFlXOW31SFSYAlBQYsmF3FsrTGoFB/cAT+OIPXRNyueFf7y0Siho6jxscGlNXwJVpnUXckjLw==
X-Received: by 2002:a17:902:ced2:b0:1fd:791d:1437 with SMTP id d9443c01a7336-2058417b1d9mr194337195ad.6.1725548964908;
        Thu, 05 Sep 2024 08:09:24 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea556f8sm29779855ad.198.2024.09.05.08.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 08:09:24 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	robh@kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v1 1/1] dt-bindings: crypto: Document support for SPAcc
Date: Thu,  5 Sep 2024 20:39:10 +0530
Message-Id: <20240905150910.239832-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240905150910.239832-1-pavitrakumarm@vayavyalabs.com>
References: <20240905150910.239832-1-pavitrakumarm@vayavyalabs.com>
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
index 000000000000..a58d1b171416
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
+        spacc-wdtimer = <0x20000>;
+        vspacc-index = <0>;
+        little-endian;
+    };
-- 
2.25.1

