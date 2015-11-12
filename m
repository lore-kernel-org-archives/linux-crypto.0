From: Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v3 0/4] crypto: add crypto accelerator support for rk3288
Date: Thu, 12 Nov 2015 10:56:52 +0100
Message-ID: <7910783.rT7PcfhDUF@phil>
References: <1447223759-20730-1-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com
To: Zain Wang <zain.wang@rock-chips.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:48577 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbbKLJ5Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Nov 2015 04:57:16 -0500
In-Reply-To: <1447223759-20730-1-git-send-email-zain.wang@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 11. November 2015, 14:35:55 schrieb Zain Wang:
> This commit support three cipher(AES/DES/DES3) and two chainmode(ecb/cbc),
> and the more algorithms and new hash drivers will be added later on.

I gave this a spin using tcrypt on my rk3288 chromebook and it seems to
work nicely for modes 200 (aes), 201 (des3) and 204 (des), so this series

Tested-by: Heiko Stuebner <heiko@sntech.de>

> 
> Changed in v3:
> - add OF depended in Kconfig
> - rename some variate
> - add reset property
> - remove crypto_p variate
> 
> Changed in v2:
> - remove some part about hash
> - add weak key detection
> - changed some variate's type
> 
> Changed in v1:
> - modify some variate's name
> - modify some variate's type
> - modify some return value
> - remove or modify some print info
> - use more dev_xxx in probe
> - modify the prio of cipher
> - add Kconfig
> 
> Zain Wang (4):
>   crypto: rockchip/crypto - add DT bindings documentation
>   clk: rockchip: set an ID for crypto clk
>   Crypto: rockchip/crypto - add crypto driver for rk3288
>   ARM: dts: rockchip: Add Crypto node for rk3288
> 
>  .../devicetree/bindings/crypto/rockchip-crypto.txt |  29 ++
>  arch/arm/boot/dts/rk3288.dtsi                      |  12 +
>  drivers/clk/rockchip/clk-rk3288.c                  |   2 +-
>  drivers/crypto/Kconfig                             |  11 +
>  drivers/crypto/Makefile                            |   1 +
>  drivers/crypto/rockchip/Makefile                   |   3 +
>  drivers/crypto/rockchip/rk3288_crypto.c            | 392 +++++++++++++++
>  drivers/crypto/rockchip/rk3288_crypto.h            | 220 +++++++++
>  drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 527 +++++++++++++++++++++
>  include/dt-bindings/clock/rk3288-cru.h             |   1 +
>  10 files changed, 1197 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
>  create mode 100644 drivers/crypto/rockchip/Makefile
>  create mode 100644 drivers/crypto/rockchip/rk3288_crypto.c
>  create mode 100644 drivers/crypto/rockchip/rk3288_crypto.h
>  create mode 100644 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
> 
> 
