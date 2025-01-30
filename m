Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EA31EE003;
	Thu, 30 Jan 2025 16:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738254748; cv=pass; b=W4pQrjfTXLIv4ISHcEMc1SWoTk8iStJs/Eko7h2VXlXowwVvjqB3iT2aFe/npIjs4OyVqAeDHA62Kk0fjVCVJW26OJNfSMUAfz9r+XIuPhBtYak2hTQ2AskVAIr5NfP9CWhtY544+pRuDkBEwP1Q6aDglMKTbpNnYJylUVhEncI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738254748; c=relaxed/simple;
	bh=MQPYLtlif+b2Bn0fUa/Vuhlyzr1PbbBwBPkMoiEg+vU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jH8vgyDnIwzV01idpQiDmEG0Lt5b74iDR4Jq9kuIBu85m2WzPFCOfjLmXBB/dmpVDlB7Ph+tSCj/T4eOdK6nJd6SInPxsuLKEu+2SX5VPnSK70JWio00KTSXy5s5ClwvWTHhe3Y/YBUt5AQT39c/q+QPCzhVF08JpJBk/j5GVTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=i8uv7jiA; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="i8uv7jiA"
ARC-Seal: i=1; a=rsa-sha256; t=1738254712; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PsLx8JB7ro5AiQA8iikug49vSEv64GeDMH6lR44pIXMIYzzdtHUpMfOWtxi4E0bb31nUJ+szLSi96eYce08+OvcdRGkHMZaiksgyiCe1DmhnaqGE4hNaox6D5PEJI3H4Ee4mwu/svXvcVzIJxKMOwpEkBMSnNtuBehs3KqTMy4M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1738254712; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=UaY0n35Nb7SCkmus3ECKUdBCfM4ZyE4EZNsg5zowUTg=; 
	b=TUdV8PWu9TKB16r9OATlI82aKnfzsyKluvXbAhEUwzlBXbEIJ61BJNvbyu1McHVT5fGFGFUR0PEEy8oV0JI8xcL9QhBmOPWD5cM5KsX3k/RWN0Y2g+CYEwTPpTBO6JtIoHY8WzdO99lQUrennatAC7+IdS4bNLe9bJU6MiCNuwI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1738254712;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=UaY0n35Nb7SCkmus3ECKUdBCfM4ZyE4EZNsg5zowUTg=;
	b=i8uv7jiA7HB5Va3CcuDs5oxhp17irJe++zPosZfkglmj77Yv+bZlzJrPpNljDP6R
	xBiyqWOcgS6vPUzuPr6n399QFWk4k5MlUU8vOWv9Y0TGqg1f4T5V/zrCqO+8mO2T5X+
	yHa2WzcQMZTaverjEwI4mHcvCVq/Xc+iXlr22GgE=
Received: by mx.zohomail.com with SMTPS id 173825470884090.2146661595857;
	Thu, 30 Jan 2025 08:31:48 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 30 Jan 2025 17:31:16 +0100
Subject: [PATCH 2/7] dt-bindings: rng: add binding for Rockchip RK3588 RNG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250130-rk3588-trng-submission-v1-2-97ff76568e49@collabora.com>
References: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
In-Reply-To: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>, 
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.2

The Rockchip RK3588 SoC has two hardware RNGs accessible to the
non-secure world: an RNG in the Crypto IP, and a standalone RNG that is
new to this SoC.

Add a binding for this new standalone RNG.

The RNG is capable of firing an interrupt when entropy is ready, but
all known driver implementations choose to poll instead for performance
reasons. Hence, make the interrupt optional, as it may disappear in
future hardware revisions entirely and certainly isn't needed for the
hardware to function.

The reset is optional as well, as the RNG functions without an explicit
reset. Rockchip's downstream driver does not use the reset at all,
indicating that their engineers have deemed it unnecessary.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 .../bindings/rng/rockchip,rk3588-rng.yaml          | 61 ++++++++++++++++++++++
 MAINTAINERS                                        |  2 +
 2 files changed, 63 insertions(+)

diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
new file mode 100644
index 0000000000000000000000000000000000000000..dff843fa4bf9d5704bbcd106398328588d80b02d
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
@@ -0,0 +1,61 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/rockchip,rk3588-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Rockchip RK3588 TRNG
+
+description: True Random Number Generator on Rockchip RK3588 SoC
+
+maintainers:
+  - Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
+
+properties:
+  compatible:
+    enum:
+      - rockchip,rk3588-rng
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: TRNG AHB clock
+
+  # Optional, not used by some driver implementations
+  interrupts:
+    maxItems: 1
+
+  # Optional, hardware works without explicit reset
+  resets:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/rockchip,rk3588-cru.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/reset/rockchip,rk3588-cru.h>
+    bus {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      rng@fe378000 {
+        compatible = "rockchip,rk3588-rng";
+        reg = <0x0 0xfe378000 0x0 0x200>;
+        interrupts = <GIC_SPI 400 IRQ_TYPE_LEVEL_HIGH 0>;
+        clocks = <&scmi_clk SCMI_HCLK_SECURE_NS>;
+        resets = <&scmi_reset SCMI_SRST_H_TRNG_NS>;
+        status = "disabled";
+      };
+    };
+
+...
diff --git a/MAINTAINERS b/MAINTAINERS
index bc8ce7af3303f747e0ef028e5a7b29b0bbba99f4..7daf9bfeb0cb4e9e594b809012c7aa243b0558ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20420,8 +20420,10 @@ F:	include/uapi/linux/rkisp1-config.h
 ROCKCHIP RK3568 RANDOM NUMBER GENERATOR SUPPORT
 M:	Daniel Golle <daniel@makrotopia.org>
 M:	Aurelien Jarno <aurelien@aurel32.net>
+M:	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
+F:	Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
 F:	drivers/char/hw_random/rockchip-rng.c
 
 ROCKCHIP RASTER 2D GRAPHIC ACCELERATION UNIT DRIVER

-- 
2.48.1

