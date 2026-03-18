Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199B5322B88
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 06:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773815500; cv=none; b=S5cR5SwkOoLCILyDkhvpligpCo8EMEvbg6xwKK7ydZg/Bms/Vwx7MKA+WRShM54suzOi6iKCccpjL58Hw1LkUpye/BDGXOFVytbqItJ8iTSVNmRbSIM6aTj5ErOUO4IHmPXatIHsZgJBRKVb/uM0vPLZDB9U31vYf+tMfLASxGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773815500; c=relaxed/simple;
	bh=1rCkpkHyHE3IPuAx81k2bwmc4nwhuww71wQ9MS0fnZE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UQTzVg+QAfXRunXmvZ9SOMQ11mABD6oPF4bvtOzj+jZmMbm8f2nZSvj9MlNj8qAObrtxfX9HIky82f/XjmuO2ojfvQuSJwrOZ4GrZ+3yPCKcfdcMUUISCsjFULS4J6Gy1/W5PMhEslbZPd9vFgsBaWq7Ck0tYridag5pcnu/IuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=RsStoXk9; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="RsStoXk9"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ab232cc803so31079755ad.3
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 23:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1773815498; x=1774420298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3WO3LsK3AW3by8XZxWRGcuY2BsjgbgR+h9RmVDdaQIY=;
        b=RsStoXk9YnpWSFWbW54z9hpv+mYRQIvlnQ0OvKmnED5RINrnIfHDLngLc0uwnLa6OX
         xkfsdNXWeDlZ1fIDcWovwFd8ZOZUEefYmGUlsUPMrX1P7hiWlupZET3ixizrcfjNrbAO
         0rz8qH0UQ+8ll/KI/EpHUrhxjduk/YxYxZVZs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773815498; x=1774420298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3WO3LsK3AW3by8XZxWRGcuY2BsjgbgR+h9RmVDdaQIY=;
        b=MB+J0mZosITAE4j6fV6V101bQSV03sIrwiuxYbWerHpssi6HiptJ/k9WTsaZhWLWW6
         ixI+suyF/30w2rjotXrp+qwTgWbcsaNqGDGKDAINfhX6CstPM1BvuvlhBfk9fX4r+D4k
         FMV10hNGcq9id7yrk7xvv+iMH1YGgOk2vTly75OeTva0YGWcVvMTAwBNTqGPwoOfFJse
         UmgudH0rJ09DF43+uKdcmxpbDVbz+NzZb31vMdgjdHFBjKr/fWaDZ4IZkCA16vWQEaWr
         B6sYWvYsG1r6P/VaXAD0VmAFuZA0w2hWvfW+eGcUvT7kcE9e3o9JlYVsfWnlIKF056G3
         unEw==
X-Gm-Message-State: AOJu0YwvrR1v61Kt714UuKs1JDuAUvqEt/2IB8+s2B5+OZsiDgpCOFvH
	rgVyQmNbkdHlYe7X9FhKIe8jAVeTVklbp65NPO7zU+c0LzqwkUQaNputb9/nVJIkMMSQRY97IbN
	jC2Z9
X-Gm-Gg: ATEYQzz2NXH7prGQTlbXzXT9gvvnUoVcP8dtie9nBCi+yth6YMEuPdHvp+vS8D9jQbW
	rAplyfVAR+YwcmkO+f2TLzN8v68P6U7D5PJYpf92mFPtqMHhBa0aiic6btnmnlA6uIWlqupamVv
	hGKoSdnPeTawtEyrokfMamL3NJjf8uTsLk3prI2zuuRs1Sh6Yue6hVufRe/8ks+70G6BukieVIj
	pnUxOzlOPQ67u8/Krq0z9LhhXpzc06ZuQLHT0Ja7e/WG6iMxtdWNQIxwaMU3uWJKHc189PEMZzL
	PGFl4j8AEgqyANEQ5ibecvZ+/hnZblP8LFHW4EWrTpJ/fXCJsJh9YDrj3NZmaPf0yS1qgj7LcZR
	jFZ2m9Y9uJzwOqEESjTBNU9pdVFcPA739YWe/QXz6wvgBSyWaoBGxTztoEcrU8h8kljZWbiXH5m
	gGVpegCBA0KH5g9Qo4XCXfgYGVZ0ec1UskOcubk8t9YA0gP8Baco2wQB1q/ls8HQV0n3MknzQdY
	FU6cihyKM3+BKAOWQslHZgwk2YEwvZkvvQaIBXJ0tCWERo18KMx7ZUyU4YSc8mvghg=
X-Received: by 2002:a17:902:ea05:b0:2ae:ab2b:bd75 with SMTP id d9443c01a7336-2b06e2fc015mr22581335ad.3.1773815498174;
        Tue, 17 Mar 2026 23:31:38 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e5ef3d1sm13620235ad.38.2026.03.17.23.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 23:31:37 -0700 (PDT)
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
Date: Wed, 18 Mar 2026 12:00:09 +0530
Message-Id: <20260318063012.816060-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260318063012.816060-1-pavitrakumarm@vayavyalabs.com>
References: <20260318063012.816060-1-pavitrakumarm@vayavyalabs.com>
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

