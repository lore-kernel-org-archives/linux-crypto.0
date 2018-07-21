From: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 13/14] arm64: dts: marvell: armada-cp110: update the
 crypto engine compatible
Date: Sat, 21 Jul 2018 14:35:01 -0700
Message-ID: <CAOesGMjx_Qprh+4Y6GM4BqGOeJtKWwAhkFNvBz0PGqQkyuRtrw@mail.gmail.com>
References: <20180628151544.22134-1-antoine.tenart@bootlin.com> <20180628151544.22134-14-antoine.tenart@bootlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        maxime.chevallier@bootlin.com, miquel.raynal@bootlin.com,
        Nadav Haklai <nadavh@marvell.com>, oferh@marvell.com,
        igall@marvell.com
To: Antoine Tenart <antoine.tenart@bootlin.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180628151544.22134-14-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On Thu, Jun 28, 2018 at 8:15 AM, Antoine Tenart
<antoine.tenart@bootlin.com> wrote:
> New compatibles are now supported by the Inside Secure SafeXcel driver.
> As they are more specific than the old ones, they should be used
> whenever possible. This patch updates the Marvell cp110 device tree
> accordingly.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> ---
>  arch/arm64/boot/dts/marvell/armada-cp110.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/boot/dts/marvell/armada-cp110.dtsi b/arch/arm64/boot/dts/marvell/armada-cp110.dtsi
> index 2bf083272a87..bb2914f90048 100644
> --- a/arch/arm64/boot/dts/marvell/armada-cp110.dtsi
> +++ b/arch/arm64/boot/dts/marvell/armada-cp110.dtsi
> @@ -427,7 +427,7 @@
>                 };
>
>                 CP110_LABEL(crypto): crypto@800000 {
> -                       compatible = "inside-secure,safexcel-eip197";
> +                       compatible = "inside-secure,safexcel-eip197b";

So the device is still compatible with the less-specific binding,
right? If so, it should probably have both compatible properties in
there, not just the more specific one.

(Same for another patch in this series).



-Olof
