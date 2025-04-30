Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BA127718;
	Wed, 30 Apr 2025 16:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746029875; cv=pass; b=AcrS8Wt/pbt0QLMcBa4XO+nUIEu6Zs+nWcgcLtznrhpEIet0uNvGTBszEket2928Qhq8bIVHdMhl6v2ay32BiK3slv2HIsiga2OAv5MZWqtkGWMzLM+ZvY1Qo5vQ6a3DAxpnw0aCk+8APZCP2MiehVMwagifGmTPPSWvUzWFbaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746029875; c=relaxed/simple;
	bh=5mNZSHb6mCpP3Lg66LkiacMQ3ZdAK5I0MUNG4QOKZPA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ue3f96JXNYV8tNL08EsrmxHViSP8SI+sFQ5SFCQpGWTHSjKoz83hMC5bOcUdZ6H0dG/FwGeRVllTyzDSY+oPwtyjQzPhm8adcayClYhW6JCunQrtVNF9qbgQoWhNMALglR6eXJQ5wpGb1sWjAYTfA7H+sCBtm0iRpNzvWM0fA5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=YGOKalQd; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="YGOKalQd"
ARC-Seal: i=1; a=rsa-sha256; t=1746029816; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=FnH76/YWeEy/aEeClOrvdV1Lr1/LcqU0T2iXebxS64wmnt9bOwGw7Ii7uaV/nz8OtwkHj7Aer7BevzuiFHLkFVofjaRn2QBVdVotk4szJ2ebbs1NzDA54A+d8GZaWAyzEzDoKityNgabm/BFSp2HtuXqQU4zKnV1E/p0j4c6FHA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1746029816; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=jDHqxj+pNMIqtx7OnVBhW5kzUARxjRYDjneVyS0hKvI=; 
	b=VIreHB6PMr/QzD2QVbjiMIdn7jFqUoRrV2Vw2WdlIFRsBqkJ1WclndHIMWhsesttMvUEaNlPd7dwnUoMhmj+eOeaGyNqEXADlDfB02Hx69WeQifEsktplsyEUkuWyJQUOtP9qgFF4OUQ2Qc87ai9YH07gWD/hAjzBVddlfSPsNE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1746029816;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=jDHqxj+pNMIqtx7OnVBhW5kzUARxjRYDjneVyS0hKvI=;
	b=YGOKalQd8pPactsftc5nDvQUxSHPdgkHSiIV4i0mhK1F3vvqLOlvJk5AO1zKX+xH
	IvO4J1qrINjuLUtRPVqPDD6/kUih8ufB2OFtz5NyCqyEctYzB2XyU6lYejD80DWf1il
	C3KApsl5jqAdSwLlUIBTWqT6QwHf13bge/sZDmv4=
Received: by mx.zohomail.com with SMTPS id 1746029814097766.0947279438221;
	Wed, 30 Apr 2025 09:16:54 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Wed, 30 Apr 2025 18:16:34 +0200
Subject: [PATCH 1/3] dt-bindings: rng: rockchip,rk3588-rng: add rk3576-rng
 compatible
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250430-rk3576-hwrng-v1-1-480c15b5843e@collabora.com>
References: <20250430-rk3576-hwrng-v1-0-480c15b5843e@collabora.com>
In-Reply-To: <20250430-rk3576-hwrng-v1-0-480c15b5843e@collabora.com>
To: Daniel Golle <daniel@makrotopia.org>, 
 Aurelien Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
 Jonas Karlman <jonas@kwiboo.se>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>, 
 kernel@collabora.com, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.2

The RK3576 SoC contains another standalone TRNG implementation. While
the register map and hardware is different, it has the same
clocks/interrupts/resets as the RK3588's TRNG, so can go in the same
binding.

Add the compatible and generalise the title/description of the binding
some more.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
index ca71b400bcaee4ad9d9c96102fd5940233c2c70f..fcc5be80142dfae1952652907a5fafe8504e36c0 100644
--- a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
@@ -4,9 +4,9 @@
 $id: http://devicetree.org/schemas/rng/rockchip,rk3588-rng.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Rockchip RK3588 TRNG
+title: Rockchip RK3576/RK3588 TRNG
 
-description: True Random Number Generator on Rockchip RK3588 SoC
+description: True Random Number Generator on Rockchip RK3576/RK3588 SoCs
 
 maintainers:
   - Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
@@ -14,6 +14,7 @@ maintainers:
 properties:
   compatible:
     enum:
+      - rockchip,rk3576-rng
       - rockchip,rk3588-rng
 
   reg:

-- 
2.49.0

