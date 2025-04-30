Received: from sender3-pp-f112.zoho.com (sender3-pp-f112.zoho.com [136.143.184.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A627720C463;
	Wed, 30 Apr 2025 16:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.184.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746029855; cv=pass; b=HK7dQmmhKM0sB5759/KyQLwxQNboEe28CBgX9ikcIiMEw/DHkxMuoPA+sdfHwzo61No1iGG+Hihmc/sq31w8JN14vEqUzginvtynBnTUN8q+IrvPpfHNnbDfLSyo83VU3zHXWOKOTTNivdWGfgwbOuI2g/As+HWYAv8yi1BSRSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746029855; c=relaxed/simple;
	bh=UI12DHEIMvhSUwnuUOxmnhKeGFXyWQZ3ohVg1izPjHE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=J5US5sNCbxf4DQU25m94iXJ2mTtWQXYTe8Ytyn69U1TYsAi+41KiXvcWbZxzNU1woo0CH7abEGGVj29PLw1Vr6u2OPg7psadfQa8I0V6oqBT8ZbPCG8MebDEJ6gxwQld1BBYv6KH7WAV0+xzHIJZzc9nGxpFMYQ+FoAVXYBpX7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=CtnL4PV2; arc=pass smtp.client-ip=136.143.184.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="CtnL4PV2"
ARC-Seal: i=1; a=rsa-sha256; t=1746029812; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=B287je1pCwj5KlUdHqnWjILCE28CeDyD/RGttZ73msudPqKOQJa/HpKQzsv5GWQKR1XvfjRGkqhMcaHqZRzYQEjgwHyK6Ygpz+Apl58/sSUOv94GhXFf5QtK3g80fTd8Zc/EwVE71e0fxaAnZ+iQfuU9+6BvyDJbIvruac/Hhxo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1746029812; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=F+Ts31OxWQ0WA/XXfCrTbdTi2PZ2UUmlCJRckaG2TDw=; 
	b=WWi/OEwYNLm6TdqHoo9nv5gmmobRI5mQY/qYcMw2YeXjW1y8WzGDVaJvi6JL4//FXEO9P1AZu5/gJsTsorRtwnNY/59RIjJspK44fiq+988lggByD7kYQbsX6ajA+5ONHWSVcjqAf4419LIM+IuM4442cj0sedhXw05Cx3GCbIE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1746029812;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:To:To:Cc:Cc:Reply-To;
	bh=F+Ts31OxWQ0WA/XXfCrTbdTi2PZ2UUmlCJRckaG2TDw=;
	b=CtnL4PV2iszZr2tLD1X+Rxo0+MnLVjzqh6kPbne1NbQidAZESyn4vrjWd/EgVct0
	fD2vXblzP/zTS2ETW0XN9QaR72t9n7aXuRBQ26zKcVhf4OzikZOOL68dKiymAbEe7qi
	horD4tl69PFbvVzR7jLvOrne4Bu3Pfms0HOplmZQ=
Received: by mx.zohomail.com with SMTPS id 1746029810436360.54725368726145;
	Wed, 30 Apr 2025 09:16:50 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Subject: [PATCH 0/3] RK3576 Hardware RNG
Date: Wed, 30 Apr 2025 18:16:33 +0200
Message-Id: <20250430-rk3576-hwrng-v1-0-480c15b5843e@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOFMEmgC/zXMQQ6CMBCF4as0s3aStlhBrmJYlDrCxFB0WpWEc
 Hcbicv/Je9bIZEwJWjVCkJvTjzHEuagIIw+DoR8LQ1WW6eP9oxyr1x9wvEjccAmVLrpXW2MJyi
 Xh9CNlx936fYWer6KmvcRep8IwzxNnFsVacn4l6Hbti+PAwAKjwAAAA==
X-Change-ID: 20250429-rk3576-hwrng-8c308b5711ae
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

Gee Nicolas, how come your mom lets you write two Rockchip HWRNG drivers
in a year?

In short, RK3576 (and RK3562 and RK3528) introduce another HWRNG IP. It
actually has quite a few cool features, but I ignored the cool bits and
went straight for the true entropy. Some of the cool bits someone else
may wish to add in the future: AES-CTR PRNG that's regularly reseeded
from the entropy, adjustments for oscillator and oscillator ring lengths
to maximise entropy generation, automatic continuous quality checking of
the produced entropy by the hardware itself, etc.

In testing, it seems to produce about 2 mbit/s of high quality entropy
on the RK3576 with its default settings when we read the TRNG entropy
output directly. That's less than we'd get if we had the hardware use
the PRNG to stretch it, but I've decided to leave that up to Linux's
entropy pool implementation for now.

RK3562 and RK3528 probably just need a compatible and a DTS node to
enable it as well, but I don't have any RK3562/RK3528 boards to test
this with, so it's not done in this series.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
Nicolas Frattaroli (3):
      dt-bindings: rng: rockchip,rk3588-rng: add rk3576-rng compatible
      hwrng: rockchip - add support for RK3576's RNG
      arm64: dts: rockchip: add RK3576 RNG node

 .../bindings/rng/rockchip,rk3588-rng.yaml          |  5 +-
 arch/arm64/boot/dts/rockchip/rk3576.dtsi           |  8 +++
 drivers/char/hw_random/rockchip-rng.c              | 73 ++++++++++++++++++++++
 3 files changed, 84 insertions(+), 2 deletions(-)
---
base-commit: 4e0a9c660788594b5b49ac07f0fbdccd2218431e
change-id: 20250429-rk3576-hwrng-8c308b5711ae

Best regards,
-- 
Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

