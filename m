Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6094282F1B
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 23:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772492473; cv=none; b=JkXeiRtxgcYWqEe/Z6YoCLecH7g5DavX5eWtN2nkLPDkFJ9ivir4a6cLCm4LQ2vJybYStdtLxBCz9hf8P/RqZWbMXkFArn0/PlA95epE83tOty9fWLtyIEsE+hJxg3E9Ff3xG16/uWrkvi1HGOmsE48awy9FEEnbhMpbdcWaecY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772492473; c=relaxed/simple;
	bh=AdFjy5dAsuSKmw2qXAWig0EInTGotX0ZMxBmhs88nLg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A7/x/XbLOIWIY94wEuE/RgTAEjWNrakpFH3eBiKDNb3jVLOxNAfJZBxbv4UgP/8I05wKWy9gXlt4n7JGV8rXKCIsCdVVTChgEJaVkan0+wryNm4t5gGASddTIYwCOVAM3s5AOOurLcxEhzLgYjrBaVaTnzpQ5lChTheuRqBGgfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=h7+VrX8J; arc=none smtp.client-ip=212.77.101.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="h7+VrX8J"
Received: (wp-smtpd smtp.wp.pl 21305 invoked from network); 3 Mar 2026 00:01:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1772492462; bh=7+cweu98TOcNO2fC2HKsiZqjaNg+7ppVWQ+2CpDVZbg=;
          h=From:To:Cc:Subject;
          b=h7+VrX8JF7VAf1BQwDmjpfLsuhB07MJnKuPBo+NocsvngfY51YBcYWwFXDEBNbohA
           xrTqSvXfz5Vf/Y8tyXi6wDF6oBtsjY5M4mH9mydRviOT1wKvR0X2vqWGtCl3eAXEgF
           hUeOgVQhxxzLTh9lHd9YAP5AqyUVEYdCLfc2WpBqAk0r050TYPFlikhh+9A8XEoTXF
           7mrlFG4VTCHkOxNoOLc70mT+hCqqhvP2tjVaMVNatTHpTlU8v0/5Azkgr6dsk4QB93
           PjCk5kX30g11wptGqAS7q6MGSnwlPpeWO+fNCfhPk6+GqYzhJuVoNvh4n3x+v6eu6u
           PSVaxrzGj5GxQ==
Received: from 83.24.116.171.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.24.116.171])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <herbert@gondor.apana.org.au>; 3 Mar 2026 00:01:02 +0100
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
Subject: [PATCH v2 1/2] dt-bindings: crypto: inside-secure,safexcel: add compatible for MT7981
Date: Tue,  3 Mar 2026 00:00:38 +0100
Message-ID: <20260302230100.70240-1-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: d08f458a8f4368eeb35a8e26834207f2
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [kFNB]                               

The MT7981 as well as the MT7986 have a built-in EIP-97 crypto accelerator.
This commit adds a compatible string for MT7981.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
v2:
- just add compatible strings
---
 .../devicetree/bindings/crypto/inside-secure,safexcel.yaml  | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
index 3dc6c5f89d32..6c797b7ce603 100644
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
@@ -80,7 +81,10 @@ allOf:
         compatible:
           not:
             contains:
-              const: mediatek,mt7986-crypto
+              oneOf:
+                - enum:
+                    - mediatek,mt7981-crypto
+                    - mediatek,mt7986-crypto
     then:
       properties:
         interrupts:
-- 
2.47.3

