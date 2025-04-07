Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803EC2528EF;
	Mon,  7 Apr 2025 12:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744030079; cv=none; b=DdzSaqnM7WGfsoaoPic04ZfOEULmWjWJb4iErsIZBXp4WQkOP8UjSOxhZEje5/ZdrgY4D9we+yuXYUP33rgAT7aAAu+RJ3uZR/KwLdS6s1lVs7WPXeT91A629cuHZhdcrRXv+1Qx+d+XhpK+z2LbRI0HCWorfpHDB8J3lvqGwJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744030079; c=relaxed/simple;
	bh=KEDPVE33uQKjxzGqy3bcfJL5Q/mx4ddBU49uxTRs+Rk=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=f1mWipTQD0I3ouldDSJfruw89LVAQF+MJMrPdUemlFMt5UZ6yMfG5uJd65/2S+31aAhYblSPiY5bjPRhQbAaPGi3jV/WYr1/B+g4GtK8tyU5xanU3dyXhPqyql+L2ldbvoS76ZZ5QXbPqo942uToPl5tec8uEKqNmIoFIvbHwIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C/HzPV+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/HzPV+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1D1C4CEE7;
	Mon,  7 Apr 2025 12:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744030079;
	bh=KEDPVE33uQKjxzGqy3bcfJL5Q/mx4ddBU49uxTRs+Rk=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=C/HzPV+0IWPNdEnGyAEliW8SgzV6uzSCnQfPsNEC8XhWhr6AbCwbTOHoKNvjmg5Jn
	 DeW1wI71Wh+5+RXPBO55pRCv9rlQtHmOotWufjr55PgBLHBMBNsNa8ljvA7Msx4Gf+
	 W1U2OWnBGMW0VueP3gxHMp8EK1tSXWQKoYLZhzL4ueHEIzSIvwse+mSenjPsNLQCk8
	 JAzWjSnQepfYSgSIg6Krn23ke9vQNuOIzG5Z9pyQT6h7DreRup/CE4E3VzzkTnC7DV
	 gD+9N2tbebyd83SvarpzjbDtIbLngWbXR4ArcdVAm41zGc5ECGAeLlrd/tjwNMSZ7u
	 HQPFoFOi5h5kg==
Date: Mon, 07 Apr 2025 07:47:57 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Anand Gore <anand.gore@broadcom.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, 
 Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org, 
 linux-crypto@vger.kernel.org, Olivia Mackall <olivia@selenic.com>, 
 William Zhang <william.zhang@broadcom.com>, 
 Kursad Oney <kursad.oney@broadcom.com>, 
 Florian Fainelli <f.fainelli@gmail.com>, 
 linux-arm-kernel@lists.infradead.org, Ray Jui <rjui@broadcom.com>, 
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 Scott Branden <sbranden@broadcom.com>
To: Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org>
References: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org>
Message-Id: <174402971847.1782936.5442564444780183051.robh@kernel.org>
Subject: Re: [PATCH v2 00/12] ARM: bcm: Add some BCMBCA peripherals


