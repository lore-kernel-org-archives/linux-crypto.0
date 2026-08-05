Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2F1483BF0
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 16:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785948527; cv=none; b=emuYeEQGstnQo/KJ9fy9vpHkMSeAA6ewLiXzofl1JOhs/j3KFoO3RDeD4x85Dke3A4rBB79EwpKVu53/NdzMU5cRuKSVrLBUr7t4MK7MkutTfh9ZsVSMgBcCBFvjnI5iJ2zTK3dhWiMTTJiBTSIvmkC+cu8UHdALF4Lt7hOI8co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785948527; c=relaxed/simple;
	bh=HugAla5NxeGvUAW6ybPWIq/99Qvbl3GRpGgOPmECK8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H1FZQ16wlB28mfrviNxnB9B3I5iEVY2cimG9F9sNR0CQXu/mEa4COHlxra3cvWFk3lrFNXUiJqpYhIl3aN2hbFL4nXlY0E0YP1eBGd03tEckY++QR6GE1AnnJM+5y5fbpg6XQot8yqy2sGu2VqTvUMZ6Gu2VVBSElT9NLtX6qkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=fvJ9zay7; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="fvJ9zay7"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38f620399a0so1117088a91.2
        for <linux-crypto@vger.kernel.org>; Wed, 05 Aug 2026 09:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1785948525; x=1786553325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=fvJ9zay7aa9DWsa03m0nxdiOS+uCg2XCnfpaJorxDI4yUk9ox1DZ8qZVp4+1w3CUak
         P/ja9QGwFnGw3ISXw0VC7nF+dnzvnZqkHn1BsjI9QUGB0bH5MMF9b8K3boVMV4ymCVWI
         xNTmyIvbHhptP+ftL0GVMo10WqMfepU21ej1E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785948525; x=1786553325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=kY10SoZZt46BTkclG2g33pXNoDE8rM9hjdKqysUBU7Bm21YHHqagcFamYuOlg07/it
         maoZzRYxEiwF/cMi83k3xuNL+Z1qn17Cea/zkEPhKkWty0xHTfnrS7wqF1Ma6/3x7GOC
         EHA9BfDwUPetrfx7Uw3EZqZgnA51tfipR8RptDpt6vosWDj9RENexfw37ZsleHXm8SAo
         JWtHjaSlJq/cvMX6BT+TsM/2QqOzWKu+gZnvZo8vH8Km8PKmhc4INL70a9h9IRr9HgwC
         HvXXzk5BEltUwMQkOVLPOFDg/UbnZ4bmj9S111RLxsMO6JO43b64zEXQJnCGtSlUJd8D
         sytQ==
X-Gm-Message-State: AOJu0YyJczzbXS6WCS2CzledZzhBz/7woudzC3eIrGUp7S4L1Ji9Oaae
	oR9XbNTZuWkSDHdHPyiaPxMSUBBg7pElOgdIq4gpIUJjMnzx47CZFbrtCCs59AhmnwezPng+jrE
	0HcT+yvg=
X-Gm-Gg: AR+sD10kamOSum9Byfpan+WCxjaOVPZbaJQN4aAsk6bNPvKt9WqNp/MbE8OzORj14nr
	fPQpcIGZ0EUUJYo9FBVN+QrqNCasdsPE7crVJ2b4UUUpf3EcAIMEvAVgx+v2oceGBMI7f9AcXTs
	Ke37/puzYQk66TaTVc4uscDUFl4nwfyg2xv7D6z5vKIaRj8pp7M+atPy06612sS8tZ5CUzoP/Zs
	dswopovAishqfN+cL9E4SppzcqByFcmWurR6fJT+8ZB3Cf2IWSeI9qiSqjdjkZX/HP+7WJ7lylk
	NI73sBLcuVYqbtpzUgDehDonydxGmmxWZSUcr0FvW9/Z6GdkgPDuWkLcjUDn9qw1Z5/rlhQ0GJF
	Zgb9RLOriYDBBTb8/U5TnMte6PIs23yu9whwFsUNpoFbdYKSuVhb9NLe/LeWASI4jkhAzAv6bc8
	LcxAVTBXJy+rJiffTcAQxf9P4iXAiVckaK98M42MYLXJhyKEHj18RyYsQfzjKgzAr39L+o0NTB9
	4uYclsvPBWbnED743SwQFpGPUF72Co0bbQVzTyi4W7K+bj2FOLlNna1rZj+G5F42NJCcDeeWvii
	V8m1z1fVChdCJ+Bx2X7kJ8s9KmKg
X-Received: by 2002:a17:90b:28d0:b0:38d:fda6:4873 with SMTP id 98e67ed59e1d1-3903c57a0bbmr8190897a91.10.1785948524816;
        Wed, 05 Aug 2026 09:48:44 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315867d7e4csm18358677eec.31.2026.08.05.09.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 09:48:44 -0700 (PDT)
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
Subject: [PATCH v20 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Wed,  5 Aug 2026 22:18:12 +0530
Message-Id: <20260805164815.249328-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260805164815.249328-1-pavitrakumarm@vayavyalabs.com>
References: <20260805164815.249328-1-pavitrakumarm@vayavyalabs.com>
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

