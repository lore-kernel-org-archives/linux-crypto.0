Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989523A5E75
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 18:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564099; cv=none; b=GHPDxGvfzWi0oQ8qlR6zGgKnArcJb5zOF97gwnltlZwDQ5+JDj/KJ2uSEKukSRZpFbd7muGSYZuQousOt02lmZgDS9kNKjR8YB0UViYk7pXwcLAqJwS5ssKOJABYfTO9cJoT5DjPIBQu0CM/pqP1ibLwUFi8xapK3lI691ocuJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564099; c=relaxed/simple;
	bh=TOindIGzZKxIs2LOXvCcEzadt2uDTnIUZ8L3R0dvn5s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RNvm7ruTPT6UiMsKacfF0OHLlB66S8mB4pFAROIcLjKGohVBa06HT9RdrBk2l7D7rLtqoa9VGENa3gngtFWjRE/fuWHKMqOLee7EgvYkyBP+oDfW5TqbwlTqdDb/aoAVeVHYSOtncFwCchGJsEdqIiExQBWZ3bsvHX8QVN+YTG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=RZ0+TCdY; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="RZ0+TCdY"
Received: (wp-smtpd smtp.wp.pl 41929 invoked from network); 3 Mar 2026 19:54:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1772564093; bh=n4z6FdYhYaFqV+h14J68jBQV7uz/eMFVd1la7jJI9Rk=;
          h=From:To:Cc:Subject;
          b=RZ0+TCdY33t4IZsm9S44lHbyCE7C9ekSDNPvB61rNzz4EvBI7OXSSNDg/h7P638cj
           94/2JSrimDIAJR3yILSpIStygYCOCcCnWceWxnU04ni4EmyR9Eui5qBA8ComSVkZ0T
           Bk6IlPH8+/Pxm7urQkxkFlEpRkhkUEyleuj008i3Yry9qCyx5pcbJHfRpXiyh9rD5l
           geWBknao5EEX6LAXCOWoWcqWyNGvqeUFb9hVaA5rrOYuWf1ch3GBO34yBVgVC9WlLA
           POouYUtmBF9lsiGlOx33CH5aqDlkhwwbxbiBkMEJWKiSSFsuPxbOtrnLtuILGSDy/Q
           x3RANrXvQwE3w==
Received: from 83.24.116.171.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.24.116.171])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <herbert@gondor.apana.org.au>; 3 Mar 2026 19:54:53 +0100
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	atenart@kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH v3 1/2] dt-bindings: crypto: inside-secure,safexcel: add compatible for MT7981
Date: Tue,  3 Mar 2026 19:53:49 +0100
Message-ID: <20260303185451.70794-1-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: 312696ebf01c215835820228deefb2c6
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [oNOx]                               

The MT7981 as well as the MT7986 have a built-in EIP-97 crypto accelerator.
This commit adds a compatible string for MT7981.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
v3:
- drop oneOf
v2:
- just add compatible strings
---
 .../devicetree/bindings/crypto/inside-secure,safexcel.yaml   | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
index 3dc6c5f89d32..a34d13e92c59 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
@@ -18,6 +18,7 @@ properties:
       - items:
           - enum:
               - marvell,armada-3700-crypto
+              - mediatek,mt7981-crypto
               - mediatek,mt7986-crypto
           - const: inside-secure,safexcel-eip97ies
       - const: inside-secure,safexcel-eip197b
@@ -80,7 +81,9 @@ allOf:
         compatible:
           not:
             contains:
-              const: mediatek,mt7986-crypto
+              enum:
+                - mediatek,mt7981-crypto
+                - mediatek,mt7986-crypto
     then:
       properties:
         interrupts:
-- 
2.47.3

