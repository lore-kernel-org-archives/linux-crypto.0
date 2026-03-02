Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794F430B514
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 23:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772492474; cv=none; b=u0sFHr2ysVosP89NI/DNV8tdR8NQfRRQQJbs/AIKNsyZbLzDxwiq0WCXgY7uU6bCxYEOPskiOgV5ox1BIAf0Y2/LX+J5j7znS0Ckg6vJTSZrwhiA5gm7vMZZtFmCYOHAhZWLbieHU/CgCnIsNHEfcHGWNH6VUGNOZAl4nLNj4qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772492474; c=relaxed/simple;
	bh=08Lo2Lp5hpnOLtmrS9ICWTId2kHrCWoTqvqJgGYWbLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNlGez1TsnNAujOp0Cqitv/yYAsPthCix0UL4Lkmqsr+WdVj1GG1SAtsmU8v6pwbBz6GD66lnlnM7j62Tbk80PwOGYdIQqf54JrQ9jamKAMIrPmytS02ZroOkLgFsO41KQyUOs2Ovtwb0/CE1kwPWGBLcCItrg7/Nuysgr8shfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=uPDCu8EG; arc=none smtp.client-ip=212.77.101.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="uPDCu8EG"
Received: (wp-smtpd smtp.wp.pl 22820 invoked from network); 3 Mar 2026 00:01:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1772492465; bh=9xOvgBccEPgIHRjW7JLhRF8m7AtAmIUXTMKnuXsqjv0=;
          h=From:To:Cc:Subject;
          b=uPDCu8EGqedIL+PL3QJTUaKpbw8mc9u4Adh4qLbQ0gOUrYLrxbN+GiEgeKuBjTj/7
           Fi9ba5J7Xp5O8MkXikCaZNTlwlRLa2kv+VACQoaI8BUjWJ4iDGcSperU8oB9lY8OhW
           SnzdCOCb9h8ALncOtIntqzoUiPxnZzr8mzpAiJ2aKU6HVulCWGH4c6E3HfdtY1Piej
           tpFOl0QBybyb8V4DoMysJGU4cNBop9HSlgyrTpEL+mOIqlYKb1L5yRoVuCZ+pXQJto
           bGUPFYEppE5Km6+M+WtdwM6zESP/KV273KVnLhc2cyhHrYJYLAEvSAiKhL799ToRzn
           LoEV4691wW/Yg==
Received: from 83.24.116.171.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.24.116.171])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <herbert@gondor.apana.org.au>; 3 Mar 2026 00:01:05 +0100
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
Subject: [PATCH v2 2/2] arm64: dts: mediatek: add crypto offload support on MT7981
Date: Tue,  3 Mar 2026 00:00:39 +0100
Message-ID: <20260302230100.70240-2-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260302230100.70240-1-olek2@wp.pl>
References: <20260302230100.70240-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: c21ac2b7c0b21cfc22d068621eec5de7
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [4Wq0]                               

The MT7981 as well as the MT7986 have a built-in EIP-97 crypto accelerator.
This commit adds the missing entry in the dts.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 arch/arm64/boot/dts/mediatek/mt7981b.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7981b.dtsi b/arch/arm64/boot/dts/mediatek/mt7981b.dtsi
index 4084f4dfa3e5..94c7bf0050fc 100644
--- a/arch/arm64/boot/dts/mediatek/mt7981b.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7981b.dtsi
@@ -150,6 +150,21 @@ sgmiisys1: syscon@10070000 {
 			#clock-cells = <1>;
 		};
 
+		crypto@10320000 {
+			compatible = "mediatek,mt7981-crypto",
+				"inside-secure,safexcel-eip97ies";
+			reg = <0 0x10320000 0 0x40000>;
+			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ring0", "ring1", "ring2", "ring3";
+			clocks = <&topckgen CLK_TOP_EIP97B>;
+			clock-names = "core";
+			assigned-clocks = <&topckgen CLK_TOP_EIP97B_SEL>;
+			assigned-clock-parents = <&topckgen CLK_TOP_CB_NET1_D5>;
+		};
+
 		uart0: serial@11002000 {
 			compatible = "mediatek,mt7981-uart", "mediatek,mt6577-uart";
 			reg = <0 0x11002000 0 0x100>;
-- 
2.47.3

