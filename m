Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCF5389DEC
	for <linux-crypto@vger.kernel.org>; Sun, 16 Aug 2026 19:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786909325; cv=none; b=uZMWpdsFrd0nAAKQ2u/xTJFl4roDaz5DANo7DSOvO3l56nZDLULk9O+iULB4756v41Gem/n2IoZp5ClLkRs8ybjJvPJgFwBTIKVTTFw++nm68wlcs3e1jPm61oxtGH3vdiOGTwkpAx56upZKpDALCmqSGbc6pUOFso/3BC+tmz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786909325; c=relaxed/simple;
	bh=0aV1EDPznOoER+avhb/DV25vmwPP/eyVYyHusxCFAP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pvgk5bO4tMjzg07FpMmYcLtF/ZHwoCO+zggOX5e6yFy6fbP+G6hb+/XeY+lW+ADiszINKWPtS3WiEAO1XsdGDJpqgWh3/9dqYV975v0uLvbSzzzIFKlYNkhFyrI0C99Ejuh37SH2mqk8wJk+F0gdtV1w7rAgEMOKjhmJjNnGfXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WCu3VAGy; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WCu3VAGy"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-471eeac43bfso2386262f8f.3
        for <linux-crypto@vger.kernel.org>; Sun, 16 Aug 2026 12:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786909321; x=1787514121; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lt1iFyoVmOWgdJa6Q9QXH7FhQnE0Gt7SjTwOuCNZXk4=;
        b=WCu3VAGyhPu9I7KIiUPVnGjQBsHyR/Y9IpATVtLvRGkv9wbDtz0neQFhnyVuq/lkna
         Ba42GmTuzP5R6yrCXwUi+0SEArXmeX7rxiBOrayfWO1DC8/b9I2kD/ll0Wpq6rq1kY/V
         T+ozX8mr3nsozeHai/ZjXQFQZEiqavxEZQMNyipGZwcDm65Ec9LuKFLA7zcxA6XxKA36
         CseWNjppO9XVfVFsaTMhic8pdKPCxnTHV/jUSDrv/Gu9Fn2vzr60Z+TuS7ISbhGQYP79
         +CYvezgAgTVu8uQPfLd+Xw75StcDpMErO0Tq+LtDYZG5HjWRrXlLZCTyn1G7LczLYGNp
         H3Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786909321; x=1787514121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lt1iFyoVmOWgdJa6Q9QXH7FhQnE0Gt7SjTwOuCNZXk4=;
        b=BDme5SEZWvWndaHWQidm35OR4Njfv8CE7ZebpAn1nvNpjugVRv+BOsUst6WQGjQJY3
         8IWN0ikt8VQaDPHkZMdAuLvQKcGU/eTRoYU5UWbXD1KYj7JZx5I25OFgyv1T/Sp6VFBS
         2XpSTu1dKlylQIMlDzEV86w4I4SgSxd6LbCpyEMAQos62834ZtrKGxILA2GMrgqLRFkv
         dJ8oaRRLOXS98/diRNBgCrQ6hXfMmFAjZuJnEi7HmEfxjW430LN6t1ybTohm0iIcvVg4
         SsA5TTJrYXMVNqKlrZBsSjdTElEpANW/XR8VFEE+kFKVIkhXl7IEWND6vOp26QQ1TV6M
         c0tw==
X-Forwarded-Encrypted: i=1; AHgh+Rr+KHFwA0LtOCXCgjVh1iV57tdEhSSUacHJdkiVF71zg5ka8GvwRvLFr15OhgneP38IucbanmGaftHOXl8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1zRGwy4RObskfxhSd6x34wriyzsrrjR9kKzOfwzI1UoAW4LCR
	NvdjsI6jBYiTNtFzkoEbzVEMOy2wsSb62Sd9k0LiVY4MP93PZdzCSfng
