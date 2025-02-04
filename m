Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC9F21517C;
	Tue,  4 Feb 2025 15:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738683441; cv=pass; b=JnWuohthMgGXfncHWNJgkDSIgFUdmD1zvX+UeXMH9FwB0zgcJqS3x6aTJSYbDV3mK/Qhi4t8GIE1hnAF/Hsv7kBRpgNdYel7srkr4ll0c56hfCbplm9XfBJjH5/mP68J6XWbtChPnwq1lU1LntWbH0xURxlsQlL7sban9FMvnhc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738683441; c=relaxed/simple;
	bh=/QWtDtIVKZ+DOfkephsSkBjccTgJTNb3p230GiJawFE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hcv8K8Ke+CNo5EtU5UfOZahazH2/321he4/d8wpG4CE9otTeesqjbHlaBRRvSPMiMDwyDayKgR1fWFI5xq01GRnFrD6GrIOD54yfbLaSikfjqCz0Hbfk3l48q+YZ3gmiVi9TI0f2HdZEvUqeFrM+1j5ccPDz6x1HfTdoN4jj/tA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=KF3VZuAJ; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="KF3VZuAJ"
ARC-Seal: i=1; a=rsa-sha256; t=1738683408; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=M+jJ3zCjDsjDnu5p0IcsJGhTZbjO3H5WonEDeYztF8vGnaOlUfdssDT2ughk8sAij6nxTVcFzhIdgZTnxryv545JhTq+VrjfQaHRu52JZecT5XZ+yNjxNBL/OBwT+LQ0kyjRqB3MG3MIggeB1gopNjQ0Py1nAZGfFhqe1kYdOMU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1738683408; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=54iXlGsz9B7Sdyg3RzGURwQveukxIgeMMUfxlEzdSXs=; 
	b=R2mOS4nKAKumwAndqcYf6K2rnSvuDQXg8WwT7aNpWhkGDXgFu+NO8EMQGGOsQnrQGAu4YcSOjie5II/YCIHP+X6M9KZZ34eTk/TaytRbTUGNew99kmSjy5fB4RkyNfpQ9cbYu4TT10Qb3suF6DZ4m/Mv0dFsKBV3d5bdFSBTRic=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1738683408;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=54iXlGsz9B7Sdyg3RzGURwQveukxIgeMMUfxlEzdSXs=;
	b=KF3VZuAJFP5QPbkxC8awh5M+FfkmEf/aZLK/FuqXZ85aHe4qIsJcVom18JTduGLA
	KmokPTb6ARVgyLMwXSB+ADu7j2yu8cQM5Ht7nQ3nWVSQbuMzjrg8pJivYZcdztaQ5H+
	sY7JxC3Hd0VWttyjqiuDoM5NAYuZjXdfTin27Tb0=
Received: by mx.zohomail.com with SMTPS id 1738683405706315.2089997355388;
	Tue, 4 Feb 2025 07:36:45 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Tue, 04 Feb 2025 16:35:51 +0100
Subject: [PATCH v2 6/7] arm64: dts: rockchip: Add rng node to RK3588
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250204-rk3588-trng-submission-v2-6-608172b6fd91@collabora.com>
References: <20250204-rk3588-trng-submission-v2-0-608172b6fd91@collabora.com>
In-Reply-To: <20250204-rk3588-trng-submission-v2-0-608172b6fd91@collabora.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>, 
 kernel@collabora.com, devicetree@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.2

Add the RK3588's standalone hardware random number generator node to its
device tree, and enable it.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
index 8cfa30837ce72581d0b513a8274ab0177eb5ae15..3cb52547754c2b64ee2dc0e08c23decf9773faeb 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
@@ -1921,6 +1921,15 @@ sdhci: mmc@fe2e0000 {
 		status = "disabled";
 	};
 
+	rng: rng@fe378000 {
+		compatible = "rockchip,rk3588-rng";
+		reg = <0x0 0xfe378000 0x0 0x200>;
+		interrupts = <GIC_SPI 400 IRQ_TYPE_LEVEL_HIGH 0>;
+		clocks = <&scmi_clk SCMI_HCLK_SECURE_NS>;
+		resets = <&scmi_reset SCMI_SRST_H_TRNG_NS>;
+		status = "okay";
+	};
+
 	i2s0_8ch: i2s@fe470000 {
 		compatible = "rockchip,rk3588-i2s-tdm";
 		reg = <0x0 0xfe470000 0x0 0x1000>;

-- 
2.48.1

