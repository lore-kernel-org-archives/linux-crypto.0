Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA09C301474
	for <linux-crypto@vger.kernel.org>; Fri, 19 Jun 2026 14:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781880410; cv=none; b=lT7GbgEmAV9B2gchExi3aJbuxYOUKF0BY/0UTYLyfOGCWtiCz9j9PhYia9lO/Igu+P+e6VusKAUM6lBDtV7M2WXlge/YnPuD0hjeFihua2lCubjCVGa6dulOVXeYmJ27i/cXtR0Lrn6lyDtt2+PjzdTmOdNIWDWDcCR+pTfS6ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781880410; c=relaxed/simple;
	bh=VwwQJeqWDmVBmZQDyOVHyUnv7kj2BXGTz/LVwYl1y0w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FMi7xmA17NXGuaoJPLyP17y1/1W+TZUwTivp1UfFJ0v+CHe7NGAEY+pNNcGW+PxOXjCoPWQk1ha03HR2wps8GP8whp82c3OXFbWK2fIadZVXPVIBnrbGPlLeFv3fepypWpEyGMZ2B1QEKHzOZHLz1Ni8H6wxSYy66R1FlKeDjWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=k7V4cZRI; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="k7V4cZRI"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c86307c4e6bso990352a12.0
        for <linux-crypto@vger.kernel.org>; Fri, 19 Jun 2026 07:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1781880407; x=1782485207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kemVDG0Oly3DI8A7HWUfa06UTS4au9Nb4+LLiP8cDDQ=;
        b=k7V4cZRIRphCYKTkY0Y0q+ILbPJMLvEec98xqo3c4Bj7NXnEMjeR8d1E9FBOdyXQyz
         XR0wrUDr37FoR32pf+ccaQElyQKFnwygEn80q3JyUzfQBLJwf43YlCFvt6n2YE7iHDed
         rBqQ9VffxPohzeq1JkajDFeeuioyXGOlnXe2I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781880407; x=1782485207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kemVDG0Oly3DI8A7HWUfa06UTS4au9Nb4+LLiP8cDDQ=;
        b=h56/ara3pETQ3Bl1r7AlngroKtokJ5ysMIl4qi4/RPx2p7bXa2RoaTOgEx62FbIRjW
         6Lhddb2+ihaK5JWXNMKgvjqGfaEUiMVMxTh1B6NAYY3LPrxra8M9RwLoLhdybocpEhmy
         Mrb9p02PcnhT5Tiaz3TmADTMCzwLJrKYjUkkw0QB/FEnk2m9gch4JHA324f07uZfnEoW
         fUdHS2ZheOrQPSU2cV/WlwymF25iUgWTjIMMg0DoLaNPZ9Eo7kRv3I5eEg2t6iUhd0Rc
         EEngRQ1TRubesORxt2iEwq3mkpZh3X/MUzU43IjRydbiW+8BNWkKJvJW7l735qeU2bgB
         a5xg==
X-Gm-Message-State: AOJu0Yzr7jA3GeMj/SJ5QUJ6TCYQUNZnRymJEZ+3er3YUuMxVeKmIoK/
	ICYrGRLCrBKTOgSk35U6lLaOk+A2y6+oEkihJ9tgjQfx/6ohS61WeUOsdixY3eR+P0dh6PyWP6f
	hU/dl
X-Gm-Gg: AfdE7cnl3AGPruPuDTmGZNwSNH91D5t+/+KTjG4caP0kA8L3qxfCOGi6h+66M3lSlao
	KkSrPBuSAH3T8SILJHB/6Uk3mLh8gx38RI3wzN+Gs0LI+vwBiYJEXVoRU7HaL45MEn0wVkrWqJa
	CdKaSM+4w9RlJrVyyF3DjVCXNDWCFuP/6UPOpdjQy/dOdGypHu/mwW9KzUOcrVHUCs4N33A+n1m
	tI9RNa7Lm7RKAFYjrOJxUl7HGcWR1+E96kvtj0PXNZGR2glYiE2NIbjrAeKnxD7eUNNRJWkFTj9
	605FDXOGCGyz+Zn4vcWz96wfXijZuxlQrpHfTwc+GT/1BsJRp22IFpH2dnVO/1wSJpv2pYP/dk0
	To1bJ6bz/6XR+M95m+st6nMYcjQlnRwTu1RPrEVjrPSyn9WMnLmWM5WfccyXiYpqx3rNdWdB7+S
	NJ+WHArex0rL3Bi8SF7y9y/UPHdWV6vBHU8SGjcNXbbO7ZGhtNqi+mRYkcewsHvIqpWvDaeIiVc
	onD4ysgUAAt4F0+MKL1UzEAEDqgx5VzOMAS/ML1pVut/u44YSf2Sjf/yLaEfHUdWN0=
X-Received: by 2002:a17:903:1246:b0:2bf:1e37:a2ff with SMTP id d9443c01a7336-2c71895901dmr44555855ad.0.1781880407608;
        Fri, 19 Jun 2026 07:46:47 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c720899fe5sm27163595ad.16.2026.06.19.07.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 07:46:47 -0700 (PDT)
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
Subject: [PATCH v14 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Fri, 19 Jun 2026 20:15:55 +0530
Message-Id: <20260619144558.1868995-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260619144558.1868995-1-pavitrakumarm@vayavyalabs.com>
References: <20260619144558.1868995-1-pavitrakumarm@vayavyalabs.com>
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

