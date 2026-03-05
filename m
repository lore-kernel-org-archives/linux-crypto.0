Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728C43FB043
	for <linux-crypto@vger.kernel.org>; Thu,  5 Mar 2026 19:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772740758; cv=none; b=DTgng+SEiucMWDQgUkzmONeEQpvARB5UA1ZRHaY85vASEWzcsg+HJIYuCm9CfEGZh/YRPNX+qmt2uYL71NmYc4flkNCsaT9Eu9fkzs2QF5cldgzRzJROkdW+1RoQ1tlWPN2Ezzi3LhJvlNCswqLED6EKYPD62BSgCqwvvmkVrOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772740758; c=relaxed/simple;
	bh=f3lIe1nCQhs09YETGeCCveWRlwXAKBFRYCG+lXb1roM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=aAI6wWT/TxyoL2sjS5O3wGQn/er5C/pwLHsGcDJsyXGGJ/shbQpZVEPn7e4lOJ4jZt2Dt22J0VoF5Gos9FSpfMfNq5VZ/4TaF+jcCvudvWCfkbhtD7l9ZeI+4OLyhkVCI+Yf1z6uofy6mqnHCBFLx9uGRFIRqT6K0SvMgrV8jfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=X4JpREue; arc=none smtp.client-ip=212.77.101.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="X4JpREue"
Received: (wp-smtpd smtp.wp.pl 16902 invoked from network); 5 Mar 2026 20:59:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1772740746; bh=7DN+KI20/nr4bGXo2TiFQ3uVPvfOMz0EViovKfREFA0=;
          h=From:To:Subject;
          b=X4JpREueQcxtL18zjrpZit6Yb5HoDpNhtqo0A7g9iGBBzW1V4lVSaPDh5+LxWd9mP
           9jUbXdePb99PQQlnWODuKhXQSFB1souwh42ov0GVy87Tdbr9Jlhl9AzRRuU5Ew5AIn
           enJRHoaSQly06lCAQ/FHuN6lYYHKSsT0cr7pBLCJJmrVcAZhhFnIlik1umBakRCDPd
           yvnbsrXtK7HEqQjr7Vu6i/STrxXjy0DK+qIxFIVo8SsY+xH8qBLSURafqsbXH4haQd
           hhmLFZUavgLYkTVvpzmnO1X0aTPAg8X4EG3orK/uhv3BAZwGgB1PnPLqH/0JhsZzwh
           mEJHI3IKcombA==
Received: from 83.24.116.171.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.24.116.171])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <ansuelsmth@gmail.com>; 5 Mar 2026 20:59:06 +0100
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: ansuelsmth@gmail.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	lorenzo@kernel.org,
	olek2@wp.pl,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] dt-bindings: crypto: eip93: add clock gate and reset line
Date: Thu,  5 Mar 2026 20:53:10 +0100
Message-ID: <20260305195903.59776-1-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: c7c3f264b6f210d9aa7875ffc4db7536
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [oWox]                               

Add the clock gate and reset line, both of which are available
on the Airoha AN7581. Both properties are mandatory.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
v2:
- mandate clock and reset properties
- drop extra new lines in example
---
 .../crypto/inside-secure,safexcel-eip93.yaml        | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
index 997bf9717f9e..10caa989f660 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
@@ -48,20 +48,31 @@ properties:
   interrupts:
     maxItems: 1
 
+  clocks:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
 required:
   - compatible
   - reg
   - interrupts
+  - clocks
+  - resets
 
 additionalProperties: false
 
 examples:
   - |
+    #include <dt-bindings/clock/en7523-clk.h>
     #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/reset/airoha,en7581-reset.h>
 
     crypto@1e004000 {
       compatible = "airoha,en7581-eip93", "inside-secure,safexcel-eip93ies";
       reg = <0x1fb70000 0x1000>;
-
+      clocks = <&scuclk EN7523_CLK_CRYPTO>;
       interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+      resets = <&scuclk EN7581_CRYPTO_RST>;
     };
-- 
2.47.3

