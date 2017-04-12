From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 5/7] arm64: marvell: dts: enable the crypto engine on the Armada 7040 DB
Date: Wed, 12 Apr 2017 10:36:48 +0200
Message-ID: <871ssyhvj3.fsf@free-electrons.com>
References: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
        <20170329124432.27457-6-antoine.tenart@free-electrons.com>
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
Received: from mail.free-electrons.com ([62.4.15.54]:49117 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751992AbdDLIhA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2017 04:37:00 -0400
In-Reply-To: <20170329124432.27457-6-antoine.tenart@free-electrons.com>
        (Antoine Tenart's message of "Wed, 29 Mar 2017 14:44:30 +0200")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Antoine,
 
 On mer., mars 29 2017, Antoine Tenart <antoine.tenart@free-electrons.com> wrote:

> Enable the cryptographic engine available in the CP110 master on the
> Armada 7040 DB.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>


Applied on mvebu/dt64

Thanks,

Gregory

> ---
>  arch/arm64/boot/dts/marvell/armada-7040-db.dts | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/marvell/armada-7040-db.dts b/arch/arm64/boot/dts/marvell/armada-7040-db.dts
> index bb0e1e8e7138..7e9a8a4e89a4 100644
> --- a/arch/arm64/boot/dts/marvell/armada-7040-db.dts
> +++ b/arch/arm64/boot/dts/marvell/armada-7040-db.dts
> @@ -171,3 +171,7 @@
>  	phy = <&phy1>;
>  	phy-mode = "rgmii-id";
>  };
> +
> +&cpm_crypto {
> +	status = "okay";
> +};
> -- 
> 2.11.0
>

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
