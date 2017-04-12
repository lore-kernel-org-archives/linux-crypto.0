From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 7/7] arm64: defconfig: enable the Safexcel crypto engine as a module
Date: Wed, 12 Apr 2017 10:38:03 +0200
Message-ID: <87shleggwk.fsf@free-electrons.com>
References: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
        <20170329124432.27457-8-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        sebastian.hesselbarth@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:49233 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753262AbdDLIiU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2017 04:38:20 -0400
In-Reply-To: <20170329124432.27457-8-antoine.tenart@free-electrons.com>
        (Antoine Tenart's message of "Wed, 29 Mar 2017 14:44:32 +0200")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Antoine,
 
 On mer., mars 29 2017, Antoine Tenart <antoine.tenart@free-electrons.com> wrote:

> The Safexcel EIP197 cryptographic engine is used on some Marvell SoCs,
> such as Armada 7040 and Armada 8040. Enable this driver as a module in
> the ARM64 defconfig.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Applied on mvebu/defconfig64

Thanks,

Gregory

> ---
>  arch/arm64/configs/defconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
> index fece4d3c2095..76308fa2fa7a 100644
> --- a/arch/arm64/configs/defconfig
> +++ b/arch/arm64/configs/defconfig
> @@ -519,6 +519,7 @@ CONFIG_MEMTEST=y
>  CONFIG_SECURITY=y
>  CONFIG_CRYPTO_ECHAINIV=y
>  CONFIG_CRYPTO_ANSI_CPRNG=y
> +CONFIG_CRYPTO_DEV_SAFEXCEL=m
>  CONFIG_ARM64_CRYPTO=y
>  CONFIG_CRYPTO_SHA1_ARM64_CE=y
>  CONFIG_CRYPTO_SHA2_ARM64_CE=y
> -- 
> 2.11.0
>

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
