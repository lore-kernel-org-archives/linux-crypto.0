Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECB9146D5A;
	Wed,  4 Mar 2026 00:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772585755; cv=none; b=lD0JlvT92BNfkpyLtXjq9iOTr1ZFWx1ivRxsDnEBguzBiYi4gAsxMUtMGMG6F75xwLXIYaiJLykGFT9e1ohzIX3jhw2JluQ4kReh623N136BO/BejiKgj95HIDa4lPlNeRBw1lM2+y6iQTRxmoDkFe+8UxtIJDjl6+I+44hxJf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772585755; c=relaxed/simple;
	bh=XI/gc3Xb8SC4YkIU2wMP+//1XWJt3JIFB04qNSovnPw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XlU7MSPwroVRciGnkyiF36hmlxMHC+5hL7iJm9cX2zgw1T0II8fsmNFziFSLrh2S6rFNxmcJuSpWeGatynoZnqnhuvtxiOWoR+C+MRS3IWL1ZEXHwu0XgEF268A+PjFmzN2nqWWGNXMSU20/t21W8ga15HvBVhnAmbjQ1bTiQ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1vxaWV-000000008MP-2yF0;
	Wed, 04 Mar 2026 00:55:35 +0000
Date: Wed, 4 Mar 2026 00:55:27 +0000
From: Daniel Golle <daniel@makrotopia.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 1/2] dt-bindings: rng: mtk-rng: add SMC-based TRNG variants
Message-ID: <04622e0bc917aed4145a9a3b50b61f343fc89312.1772585683.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Add compatible strings for MediaTek SoCs where the hardware random number
generator is accessed via a vendor-defined Secure Monitor Call (SMC)
rather than direct MMIO register access:

  - mediatek,mt7981-rng
  - mediatek,mt7987-rng
  - mediatek,mt7988-rng

These variants require no reg, clocks, or clock-names properties since
the RNG hardware is managed by ARM Trusted Firmware-A.

Relax the $nodename pattern to also allow 'rng' in addition to the
existing 'rng@...' pattern.

Add a second example showing the minimal SMC variant binding.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 .../devicetree/bindings/rng/mtk-rng.yaml      | 28 ++++++++++++++++---
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.yaml b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
index 7e8dc62e5d3a6..6074758552ac3 100644
--- a/Documentation/devicetree/bindings/rng/mtk-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
@@ -11,12 +11,15 @@ maintainers:
 
 properties:
   $nodename:
-    pattern: "^rng@[0-9a-f]+$"
+    pattern: "^rng(@[0-9a-f]+)?$"
 
   compatible:
     oneOf:
       - enum:
           - mediatek,mt7623-rng
+          - mediatek,mt7981-rng
+          - mediatek,mt7987-rng
+          - mediatek,mt7988-rng
       - items:
           - enum:
               - mediatek,mt7622-rng
@@ -38,9 +41,22 @@ properties:
 
 required:
   - compatible
-  - reg
-  - clocks
-  - clock-names
+
+allOf:
+  - if:
+      properties:
+        compatible:
+          not:
+            contains:
+              enum:
+                - mediatek,mt7981-rng
+                - mediatek,mt7987-rng
+                - mediatek,mt7988-rng
+    then:
+      required:
+        - reg
+        - clocks
+        - clock-names
 
 additionalProperties: false
 
@@ -53,3 +69,7 @@ examples:
             clocks = <&infracfg CLK_INFRA_TRNG>;
             clock-names = "rng";
     };
+  - |
+    rng {
+            compatible = "mediatek,mt7981-rng";
+    };
-- 
2.53.0
