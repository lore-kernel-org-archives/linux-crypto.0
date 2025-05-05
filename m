Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610674683;
	Mon,  5 May 2025 13:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.11.138.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746450110; cv=none; b=rsw+2RrMPUO8UO25l9MreLmRaQ2DAW+1ngzj+ERTbaYvmMqosokQOVg82Btpi4KEkDCWn2dRjtrv/fZJUusbcNU4scNt5caVlL1MUvN6Lq6+KdiISll23HZOBi1VQNccjKqT/r3tAjX2eUxKti5fLtLh9VRoRXXlicY0pBCSdig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746450110; c=relaxed/simple;
	bh=HWtpxq8VSbL7osdg/n3YvEAARAvRWdjvgKI8goZ9yrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Plcp4fxJFGakoL06UGIkj71vReE9+flFNnsWUV6rZ+3rDONlflpO0NieXS4aG+p1UedD2BNq8pR1pLfpVHB2Cf4lPymY5/VrVpYgkbDTKGpzYTvSt14a3M4HDfukzFkEilrY2SthxG8+iQwU67YSuvK+tr+OxGKjuED72dFtEWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de; spf=pass smtp.mailfrom=sntech.de; dkim=pass (2048-bit key) header.d=sntech.de header.i=@sntech.de header.b=G/pbePtf; arc=none smtp.client-ip=185.11.138.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sntech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sntech.de header.i=@sntech.de header.b="G/pbePtf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sntech.de;
	s=gloria202408; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID;
	bh=WBYMe8AWciFRbGt/UH6lyqSHdnAGgD4jpjABIeG45Ss=; b=G/pbePtf629UUQemqdlgBwP/jR
	MZV+7whYgmJ/tAJLSU+DLyqCxZ/wfKCgiDyKBYAfD1wpq88Eu8+7hPhfNwcNJcHvbYUTsRYld6gyi
	Vzt9xbaQYFL6tKFKTRveu/knLvUBh+thg5wLRJpoEpgJadUBlIRLHtza6Kizff+5la/rQMNIFEiCO
	GKL5qQMaJ75xsZpMB81aB0HsJoV6bL6kEpR5OC6723rGQezQeFzKGcqEL9COaPSx2ITSiX21OoIC0
	Uc0vDch+cxHvVi5mbuRSPsEouddLoxf80+lxq6bWHL0wFwh0+9xub7lByQds7VRztvPVUAWJ3gn1c
	K6hodFqg==;
Received: from i53875a1d.versanet.de ([83.135.90.29] helo=localhost.localdomain)
	by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <heiko@sntech.de>)
	id 1uBvRd-0006mT-UT; Mon, 05 May 2025 15:01:18 +0200
From: Heiko Stuebner <heiko@sntech.de>
To: Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonas Karlman <jonas@kwiboo.se>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Heiko Stuebner <heiko@sntech.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	kernel@collabora.com,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH 0/3] RK3576 Hardware RNG
Date: Mon,  5 May 2025 15:01:07 +0200
Message-ID: <174645006215.1225797.3007982185133849135.b4-ty@sntech.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250430-rk3576-hwrng-v1-0-480c15b5843e@collabora.com>
References: <20250430-rk3576-hwrng-v1-0-480c15b5843e@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 30 Apr 2025 18:16:33 +0200, Nicolas Frattaroli wrote:
> Gee Nicolas, how come your mom lets you write two Rockchip HWRNG drivers
> in a year?
> 
> In short, RK3576 (and RK3562 and RK3528) introduce another HWRNG IP. It
> actually has quite a few cool features, but I ignored the cool bits and
> went straight for the true entropy. Some of the cool bits someone else
> may wish to add in the future: AES-CTR PRNG that's regularly reseeded
> from the entropy, adjustments for oscillator and oscillator ring lengths
> to maximise entropy generation, automatic continuous quality checking of
> the produced entropy by the hardware itself, etc.
> 
> [...]

Applied, thanks!

[3/3] arm64: dts: rockchip: add RK3576 RNG node
      commit: 5268f3b5d29887480011b44567bcbf0d422cda94

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>
