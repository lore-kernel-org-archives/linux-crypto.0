Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25562C0266
	for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 07:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759131846; cv=none; b=CTcYSpHMqaC7Fg6lGx8vrYNwcWs6Pm35bybdr+bX9qRKWayNjfUZAiKOvKCb5kE6vpAe8qlhqt7ee2euctmyyKWXtnxbMNVJakQkqsfdzc5fcKsWPZExpj5ksPBfHZazRWSMjfw0hYFIOF23bNNcX6rBciI5ZFuSZ8rt9MRTcGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759131846; c=relaxed/simple;
	bh=VqneJzSj6ZAncie4Pm4kr22vBIPcmTH6MVSrCpJuRgA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ImLfBo/qT6DmjRmaC1OunikpqeSYicju5mzggQtGDb3r2BH1tX9BJiz4880X4cD71JJCI7i2VU1WByJ70FeKRqveS8ANMvQDJZuFfjIE1BvIGGVFM7imU+vn4f/fusIaYrLPm5W+wGBxfFjNZhZ4Dy+2XH41+fxjw4UjQ0Aydz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=mGr9sWhT; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="mGr9sWhT"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b5515eaefceso4172252a12.2
        for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 00:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1759131844; x=1759736644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhMtSPXj9mr8UNmQXgxlkL8r6YPZnmm760J+NfJOOMc=;
        b=mGr9sWhTpQT12zhTVLvLgPf7F1E1um9v/wu8W7ihhItPsJyvZqUrwLnkvkx7Mc0viw
         6LcSoIj3ltIsFjc/d+Z6p1iwCq987x9Anyq6E9ZjAHyeBET7pR4NMvoQXDPkO0jFA1Gu
         C6+0gh/zS1ogud192q67/V4JEgJ0QbJ0LenHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759131844; x=1759736644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhMtSPXj9mr8UNmQXgxlkL8r6YPZnmm760J+NfJOOMc=;
        b=E6+uL8BDYmGs+3utM/uo63qD0alsXjZQJCqVV9D0byuh9OLlYjA7SG9tiTn5t1H2gY
         Ww+6sZ9rVXHZwwBlPpQ17FOFmJ+GsVc1bdGvHeeXpjZhP4KjAboT1WEHWFCTVoUTemqq
         E+u0V8WyLHzJf2LOeH7Cx04vj4Ssx9wWh37VbuQgKHFJ/5qIKoiUsIauzwP60M4DqdpP
         iTRPyFh4V0+lcmBroN+YheRhxAL1pRHP2QY6h6l3QLh9UFj0ZoPKFMzRJche0Az4b1iG
         tIeiTktvJWP27izySt6fplFDemRNl2n5n8x+cnOeC8ZOZ9Wd03NnLNHh75aTzsNhwr7n
         78Nw==
X-Gm-Message-State: AOJu0YxVx91mbIKn0d/jz6yNDfTFWZxNK0TX0M2FFK5tK2kue9sWT0KO
	d4M6g1T0qagwjW7IOBosKFqOY1FPrHQy7std/e2XEfo3Dr5aswDk9BwvifwRPXptOEaY5aBZTpk
	/VP+yv2A=
X-Gm-Gg: ASbGnctRoZ+0Vyk25M8K/V6AomJOj6DVIkyFKcPcqfkYYjTJkoSytxL/gebufStx5LF
	eBWeH0X4e3XIMet3tZ0z0srUb21Q5A6AS14dXm9KhSp9/xM1gBfgZ2CV2s9Q4BcaVz4IgauAK99
	n0/n8pemjfgaowLbMx50BL7eaxUWQhYcd1d0zJ5bnAOiCv+sx8tBdnyZXEJFvmiumUcGA2GAimh
	BJF2m+Rz5Uf2+FPUPiCx+GSnVkQeQNobN85ldwDb8o1blCPmd2nCiWujteT13im2ICtdZHWsEOR
	enpfK7wZwcOVT6vpbsd84wRDP7lU9moKLaj/TJ2aHV0EKgxMQTqXRhbduLjH4WbxBvpHvHg8vyX
	Y+CNrekSrpK2TwRVgfMslM8z6jLSa7m8F4iCfBwPzeAiWfA==
X-Google-Smtp-Source: AGHT+IHxrZbPwGSttT/rK/3nM9d++wHRed2uyihSorrTkwzRs+DsdBy5pvENJ/cXjyA0kBi6xWr2PA==
X-Received: by 2002:a17:903:ac5:b0:269:b2ff:5c0e with SMTP id d9443c01a7336-27ed4a4959bmr172403005ad.46.1759131843753;
        Mon, 29 Sep 2025 00:44:03 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed69bc273sm121341105ad.124.2025.09.29.00.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 00:44:03 -0700 (PDT)
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
Subject: [PATCH v6 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Mon, 29 Sep 2025 13:13:31 +0530
Message-Id: <20250929074334.118413-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250929074334.118413-1-pavitrakumarm@vayavyalabs.com>
References: <20250929074334.118413-1-pavitrakumarm@vayavyalabs.com>
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

