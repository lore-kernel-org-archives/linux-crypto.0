Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976F621D596
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 11:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781696693; cv=none; b=YXXuKRbJqsPA0lHWCzjMdSaBJApRgjpks5nevUe1MRutXk4julAVVx6c8wYYRQ6jn43Yk3xkzsfrHeuoirewuWHH7SGSYKZTeUTFTDeWN0PcqEO/UoHFsIgLEUWTQtoVswTf2gFo1XgQH0D/24sD/fuIBOe3A+ge1WHqu/lDvF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781696693; c=relaxed/simple;
	bh=6PRiza3LXnOI5sh399qO0oBWFGp2+hOMtX90PkVi46A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T7di+U+wbONqchbUQpAc2UOl4XhY4t0rBMvdAjFta2G4EAFEoi0BHc6Vx+IqEdPC9JNEBWmYqD4xeWSbEePgwmkIgdILFVXan+Rr8MGqR9zZJeWjEu6B0A9oxzinB/rZ9ocLt/73qwXMj03aj7n4a1tXQ/1A5YifvwIcxJmyzew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OuOuDUPA; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OuOuDUPA"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-46066e640easo3485919f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 04:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781696688; x=1782301488; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HPDJtP52p5BOP+sKi7OFUfIBErlWFolQCAuHzVeCjRo=;
        b=OuOuDUPAR4dq8V67wlZu7BAr9/kD1BFa8qxQw1eYgvS3cMky6B2m+oj4ev2J45pFHl
         ohkYTCy65X0vyrT2yaIHC6Eqb1/cfcHm+4j0NhWjvaWQ3/aqiVkIlrVEfj6SHofeDoX6
         mgCfsTyvXB4lpPOspsx8ihJ0RG8gdf/TWqlVkPuzGgsUd47OioRCLnLflVKAlZ/beRFp
         2CwwOJkg8hgXgbsGyaSvoxACJ+9tkftqjENEcK7gOyoBFaehk3/fFC514Bqp2UpYv7Pe
         06YqDMd7t3Hz/ik+8AOxX5ORR3PVIwJXvBknn99T+Y23HCnYqByfj/G0nOE/pqoLB+xr
         rzjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781696688; x=1782301488;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HPDJtP52p5BOP+sKi7OFUfIBErlWFolQCAuHzVeCjRo=;
        b=GMYC4rFO66dxu367ABt/42N1QFeHgxCZpIF9N7wjawzMLZbRgCCJWOkY5mzhkLxsD/
         VXsxBQYaYT+MX0184iCIOlY9m2y2g2ucRp2oHuN6VSdvo+7E0OIMnU8YbvrKRQFlg8Ks
         dfjCRAdKBIWAl16byuLNbK/h4ChEOqeqHwp9bpsfOfaDmZZGmmg+nW3qzJ9ah9X6CUfK
         A3OQPp6H0v916qIQNWHhba+Jr/SBY/BzWzNYW4YwjqPmicggRYj9h+4jFX8rOoIPWQb2
         2hZsiWc7zyDCR1U0N8ubEKPp85Bfhhaeh4TdAzJEFzab3gqgESU2WeP5XVGJdbk4rVQ5
         pqzw==
X-Forwarded-Encrypted: i=1; AFNElJ840cnQ660QqbuBbHBozdwRaWph60kGNnu5e1z+P6UGUxASEuoksULRbsbNmmFb1EgBn85MzxkKIGp3pUo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEr8ic0B/U1L5nStmRoPN9jEem4Pu8GNZaixZhlQMzjJZZKktQ
	BwgX/vFQP68uXSjvDD8lbQUFF54xQABafTMh15PwJ0Olr4ebZFWS++7L
X-Gm-Gg: AfdE7cny0mBV4pLIOZsTudocEoUFXzYrfMxyW7FwkwhkNK8MomDFFn6WK+BBRoYE54M
	2IAlHSVtRkH00UxNfe3ZhHuquO9Bgie1Yv/5koZ0DRpholDmT5X5oAV7pFNX6PjthwgkmWKON9v
	sF5LhiQK6S0EQgGa7lHgeOcp7DhpjEqT3SV9nz3ZcBP43XlSWjHy001C+3Q1QqOH+8e2x4vlHtd
	AfG2QelujlGwXv+PArGT8UTTVXA6APYBvkIW0Xa0RtzdNqpPPCU2O6K+psggrtL8ROwrkKd3dJz
	bdsHjRzR90MpdzGLPk8Y000CpxtMFVUeWi7INnqzqUoQjLMDNR8r85i7Ndf3zQAA0LKJG73bvoH
	2C2iC3/vFx8f7ZNOXFxF2YwzDudwa6v8ONS6YonamSfN/SMRoNwA67sOJ/WfRmlsxLlyZ4HT7zD
	TNgBbxJwbOFKEgWrUsF5FXyZQYGVzB56oBNzEDtrTRiN6yRLmsJuqCP+r/Qpftj18=
