Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A14020CCD0;
	Wed, 16 Oct 2024 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729091970; cv=none; b=EjvnExoMDE2eSmn2+PcnyzsXnEPy+OMnqrJFxBOBIFEO5FZxsCXHrulVMgiqMJjUKRIjBrfisQuNP/ulE8dbPZAK2lEMU43JpwSG38ni+bYleM1sZ7IuqtgaVGGAnjvk8j6ndHjYokKzeQOwm4XiXRDUyVTQ15chcTMMzXTeGcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729091970; c=relaxed/simple;
	bh=9eQA7Mrnz0T/jqiPyQO6qRTIPGO522pJDaPgx3LSD18=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=HQD6bFqqPdwMu0mbL1jZAUkzcXPQwl+HcI+KAlkJv4EARimd0UuNUfzAFIJQ6bwjLwR5bKw/KVk1fcHbKsQGY2ayxYx/sze9ZPJFeMuWEfzVk5fS2GdWTDQjFMwUHySmcB9U4Jox14TVagy8yTWdBByXxvTUnDv35q/fqj2sMFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m1etdV2t; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m1etdV2t"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2fb59652cb9so27114871fa.3;
        Wed, 16 Oct 2024 08:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729091967; x=1729696767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=WxzJMq65NdH0fxsJEWKyKowEXDFQj7nxACznD2f8fi0=;
        b=m1etdV2tWMC3Kgh6LyxdU2HITuB58CmnvrsuLF3VcRwGyuKV/dR2QycANFvKFvtmBv
         OrPJ6TIO244RWxkRl2o/jRqFZ74lBTWDjzXCQKSdH2rpyWLzj5LlGpEhdSXP/ClPT4NU
         YBSP9XcJchJ52Kk4j/T731TqqXS9RL/pCY8LP152/R+Tf+aw2ozFeIhEqjVVaq7W588L
         gEh1KjNRpsjEcBsUEDB6YSTPqkCBgal1hfu+j7ntiGizpjhttotgh7oUgJ1l5C8p4JUI
         bd+kSlf9xZm1l5hlnE0x6awTbgC4kiBbE7wqPRZUKu7a04uhrYdH5QjZJloHXBGoROIN
         xv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729091967; x=1729696767;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WxzJMq65NdH0fxsJEWKyKowEXDFQj7nxACznD2f8fi0=;
        b=K2zl+dlbn80d4Y2sAw1ig67+73if3J2+TXxEoy7Vt6SFzXZERxJ5nfTVlf78RoUCOW
         Qt0HITMsHzgVbYMLdVcUcBTl+XOgCVxfmEuszMDvYMtZsx8D9a5U0pP2GDCt5ZOO7Dbw
         ovnlPkLghha6tyCF5aomcFV00kPp+5v/lpAh6EgseKhuLwjjTi6+kDyFY/2TaOifhgx5
         A5VxwpTVtqoxnRzr+ub1po4ZW9/PxRRpX+x70BGD4kL7wf708FjNnBwXqeIQ0IkkAxJ5
         pl/QCmAjnxwt7ZxUU2lVqOVQnAXn/ZJCh9WeHEk5U4zG0i9XFB88PFl0eSmyN/efHlMT
         4UmA==
X-Forwarded-Encrypted: i=1; AJvYcCU+WwOkqheZ0JiR54MiPV5Tpp4Qq51cUO1YhSigIOoyKAwx4RMvtC0Rk2QxwCn8q8iAqPSWcG4pyUKT@vger.kernel.org, AJvYcCVr3ZjJrwv6jH7Czr9MJEguCcyRk5iCxxN6MHzay0G448Rh1wfLhAZLcOfphDmR7Nbg695UE4+Fx1WW9Yhv@vger.kernel.org, AJvYcCXaqRPTuiMIj834E6V9HNLGiHUcYtUFrHJ9eh7QSbDb0dy+Es5OBIZqY50V7UaB/zKHxE0SxdbSLD711Fki@vger.kernel.org
X-Gm-Message-State: AOJu0YyqAluA0hTp7zvNx92yRD2RA2hcTPS6deUTfd/pr8iB4kYB9Kye
	vcnF60Sx2QO6HGtYiXW8A5yGLqgKmzwYg1IiKOnqK6IbraRe2/w4
X-Google-Smtp-Source: AGHT+IFOfVkPkVMGRlk3XiA/ffykapP2FRwcnWz9umNZoMiKjGYxS7tb4En/V+gVcTXv1AYtTEIVwg==
X-Received: by 2002:a05:651c:512:b0:2fa:cd7e:3b40 with SMTP id 38308e7fff4ca-2fb3276f1d6mr88483621fa.11.1729091966809;
        Wed, 16 Oct 2024 08:19:26 -0700 (PDT)
Received: from localhost.localdomain ([62.19.118.125])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-5c98d7b725esm1824716a12.87.2024.10.16.08.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 08:19:26 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	upstream@airoha.com
Subject: [PATCH 1/2] dt-bindings: rng: add support for Airoha EN7581 TRNG
Date: Wed, 16 Oct 2024 17:18:41 +0200
Message-ID: <20241016151845.23712-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for Airoha EN7581 True Random Number generator.

This module can generate up to 4bytes of raw data at times and support
self health test at startup. The module gets noise for randomness from
various source from ADC, AP, dedicated clocks and other devices attached
to the SoC producing true random numbers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../bindings/rng/airoha,en7581-trng.yaml      | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/airoha,en7581-trng.yaml

diff --git a/Documentation/devicetree/bindings/rng/airoha,en7581-trng.yaml b/Documentation/devicetree/bindings/rng/airoha,en7581-trng.yaml
new file mode 100644
index 000000000000..dfc6d24ee7d9
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/airoha,en7581-trng.yaml
@@ -0,0 +1,38 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/airoha,en7581-trng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Airoha EN7851 True Random Number Generator
+
+maintainers:
+  - Christian Marangi <ansuelsmth@gmail.com>
+
+properties:
+  compatible:
+    const: airoha,en7581-trng
+
+  reg:
+    maxItems: 1
+
+  interrupts:
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
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    rng@1faa1000 {
+        compatible = "airoha,en7581-trng";
+        reg = <0x1faa1000 0x1000>;
+        interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
+    };
-- 
2.45.2

