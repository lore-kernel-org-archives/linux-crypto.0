Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3157843713C
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2026 17:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783533543; cv=none; b=MB6kz5zEjWgeyB4NTfVNJz9o7Y3OK/BH3IkPGbJcFpcSR+fInLantiZkh+Ra2jvbN0r0sP4NJPD6/fk5th3GTjlFgYSSLx5A8Wm/+V7ll2ECc6IC+fIshA8IXuBCl8N5vClKnwrMYoszRydWPdHwktxSU0ENm9+LDTw3Ced6P2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783533543; c=relaxed/simple;
	bh=qR8da7hKtoo+tPfwG3vADxqc/OIuPfs3p6aDdWf+HJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m28aKDgw3r0PPVhshJ9CNPMfkMViFm1EUs7VkRv+YWXkyL4mkIug5HJQ+JDwlpQjrMfMuLc2pKa/T9jMMwoSsjuQoIHPQ/wDHfkDSuSaOlwUsvzkqJVuJ6gutJxQNcyjLR2CZcb7ZprpSElRkSCE4k7Wh03+33ekk+Vo9LXoCp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=okXq95Bu; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="okXq95Bu"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-69a50b818c8so1643220a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jul 2026 10:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783533541; x=1784138341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ANaeyZnIlvUZuUb+qcVD79ri5D/Hu+DLtzSwYPDFNAo=;
        b=okXq95BumxxuPuQcGSoDV1NhQQWS+Pw+q68vEYQuqMONf6t0YyZS6oarm3EO7av1hY
         sm5bc5QrNtKjLCHBDgwxC9znCd+yqRvDve8Dmp3LGG0JbvgK1wT+2EsmLR7kUkIIicLY
         W4SvUqdumDi8n1XEg4dTxOEV/EitJsUqQ/gl9vC6r5QZ3fxE+n/rX2mwS3biBPjJEiLA
         5MNcIYCZ6Zuo/XRVa2zs99mbc3EB283P9embX+uYa8OJV8MJrt3l6n2Hm2/40rJrDVnH
         1vLr2JBNYk0DhkTiU5q6Y0ts5LEvAZNXPqd5tvRxWmlZVJDFKXwOPgnUOxsMDybM/pYr
         YMYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783533541; x=1784138341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ANaeyZnIlvUZuUb+qcVD79ri5D/Hu+DLtzSwYPDFNAo=;
        b=RwOgs3MiNN2HGyYKbVnA+1xdwTGcbL00MoPDoM1AYlExHlZer5j14FuN8bYMY/P9wE
         KJ5v/zskKH76BZdgA8Xj6NcwG4xfHwbzDiZFyw6rpJtkQqVjdggA+4OT2teAcW0bFPm2
         +o3JgOs6LX6aQTJUZgUC9rsPabbskuUL40o4OIikdTVHV55V5q15uqEFA3e4GTHeU3RI
         WHBvDXCee5ohTDO/cY6up3dkbLNtnKv/ZvrIZI7Jbr/C+W+wmV6RCWnnL80jzgqLnsfN
         WRpGVuWpb+vbEiIwHPw43i794d0w7BoAI6EIdLFJQxxZL9BVEUc/Q8fjRSAfxfVTAtmX
         oZcQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp+Sv/rPpcZjqcK+t/gxB+Zp9l2UiTEXVyLwViH/jxQ0cUD215T59OM6wGtOg8EfQFGh1yuwLbHgXvMvCY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdVSqiujdZ1n9W7ZiddoX3MxIJT/lofystyWGzFj6AGqfoMVu7
	0TewTvKxBT/BRCYn1dlxkmfwjP+2E/uFxrI8CtaemxV2VdI2HchyvqrK
