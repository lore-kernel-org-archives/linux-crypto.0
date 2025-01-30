Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9C91EE00A;
	Thu, 30 Jan 2025 16:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738254757; cv=pass; b=NeHuUvwtx2k5TXWi04i2TVGiiqVW7Rx+DnB10RA+pznmUBu/Q17rGIwzb9lpFDx3fYVBja6MpFuvgDkm1rCrpJ1HdJ96231dWSBsigEyGtbore848dTOWb1Ugx5BroqXu8e1I0avD5mdrvRcqvu9kt1HLC6aYb9fD6rpQEt2fXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738254757; c=relaxed/simple;
	bh=QkNjV9M7+C6z0NLu3F5x1NfeVFdklKWH29BBErv1KYA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jeEXqVMVu4EqBa9Jo6qX7C8K0jxDVMzevtQyZawin2BhSi/q+hLYyG6Gj24mwgCruOjlz7JOQ1qnTVwFSvtX9iwalnsj8tUJMgph0Es5gWyx5Jk5KAj8J6q/QGyFeAyRpRROF/CaZ3U4WzQ+68yuwpb6gx5w9RM49U8XMS+rYmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=j80LJ3mO; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="j80LJ3mO"
ARC-Seal: i=1; a=rsa-sha256; t=1738254731; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=OZfOqK7UyDFGJsQXib/gpgYHBzMWJMeZKAbDvDWFzaANruEAkbBoNAWi3h/WxPsVF2l+P2xNBfS+QpUGwsau7aZOz9Q9ECCTizFh6pEGJRcqXdfizmc8bJFo17RMfzd2qGaSBxDbPOxD8PG2OF/gUVnMnPjWr04b4WlLAii8KIE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1738254731; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=MfIMIPmWjQlIq+rN6AT54US673m3Vv7abwiUpRadqEo=; 
	b=T9IoevOmePSt7qbl8FMmzE7jJ6bj/6a97GjzMCidcXd3PFYlQkALozhD3VliflPYq9GcfPJZNl23RXXlh/YN8zl7+KCb+9xOjl4PkenukQe/nKxh3+RVLZYAgk4po0LqncfLWha3nq9Y5WRFnQyUQs/ivfKwAPNG+0sTeLBgGF8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1738254731;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=MfIMIPmWjQlIq+rN6AT54US673m3Vv7abwiUpRadqEo=;
	b=j80LJ3mOWHOUS5cYN8/9fjU3IH0zboU200gSWF+Q7SG0hPgsFNE1S0kVfmSxnbGW
	kZvaUhhH2m+tvMM184rySkdotzz3tLGpp3ed3SkkpU8MTAc9ms/OoPhGuITZWsJP7Ew
	54l//sso/HiogQMkslkvRqFRUP9btbTT4181NZZo=
Received: by mx.zohomail.com with SMTPS id 173825472681471.09490665162434;
	Thu, 30 Jan 2025 08:32:06 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 30 Jan 2025 17:31:20 +0100
Subject: [PATCH 6/7] arm64: dts: rockchip: Add rng node to RK3588
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250130-rk3588-trng-submission-v1-6-97ff76568e49@collabora.com>
References: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
In-Reply-To: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>, 
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.2

Add the RK3588's standalone hardware random number generator node to its
device tree, and enable it on the one board I've tested it on and can
verify it produces good output, the Rock 5B.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi   | 9 +++++++++
 arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts | 4 ++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
index 8cfa30837ce72581d0b513a8274ab0177eb5ae15..1c72922bcbe1afd7c49beac771f8b7c6e5cc6e05 100644
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
+		status = "disabled";
+	};
+
 	i2s0_8ch: i2s@fe470000 {
 		compatible = "rockchip,rk3588-i2s-tdm";
 		reg = <0x0 0xfe470000 0x0 0x1000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts b/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts
index d597112f1d5b8ee0b6a4fa17086c8671a5102583..00a915cf266202e26b274cab962f7bf6bcf76fc1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts
@@ -430,6 +430,10 @@ &pwm1 {
 	status = "okay";
 };
 
+&rng {
+	status = "okay";
+};
+
 &saradc {
 	vref-supply = <&avcc_1v8_s0>;
 	status = "okay";

-- 
2.48.1

