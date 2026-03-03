Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B487E3976A1
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 19:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566770; cv=none; b=eqyU4nL17ZFrfKEm30t7OUfRPmt2JxwAyvzgom4xL8xMliE5nur+KE9lREjtmamFxVXJjjTcVEm9uCgk4Lc+KgaI9FUT8sBuFURK/h4Y/+qHFH5K0A2o3rCwXHa+X5Obpr1CnpjzQfeiJDlefZyg7wo9wwgBmoZrT9NUopSptF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566770; c=relaxed/simple;
	bh=8euL0IW+U1FjkfADxJnICOPAC6YEd9jyOgAv9YEVWiA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=nCHsoTuwpel5WAugBy5b0IG3kLxkOaLduUfjcYXQdKjw35GL51uQvIif+RyEEgUtckxeUHeZ4G04Z66tUpG+XxzKzaKdRP/g3+ACUr4Q4l9QBPsWSUuqrZh/iuKePFOVTIuNa4hPt0q9/6d6nHaFxDFciRF6xqOZ41J7AQVdk9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=cCbwc53b; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="cCbwc53b"
Received: (wp-smtpd smtp.wp.pl 25368 invoked from network); 3 Mar 2026 20:39:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1772566765; bh=V/WjAJijWZg2nQnR0Dw6GKJGN7hld0EpcPy+hJO8Aew=;
          h=From:To:Subject;
          b=cCbwc53bfA0nWMP4mTTDmQjVclbq/fKeM2VkCXwVjVgMXVSDM3Siu/ZCVv61wNwLp
           IED2or1NJMjdaTJhiCjeJ0r7PbNadT0IUfrMK5YJoP3J+IHeWWI4BRXotnH30sRRFq
           Y7EM69d14LjklIRi3tjR8EbuK+i0Mc9I0RCyJSH/gf5WHDwl82PwP3/XT46mkMghmu
           4sre4mP/K3gzTZxcbrLxv03TrU4dQP2JPIksbJID5EPTf/6o5Dng4ObuB9zgKbl0F+
           C6Ya+ifdF78ZIKi1jLlLM9XPOABg/SeaS56CPXpedOylWVV2SGcONX279dKKjw+qYG
           rLTkNwRAxqXyg==
Received: from 83.24.116.171.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.24.116.171])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <ansuelsmth@gmail.com>; 3 Mar 2026 20:39:25 +0100
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
Subject: [PATCH 1/2] dt-bindings: crypto: eip93: add clock gate and reset line
Date: Tue,  3 Mar 2026 20:39:17 +0100
Message-ID: <20260303193923.85242-1-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: bc4a4ec882821cb528a87e98cbf1d0e6
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [0epB]                               

Add the clock gate and reset line, both of which are available
on the Airoha AN7581. Both properties are optional.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 .../crypto/inside-secure,safexcel-eip93.yaml         | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
index 997bf9717f9e..058454b679b4 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
@@ -48,6 +48,12 @@ properties:
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
@@ -57,11 +63,17 @@ additionalProperties: false
 
 examples:
   - |
+    #include <dt-bindings/clock/en7523-clk.h>
     #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/reset/airoha,en7581-reset.h>
 
     crypto@1e004000 {
       compatible = "airoha,en7581-eip93", "inside-secure,safexcel-eip93ies";
       reg = <0x1fb70000 0x1000>;
 
+      clocks = <&scuclk EN7523_CLK_CRYPTO>;
+
       interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+
+      resets = <&scuclk EN7581_CRYPTO_RST>;
     };
-- 
2.47.3

