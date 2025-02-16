Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5F8200CD;
	Sun, 16 Feb 2025 15:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.11.138.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739720064; cv=none; b=KTiUmEowRucorodgrZ+cZw3fyONQcklK4IU5DCDxFMbJnFk46KVWDkqL4Mq9jDmgGrfELh1YtdDf71nnK+VOlryyC3JwdAMvwEC15E7UqRv00ovqnc6HmT2FefTGSvGV2D0BGDXFUHlHtS7EjmFOyPEqQj/TZRojG/+P+7truNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739720064; c=relaxed/simple;
	bh=FJWQsNilroRisQAUTQKW7ddDQyvmTvRoFXGR/hOtyPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CMYx/S2MpBt3eXkLN6yecEpUtE4LbszxFPDNBxp+cF0Va9aq76EtSMO9n09vmRQ3d+uwf7WEoi3FLB7nim/WNlzerViYVVnSD+Cen+TkOJNuGu84mqmepauC6oOi3qf5qK7xXUt1fiNQTbsnezoeu66W4ZXu5sFDo3ZsHefSL4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de; spf=pass smtp.mailfrom=sntech.de; dkim=pass (2048-bit key) header.d=sntech.de header.i=@sntech.de header.b=sfEtQBKP; arc=none smtp.client-ip=185.11.138.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sntech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sntech.de header.i=@sntech.de header.b="sfEtQBKP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sntech.de;
	s=gloria202408; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=X3B5AHta8iT81vmhTEO3/fEUlWSWkvof26s+ONKqoy0=; b=sfEtQBKPCi+F28t1DCWdgzr+rS
	ZT0m+CgsJ/TAjHBJfAkL6XIWqlm/gAVG5gbA+jSKTjOdO4i+LUPw8dt/+bBPYbwrK+2wI6wbshOA/
	7ctZhdsbaEuwtMXbdPxMLmdres3KxLyF2I6nJM6A4TDFXXnCUDGTSCIVhFFIlmCdG7y4wfDkhb4aA
	VJExjfyLn6B5NmvNQz9hctvZyUeAeZZlLH+MU4Q5n5T5fYy0Af+9kKZHwBvzvxbkGp5RwRHvzh6or
	rxb/WfRFI1i1xanjQxM9Vq0db8NSVOTLPSg0IbP8dpaVtkm6oyWhGbW3OEAEni1qpbRoV7NwtiIOi
	Xqwl+HNA==;
Received: from i53875bc0.versanet.de ([83.135.91.192] helo=localhost.localdomain)
	by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <heiko@sntech.de>)
	id 1tjgeS-0007m6-5F; Sun, 16 Feb 2025 16:33:48 +0100
From: Heiko Stuebner <heiko@sntech.de>
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Heiko Stuebner <heiko@sntech.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	kernel@collabora.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	XiaoDong Huang <derrick.huang@rock-chips.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Lin Jinhan <troy.lin@rock-chips.com>
Subject: Re: (subset) [PATCH v2 0/7] RK3588 Hardware Random Number Generator Driver
Date: Sun, 16 Feb 2025 16:33:37 +0100
Message-ID: <173971983108.1865604.1801020506672691939.b4-ty@sntech.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250204-rk3588-trng-submission-v2-0-608172b6fd91@collabora.com>
References: <20250204-rk3588-trng-submission-v2-0-608172b6fd91@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 04 Feb 2025 16:35:45 +0100, Nicolas Frattaroli wrote:
> This series adds support for the Rockchip RK3588's standalone hardware
> random number generator to the existing mainline rockchip-rng driver.
> 
> The RK3588 has several hardware random number generators, one in each
> the secure-world and non-secure-world crypto accelerator, and one
> standalone one in each the secure-world and non-secure-world, so 4
> hwrngs in total. This series adds support for the standalone hwrng,
> which is an entirely new IP on this SoC and distinct from the one in the
> Crypto IP.
> 
> [...]

Applied, thanks!

[6/7] arm64: dts: rockchip: Add rng node to RK3588
      commit: 6ee0b9ad3995ee5fa229035c69013b7dd0d3634b

I've dropped the status=okay - this is the default so not needed
on always-on blocks

Also dropped the rng phandle, as boards should not need to change
the rng.

And I've changed the reset-id constant to its "48" numeric equivalent.
The reset-id change is making its way through the crypto tree
(needed by the binding-example).
I've also queued a patch for 6.16 to change that back once the
header is available to everything after 6.15-rc1.


Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>
