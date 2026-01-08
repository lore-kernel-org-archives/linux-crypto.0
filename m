Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6A23A640B;
	Thu,  8 Jan 2026 11:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767870163; cv=none; b=ZmhGlI0UD8eqoCOn1WXVOpVIbBxC2Zp4d9guiafIjFZ4eTJu4Wj0NMidQsZDNRf+lFNVzBNWOzmcQnyQB1O/OgOfFKq+za1vREb82AxP6x+jfWrBuZcXCk2idtMG/gP2Mm0dBiMA2g16lClSfAnTVkwXvMefmz/wOjxEeTAR5rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767870163; c=relaxed/simple;
	bh=gw1VaxWzqkyKrA2KxIUxIvewB29jkb6zfBD6Cnr2AVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OigubWvLcZdZzbfVfqX68GbQBQRRhiL9D0zWQrNRKK+GJ1GwJRzu1dCEZvV9N908MkzAdUOQowWD7t+WF8VeLfIaWwiUkQDSwpDQvWgSfPXKJWwGHIsaS6RbYJJjA9ucypL508vnR9FHQWnupiSnPaJsMYwpya1ij1n3ejtykuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=ST55Cl/b; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="ST55Cl/b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1767870150;
	bh=gw1VaxWzqkyKrA2KxIUxIvewB29jkb6zfBD6Cnr2AVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ST55Cl/be8Fa/ix2tx495kwY7maMiNlOVgAfRBDwMT/EbwANxJbtE7qMSdG4JunKA
	 vD1WBXNOVPku7kPatEmReCNA7MEM4E19JGCHGFHtR9Kn+l6FpGvIthi39x+ZcH51BU
	 YAQt2Vvebpu3cMxTNEIT5CJ3WTcahG+JKY6s9F2lms8k65cP0D+6Ek1zIUqHkMEAvV
	 JAtgd+uMOclMrNnPUetWYcn93kzwvb897z2ljNyJfllLvecWki7RKh2XuyyPDgrqJB
	 yU+Zw+rWzTyVIzozFUMtZTy8/BBktKCBI5lqBVzPtCoyixLTVjoHDuJZdwWMThZNy6
	 89ib0hnK7LKlw==
Received: from IcarusMOD.eternityproject.eu (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 476B217E1529;
	Thu,  8 Jan 2026 12:02:30 +0100 (CET)
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
To: krzk+dt@kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	robh@kernel.org,
	conor+dt@kernel.org,
	andrew@lunn.ch,
	gregory.clement@bootlin.com,
	sebastian.hesselbarth@gmail.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	atenart@kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	kernel@collabora.com
Subject: [PATCH 3/4] arm64: dts: marvell: Add SoC specific compatibles to SafeXcel crypto
Date: Thu,  8 Jan 2026 12:02:22 +0100
Message-ID: <20260108110223.20008-4-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108110223.20008-1-angelogioacchino.delregno@collabora.com>
References: <20260108110223.20008-1-angelogioacchino.delregno@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following the changes in the binding for the SafeXcel crypto
engine, add SoC specific compatibles to the existing nodes in
Armada 37xx and CP11x.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi  | 3 ++-
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index c612317043ea..87f9367aec12 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -427,7 +427,8 @@ xor11 {
 			};
 
 			crypto: crypto@90000 {
-				compatible = "inside-secure,safexcel-eip97ies";
+				compatible = "marvell,armada-3700-crypto",
+					     "inside-secure,safexcel-eip97ies";
 				reg = <0x90000 0x20000>;
 				interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi b/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
index d9d409eac259..39599171d51b 100644
--- a/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
@@ -512,7 +512,8 @@ CP11X_LABEL(sdhci0): mmc@780000 {
 		};
 
 		CP11X_LABEL(crypto): crypto@800000 {
-			compatible = "inside-secure,safexcel-eip197b";
+			compatible = "marvell,armada-cp110-crypto",
+				     "inside-secure,safexcel-eip197b";
 			reg = <0x800000 0x200000>;
 			interrupts = <88 IRQ_TYPE_LEVEL_HIGH>,
 				<89 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.52.0

