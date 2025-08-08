Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3036277CA0
	for <linux-crypto@vger.kernel.org>; Fri,  8 Aug 2025 12:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754656037; cv=none; b=J4YhzFxku0FG13ZOQUkinNjsQv568FyOgn3oYYnrE7DWodsokB4LOKXGgUT2sPjeTIt4dvyOmpTSLAJ43ui/wzUrsZgmGHErcujcQ5q3E6tqlXCYzdT2t4l4y0qma94aPgvKJjLwm6XfoejZKeT8KuJkEXljGGCNTVmt2VMAESo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754656037; c=relaxed/simple;
	bh=55xyNih1p/jm8DNDiay6Vgkq0BIb6mLAUammufSbVHI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jWt+PpbSeq+8mpWTLrki4ouivp13a/sQNKAcliYcilD+/IHtWb+QU3ZCJEuPDHNNJckBf9UBPu1gT4DiX4ninctQ4yGjiXRKObebfOOSK6dNLlygNVg9TUf+cxQkfKCUx5CX3SYk6/WMWP54HyI4gOD2mlDOgbLrbhaEDaG+FGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=e45pRocT; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="e45pRocT"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-76bc61152d8so1956469b3a.2
        for <linux-crypto@vger.kernel.org>; Fri, 08 Aug 2025 05:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1754656035; x=1755260835; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJ2tefdglAjtygFqd1QbWGrd125necdYQVliSr1KcFQ=;
        b=e45pRocTY9m9eLsaL2CzWhlxb54ZJgypNjtaTVWli/TXBbNaWQJCsGCRIWe2geCk1C
         h6Y8CoGStq6eq995nkWyZztlkX+RueFYXAlYf35pF6uTjE7420gltpMREDcsH/cBvG7d
         PzmOTvLb3y7zGORu1Sfk3m/GpzhHDcNWgIqYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754656035; x=1755260835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJ2tefdglAjtygFqd1QbWGrd125necdYQVliSr1KcFQ=;
        b=Gg6HSMBUf+4rzlf7N0xOh85xW4ng0C0L1IVXRDW4zR/vGv/rM4YbLumGjBailDvJWC
         5+lT0k37MpKqb4/qSsPjlAawd1yHHuu5PZiQdLfToTToHvEcOmmPYnIMB4VicR9t0yPG
         ZGiMPP13LBanpl3D75TuCwf2rZQctPMdN/4ah/sCk6Bu5jfRuyRBudayE33O94TCTSzp
         sstHS1awsFeT4osNC4PGGQLeW9lqoZMQdEbdrQkQZZqiuBFC1tKc37kEYzsDA8rsbTXd
         CremjCYdSMtezfU53VKDmNUt3iV1hN93KDUcXzQv5MX5vfyvsVJHX+dm+4X6S5z7p4/G
         djMA==
X-Gm-Message-State: AOJu0Yyubma467wT76+RDBL7ypmI8AMCGpk+FHJnnu4gptq3VlXAEkAs
	2b++FzuJnoggF1HmdH7YlLR712iGFduLTes7H+ghT9fIM4VkBAnbdaP4mN7f4hEiGBvm4tIC/Qq
	zqQX+
X-Gm-Gg: ASbGncvPszTvvmj5P7dB7u0EQaZB+cYRXPqTugB9TOCaNOtHnizp1NQuzPgqNvKhZ/6
	YPLtsIpLOX9tPLNqw3VbSxydgUEyXvzXLP8w5vwoDeXh54ADn2KzjL2YyKKC92k42YTzY1yZ+6k
	RXLoE60HBK0NZS3Ei9lLZgwxwsdOa3xcpbu3ddCHOPCe6iEZhPYAmhWn+MNK1mGTfax7cseGNVx
	UP8M39i+rfjo6ztWX+ZeAqSoXibgmefkZW4/hUbJxlGnxf4t2aDAL4+uufl8fRlIbElBafyUv0y
	d7AlLX2JXkiPEEhJNOGgQgSAUs5SfCndkYNjKntmFbBZMbQudbOJk3CQME+Dp9R/LpWw5PcGLY1
	Nrqs421TKIRbgyHg3qkG+quoDrlqFGFN5M9RmT612lQsJ3w==
X-Google-Smtp-Source: AGHT+IERx8aVenHBuTli8JAbJCc9oxtQxg7z2FMu+cbVVrScQ3tjY/TvMSb6NyxPz69iUhJCLa6iiQ==
X-Received: by 2002:a17:902:f688:b0:240:7235:6292 with SMTP id d9443c01a7336-242c224cca8mr50641925ad.39.1754656034890;
        Fri, 08 Aug 2025 05:27:14 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e899a8cdsm208296665ad.121.2025.08.08.05.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 05:27:14 -0700 (PDT)
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
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Subject: [PATCH v4 1/6] dt-bindings: crypto: Document support for SPAcc
Date: Fri,  8 Aug 2025 17:56:26 +0530
Message-Id: <20250808122631.697421-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250808122631.697421-1-pavitrakumarm@vayavyalabs.com>
References: <20250808122631.697421-1-pavitrakumarm@vayavyalabs.com>
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
---
 .../bindings/crypto/snps,dwc-spacc.yaml       | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml

diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
new file mode 100644
index 000000000000..1053deaea304
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
+  semiconductor IP designed to accelerate cryptographic operations, such as
+  encryption, decryption, and hashing.
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

