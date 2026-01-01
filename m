Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F9F212554
	for <linux-crypto@vger.kernel.org>; Thu,  1 Jan 2026 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767288059; cv=none; b=A6X8EMrItN1VpLDC6HUGJjFt+6Yas050ZaX6kHhCkG8cQnPVXJEZB3GcNMORsdCOWG3kDKQvCGV2JPLqQzZn5fYwDNq67SHyiQeVHN/LnMmTLPjJRJgMe+uMc8G+lBEX4ZF8pd97IVVm/H28w/BtrkXJNK0F5esMni0LMFNZmlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767288059; c=relaxed/simple;
	bh=90htk7bfuWYRnjVIKKUjR+1kSEJaZ/Trtv5/TNJly5w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R8emf9Z6vLDKPR4E7WNd28qy59L0521WBhy+grxuDehr8tyCRNDZr0InkLOiqDFxQQhcfL2EI0t12Vtw53F+6uOWaARnQviyeuma3SsiiN71AuE5SY6eBtbTlmPOOwuXRkRD8DsmZucOL87Ifh2F3mo7wNPUkSXmqkH2Nx8+TJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=PUksjmM4; arc=none smtp.client-ip=212.77.101.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="PUksjmM4"
Received: (wp-smtpd smtp.wp.pl 29140 invoked from network); 1 Jan 2026 18:20:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1767288055; bh=VFxRYh+8coogy2GN8owHTs5aoW2sEqq+/fQszUYZvNs=;
          h=From:To:Cc:Subject;
          b=PUksjmM42K510nffF/6GK+kvx7CdnCnS56eZTJklUOwp0Zw7OqAzzqX60uBMZKvW7
           Htq+VwYtGAW5Pudk/OiQSuLpMZQ6FuPuy/PP+Qcbni7mVA22RPXw/N2WmoyXxXbMo8
           hLdTnpMQSEXaqTkGwS34GCEt+5xNEmz5cB+PvKYwQfGrBjzhIg7cFEOO49EMQvt4Mu
           Grblq3QVX/f9nncGM6MaPaONF/mimYpMF/w+dLNpP62Z0qvrZET/HEJ5f5POWFAYW2
           jhQABDOERVIWBlX+KIsxfImrBhs2V953QGOh4lmDfh55XQlCsy/sph83WCb5bHtiPF
           7oZ81vJGstqwg==
Received: from 83.5.157.18.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.5.157.18])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <ansuelsmth@gmail.com>; 1 Jan 2026 18:20:54 +0100
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: ansuelsmth@gmail.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	chester.a.unal@arinc9.com,
	sergio.paracuellos@gmail.com,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	matthias.bgg@gmail.com,
	tsbogend@alpha.franken.de,
	angelogioacchino.delregno@collabora.com,
	linux-crypto@vger.kernel.org,
	linux-mips@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH v2 1/2] dt-bindings: crypto: Add support for Mediatek MT7621 SoC
Date: Thu,  1 Jan 2026 18:20:04 +0100
Message-ID: <20260101172052.1862252-1-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: df73573d01c56ae3faa788a124db769a
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000007 [ccSx]                               

Add compatible for Mediatek MT7621 SoC. The implementation is exactly the
same os in the Airoha SoC.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
v2:
 - Corrected commit description
---
 .../bindings/crypto/inside-secure,safexcel-eip93.yaml          | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
index 997bf9717f9e..8ccff64f5c1c 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
@@ -33,6 +33,9 @@ properties:
       - items:
           - const: airoha,en7581-eip93
           - const: inside-secure,safexcel-eip93ies
+      - items:
+          - const: mediatek,mt7621-eip93
+          - const: inside-secure,safexcel-eip93ies
       - items:
           - not: {}
             description: Need a SoC specific compatible
-- 
2.47.3

