Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908D734B69C;
	Mon, 20 Apr 2026 16:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776702899; cv=none; b=SYvFJxLATXDA9j5Mu+a7Km4QCZQb4wOBVtvIIBNz5iCrFZA5BG8VIw0GCasIwisgMV14mvQmeJSxBbey4eaUtQHY2zZu7ZNUTQn/Pw0ncPYYfCu7sCPqvFT+r4//n3MAOgLV3vkvQuWBlTR5ejZEiGLmEVazbztTEqpfRFeeuyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776702899; c=relaxed/simple;
	bh=EsCUyEPRwQSZlruBolpbuf2AreSJOySm10HLNkmg42E=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jfuRCu+T2zYM+RsS+cLirJl0OPRWCb+/m+uBTGLAXbt0ui2Z94qX1iZDfX7OAsQQaJmaUNGl+ah4S54w90Sctyg9xV++qQEHhh1JHQJ9qQrTamNJPQrzsq4zaLHdSOFc5N/AHCGV4rsdnVBkpHs2hMGEcVvtd15PL6V/y2DDl5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wEraC-000000001Bl-1o7A;
	Mon, 20 Apr 2026 16:34:48 +0000
Date: Mon, 20 Apr 2026 17:34:45 +0100
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
Subject: [PATCH v4 1/3] dt-bindings: rng: mtk-rng: fix style problems in
 example
Message-ID: <912fe579eccf577f3064b69d6c945e2c9087cab8.1776702734.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Use 4 spaces for each level indentation, remove unused label, and add
missing empty line between header include and body.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
v4: new patch

 Documentation/devicetree/bindings/rng/mtk-rng.yaml | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.yaml b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
index 7e8dc62e5d3a6..8f2f4c32a0cfc 100644
--- a/Documentation/devicetree/bindings/rng/mtk-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
@@ -47,9 +47,10 @@ additionalProperties: false
 examples:
   - |
     #include <dt-bindings/clock/mt2701-clk.h>
-    rng: rng@1020f000 {
-            compatible = "mediatek,mt7623-rng";
-            reg = <0x1020f000 0x1000>;
-            clocks = <&infracfg CLK_INFRA_TRNG>;
-            clock-names = "rng";
+
+    rng@1020f000 {
+        compatible = "mediatek,mt7623-rng";
+        reg = <0x1020f000 0x1000>;
+        clocks = <&infracfg CLK_INFRA_TRNG>;
+        clock-names = "rng";
     };
-- 
2.53.0
