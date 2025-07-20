Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA1F1CA81
	for <linux-crypto@vger.kernel.org>; Sun, 20 Jul 2025 17:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753033751; cv=none; b=WJbFAJF/sn+Ue/GOiEF227Hhv5L9dRg7CRMu80eZ5Cr6G1blBYrRrb8zUgA1+0SsgfZaNmvlrpIP77bDgU6qgRatdvn7c+Or9lobxmQjPtHZ/LMbClvwqghJXBU/Avllg7KpBgq+Zt7005WZKUBU3sbxUqaWVW4jKxk7/PRzL5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753033751; c=relaxed/simple;
	bh=KjZzS8XBgTZPPOnkKB3OMbLXCrHeBc/DuwjqhPGv1yk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=eYs1Rkfu0RqxbF5Vxj8p4+8Rf45mT6eCQR1HzdNCeLMzEN1s0URXrWx+9xrIF+LWwHDTTcLRD1xcDOuS7TeSl4qC3Z/pBs43msiYT5jZwz7iFPzR9a9KURP1XCNNSLHc6Yn8/7jyHqu7CJdPAUQytXz6ZIj1eBEbaF6OyjySkGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=n7/Hit4k; arc=none smtp.client-ip=212.77.101.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="n7/Hit4k"
Received: (wp-smtpd smtp.wp.pl 39467 invoked from network); 20 Jul 2025 19:49:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1753033746; bh=ZoV8pDRAyWULEp5ZRBitKk63UkguBuNR7jm0lOnkgcM=;
          h=From:To:Cc:Subject;
          b=n7/Hit4kzTHWgHPbjsYJTjEH9Qxe0xVT4tOZE6b7w738YiHZ8vNvtQVgSx6K8DlAr
           Jx8p4aia2GHBhn+Xs9kefJjss58UlcEBvkYeaqzUnyLI6PgU6zAj3WviaCSE1H5HfP
           1OCxNR6hjQANdcbH8XE4DZEN+3rsEWJnE+0RYFV/GyCFLSlGX1edHsrwaXPVytKP9y
           EDb/IbCEMnqoDS7lPa3CV+N02bpgx1hF/gAVh9Spbu6Y/jkv5a7yuMfx/1MXs47P7x
           9kLLjZodNlQz5rrPZprJYfLInFMhzuhQb/Qsiwxdg+Tkoq4mmxVt/xQB3Cuuf5JFMA
           R4WXK7+RZ3Evw==
Received: from 83.24.129.157.ipv4.supernova.orange.pl (HELO localhost.localdomain) (olek2@wp.pl@[83.24.129.157])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <herbert@gondor.apana.org.au>; 20 Jul 2025 19:49:06 +0200
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
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>,
	Sam Shih <sam.shih@mediatek.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 1/2] dt-bindings: crypto: inside-secure,safexcel: make eip/mem IRQ optional
Date: Sun, 20 Jul 2025 19:49:02 +0200
Message-Id: <20250720174903.1321533-1-olek2@wp.pl>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: 1a3ebb6bead59a00b80590b1222a87ba
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000008 [ATvR]                               

Binding for this cryptographic engine defined 6 interrupts since its
beginning. It seems however only 4 rings IRQs are really required for
operating this hardware. Linux driver doesn't use "eip" or "mem" IRQs
and it isn't clear if they are always available (MT7986 devicetree
doesn't specify them).

The hardware reference manual [1] for the EIP-197 IP core only defines
ring interrupts and a global interrupt ("eip"). Ring interrupts can
optionaly be routed via the main interrupt. Role of the "mem" interrupt
is unknown.

This deals with:
arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: crypto@10320000: interrupts: [[0, 116, 4], [0, 117, 4], [0, 118, 4], [0, 119, 4]] is too short
        from schema $id: http://devicetree.org/schemas/crypto/inside-secure,safexcel.yaml#
arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: crypto@10320000: interrupt-names: ['ring0', 'ring1', 'ring2', 'ring3'] is too short
        from schema $id: http://devicetree.org/schemas/crypto/inside-secure,safexcel.yaml#

[1] https://www.scribd.com/document/665924595/Security-IP-197-HW3-4-Hardware-Reference-Manual-RevA
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Sam Shih <sam.shih@mediatek.com>
CC: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 .../crypto/inside-secure,safexcel.yaml        | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
index 343e2d04c797..97af96bfe5f6 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
@@ -26,16 +26,23 @@ properties:
     maxItems: 1
 
   interrupts:
+    minItems: 4
     maxItems: 6
 
   interrupt-names:
-    items:
-      - const: ring0
-      - const: ring1
-      - const: ring2
-      - const: ring3
-      - const: eip
-      - const: mem
+    oneOf:
+      - items:
+          - const: ring0
+          - const: ring1
+          - const: ring2
+          - const: ring3
+          - const: eip
+          - const: mem
+      - items:
+          - const: ring0
+          - const: ring1
+          - const: ring2
+          - const: ring3
 
   clocks:
     minItems: 1
-- 
2.39.5

