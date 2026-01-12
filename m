Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4CC2C1586;
	Mon, 12 Jan 2026 14:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229767; cv=none; b=CvOSkRlnmjmaOCbYIPDjYyVgTI3rdEarzV77UnZLB49QihtlAH2ILI1P92UbVCfs6k23xxy9+/1aUnVQ7pUa/AvI/gG1942VjsPkK/0UptkMPxnr9+jnkFnbRPyuwZowWKUwVWPZ3k5TTJtrLBja74MtE4aW5zsP8Es3agyCr+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229767; c=relaxed/simple;
	bh=2+DvUYmYV9U/Yj8ZST1r0/xHoFeYFSLopr9bIm8GCoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3wGHgJfvZWqkgAWityNY/ehzz0ejCgz/WTxkvnJSPO0qp0dnZRNOK82xOE3IH9e7x814SDMhz4NYj6Ves3wBudQc0gf9Kq1Zo98xDpGIr2/hXBA6npz2pB31pdgxI4fqxTaGD4V+TVSEbkIpAFGPUSdAKcDzvyyYLAYoVaeDqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=MOzETrib; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="MOzETrib"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1768229764;
	bh=2+DvUYmYV9U/Yj8ZST1r0/xHoFeYFSLopr9bIm8GCoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MOzETribil6Cl9y0nxG5xkoWU+8V0zB3L08kfQ2O8t5Tl8FkHbdKCPwR0DEjX55Tz
	 xSsl6e7guJ8jfl4fm6o8F+p8HWe2vq0Whh6fInP33Nz1sXSXXjGuqaEhJVq3PM/lW2
	 kgCbvGwaeH4lhiXmb8y+FJkBA4PAZDkxwbzb7j6+/Iqw+m44DCMm6kTmE5rWnRAtfI
	 4YUQqPf8/oKYyW4hWGwz40YWUZyo9rBHiTEiaB0QEHgbCT5p4+cCG8ex6U9LApvVmm
	 27gx4ZToOO0iNxvt7ZrDBJyupZghIWETlxJmzJF6iOVEzojmMoaHm0qHy4CP0CmE7S
	 ZO2i4iUPMmuiA==
Received: from IcarusMOD.eternityproject.eu (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9919617E13F1;
	Mon, 12 Jan 2026 15:56:03 +0100 (CET)
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
Subject: [PATCH v2 4/4] arm64: dts: mediatek: mt7986a: Change compatible for SafeXcel crypto
Date: Mon, 12 Jan 2026 15:55:58 +0100
Message-ID: <20260112145558.54644-5-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112145558.54644-1-angelogioacchino.delregno@collabora.com>
References: <20260112145558.54644-1-angelogioacchino.delregno@collabora.com>
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

