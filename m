Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E0113D60A;
	Sat, 10 Aug 2024 19:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.11.138.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723317361; cv=none; b=OOu+Oflsa2vHSlaY3BojUGbs/N64iD6Hw4khALcZep+GRobTYjJEZdvuuQfQJIEbHeORfx9LTwZKu0gDL57Wfdpcq5Ft/1a11dK6TK02noA2eLA9VC+mG1fB/CL/74Un3mPKrpCh5qvtLIvdzZYz/AC6L80IG94H+JN6oHceMJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723317361; c=relaxed/simple;
	bh=/xTZOW99xr3kaEDbpp2eSSiLPQpb60jIyR1E0U2bcyw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S2wmlddBhE7PtVlkiiO+z5T7mGWIPebqoar/X9AgdAFANgULrdQovFmL0Imi+8zLL/0xQLCGWhXysoB2BV2AnDdyCgRcTkI9nWfymHZdyZyheEKOXDjZfVrZKEItqtmO9C9LtE41/+TbIreRIhziCI+C8SPm18xOXhuj+8gwE84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de; spf=pass smtp.mailfrom=sntech.de; arc=none smtp.client-ip=185.11.138.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sntech.de
Received: from i53875b02.versanet.de ([83.135.91.2] helo=phil.lan)
	by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <heiko@sntech.de>)
	id 1scrYx-0006Wd-7T; Sat, 10 Aug 2024 21:15:39 +0200
From: Heiko Stuebner <heiko@sntech.de>
To: Sascha Hauer <s.hauer@pengutronix.de>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	devicetree@vger.kernel.org,
	Conor Dooley <conor+dt@kernel.org>,
	Daniel Golle <daniel@makrotopia.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Aurelien Jarno <aurelien@aurel32.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
	Rob Herring <robh@kernel.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Olivia Mackall <olivia@selenic.com>
Cc: Heiko Stuebner <heiko@sntech.de>
Subject: Re: (subset) [PATCH v9 0/3] hwrng: add hwrng support for Rockchip RK3568
Date: Sat, 10 Aug 2024 21:15:36 +0200
Message-Id: <172331732517.282332.1542655399942627600.b4-ty@sntech.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1722355365.git.daniel@makrotopia.org>
References: <cover.1722355365.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 30 Jul 2024 17:08:04 +0100, Daniel Golle wrote:
> Rockchip SoCs used to have a random number generator as part of their
> crypto device.
> 
> However newer Rockchip SoCs like the RK3568 have an independent True
> Random Number Generator device. This patchset adds a driver for it and
> enables it in the device tree for RK3568.
> 
> [...]

Applied, thanks!

[3/3] arm64: dts: rockchip: add DT entry for RNG to RK356x
      commit: afeccc4084963aaa932931b734c8def55613c483

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>
