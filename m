Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66E213C9A3;
	Sun, 16 Feb 2025 05:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739683562; cv=none; b=ZhsNGWV5GXTmNYGKfLiVv2SayAcnqE8fKLn1CmG7MDBHC4Z83zgK/B2W89XGCqpAVNqtMfNqPdv7qoKdDmAWE8SL5+ExtLhdpnYRdKuZGyse979oYc9Y9tmMCyxIDcEbEY2wOtTfKTOF5Q4k/Dw8XhzAIpZ/yU36D0DLK4ujCbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739683562; c=relaxed/simple;
	bh=jwC8hxlDHNhj9GsTCY2wTKGGrPWG2IitnX4565Hep24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/qfp99bUjADU2pKfJrkwVFjCjEcL5H2JDn9CTNcRAFRYQdM5zSN/NuSaHhzBsLlmfN+3vTp1HMYX0diy7xe2NgHYe+1j6WxVwCNIxsH+vAgQg1Y1vztsW4tidD2rLpxcqt9csN/Unkn2napnnVs7LTTotD0EMRVDAbqpgwWq4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MLePav5M; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MLePav5M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hMOMpz3rHzMOkguWMPiJFqJ9y7VD90/T+fEEHUjYmcM=; b=MLePav5M0nhtNVRiOZAP6i3Irx
	8MwyL7KSpPLXQk5quYnJ8JY/9OVSv2fbIHLTZBOfEN2rkhHHVbtvC18htPpJ2xoWi8Hm89ABLpRT2
	x3PfiZGgZ03mccuy+Q+MYKC+vgtSF8X2/zW6rC4hyapZsFLTlwOafOW2xC+nyJgLPMLqpn7h3a+uL
	cIIa3EhxrN1MQFUTIRxouWAP+k26f6g8U/eVPa3FxNWpVLzpylnvkDODsJHl9/pXdpvkqSBW4ifGX
	tra9iol3zcOAwNllnm+0rZNUjYrZ1ccS+fMMK+gDQZgGgxa3Etpy8Ty/0egN4m0a9a+v9zZzQXMUu
	xbyy2wDA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjWwi-000hJg-1K;
	Sun, 16 Feb 2025 13:25:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 13:25:21 +0800
Date: Sun, 16 Feb 2025 13:25:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Olivia Mackall <olivia@selenic.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	kernel@collabora.com, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	XiaoDong Huang <derrick.huang@rock-chips.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Lin Jinhan <troy.lin@rock-chips.com>
Subject: Re: [PATCH v2 0/7] RK3588 Hardware Random Number Generator Driver
Message-ID: <Z7F2wdG99A0na-ie@gondor.apana.org.au>
References: <20250204-rk3588-trng-submission-v2-0-608172b6fd91@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204-rk3588-trng-submission-v2-0-608172b6fd91@collabora.com>

On Tue, Feb 04, 2025 at 04:35:45PM +0100, Nicolas Frattaroli wrote:
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
> The decision to integrate this into the existing rockchip-rng driver was
> made based on a few factors:
> 
> 1. The driver is fairly small.
> 2. While not much code is shared, some code is, specifically relating to
>    power management, the hwrng interface and the probe function.
> 3. I don't want users to figure out why "CONFIG_HW_RANDOM_ROCKCHIP"
>    doesn't enable the RK3588 one, and I really don't see a reason to
>    build without both of them considering the other RK3588 TRNG (for
>    which there is not yet a driver iirc) *does* share code with the
>    existing rockchip-rng driver.
> 
> Here are the rngtest5 results from this new driver on my board:
> 
>   user@debian-rockchip-rock5b-rk3588:~$ cat /sys/class/misc/hw_random/rng_current 
>   rockchip-rng
>   user@debian-rockchip-rock5b-rk3588:~$ sudo cat /dev/hwrng | rngtest -c 10000 
>   [...]
>   rngtest: bits received from input: 200000032
>   rngtest: FIPS 140-2 successes: 9990
>   rngtest: FIPS 140-2 failures: 10
>   rngtest: FIPS 140-2(2001-10-10) Monobit: 1
>   rngtest: FIPS 140-2(2001-10-10) Poker: 0
>   rngtest: FIPS 140-2(2001-10-10) Runs: 5
>   rngtest: FIPS 140-2(2001-10-10) Long run: 4
>   rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
>   rngtest: input channel speed: (min=212.255; avg=29089.272; max=19531250.000)Kibits/s
>   rngtest: FIPS tests speed: (min=64.005; avg=102.494; max=153.818)Mibits/s
>   rngtest: Program run time: 11292340 microseconds
> 
> As you can see, the quality of the entropy is quite good, and the
> throughput is an acceptable 29 Mibit/s.
> 
> The series starts out with two patches for the bindings. The bindings
> are separate from the rockchip,rk3568-rng bindings, as the required
> properties differ. The SCMI reset ID numbers are needed because mainline
> uses a different reset numbering scheme, but TF-A uses the downstream
> numbering scheme as far as I know. The TRNG must be reset through SCMI.
> 
> Next up are two cleanup patches for the existing driver. Even if a
> decision is made to split the drivers for whatever reason, these two
> patches should be used in the rk3568-rng driver as they get rid of small
> peculiarities in the code without meaningfully changing how the driver
> works.
> 
> Next up is the main driver patch that adds support for the new TRNG. As
> the driver was developed by reading the downstream vendor code for this
> particular device and reworking it, I've included the downstream vendor
> developer who wrote the driver as a Co-developed-by tag with their
> existing downstream sign-off.
> 
> The penultimate patch adds the node to the rk3588-base.dtsi, and
> enables it.
> 
> The final patch adds myself to the MAINTAINERS of this driver and these
> bindings.
> 
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> ---
> Changes in v2:
> - Drop mailmap patch
> - driver: restore the OF matching to how it was, and change soc_data to
>   const
> - dts: get rid of the board specific DTS enablement and instead enable
>   it in rk3588-base
> - bindings: drop the change of adding myself to maintainers from the
>   bindings patch, make it a separate patch
> - bindings: get rid of the comments
> - bindings: set status = "okay" in the example
> - bindings: make interrupts property required
> - Add a patch to add me to the MAINTAINERS for this driver/binding
> - Link to v1: https://lore.kernel.org/r/20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com
> 
> ---
> Nicolas Frattaroli (7):
>       dt-bindings: reset: Add SCMI reset IDs for RK3588
>       dt-bindings: rng: add binding for Rockchip RK3588 RNG
>       hwrng: rockchip: store dev pointer in driver struct
>       hwrng: rockchip: eliminate some unnecessary dereferences
>       hwrng: rockchip: add support for rk3588's standalone TRNG
>       arm64: dts: rockchip: Add rng node to RK3588
>       MAINTAINERS: add Nicolas Frattaroli to rockchip-rng maintainers
> 
>  .../bindings/rng/rockchip,rk3588-rng.yaml          |  60 +++++
>  MAINTAINERS                                        |   2 +
>  arch/arm64/boot/dts/rockchip/rk3588-base.dtsi      |   9 +
>  drivers/char/hw_random/Kconfig                     |   3 +-
>  drivers/char/hw_random/rockchip-rng.c              | 250 ++++++++++++++++++---
>  include/dt-bindings/reset/rockchip,rk3588-cru.h    |  41 +++-
>  6 files changed, 335 insertions(+), 30 deletions(-)
> ---
> base-commit: 72deda0abee6e705ae71a93f69f55e33be5bca5c
> change-id: 20250130-rk3588-trng-submission-055255c96689
> 
> Best regards,
> -- 
> Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

Patches 1-5,7 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
