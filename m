Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB813A4AC1;
	Thu,  8 Jan 2026 11:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767870165; cv=none; b=Vb2T0Bch/jdF9ZnO9Bz1O2j5uBGBa6/kGSERQ78OOjzWemLYil/CPKLoDZRIIac9CowHkYz0IWvAwYA1juE26x5ga+j4pgVqYsMxe7ArXI9gP4QEtIwX5hdJImFidrVqNUIWHip6XSy0IcZt7zH/xoMRPgy795ediPj/fNwdpTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767870165; c=relaxed/simple;
	bh=2+DvUYmYV9U/Yj8ZST1r0/xHoFeYFSLopr9bIm8GCoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THBqfGPr0BFZh2qU0us4RAseT+uaHocj4QBfWviKV8w5STQonNnR7/iNhClUPwqvo9M5SWI2bQpoLctHa4MxlJ3RqcE0KUgZAbripw0GfU6B4vhSagm4UUVz1zr7uAjcolyZN54PSAd0WSr7BNZ7AOSsPp65olzpe+5p6WoHy5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=qMSvc9ks; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="qMSvc9ks"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1767870151;
	bh=2+DvUYmYV9U/Yj8ZST1r0/xHoFeYFSLopr9bIm8GCoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMSvc9ks6g7641gm1YJtSjKbwTP7DWfNV+86VME4OIhW7DFPi7RblvD7CiXkbY8pT
	 Pb+O9clCJuV8nhiCQXDpuKaWJzhi6rGfgBOjA1jAqsa7TgIDz+k0WVvmRq/K3F2+3O
	 z6tpwjseHX/RNSZcOzp3BYm/aw7nA62xftTP0TXueV/xfcEiXhtxGNT50njuNXavD1
	 sFjcDWjVUbS1ZL7Sf4xwBWu1E7safjVralqz2YgV7lNOM34Yp086SfbYChYFhGO52j
	 OS6gaEfxOR+JotyD2akXoOVe9k3SsS4JjY92272to6orZvBJe/diUoeF7jWVlQd/oO
	 oV2ojqGhJqTZA==
Received: from IcarusMOD.eternityproject.eu (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0DABD17E152C;
	Thu,  8 Jan 2026 12:02:31 +0100 (CET)
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
Subject: [PATCH 4/4] arm64: dts: mediatek: mt7986a: Change compatible for SafeXcel crypto
Date: Thu,  8 Jan 2026 12:02:23 +0100
Message-ID: <20260108110223.20008-5-angelogioacchino.delregno@collabora.com>
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
engine, add a SoC specific compatible to the existing crypto
node and, while at it, also change the fallback compatible to
inside-secure,safexcel-eip97ies as the eip97 one is deprecated.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 7790601586cc..9693f62fd013 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -231,7 +231,7 @@ trng: rng@1020f000 {
 		};
 
 		crypto: crypto@10320000 {
-			compatible = "inside-secure,safexcel-eip97";
+			compatible = "mediatek,mt7986-crypto", "inside-secure,safexcel-eip97ies";
 			reg = <0 0x10320000 0 0x40000>;
 			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.52.0

