Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7FC202C29
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 10:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785320823; cv=none; b=ALJludiFPFgN2gd0DY9K/ftmmSYdh/nKxYpENwP4GaIfD7ut2evRO4LG1aOv9mFZdiWuS9pG9DNv6eUcw79s5s8wq/1yNmMrfjFsIpOT8ziaCKnWV8GpRp7+mSDpDci9LkkDvSE5EXfe7n14173TkRcjBQDPvj+7AkNFOXX17Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785320823; c=relaxed/simple;
	bh=HugAla5NxeGvUAW6ybPWIq/99Qvbl3GRpGgOPmECK8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dddSiLRWsjqaHT1gpcOj936WWrhF1BnxatoF/gxpDw8myrkc4dRAxRVeFn3uLjhXijinaYj9gQuqpcCJAqy++e4Tt5FZykecIS9QYLXe08rUr2LdKwrVlQgJLY9DHWSlCDpIbba7ja/CMvQvJstG0LfBHI1OoBwuSXCF7CJ3iT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=I32AuaBu; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="I32AuaBu"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8485bd28dd0so796048b3a.2
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 03:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1785320822; x=1785925622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=I32AuaButFyQjQn9JXqefUchPGOtlyEiLzdmIyhrzbSYnykIw7aZP8hjyS41Ni+5r2
         nZ8zm1hlKttZ9b1R3XaqlCrKgwr3Fu0nrhnN7CZtXhRBQrYCznxwIHeDigXMOaO+PXA0
         XYOw1AgE7YpdYk8PhF5PHWG2ebGILT/8USwFU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785320822; x=1785925622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=PMqklgBQsLeCzlAuQrL8Jnrwc/VH0YU5DJbo3yM5lFjTDRRY6pQqdL1Ewxxs3G8IxI
         GD6oGp8hs0t3HY3ElMCfhUZI3pZYBcoZI3f3uyb3Vbr+h/algJ2MitNhAOkBaecaR5vp
         VfPGN/TMx6v5QLDQS0Lr2dxEkb/aTUC2pxYpdYbHU34202AaoPOlXrF0+WKdRl7hWVTb
         +6dsC6UdQhqtFaarN97jKZWqVKK8Dvrhm2z8k0eGZxebwczBsnJbSTrBQ/PC0EtfrK0q
         TGB4rVBtfWaNvgb0dtEKi74tYH1QKnS9P5Ijhl82zFT74zYpj4DoOP/v8Wl5qEDywHHO
         9HUA==
X-Gm-Message-State: AOJu0YxbGV+vzxSdSXezFsT1x3s6+zpY5X+GCS9wvnSWXrphNO2HlC47
	zbMj6Ru7+PXV8hjZ1yL2fR2Gvh0mGpVlqAseLNGnGTKNx4CY+gMOz+b6S3WSPuV+TVCGOdeKQ6t
	KrMt94gk=
X-Gm-Gg: AR+sD12vnezi+GVBwaOtIAiNtlkKAjAbunEiDY1LwJQoGPIj218/GqVTap4Hn6QcNOV
	pc1OEJCbXMmzVUlcj89KAei0ElVwgMCfP3gDcSkvq5HBTt7PdOC1awFpKXdyQhdIW5r1e2gaTr1
	UOE6UREQRbpo/EtNHHO/lQEGoiAK6AzzbiqsuFUvVK5qkx1rA8aFMFCtFEjnG5isDcxXoMz7ZuK
	YIRlJhE79NPsYtxEAbFUo6jP/XMmJkAT4u2GK5xWeP79a+1wFUIZL2L+23Xru8HFRklJI2Zqwk5
	bAyeTsimAjvtiwmxr2lpJRmIHJDrdI1Ld14Udsa9z17srUTcBVwChAJiHhcgxIHdvf3gmBizRep
	JusfXEpwPizzsj9yai1pmN+Ygcr7YclezjP3pES0wl39vySgM/PI8EEagCi08fabqM0yvIQ4Vrp
	/TnwDzNzsy2yoR48VHkH8nlD7lyK374wB/q5x/acuTq2UzuZln1KbXpVouXq6S+lfNvjScgWId1
	w1/xQgeW9a804J5GHStPM1nksA9dVh8zZ8Pbb+NnYUMMO78QebLYqIZ2Rv57OM5YQEax+dCXc7M
	9102Lo0bykjp+oVI8CR6UYC7Fh0DBhTzyp1xMFU=
X-Received: by 2002:a05:6a21:6d9d:b0:3b3:26aa:5455 with SMTP id adf61e73a8af0-3c8aaf7b161mr7891708637.13.1785320821722;
        Wed, 29 Jul 2026 03:27:01 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504b15f77sm9238958eec.4.2026.07.29.03.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 03:27:01 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk@kernel.org,
	conor+dt@kernel.org,
	ruud.derwig@gf.com,
	rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	nazim.khan@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v19 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Wed, 29 Jul 2026 15:55:44 +0530
Message-Id: <20260729102547.159890-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260729102547.159890-1-pavitrakumarm@vayavyalabs.com>
References: <20260729102547.159890-1-pavitrakumarm@vayavyalabs.com>
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
Acked-by: Ross Bannerman <rbannerm@synopsys.com>
Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/snps,dwc-spacc.yaml       | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml

diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
new file mode 100644
index 0000000000000..a337f7b473cc7
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
@@ -0,0 +1,50 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/snps,dwc-spacc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Synopsys DesignWare Security Protocol Accelerator (SPAcc) Crypto Engine
+
+maintainers:
+  - Ross Bannerman <rbannerm@synopsys.com>
+
+description: |
+  The Synopsys DWC Security Protocol Accelerator (SPAcc) is a
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
+        reg = <0x40000000 0x40000>;
+        interrupts = <28>;
+        clocks = <&clock>;
+    };
--
2.25.1

