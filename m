Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68F72D9780;
	Mon, 12 Jan 2026 14:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229766; cv=none; b=bC+KLjLd5tYvR6aZP1D1kdTwH9AGpUuSxq0OjchiGlFLoGrrSurBvnUfselJrQRI51vCGVee62evq6u53/OI93iyu9frJzMfC97Jha6S/ApXjBMTFb/fgYGcnL60YVKYUJxqn+Q3otJdF6JxxMQW/eVybKCJtEHLCqTmSW6XUQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229766; c=relaxed/simple;
	bh=gw1VaxWzqkyKrA2KxIUxIvewB29jkb6zfBD6Cnr2AVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPPhI/zagAubHj98Ep1lAs8gw16by7Aw5/HWeZKCTzuiLQNhcWqIsuavz2ndq7AEUggdsaOYXVWRbR/zqaSXsYdiVRa8QiY6UrT6wwXpZ9T4sRXBEGKpBmHB/h6/TDeV/tTdrnrerbhW7RL/9h6V0F1qJvWqOBSrVNW6DXyiQgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=Jvvp8D/P; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="Jvvp8D/P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1768229763;
	bh=gw1VaxWzqkyKrA2KxIUxIvewB29jkb6zfBD6Cnr2AVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jvvp8D/P+mDkgw+JICaE/Z1AYqoyAAOjofI/lF7k9/a/WA8mOhDNBsq1MO7wgAJmS
	 1Rf4Bk0oNTk7nETQ4hAp+kCViyilQBVWXqk7w7tJPkCf7ZvJ6XeJvwPi4xFIqVNPhy
	 sbFPD4ZDI7eflyQoGZI4Yb6eqR1gYSST5MDyVvweUDu3DnUyRnLSVzZGP/nK1ksFkk
	 i9DsC8gOM/4QYoK83hg5Cd4sSuv3cNF3pMk43nBelWHHtQwb/9yz74N+iz4dH80i1c
	 y1o3sQLkzoR06eGbAyseWGzWgKSlnWIov5VIjXPLC/saPgE/YwcpSuqCiBImcnRHLD
	 2mWzb5by9/JPA==
Received: from IcarusMOD.eternityproject.eu (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id D527117E11FF;
	Mon, 12 Jan 2026 15:56:02 +0100 (CET)
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
Subject: [PATCH v2 3/4] arm64: dts: marvell: Add SoC specific compatibles to SafeXcel crypto
Date: Mon, 12 Jan 2026 15:55:57 +0100
Message-ID: <20260112145558.54644-4-angelogioacchino.delregno@collabora.com>
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

