Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA0318DB26;
	Sun, 19 Apr 2026 12:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776600325; cv=none; b=GtbaL+4MvuIuIb9MkG/R5JaPIZlp25fsHXBa9IyfgBJIZaUB8m9QHeLnWsTPGX9+BZ7bPy1ilrPZqRgJv7o/OPf/jkD4KvjOH2EiTxEhIgiYK0+PRTEOK08FnU00UUjYI1lNWKSuzX5gluWAzFWhM7ZrYiFTvYOH1Xa0dPesDik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776600325; c=relaxed/simple;
	bh=sU+lBqCy95TUaGp6nCHLuIb1ds3xHsDuiuE6/pgp39U=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Uhy5ghEjnZI0koAPlimYLSTgKfDKdNrgItzC2F4tFKGDUIPjbMz5LmIQlmZer7qvglLmSJ3LUi208UKSBKNM2O6rK7rSnoy8j5JjW1e0/1PbIgW14rgBgPaCi84zL04GIMGLgXG8gozGGgdrpXFbxVNoKNp5qGmTzgn21GMsogU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wEQte-000000006Ha-26VQ;
	Sun, 19 Apr 2026 12:05:06 +0000
Date: Sun, 19 Apr 2026 13:05:01 +0100
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
Subject: [PATCH v3 1/2] dt-bindings: rng: mtk-rng: add SMC-based TRNG variants
Message-ID: <585fc832e4e5d3656bd25ecee6bafb636993104a.1776600269.git.daniel@makrotopia.org>
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
v3:
 * drop not: in compatible conditional
 * add reg/clocks/clock-names: false for mt7981-rng
 * add else: requiring reg/clocks/clock-names for others

v2: express compatibilities with fallback

 .../devicetree/bindings/rng/mtk-rng.yaml      | 32 ++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.yaml b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
index 7e8dc62e5d3a6..8fe6c209ab1e5 100644
--- a/Documentation/devicetree/bindings/rng/mtk-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
@@ -11,12 +11,13 @@ maintainers:
 
 properties:
   $nodename:
-    pattern: "^rng@[0-9a-f]+$"
+    pattern: "^rng(@[0-9a-f]+)?$"
 
   compatible:
     oneOf:
       - enum:
           - mediatek,mt7623-rng
+          - mediatek,mt7981-rng
       - items:
           - enum:
               - mediatek,mt7622-rng
@@ -25,6 +26,11 @@ properties:
               - mediatek,mt8365-rng
               - mediatek,mt8516-rng
           - const: mediatek,mt7623-rng
+      - items:
+          - enum:
+              - mediatek,mt7987-rng
+              - mediatek,mt7988-rng
+          - const: mediatek,mt7981-rng
 
   reg:
     maxItems: 1
@@ -38,9 +44,23 @@ properties:
 
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
+          contains:
+            const: mediatek,mt7981-rng
+    then:
+      properties:
+        reg: false
+        clocks: false
+        clock-names: false
+    else:
+      required:
+        - reg
+        - clocks
+        - clock-names
 
 additionalProperties: false
 
@@ -53,3 +73,7 @@ examples:
             clocks = <&infracfg CLK_INFRA_TRNG>;
             clock-names = "rng";
     };
+  - |
+    rng {
+            compatible = "mediatek,mt7981-rng";
+    };
-- 
2.53.0
