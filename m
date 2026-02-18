Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627A031E0FB
	for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 12:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771419510; cv=none; b=ByafGtdo+0NDzi/CHR3rUWToQTyvjlWpIw+jljWEjs4/n1hYdVb0D78v1oAjQi5T3l7IuNVYGCRDEsGncpiIIDFvvagD3qMsC4XD6iSpp5PyqxmP06agMm1/gUVytJHXRpul1MS42wOxRhQqW9u1hndBXgGjP4GXZo0hccUuIwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771419510; c=relaxed/simple;
	bh=1rCkpkHyHE3IPuAx81k2bwmc4nwhuww71wQ9MS0fnZE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gipVGa7DHCyuDAgAEp5wgaZxido9PB7vsCSWUaKsoWefXuNNIcvYzpBCmkKxXoRE0QpX4tcnf+bhE0+p1sJ3XGKZDguy4Ginl1T2Dv0FSxO/u9PKG1iXgCadLuIXbsRWAu9ApzKlQVPqzAmCzH5YFUixwRivbBReX/5zWiTArHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=e4PrTHY7; arc=none smtp.client-ip=209.85.210.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="e4PrTHY7"
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-82418b0178cso2945180b3a.1
        for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 04:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1771419508; x=1772024308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3WO3LsK3AW3by8XZxWRGcuY2BsjgbgR+h9RmVDdaQIY=;
        b=e4PrTHY7+cXfMs4xzEPHxhzVh0jgNUPPt5HsrLyYi+lnWMqMoITNizr1yajyZudPzP
         Qkw+UUjpa6285ldFbb8KcctyYrmS86mCGiLsZ1nYvEu8bRLw4O3CCCBicHjLnkbzugD8
         ttHX7Ym50MOGcZU7S7GrV8RpJjsfwXPNueLNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771419508; x=1772024308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3WO3LsK3AW3by8XZxWRGcuY2BsjgbgR+h9RmVDdaQIY=;
        b=c5HC6mVxHUmGJoarU/hn9ucDtNTEP38eARYs7GkLJixNnK6ZZJxaq6v19Zi3VoxTas
         c17XPmBkcB7H9z05QiJL0/p5xpEemKiULxKQfn9cOIxLPMllqzhOvrB84V9sZN2fnyQm
         oSF4ZnwVgVX7JtfuikaKshP/pnQahEwBfkiJG7pIazEh7FjlisNNV/pI5jlogJZx9yjU
         ozXTssvKoIZfOaSKbNVWCBICUNsGSNniw7gDd3FeHM8NetVb2C3x9K8jScoSC27zubpK
         omY1IONYAqxzcMQi6hUITOAb61wEpGhYYVMmmjtv6DY01z3ttwo6QR3gNCNBpVghmi9J
         M+Jg==
X-Gm-Message-State: AOJu0YxESGuCzsaYXJwCYkj8EKrAGfmoUvzD5cNR2G8VVqCtdpkAGC0N
	41C4CdEOPFM3jGxWyZhZ13XMv1HM92S05KWAcRU5S52t572DohZhCJXpTcFZjUw3Ly7KK5l5zOa
	FJmcwXaaKdg==
X-Gm-Gg: AZuq6aJ0Uwc6mOiTWLxMnwXhoU23ZFAivThcbhs3C7Ruwdbspe5bEY7E87eWO9cY8Ey
	xswFNsBLa0t30nD5VBtTaD86tNe/J46nfMdM8LoPv3AWjH2ibd+xiS6JEckP0QJN30bJE2jze/o
	E+7rJxuvgr4Lx2YlbGRThECqtVL8aGxad3VFqK/qglFLZHX6y7AqqAIFjVKn12bg0vkuFUKup0H
	Bre1kIIUpZL7Z2LXt5W125YiLgCdZkt93H28mXIQ7vDSGWk9qx32EaUrZ2Y6dX44L0Mq5E7gcKw
	13eFXoxjKL4KnKxTCBSeEA89jdxhq2ztS6SlfLo46xFM/XwprHYatCYu5X8FQaUj9tdpbt+wLS5
	uPWXZ9G8iRXnSrr02NT3KlzdntTnP//qyifvc5jS7igkuQ5lh9GUJ8xe8S3udZDKIh0thccR/WJ
	WteZ5XbbXEK220x5MwPp6RAAnW7T0yTsWOkdGMYy2KAb1L+DbUirkOtzsU1ZgsOUr8Y3r1XZ4H+
	S4qKM+2XapOtb/ChnD4GsAQjrExDC0XF8XKlYrx4R88vHPJPMdRWMd+Zmffr3gpFec=
X-Received: by 2002:a05:6a00:2d84:b0:824:1938:631c with SMTP id d2e1a72fcca58-8252776c442mr1988288b3a.70.1771419508618;
        Wed, 18 Feb 2026 04:58:28 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a2afeesm19227464b3a.2.2026.02.18.04.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 04:58:28 -0800 (PST)
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
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v9 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Wed, 18 Feb 2026 18:28:02 +0530
Message-Id: <20260218125805.615525-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260218125805.615525-1-pavitrakumarm@vayavyalabs.com>
References: <20260218125805.615525-1-pavitrakumarm@vayavyalabs.com>
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
index 0000000000000..857e5c6d97fc9
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