On Sun, 06 Apr 2025 17:32:40 +0200, Linus Walleij wrote:
> This adds a bunch peripherals to the Broadcom BRCMBCA
> SoC:s that I happened to find documentation for in some
> vendor header files.
> 
> It started when I added a bunch of peripherals for the
> BCM6846, and this included really helpful peripherals
> such as the PL081 DMA, for which I think the most common
> usecase is to be used as a memcpy engine to offload
> transfer of blocks from NAND flash to/from the NAND
> flash controller (at least this is how the STMicro
> FSMC controller was using it).
> 
> So I took a sweep and added all the stuff that has
> bindings to:
> 
> ARM:
> - BCM6846
> - BCM6855
> - BCM6878
> - BCM63138
> - BCM63148
> - BCM63178
> 
> ARM64:
> - BCM4908
> - BCM6856
> - BCM6858
> - BCM63158
> 
> There are several "holes" in this SoC list, I simply
> just fixed those that I happened to run into documentation
> for.
> 
> Unfortunately while very similar, some IP blocks vary
> slightly in version, the GPIO block is differently
> integrated on different systems, and the interrupt assignments
> are completely different, so it's safest to add these to each
> DTSI individually.
> 
> I add the interrupt binding for the RNG block in the
> process as this exists even if Linux isn't using the
> IRQ, and I put the RNG and DMA engines as default-enabled
> because they are not routed to the outside and should
> "just work" so why not.
> 
> I did a rogue patch adding some stuff to BCM6756 based
> on guessed but eventually dropped it. If someone has
> docs for this SoC I can add it.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Changes in v2:
> - Pick up Krzysztof's ACK
> - Push the BCM6858 DMA block into its own simple bus.
> - Fix GPIO node names and registers on BCM63138.
> - Fix GPIO node names and registers on BCM63148.
> - Link to v1: https://lore.kernel.org/r/20250328-bcmbca-peripherals-arm-v1-0-e4e515dc9b8c@linaro.org
> 
> ---
> Linus Walleij (12):
>       ARM: dts: bcm6878: Correct UART0 IRQ number
>       dt-bindings: rng: r200: Add interrupt property
>       ARM: dts: bcm6846: Add interrupt to RNG
>       ARM: dts: bcm6855: Add BCMBCA peripherals
>       ARM: dts: bcm6878: Add BCMBCA peripherals
>       ARM: dts: bcm63138: Add BCMBCA peripherals
>       ARM: dts: bcm63148: Add BCMBCA peripherals
>       ARM: dts: bcm63178: Add BCMBCA peripherals
>       ARM64: dts: bcm4908: Add BCMBCA peripherals
>       ARM64: dts: bcm6856: Add BCMBCA peripherals
>       ARM64: dts: bcm6858: Add BCMBCA peripherals
>       ARM64: dts: bcm63158: Add BCMBCA peripherals
> 
>  .../devicetree/bindings/rng/brcm,iproc-rng200.yaml |   6 +
>  arch/arm/boot/dts/broadcom/bcm63138.dtsi           |  79 ++++++++++-
>  arch/arm/boot/dts/broadcom/bcm63148.dtsi           |  64 +++++++++
>  arch/arm/boot/dts/broadcom/bcm63178.dtsi           | 112 +++++++++++++++
>  arch/arm/boot/dts/broadcom/bcm6846.dtsi            |   1 +
>  arch/arm/boot/dts/broadcom/bcm6855.dtsi            | 127 +++++++++++++++++
>  arch/arm/boot/dts/broadcom/bcm6878.dtsi            | 120 ++++++++++++++++-
>  arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi   | 122 ++++++++++++++++-
>  arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi  | 150 ++++++++++++++++++++-
>  arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi   | 138 ++++++++++++++++++-
>  arch/arm64/boot/dts/broadcom/bcmbca/bcm6858.dtsi   | 127 ++++++++++++++++-
>  11 files changed, 1037 insertions(+), 9 deletions(-)
> ---
> base-commit: 8359b1e7edc722d4b1be26aa515041a79e4224a3
> change-id: 20250327-bcmbca-peripherals-arm-dfb312052363
> 
> Best regards,
> --
> Linus Walleij <linus.walleij@linaro.org>
> 
> 
> 


My bot found new DTB warnings on the .dts files added or changed in this
series.

Some warnings may be from an existing SoC .dtsi. Or perhaps the warnings
are fixed by another series. Ultimately, it is up to the platform
maintainer whether these warnings are acceptable or not. No need to reply
unless the platform maintainer has comments.

If you already ran DT checks and didn't see these error(s), then
make sure dt-schema is up to date:

  pip3 install dtschema --upgrade


This patch series was applied (using b4) to base:
 Base: base-commit 8359b1e7edc722d4b1be26aa515041a79e4224a3 not known, ignoring
 Base: attempting to guess base-commit...
 Base: tags/v6.14-rc6-274-gf4e35e5f940c (exact match)

If this is not the correct base, please add 'base-commit' tag
(or use b4 which does this automatically)

New warnings running 'make CHECK_DTBS=y for arch/arm/boot/dts/broadcom/' for 20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org:

arch/arm/boot/dts/broadcom/bcm4709-asus-rt-ac87u.dtb: pcie@12000: 'device_type' is a required property
	from schema $id: http://devicetree.org/schemas/pci/pci-bus-common.yaml#





