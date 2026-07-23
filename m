Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B245747DFA5
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 12:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784808154; cv=none; b=m1tNVb1n/7tBLct/6jnFBR6NeMTqSmB+ZbyoezQ2e913RrWSpdOYEzbFov8HcWvtuoHXH1FIQxEx8aB+3NXmYLsVQ2DQPtpaeiIknSEILOPDa8RfQ+pCs0/JMKrnZiBsAY9zJvgYeoGqZRNmtCoEbZ5RpzWflTKv7tqftoc7rKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784808154; c=relaxed/simple;
	bh=HugAla5NxeGvUAW6ybPWIq/99Qvbl3GRpGgOPmECK8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mLfB7a9VVEe+bb2I++oNTd774NDQLp06wvMaZHGs8qHurfVe96IfwnKwXoVgTeX5/YrETUBZBEBG5yTLFoFy3HI9ejlZnXL+uRChYuJ0aOEJF+t/D62PmvaGM+vpKfXrvIdDl+n+tYmXHTvO+zbZm+a5EmBEhxXxQdsNHBBfmso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=bUhJW4dE; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="bUhJW4dE"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-ca766c1c9ccso359060a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 05:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1784808144; x=1785412944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=bUhJW4dEoMf1MPBDa/ByXDHOXKSUk7M1zG0Dufppl9LJwHkrbHQatX97s2SApt5XRS
         QRG/fffRujj4rIgsiJZZpk3lAr1SGObC3nN2wpH4lzf/wrGcGGc8rtyz14DSwF00wB7q
         S9sYzON+WMa2RyFo43Dzqj9er/AtcbB2XSupQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784808144; x=1785412944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=lKV2hx6CkyvJfiiT1o4qixCcPV0aWWTpwToRGyFScNvpBqdEm6/LiIPkwdGpi6yWBg
         Az0QOH77zZcmInwZCnnoL+ooV9u9Hz1d3AgiB4MY5QRgoIuYtaViJBWUYJPe40Pvs81D
         XFzcLuioAADZDHw+p3fqcRmt3veOubzFv2mBic7HeVKtm1lT1XvY4+3KaU8kPld3Hk53
         6j91S/plwkF1MbURwIWObYVFDuSLqA/EbjCFIdlsBufS3K9H05azwXL+pDe/nJt6ziYF
         PnhX9FZ7ADjGY6AsbY6BxnV3swPwgLRahG8ZjpB+el2cYPr+BlK4tEx+H89vT+jcpLhB
         uSAQ==
X-Gm-Message-State: AOJu0Yyf2Jfbk1OrQaZWTgwIaOy54osSCOwu54lRupFvVASZbJKWxfVM
	iTCzCs6AYj3UWq/xcZJhEoiuu7J+mg5drYJShKMySjffmRls98qJY2f5hDadZrLVw45oUxOJfMi
	8IpQ7bZ4=
X-Gm-Gg: AR+sD12Xmh7o09hPD0N1FfDACuXZZOK1XZHOEfXwH8QOhAmp8iQdwCDzaHq9NeW6ZKQ
	HNuOpxusucm4bKIbBzST8VYBgCiwCcuSFgfaEHYOH0QrPoNitJnFvFzcxZqeJ0hmWY9AqOkOnuz
	+qZooeeM7rEgpUpwAH87K4csuD00dG9MLnDSvOc4m+4CS9Hku/bOOunbQRtV5bTxg26QBekUfCS
	IpyJ73onHKEUrI47atSMwd+nDTbatFsQ2hYYNgATlcFVOCdRgFqnGqgsveOXfD09rvbKvOfqO3a
	Q9Doo0+by/z6K9FgE2j5GVaDAZCRlma2R3SbxxlODo88m40C3ouKDoS/FR1f/MJAKBB67uCIJ6G
	DnCyNm4G4XyBeefsOo80+rcAuWhUM1LlAcEiw/tvlrmI5sotjPYQZx/xw33bDbjJ0ExO6vm0Kt2
	wEyzu9WqL2mzRk6fk9QkuOz0xF1wiEpe5Wdb4KZUJzNDq7dbIA5LWU99HRPVRAzhtLVqWn9IP/M
	Xgr/ZFAO49UmQ2vys+Rwf8LyEy37yjz1bhzEnMnS5ljyg==
X-Received: by 2002:a05:6a20:c784:b0:3ba:f5c7:6bc3 with SMTP id adf61e73a8af0-3c44afcd253mr2853658637.10.1784808144217;
        Thu, 23 Jul 2026 05:02:24 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147df06864sm19359125eec.15.2026.07.23.05.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 05:02:23 -0700 (PDT)
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
Subject: [PATCH v18 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Thu, 23 Jul 2026 17:31:53 +0530
Message-Id: <20260723120156.285270-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260723120156.285270-1-pavitrakumarm@vayavyalabs.com>
References: <20260723120156.285270-1-pavitrakumarm@vayavyalabs.com>
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

