Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E393FB059
	for <linux-crypto@vger.kernel.org>; Thu,  5 Mar 2026 19:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772740760; cv=none; b=kSd1chH40oNtQ/7hVcl6v+AqbU1fHyjT1Q6m7HyGXDuQ+oS+md/rDLWintCKRwDdTWZP8F+WD8DBHcrRek2MQvtEWFfQCVAqSjrWGq4VHoYx+G+r/13XK3yzUoRcFM3YlqNMZH39NsA5a4BpevUpGHswq2NUKQm0ErUuOk21x54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772740760; c=relaxed/simple;
	bh=fcA8XSTeu115N9PUnt2hlsZJz7kgu2mWp1bBGaqNijU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPovZySGd4mcK2YwghPVWAle0yEUtvK3ISH7qVsFECV1wJdWy2tP3UZS4jM8pcbS/W6NbTXUB/0xxBcCUAgeVJvZVqdzOb2AijdOuCBnZRnSD0KWSW/OE7zWCoZFMVqZ4yJwlL5VMy6b9bAJe2yhZX5ph9V8ASaOOc4Q/skKUvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=KwhuQA6G; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="KwhuQA6G"
Received: (wp-smtpd smtp.wp.pl 18178 invoked from network); 5 Mar 2026 20:59:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1772740748; bh=UZ5ElGs4yDjDl9zUzhOrvjxZKl8oYf69gNiHnYY/vp0=;
          h=From:To:Subject;
          b=KwhuQA6G1v8VHcwAdkzeKB0Jd617Ax7zMA450fs72GLxUEvDqepotNfJVqNqmUrxb
           WZ544pJS6d7bKpb4AdvpXUgYCbyWjwYP88O8h/JAN+MNdDR4jnVJBWnHHN1bzdFIrI
           uoB1p74t1ZEVy0SR47a3NRmYQll4R7moXSRXygHGH3j0xJjQO1Jz1/BmKkpA2Df2CT
           //3gM3tmEPSmVC1m4Ja8jSZjhtLVzbBxRbX0NdTWHeoQ7yr/cTdKWvd4tnoA5NR6Qc
           QHseuxno8SequcRZUlFOgpFgduN6lo1v+jPE0Xz1ZY34EHmC+PgmYz6xdunD3AqaVV
           4U+vuhftNLRmA==
Received: from 83.24.116.171.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.24.116.171])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <ansuelsmth@gmail.com>; 5 Mar 2026 20:59:08 +0100
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
Subject: [PATCH v2 2/2] arm64: dts: airoha: en7581: add crypto offload support
Date: Thu,  5 Mar 2026 20:53:11 +0100
Message-ID: <20260305195903.59776-2-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305195903.59776-1-olek2@wp.pl>
References: <20260305195903.59776-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 303be36492603e776a8e2b4ea6b63e57
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [Ido0]                               

Add support for the built-in cryptographic accelerator. This accelerator
supports 3DES, AES (128/192/256 bit), ARC4, MD5, SHA1, SHA224, and SHA256.
It also supports full IPSEC, SRTP and TLS offload.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
v2:
- drop extra new lines between properties
---
 arch/arm64/boot/dts/airoha/en7581.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/airoha/en7581.dtsi b/arch/arm64/boot/dts/airoha/en7581.dtsi
index ff6908a76e8e..5621473f5155 100644
--- a/arch/arm64/boot/dts/airoha/en7581.dtsi
+++ b/arch/arm64/boot/dts/airoha/en7581.dtsi
@@ -300,6 +300,15 @@ rng@1faa1000 {
 			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
+		crypto@1e004000 {
+			compatible = "airoha,en7581-eip93",
+				"inside-secure,safexcel-eip93ies";
+			reg = <0x0 0x1fb70000 0x0 0x1000>;
+			clocks = <&scuclk EN7523_CLK_CRYPTO>;
+			interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&scuclk EN7581_CRYPTO_RST>;
+		};
+
 		system-controller@1fbf0200 {
 			compatible = "airoha,en7581-gpio-sysctl", "syscon",
 				     "simple-mfd";
-- 
2.47.3