X-Received: by 2002:a5d:6109:0:b0:460:e00:121c with SMTP id ffacd0b85a97d-46237b7179emr4214957f8f.28.1781696687715;
        Wed, 17 Jun 2026 04:44:47 -0700 (PDT)
Received: from fedora ([196.77.26.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c4240sm48998658f8f.27.2026.06.17.04.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 04:44:47 -0700 (PDT)
From: Jad Keskes <inasj268@gmail.com>
To: Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alexander Clouter <alex@digriz.org.uk>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jad Keskes <inasj268@gmail.com>
Subject: [PATCH v4 1/2] dt-bindings: rng: timeriomem_rng: add reg-io-width and mask properties
Date: Wed, 17 Jun 2026 12:44:35 +0100
Message-ID: <20260617114436.1909659-1-inasj268@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add optional reg-io-width (1, 2, or 4 bytes) and mask properties to the
binding.  reg-io-width selects the bus access size,  mask is ANDed with
the raw register value to allow only the entropy-bearing bits through.

Update the example to show a typical 1-byte configuration.
Update SPDX to dual license to match kernel convention.
Drop the misleading '32-bit aligned' constraint from the reg
description since alignment now depends on the configured width.

Signed-off-by: Jad Keskes <inasj268@gmail.com>
---
 .../bindings/rng/timeriomem_rng.yaml          | 48 +++++++++++++++----
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/timeriomem_rng.yaml b/Documentation/devicetree/bindings/rng/timeriomem_rng.yaml
index 4754174e9849..740bc52bf474 100644
--- a/Documentation/devicetree/bindings/rng/timeriomem_rng.yaml
+++ b/Documentation/devicetree/bindings/rng/timeriomem_rng.yaml
@@ -1,10 +1,16 @@
-# SPDX-License-Identifier: GPL-2.0-only
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 %YAML 1.2
 ---
 $id: http://devicetree.org/schemas/rng/timeriomem_rng.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: TimerIO Random Number Generator
+title: Timer IOMEM Hardware Random Number Generator
+
+description: |
+  This binding covers platforms that have a single IO memory address which
+  provides periodic random data.  The driver reads from the address at a
+  fixed interval, returning a configurable-width value masked to the desired
+  bits.
 
 maintainers:
   - Krzysztof Kozlowski <krzk@kernel.org>
@@ -13,9 +19,17 @@ properties:
   compatible:
     const: timeriomem_rng
 
+  reg:
+    maxItems: 1
+    description:
+      Base address to sample from.  Must be aligned to the configured access
+      width (1, 2, or 4 bytes) and at least that wide.
+
   period:
     $ref: /schemas/types.yaml#/definitions/uint32
-    description: wait time in microseconds to use between samples
+    description:
+      Interval in microseconds between reads.  New random data is expected to
+      be available at this rate.
 
   quality:
     $ref: /schemas/types.yaml#/definitions/uint32
@@ -26,16 +40,26 @@ properties:
       instead.  Note that the default quality is usually zero which disables
       using this rng to automatically fill the kernel's entropy pool.
 
-  reg:
-    maxItems: 1
+  reg-io-width:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 4
+    enum: [1, 2, 4]
     description:
-      Base address to sample from. Currently 'reg' must be at least four bytes
-      wide and 32-bit aligned.
+      Access width in bytes.  Determines whether the read is performed as
+      an 8-bit, 16-bit, or 32-bit bus access.
+
+  mask:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 0xFFFFFFFF
+    description:
+      Mask applied to the value read from the register.  Bits set to 0 in
+      the mask are cleared in the output data.  Default (no mask) passes
+      all bits through.
 
 required:
   - compatible
-  - period
   - reg
+  - period
 
 additionalProperties: false
 
@@ -46,3 +70,11 @@ examples:
         reg = <0x44 0x04>;
         period = <1000000>;
     };
+
+    rng@64 {
+        compatible = "timeriomem_rng";
+        reg = <0x64 0x01>;
+        period = <50000>;
+        reg-io-width = <1>;
+        mask = <0xFF>;
+    };
-- 
2.54.0

