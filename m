Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71A44B8DDF
	for <linux-crypto@vger.kernel.org>; Wed,  1 Jul 2026 12:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782909129; cv=none; b=Aqaf11uE1BQ2M4EoDwHvlHG13/qLf/YJPXbzMgtRyMpBdL5zO7jXFpb9NCi5ulz/N9KOSPoRbKY5tMHPOOYgNcH0Bjbw8afhT4TMLkIeFuzRoOm7G6k/kwZE9be3q+8a1Us1zqqPow28NHznkyKJsVO7tYOgmzFGADHGY+ecWTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782909129; c=relaxed/simple;
	bh=CuUxgflABv2d2hkWxKx7KtJacYxGlz4PuMBKL3Eva7o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oiVuVOzNNHharoJ5nLfk1khf3vVEvFI7FdqKP3M0B9TZuIJ2IyCfO/8+0nIoTwePZhdzuaEa4wkJoenTgTDOUwbgiSQ58y+zF1tv8XDoAGfgk8KOF63H6p+e3kDC6pL4QSLMFLBbOp4O+VnBH6HLzLKXmUo7KtBLAN6K7hd/0OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=PhWDb/ZO; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="PhWDb/ZO"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-30e9eefa268so1133324eec.1
        for <linux-crypto@vger.kernel.org>; Wed, 01 Jul 2026 05:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1782909128; x=1783513928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1wAwwi5LpmrlOVfv+9UYg3mDAono2kNVvtVhtpInmY0=;
        b=PhWDb/ZOp184BbGMyRxXtfhmB+J/xGeHrf6WzQgXpoA1UB/JgJ3oFosIlIbav/xjHd
         wCUIpGJQFXXpc1az77Wdmbw2goiut6tP+K93avnKirT078ep+p2ZoAp5Edsa0aYkYcdq
         76EDSVipk7HpL6A7gjsLs5E8IXAsxoN4FqXZ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782909128; x=1783513928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1wAwwi5LpmrlOVfv+9UYg3mDAono2kNVvtVhtpInmY0=;
        b=O1juzX4YbKobWwV3a/8WeBfN/OQ967DfV9MlrhJkRjl2CrziTlt1u8We5InJpVSo7P
         OBdPyLCLEfvF+dNVvv2nZc/2YrYpFI+OofC/yupG4qOEipEFT+G7+qTp2s5HKoyc6I/I
         Zk4CGIa6JS0C/L/WFm7vKauZME4kQUCcKRe530axb0YIMvV9xJlG6k7+TLa/ZoH+yo1a
         TGH6dvFf5pSBAc5VC3IdE8ipRZfFesEpKFDxmRxyHRysufb9J+c6ndUsypDhlFaHyGdk
         WpHXuBUYeHxVmWMwmPvXIcVCEp7ZBJ3BD4cjn2wCRqmAM084DjBG6GP5zXFwF73rzjlF
         LEaA==
X-Gm-Message-State: AOJu0YxxMoU78KooGqPB+JDEKwc/7eiDeYe1TtlIWtr7LUi/Kh/MGRU5
	hyzfMoapMIRPlgVKvwuCXV3Vb1pZyPZm/mWULgKiujB8qc7Oq5BVj54F2dnry09xVSDFXcmkZ9K
	7572H
X-Gm-Gg: AfdE7cmgpmKEbqyacLVqIlHZVW7Wy7lRSh4K3KOZSJvUBECeueLr88/efHn4+UjT9Ao
	nzhn5fR5Hh6LZ4kcP7MfGPzVTaDB84K7TTqAZyEmrvn5uR4suleyKTzNG/geec0xgdKwG5i96iz
	aKiHIdnz97NTMdU680wdNh0nYLOf6lCsMSENoC9Elylh/QMRhzs8Ylt/5mvG5pHQ9EvshxZXMAd
	hdb5dOgRSfgwwgsmyQz8gfishftJiBaavFrEUua6T6LbiqpYSirdWc01kxqMwhyRC/nelkhcV5y
	DLwHEVx6Dfq6Sp0n0KXqcFxZ935d6Zy3WM9UhoFQoq13sPJUcIpbD5sAxWBMst7W9iete1XeE5f
	UCSq5dKcUG3CYqoxFyNYDyVDsKc9sfnDjZ4WMTDgswfGnmD07IFFPasrDuUG2bJfm/ElrOGuVhX
	bEmfWDyKcHE/1JBgZotuKZaEaTYpSmZy9TcrDeuCIJdz7l/BqowGkGZTV6Y2JveBFU+FijD9qt7
	tRjEAB32tF8/Q+XgPiUdIlKHNVTo5+VsmZyWBsFZcYKqtaooWXGyMrzdOuwRkdeZZY=
X-Received: by 2002:a05:7300:a506:b0:30c:ab4d:da36 with SMTP id 5a478bee46e88-30eff335a13mr1728964eec.40.1782909120326;
        Wed, 01 Jul 2026 05:32:00 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee2cd21bcsm40776402eec.0.2026.07.01.05.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 05:31:59 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk@kernel.org,
	conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com,
	rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v15 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Wed,  1 Jul 2026 17:59:38 +0530
Message-Id: <20260701122941.2149121-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260701122941.2149121-1-pavitrakumarm@vayavyalabs.com>
References: <20260701122941.2149121-1-pavitrakumarm@vayavyalabs.com>
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
+  - Ross Bannerman <rbannerm@synopsys.com>
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

