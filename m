Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5156B38424A
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 19:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566770; cv=none; b=mPA5A0znXfOBBUMXNuBYf76DUGG6AB8tMcikrxqduGB+L8KmRvPLZGZRFm/OXJWTuSqpc2p9NOuDmw9YpHOZ8Ayq9dVnXMHz1Kp11tFzsygAP7uOzBgOGbvrsDiddhU0bNdke+D8NBAxPcYSPbbeiLSX5Mjc2Y4dRNhTTxv5iGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566770; c=relaxed/simple;
	bh=EIuf9p9DGDerJYckqSEXvWNfidXj4lFLK+deyqe5Fm4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AS9ymBWeBM4hb1h1v9/lijdjzqUOWqD8LB03UFOb8SoACP/a0zEKxU3sMLImaA+Wgrr3EO12vrFeQrmDRbPewFOFENA+BbcJuP/0HOWgCqy6RM+BURiiHSoINu+JcYN5nexC4ZtXroSd7kD6lK/osBden/apQS06PuXttIMVC44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=E4FT7ZCm; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="E4FT7ZCm"
Received: (wp-smtpd smtp.wp.pl 27543 invoked from network); 3 Mar 2026 20:39:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1772566767; bh=YKkgtekbPY1RubSw8KzAomOXLrhdGpkkWDAczAbTOhQ=;
          h=From:To:Subject;
          b=E4FT7ZCm02JgZguuxHAAIO4kAV7PgBOIGBRHZlrWgV/Fvvj+f3C1uwn9MPgXOsqbM
           EtUSx3h+rvVR+JkyYEu9f1a0JsuHqxPmQVPQ1LJZH1h8aewuOR0mkfipk3eiC+BRAS
           uDazu5gjK3ijGdrmDfuw8ZOtbllRBsE3UfJTmWvOpfdUU4PRbiKbKTLb1C2pvldPms
           d6QYrc8HsIoJMSbkXNbbvkwNvpyUG7oNzrTBLSnbNV+Hkd/TZMSNebks5K9F6dEJ7U
           ptQYT9owcL4zs/LoN8kFHPNbZrhDCsvtdxj9oG4T0Viy8E9PwlBGRDnG574+vBEq5o
           YX4sk/Gcg0PqQ==
Received: from 83.24.116.171.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.24.116.171])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <ansuelsmth@gmail.com>; 3 Mar 2026 20:39:27 +0100
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
Subject: [PATCH 2/2] arm64: dts: airoha: en7581: add crypto offload support
Date: Tue,  3 Mar 2026 20:39:18 +0100
Message-ID: <20260303193923.85242-2-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260303193923.85242-1-olek2@wp.pl>
References: <20260303193923.85242-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: fd91f4b048d23eafbae91f1322a9d673
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [QRq0]                               

Add support for the built-in cryptographic accelerator. This accelerator
supports 3DES, AES (128/192/256 bit), ARC4, MD5, SHA1, SHA224, and SHA256.
It also supports full IPSEC, SRTP and TLS offload.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 arch/arm64/boot/dts/airoha/en7581.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/airoha/en7581.dtsi b/arch/arm64/boot/dts/airoha/en7581.dtsi
index ff6908a76e8e..4931b704235a 100644
--- a/arch/arm64/boot/dts/airoha/en7581.dtsi
+++ b/arch/arm64/boot/dts/airoha/en7581.dtsi
@@ -300,6 +300,18 @@ rng@1faa1000 {
 			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
+		crypto@1e004000 {
+			compatible = "airoha,en7581-eip93",
+				"inside-secure,safexcel-eip93ies";
+			reg = <0x0 0x1fb70000 0x0 0x1000>;
+
+			clocks = <&scuclk EN7523_CLK_CRYPTO>;
+
+			interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+
+			resets = <&scuclk EN7581_CRYPTO_RST>;
+		};
+
 		system-controller@1fbf0200 {
 			compatible = "airoha,en7581-gpio-sysctl", "syscon",
 				     "simple-mfd";
-- 
2.47.3

