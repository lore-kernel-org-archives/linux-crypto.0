From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 6/7] arm64: marvell: dts: enable the crypto engine on the Armada 8040 DB
Date: Wed, 12 Apr 2017 10:37:07 +0200
Message-ID: <87wpaqggy4.fsf@free-electrons.com>
References: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
        <20170329124432.27457-7-antoine.tenart@free-electrons.com>
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
Received: from mail.free-electrons.com ([62.4.15.54]:49164 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752515AbdDLIht (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2017 04:37:49 -0400
In-Reply-To: <20170329124432.27457-7-antoine.tenart@free-electrons.com>
        (Antoine Tenart's message of "Wed, 29 Mar 2017 14:44:31 +0200")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Antoine,
 
 On mer., mars 29 2017, Antoine Tenart <antoine.tenart@free-electrons.com> wrote:

> Enable the cryptographic engine available in the CP110 master on the
> Armada 8040 DB. Do not enable the one in the CP110 salve for now, as we
> do not support multiple cryptographic engines yet.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>


Applied on mvebu/dt64

Thanks,

Gregory


> ---
>  arch/arm64/boot/dts/marvell/armada-8040-db.dts | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/marvell/armada-8040-db.dts b/arch/arm64/boot/dts/marvell/armada-8040-db.dts
> index 80e685e4235d..f6d808bced51 100644
> --- a/arch/arm64/boot/dts/marvell/armada-8040-db.dts
> +++ b/arch/arm64/boot/dts/marvell/armada-8040-db.dts
> @@ -140,6 +140,10 @@
>  	phy-mode = "rgmii-id";
>  };
>  
> +&cpm_crypto {
> +	status = "okay";
> +};
> +
>  /* CON5 on CP1 expansion */
>  &cps_pcie2 {
>  	status = "okay";
> -- 
> 2.11.0
>

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
