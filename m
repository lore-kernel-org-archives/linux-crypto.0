Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 378A5C432C3
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 10:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 148C2222B3
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 10:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfKSKHH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 05:07:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:39546 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726510AbfKSKHH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 05:07:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 879F6AFBD;
        Tue, 19 Nov 2019 10:07:04 +0000 (UTC)
Message-ID: <e38de8daad5a2c9b03bda1aa2632844e3ed3d11e.camel@suse.de>
Subject: Re: [PATCH v2 3/3] ARM: dts: bcm2711: Enable HWRNG support
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Stephen Brennan <stephen@brennan.io>
Cc:     Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Branden <sbranden@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, Ray Jui <rjui@broadcom.com>,
        linux-kernel@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        Stefan Wahren <wahrenst@gmx.net>,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org
Date:   Tue, 19 Nov 2019 11:07:01 +0100
In-Reply-To: <20191119061407.69911-4-stephen@brennan.io>
References: <20191119061407.69911-1-stephen@brennan.io>
         <20191119061407.69911-4-stephen@brennan.io>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-f4TrG9pLSfNSCk5pcMvM"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--=-f4TrG9pLSfNSCk5pcMvM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Stephen, thanks for the follow-up.

On Mon, 2019-11-18 at 22:14 -0800, Stephen Brennan wrote:
> BCM2711 features a RNG200 hardware random number generator block, which i=
s
> different from the BCM283x from which it inherits. Move the rng block fro=
m
> BCM283x into a separate common file, and update the rng declaration of
> BCM2711.
>=20
> Signed-off-by: Stephen Brennan <stephen@brennan.io>
> ---

It's petty in this case but you should add a list of changes here too.

>  arch/arm/boot/dts/bcm2711.dtsi        |  6 +++---
>  arch/arm/boot/dts/bcm2835.dtsi        |  1 +
>  arch/arm/boot/dts/bcm2836.dtsi        |  1 +
>  arch/arm/boot/dts/bcm2837.dtsi        |  1 +
>  arch/arm/boot/dts/bcm283x-common.dtsi | 11 +++++++++++
>  arch/arm/boot/dts/bcm283x.dtsi        |  6 ------
>  6 files changed, 17 insertions(+), 9 deletions(-)
>  create mode 100644 arch/arm/boot/dts/bcm283x-common.dtsi
>=20
> diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.d=
tsi
> index ac83dac2e6ba..4975567e948e 100644
> --- a/arch/arm/boot/dts/bcm2711.dtsi
> +++ b/arch/arm/boot/dts/bcm2711.dtsi
> @@ -92,10 +92,10 @@ pm: watchdog@7e100000 {
>  		};
> =20
>  		rng@7e104000 {
> +			compatible =3D "brcm,bcm2711-rng200";
> +			reg =3D <0x7e104000 0x28>;
>  			interrupts =3D <GIC_SPI 125 IRQ_TYPE_LEVEL_HIGH>;
> -
> -			/* RNG is incompatible with brcm,bcm2835-rng */
> -			status =3D "disabled";
> +			status =3D "okay";
>  		};
> =20
>  		uart2: serial@7e201400 {
> diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm2835.d=
tsi
> index 53bf4579cc22..f7b2f46e307d 100644
> --- a/arch/arm/boot/dts/bcm2835.dtsi
> +++ b/arch/arm/boot/dts/bcm2835.dtsi
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include "bcm283x.dtsi"
> +#include "bcm283x-common.dtsi"
>  #include "bcm2835-common.dtsi"
> =20
>  / {
> diff --git a/arch/arm/boot/dts/bcm2836.dtsi b/arch/arm/boot/dts/bcm2836.d=
tsi
> index 82d6c4662ae4..a85374195796 100644
> --- a/arch/arm/boot/dts/bcm2836.dtsi
> +++ b/arch/arm/boot/dts/bcm2836.dtsi
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include "bcm283x.dtsi"
> +#include "bcm283x-common.dtsi"
>  #include "bcm2835-common.dtsi"
> =20
>  / {
> diff --git a/arch/arm/boot/dts/bcm2837.dtsi b/arch/arm/boot/dts/bcm2837.d=
tsi
> index 9e95fee78e19..045d78ffea08 100644
> --- a/arch/arm/boot/dts/bcm2837.dtsi
> +++ b/arch/arm/boot/dts/bcm2837.dtsi
> @@ -1,4 +1,5 @@
>  #include "bcm283x.dtsi"
> +#include "bcm283x-common.dtsi"
>  #include "bcm2835-common.dtsi"
> =20
>  / {
> diff --git a/arch/arm/boot/dts/bcm283x-common.dtsi
> b/arch/arm/boot/dts/bcm283x-common.dtsi
> new file mode 100644
> index 000000000000..3c8834bee390
> --- /dev/null
> +++ b/arch/arm/boot/dts/bcm283x-common.dtsi
> @@ -0,0 +1,11 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/ {
> +	soc {
> +		rng@7e104000 {
> +			compatible =3D "brcm,bcm2835-rng";
> +			reg =3D <0x7e104000 0x10>;
> +			interrupts =3D <2 29>;
> +		};
> +	};
> +};

I think Stefan wrote bcm283x-common.dtsi by mistake, he really meant
bcm2835-common.dtsi.

See bcm2835-common.dtsi's header comment:

/* This include file covers the common peripherals and configuration betwee=
n
 * bcm2835, bcm2836 and bcm2837 implementations.
 */

Regards,
Nicolas


--=-f4TrG9pLSfNSCk5pcMvM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl3TvsUACgkQlfZmHno8
x/4BbAf+MpKR4ihlPDuftuddKUI/HC7nve3fsLHoczZfLRf0pj2/FnKvX3qgFytE
xAYDpOXI1dprqHUPR1OavYQFO/UWFOSS3MRDIducwmDELc9gc5Z8iToD5ijYQiLM
z6/NO8BxIQJFky/2inBcsx70fEM5VLLJHQOfkSuf5NxfDR/iETwuzE0EMEBLj3tz
AnB31t86PHWGxFL2akCTFAdsbK8kJLiL0c6zrMb9xYct9S/9LC9ll0mU920HMUc9
Rwu7je1CKU72Pik+GQOTt1fF5b/TOvVENxprfCoTcelH3QudGfqVIQcXkNJFOMrd
oOhtvpofrtSfG1Dt9fsKdenSpi2gdg==
=ikdQ
-----END PGP SIGNATURE-----

--=-f4TrG9pLSfNSCk5pcMvM--

