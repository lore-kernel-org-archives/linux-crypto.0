Return-Path: <SRS0=WdwO=YZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB682CA9EC9
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 06:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 984A220656
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 06:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725784AbfKAGJd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Nov 2019 02:09:33 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37634 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726457AbfKAGJc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Nov 2019 02:09:32 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iQQ7Z-0001wo-Dp; Fri, 01 Nov 2019 14:09:17 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iQQ7W-0004s8-A2; Fri, 01 Nov 2019 14:09:14 +0800
Date:   Fri, 1 Nov 2019 14:09:14 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     catalin.marinas@arm.com, davem@davemloft.net,
        linux@armlinux.org.uk, mark.rutland@arm.com, mripard@kernel.org,
        robh+dt@kernel.org, wens@csie.org, will@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v6 00/11] crypto: add sun8i-ce driver for Allwinner
 crypto engine
Message-ID: <20191101060914.sv7g5ipygagzz4ed@gondor.apana.org.au>
References: <20191023200513.22630-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023200513.22630-1-clabbe.montjoie@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 23, 2019 at 10:05:02PM +0200, Corentin Labbe wrote:
> Hello
> 
> This patch serie adds support for the Allwinner crypto engine.
> The Crypto Engine is the third generation of Allwinner cryptogaphic offloader.
> The first generation is the Security System already handled by the
> sun4i-ss driver.
> The second is named also Security System and is present on A80 and A83T
> SoCs, originaly this driver supported it also, but supporting both IP bringing
> too much complexity and another driver (sun8i-ss) will came for it.
> 
> For the moment, the driver support only DES3/AES in ECB/CBC mode.
> Patchs for CTR/CTS/XTS, RSA and RNGs will came later.
> 
> This serie is tested with CRYPTO_MANAGER_EXTRA_TESTS
> and tested on:
> sun50i-a64-bananapi-m64
> sun50i-a64-pine64-plus
> sun50i-h5-libretech-all-h3-cc
> sun50i-h6-pine-h64
> sun8i-h2-plus-libretech-all-h3-cc
> sun8i-h2-plus-orangepi-r1
> sun8i-h2-plus-orangepi-zero
> sun8i-h3-libretech-all-h3-cc
> sun8i-h3-orangepi-pc
> sun8i-r40-bananapi-m2-ultra
> 
> DT and defconfig will go thru the mripard tree
> 
> Regards
> 
> Changes since v5:
> - fixed uninitialized err in sun8i_ce_allocate_chanlist (reported by lkp@intel.com/dan.carpenter@oracle.com)
> 
> Changes since v4:
> - fixed some typos in kconfig
> - made sun8i_ce_pm_ops static
> - Use devm_platform_ioremap_resource
> 
> Changes since v3:
> - removed need of reset-names
> - made reset mandatory
> 
> Changes since v2:
> - changed additionalproperties
> - splited fallbacks functions out of sun8i_ce_cipher()
> - changed variant "model" to "has_t_dlen_in_bytes"
> - splited sun8i_ce_register_algs/sun8i_ce_get_clks out of sun8i_ce_probe()
> 
> Changes since v1:
> - Add sun4i-ss to allwinner directory
> - Cleaned variant structure
> - Renamed clock name from ahb to bus (and mbus to ram)
> - Fixed DT bindings problem reported by mripard
> - Cleaned unneeded status = ""  in R40 DT
> - Removed old unnecessary interrupt_names in A64 DT
> - Added arm64 defconfig
> - Added support for PM functions
> - Splitted probe functions
> - Reworked clock settings
> - made reset mandatory
> 
> Corentin Labbe (11):
>   crypto: Add allwinner subdirectory
>   crypto: Add Allwinner sun8i-ce Crypto Engine
>   dt-bindings: crypto: Add DT bindings documentation for sun8i-ce Crypto
>     Engine
>   ARM: dts: sun8i: R40: add crypto engine node
>   ARM: dts: sun8i: H3: Add Crypto Engine node
>   ARM64: dts: allwinner: sun50i: Add Crypto Engine node on A64
>   ARM64: dts: allwinner: sun50i: Add crypto engine node on H5
>   ARM64: dts: allwinner: sun50i: Add Crypto Engine node on H6
>   sunxi_defconfig: add new Allwinner crypto options
>   arm64: defconfig: add new Allwinner crypto options
>   crypto: sun4i-ss: Move to Allwinner directory
> 
>  .../bindings/crypto/allwinner,sun8i-ce.yaml   |  88 +++
>  MAINTAINERS                                   |   4 +-
>  arch/arm/boot/dts/sun8i-h3.dtsi               |   9 +
>  arch/arm/boot/dts/sun8i-r40.dtsi              |   9 +
>  arch/arm/configs/sunxi_defconfig              |   2 +
>  arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi |   9 +
>  arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi  |   9 +
>  arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi  |   9 +
>  arch/arm64/configs/defconfig                  |   2 +
>  drivers/crypto/Kconfig                        |  28 +-
>  drivers/crypto/Makefile                       |   2 +-
>  drivers/crypto/allwinner/Kconfig              |  60 ++
>  drivers/crypto/allwinner/Makefile             |   2 +
>  .../{sunxi-ss => allwinner/sun4i-ss}/Makefile |   0
>  .../sun4i-ss}/sun4i-ss-cipher.c               |   0
>  .../sun4i-ss}/sun4i-ss-core.c                 |   0
>  .../sun4i-ss}/sun4i-ss-hash.c                 |   0
>  .../sun4i-ss}/sun4i-ss-prng.c                 |   0
>  .../sun4i-ss}/sun4i-ss.h                      |   0
>  drivers/crypto/allwinner/sun8i-ce/Makefile    |   2 +
>  .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 434 +++++++++++
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 676 ++++++++++++++++++
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  | 254 +++++++
>  23 files changed, 1570 insertions(+), 29 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
>  create mode 100644 drivers/crypto/allwinner/Kconfig
>  create mode 100644 drivers/crypto/allwinner/Makefile
>  rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/Makefile (100%)
>  rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-cipher.c (100%)
>  rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-core.c (100%)
>  rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-hash.c (100%)
>  rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-prng.c (100%)
>  rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss.h (100%)
>  create mode 100644 drivers/crypto/allwinner/sun8i-ce/Makefile
>  create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
>  create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
>  create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h

Patches 1,2,11 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