X-Gm-Gg: AR+sD119vQZEpV13rR9moIZW+afjJSggLVguLP0U7zMIGETQMCqYTvODlw7QrHGXhbU
	4Kl5A5aydEssoV+u16KaD7CNhujUraiDCT4AX7VBMDifMaSJ2kywODZcqcejc5VDrZX1SivPOCG
	pAZ9BNixaKViWp/HnXQESUqsqb2by0mPwQqebNX/HtAo+zOFufB6wcw0fPl6KdHIY9/6NkuTBeM
	CDr7OhtOnvwmQbpwMwMACqhic6jVMLfaaJGM5S8x2shWeaMuZPph7o1/zopp+1/XKgEucdJdtmZ
	h7KMWFPi4D5pPq4xD+VHrcA8L/xtnbK62KNC+jN6eR8NRr2PSLfYj+v4sLGh+IsoVn9TQu3FcNs
	OnFRCE+rVqEDFZXp9pWT0Uum07nYmhF0YPwVQvaoE1Ibk4HnYvtAq4yN6vPX5Q5IJGv/oU2Q/Pw
	MTEp77yQovjveWpCm+vNhbnskznXh5EvfDjoJt+ySds8rjbcUoLfvYA2BedXlaPytw
X-Received: by 2002:a05:600c:1546:b0:499:484a:98e7 with SMTP id 5b1f17b1804b1-49987974700mr299168845e9.14.1786909321442;
        Sun, 16 Aug 2026 12:42:01 -0700 (PDT)
Received: from olympus.. ([2a0a:ef40:f1b:d401:2e0:4cff:fe68:285])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996106c6esm100527875e9.5.2026.08.16.12.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 12:42:01 -0700 (PDT)
From: Dawid Olesinski <dawidro@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>
Cc: Diederik de Haas <diederik@cknow-tech.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Conor Dooley <conor+dt@kernel.org>,
	Corentin Labbe <clabbe@baylibre.com>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Dawid Olesinski <dawidro@gmail.com>
Subject: [PATCH v3 1/4] dt-bindings: crypto: rockchip: Add RK356x/RK3588 crypto engine binding
Date: Sun, 16 Aug 2026 20:39:44 +0100
Message-ID: <20260816194112.552100-2-dawidro@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260816194112.552100-1-dawidro@gmail.com>
References: <20260708175837.1718437-1-dawidro@gmail.com>
 <20260816194112.552100-1-dawidro@gmail.com>
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

Co-developed-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Dawid Olesinski <dawidro@gmail.com>
Tested-by: Diederik de Haas <diederik@cknow-tech.com>  # Quartz64-B,
NanoPi R5S, NanoPC-T6 LTS
---
 .../crypto/rockchip,rk3588-crypto.yaml        | 83 +++++++++++++++++++
 MAINTAINERS                                   |  2 +
 2 files changed, 85 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml

diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
new file mode 100644
index 000000000000..32d241c19453
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
@@ -0,0 +1,83 @@
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
+    oneOf:
+      - const: rockchip,rk3568-crypto
+      - items:
+          - enum:
+              - rockchip,rk3588-crypto
+          - const: rockchip,rk3568-crypto
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
+    minItems: 1
+    maxItems: 3
+
+  reset-names:
+    minItems: 1
+    items:
+      - const: core
+      - const: aclk
+      - const: hclk
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
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
+        compatible = "rockchip,rk3588-crypto", "rockchip,rk3568-crypto";
+        reg = <0x0 0xfe370000 0x0 0x2000>;
+        interrupts = <GIC_SPI 209 IRQ_TYPE_LEVEL_HIGH 0>;
+        clocks = <&scmi_clk SCMI_CRYPTO_CORE>, <&scmi_clk SCMI_ACLK_SECURE_NS>,
+                 <&scmi_clk SCMI_HCLK_SECURE_NS>;
+        clock-names = "core", "aclk", "hclk";
+        resets = <&scmi_reset SCMI_SRST_CRYPTO_CORE>;
+        reset-names = "core";
+      };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index c8d4b913f26c..50b77a750db3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23131,9 +23131,11 @@ F:	drivers/media/platform/rockchip/rkcif/
 
 ROCKCHIP CRYPTO DRIVERS
 M:	Corentin Labbe <clabbe@baylibre.com>
+M:	Dawid Olesinski <dawidro@gmail.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
+F:	Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
 F:	drivers/crypto/rockchip/
 
 ROCKCHIP I2S TDM DRIVER
-- 
2.47.3

