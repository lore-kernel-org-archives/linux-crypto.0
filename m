Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6127832D7C7
	for <linux-crypto@vger.kernel.org>; Sat, 30 May 2026 16:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780157235; cv=none; b=hZTuoJ4HrPllYRZXOOAOp8wKdKNPuZuevMj496x57OwzeYRPbU0HPWFMbYGKv8W/cIysiyauBdww7nTs5eo9v4ZNDDkr3735/4vWSVovDVOihkOvhqJUpfNjkfwb/B+OBuMcbGoJSZ++/RR4Qc+tgBS1UGAc8nw1J5SvOoedj9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780157235; c=relaxed/simple;
	bh=oJaLQm7RO4ezlWTTXjCrTAAHg8KhdMd5CaAE1SfLUXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGnAYq9RBKngbh9DykS0qSvKd/FQ01JjBLvAvz7RFhBLrHc0BKbAV5aY5gA0dhtMqFloCKv6AUN1qvW6X0WY4fiouutUlIXFyUqrLrNtymbEXsPSiw3PXIoM7DDNzeDY4CB2x5X+8JXX82CszwG9uGhQ/PLgZjjtYAh29ISE6EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pXCyCyEn; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pXCyCyEn"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-45eea3448f2so1554676f8f.2
        for <linux-crypto@vger.kernel.org>; Sat, 30 May 2026 09:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780157233; x=1780762033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sh+f2AliULr9Rp7wvXUw2a0MafO9SPx6nLUlNFzn0RI=;
        b=pXCyCyEnOK1AzweldIusjmSZ4u8N4g3zqY9XGPuyJPoJDbQJlDAKHb8kJvznHAU6lc
         4c5z7mGBeQWH8a6414G3Yya9GWYHvlt2fTichrvPStlJbINt0niM/hbSSyLP/Q2h7yPw
         8MKM7B5QL9UaUwQRqOiNeco4VQSkJXeHDCueaTPyIdKgNV6WW6AfQ+e55WTcaiIv8cKF
         ypcR0Gm0Lu+6OdkQcuOVeK5WBWdSL1GduDTepD1usypt9ASBfIaSR9nqn/Vp2vjaj0Nu
         PXLLXIVB0w6DiDAGCPnYf8I9rTNXriSaEVGWhLPKb9cZo7I9qHHKf1sYTjgKGJkFKwK5
         Ei2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780157233; x=1780762033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sh+f2AliULr9Rp7wvXUw2a0MafO9SPx6nLUlNFzn0RI=;
        b=j4e4KKq57+I8UHSwRJ7ojakHWEj6/tX8lUXJqR5iwXE4Pkh7eNkuazr5mtkSK20AhD
         wUfVqRRsP/w0nO6unYFUsiKC/yoD/e598Vm7GZDCMSvYK5QztG35IwsizDlgNFHOb3/Y
         N7udBZK2V9whwae/EcnwVQN13DrewnABY5CfNr7xfuHP/mF+TnZRyMHclKrXkULEojJl
         mP4fOtaZ0H7TubdyYTC10HcqEFave1i5MhYBj9JdxDX620QmgnCq1RW7oDMQC6XxpbhI
         uSaFnWlrgWP7dOdJOlQmBh3kxg6xYoiK7cBpjmfKDx8Zkci77tlX9aReLW/XqDhJinxJ
         Yf9A==
X-Gm-Message-State: AOJu0YzchJrjUbUwoFBk6U+ijdqxgpswicnL8vR073gFJIqquFbF+YgM
	d/241iXO6nbghYcaNzQx6vkWYhmdd3AVPhfvQ2x2kwnJ7kmi7eKdJ1DI
X-Gm-Gg: Acq92OHya/09twHir6wIm3clHSqA/BpPBYEYGwZyDGS+Y5YnoVKZXMnD4GkHB8u7Hqb
	UKgm2s+t7RlPigZuqANdCGJqj2kb9PUkOC3GcWVNtgEimh/0EOR1+5F1oDd4qj/QVhmO/c6lL5b
	CkSPKFRFYWMkS5qEehU4xucRH879Cx6AKzOxRayo9r0s8Sptnw8ZfUq7l7buetRn2ozmpITBLcW
	f86WIcZnXAPeEX4sSx2K8OGfjGJnT1jaa9+GSztAHFgQG0MoUZ4BNsofh2BF2nbERfIMqCUG5Fk
	1SP9kNT0B7rNHP5DHBepuIpdCxBcWeOSKms/7jpXPjTOp2PClCIj3mWouVX7vP5gEL1EMlBY6iD
	9AnnhaYOj2+fLcsoq/UZAOAn5MaOFm26jKb1Pmx9PCSGFRYNUxRh50jE/T3CbFJAbVssGusL5X5
	j6W9zXfrwpy8J+PQlsMoO4nalBLuM=
X-Received: by 2002:a05:6000:22c7:b0:43d:762e:76ba with SMTP id ffacd0b85a97d-45ef6b19b8emr8623681f8f.17.1780157232877;
        Sat, 30 May 2026 09:07:12 -0700 (PDT)
Received: from olympus.. ([2a0a:ef40:ea3:3f01:2e0:4cff:fe68:285])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef32fabcasm11667339f8f.0.2026.05.30.09.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 09:07:12 -0700 (PDT)
From: Dawid Olesinski <dawidro@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	heiko@sntech.de
Cc: linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	clabbe@baylibre.com,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	linux-kernel@vger.kernel.org,
	Dawid Olesinski <dawidro@gmail.com>
Subject: [PATCH 1/4] dt-bindings: crypto: rockchip: Add RK356x/RK3588 crypto engine binding
Date: Sat, 30 May 2026 17:06:42 +0100
Message-ID: <20260530160704.3453555-2-dawidro@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260530160704.3453555-1-dawidro@gmail.com>
References: <20260530160704.3453555-1-dawidro@gmail.com>
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
 .../crypto/rockchip,rk3588-crypto.yaml        | 69 +++++++++++++++++++
 1 file changed, 69 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml

diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
new file mode 100644
index 000000000000..4188ed8920db
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
@@ -0,0 +1,69 @@
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
+
+    crypto@fe370000 {
+        compatible = "rockchip,rk3588-crypto";
+        reg = <0x0 0xfe370000 0x0 0x2000>;
+        interrupts = <GIC_SPI 209 IRQ_TYPE_LEVEL_HIGH 0>;
+        clocks = <&scmi_clk SCMI_CRYPTO_CORE>,
+                 <&scmi_clk SCMI_ACLK_SECURE_NS>,
+                 <&scmi_clk SCMI_HCLK_SECURE_NS>;
+        clock-names = "core", "aclk", "hclk";
+        resets = <&scmi_reset SCMI_SRST_CRYPTO_CORE>;
+        reset-names = "core";
+    };
-- 
2.47.3

