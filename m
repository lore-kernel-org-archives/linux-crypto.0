From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 3/3] crypto: dcp: rename 'compatible' property to 'fsl,dcp'
Date: Thu, 08 Aug 2013 23:39:47 +0400
Message-ID: <5203F403.1040800@cogentembedded.com>
References: <1375968629-10091-1-git-send-email-LW@KARO-electronics.de> <1375968629-10091-4-git-send-email-LW@KARO-electronics.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: devicetree@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
	Rob Herring <rob.herring@calxeda.com>,
	linux-crypto@vger.kernel.org,
	Tobias Rauter <tobiasrauter@gmail.com>,
	linux-arm-kernel@lists.infradead.org
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34401 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965777Ab3HHTjm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Aug 2013 15:39:42 -0400
Received: by mail-lb0-f172.google.com with SMTP id o7so2785176lbv.31
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2013 12:39:41 -0700 (PDT)
In-Reply-To: <1375968629-10091-4-git-send-email-LW@KARO-electronics.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello.

On 08/08/2013 05:30 PM, Lothar Wa=C3=9Fmann wrote:

> Leave the old 'fsl-dcp' value in place with an appropriate comment
> until external users have updated their DTBs.

> Signed-off-by: Lothar Wa=C3=9Fmann <LW@KARO-electronics.de>
> ---
>   arch/arm/boot/dts/imx28.dtsi |    2 +-
>   drivers/crypto/dcp.c         |    2 ++
>   2 files changed, 3 insertions(+), 1 deletions(-)

> diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.d=
tsi
> index ea99d09..0584935 100644
> --- a/arch/arm/boot/dts/imx28.dtsi
> +++ b/arch/arm/boot/dts/imx28.dtsi
> @@ -794,7 +794,7 @@
>   			};
>
>   			dcp: dcp@80028000 {

     By the way, I see that this is a crypto device, so it should be na=
med=20
"crypto" according to ePAPR spec. [1]

> -				compatible =3D "fsl-dcp";
> +				compatible =3D "fsl,dcp";
>   				reg =3D <0x80028000 0x2000>;
>   				interrupts =3D <52 53 54>;
>   				status =3D "disabled";

[1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.=
pdf

WBR, Sergei