X-Gm-Gg: AfdE7clFIvPudUh9vxCwQdeR+7ayH8/daFi151ACmVqI1iJyWm92VuOHi+Fe2cwU/GX
	VMef8c0/aB2XdphTDltDvK3eo80AGeLDIzSbFsdEM2ALv+sWMZ0YnXebmDW6TPEyJ+l6u8kkC9H
	gJNE7oTtYBdgoQ7PdJj/WlBkg+mqv2Bfh8ohWtFEGjvA9eO4dEfqJqXthoA6pDtegcrUaNW73Ml
	vwMXz9ZqmkUGt3dRU+3vOS4nFxF5+sliF8PPd877b0+zVuoVx/yeVqnCI3w6a3jdzhawfzcwZ5K
	1xCoSCw+SXShU1KszYj53svS4ebft5LleD1Hl+jKXvVZ/PrZ3CB1TsGg1zwMYIzBdKQzmk3w567
	RQ99WTU6nAIvSeNZ074iVlpQoJCqC+nKddbF381/crvq0u6UbtpEHK3VolAFLr2Yd1WzM5Fg4j9
	cJz9KkKQ==
X-Received: by 2002:a17:907:a286:b0:c15:b6bd:cbb8 with SMTP id a640c23a62f3a-c15ce121a12mr164929166b.50.1783533540594;
        Wed, 08 Jul 2026 10:59:00 -0700 (PDT)
Received: from olympus.. ([2a0a:ef40:ea3:3f01:2e0:4cff:fe68:285])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15ad9bcc26sm357653666b.34.2026.07.08.10.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 10:59:00 -0700 (PDT)
From: Dawid Olesinski <dawidro@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Corentin Labbe <clabbe@baylibre.com>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Dawid Olesinski <dawidro@gmail.com>
Subject: [PATCH v2 1/4] dt-bindings: crypto: rockchip: Add RK356x/RK3588 crypto engine binding
Date: Wed,  8 Jul 2026 18:58:22 +0100
Message-ID: <20260708175837.1718437-2-dawidro@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708175837.1718437-1-dawidro@gmail.com>
References: <20260708175837.1718437-1-dawidro@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a YAML device tree binding for the Rockchip second-generation (V2)
cryptographic hardware accelerator present on the RK3568 and RK3588 SoCs.

The IP block exposes AES-ECB, AES-CBC, AES-XTS block ciphers, SHA-1,
SHA-224, SHA-256, SHA-384, SHA-512, MD5, and SM3 hash algorithms, each
with a hardware DMA engine controlled via linked-list descriptors.

The binding covers two compatible strings:

  - rockchip,rk3568-crypto: clocks and resets are driven directly by the
    non-secure CRU (accessible to Linux at EL1).
  - rockchip,rk3588-crypto: clocks and resets live in SECURECRU, a
    register bank sandboxed to TrustZone. Linux must request them through
    the ARM SCMI firmware interface (scmi_clk / scmi_reset), as direct
    MMIO access to SECURECRU from EL1 triggers a bus fault.

Signed-off-by: Dawid Olesinski <dawidro@gmail.com>
---
 .../crypto/rockchip,rk3588-crypto.yaml        | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml

diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
new file mode 100644
index 000000000000..fc09f21b0654
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
@@ -0,0 +1,75 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/rockchip,rk3588-crypto.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Rockchip cryptographic offloader
+
+maintainers:
+  - Heiko Stuebner <heiko@sntech.de>
+  - Corentin Labbe <clabbe@baylibre.com>
+  - Dawid Olesinski <dawidro@gmail.com>
+
+properties:
+  compatible:
+    enum:
+      - rockchip,rk3568-crypto
+      - rockchip,rk3588-crypto
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: Core clock for the crypto IP internal logic
+      - description: AXI interconnect clock interface
+      - description: AHB interface clock
+
+  clock-names:
+    items:
+      - const: core
+      - const: aclk
+      - const: hclk
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    items:
+      - const: core
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - resets
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/rockchip,rk3588-cru.h>
+    #include <dt-bindings/reset/rockchip,rk3588-cru.h>
+
+    bus {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      crypto@fe370000 {
+        compatible = "rockchip,rk3588-crypto";
+        reg = <0x0 0xfe370000 0x0 0x2000>;
+        interrupts = <GIC_SPI 209 IRQ_TYPE_LEVEL_HIGH 0>;
+        clocks = <&scmi_clk SCMI_CRYPTO_CORE>, <&scmi_clk SCMI_ACLK_SECURE_NS>,
+                 <&scmi_clk SCMI_HCLK_SECURE_NS>;
+        clock-names = "core", "aclk", "hclk";
+        resets = <&scmi_reset SCMI_SRST_CRYPTO_CORE>;
+        reset-names = "core";
+        };
+    };
-- 
2.47.3

