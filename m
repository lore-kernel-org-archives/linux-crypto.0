Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9449FC432C0
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 11:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7284620862
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 11:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfKRLpF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 06:45:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:60952 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726704AbfKRLpF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 06:45:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D2085AD88;
        Mon, 18 Nov 2019 11:45:02 +0000 (UTC)
Message-ID: <3209f601ad0537a7ef01e2a752f022ccf8816210.camel@suse.de>
Subject: Re: [PATCH 3/3] ARM: dts: bcm2711: Enable HWRNG support
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
Date:   Mon, 18 Nov 2019 12:44:59 +0100
In-Reply-To: <20191118075807.165126-4-stephen@brennan.io>
References: <20191118075807.165126-1-stephen@brennan.io>
         <20191118075807.165126-4-stephen@brennan.io>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-BrzURT1nntfCQobYCsCl"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--=-BrzURT1nntfCQobYCsCl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Sun, 2019-11-17 at 23:58 -0800, Stephen Brennan wrote:
> From: Stefan Wahren <wahrenst@gmx.net>
>=20
> This enables hardware random number generator support for the BCM2711
> on the Raspberry Pi 4 board.
>=20
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> Signed-off-by: Stephen Brennan <stephen@brennan.io>
> ---
>  arch/arm/boot/dts/bcm2711.dtsi | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.d=
tsi
> index ac83dac2e6ba..2c19e5de284a 100644
> --- a/arch/arm/boot/dts/bcm2711.dtsi
> +++ b/arch/arm/boot/dts/bcm2711.dtsi
> @@ -92,10 +92,9 @@ pm: watchdog@7e100000 {
>  		};
> =20
>  		rng@7e104000 {
> +			compatible =3D "brcm,bcm2711-rng200";
>  			interrupts =3D <GIC_SPI 125 IRQ_TYPE_LEVEL_HIGH>;
> -
> -			/* RNG is incompatible with brcm,bcm2835-rng */
> -			status =3D "disabled";
> +			status =3D "okay";
>  		};
> =20
>  		uart2: serial@7e201400 {

We inherit the reg property from bcm283x.dtsi, on which we only define a si=
ze
of 0x10 bytes. I gather from the driver that iproc-rng200's register space =
is
at least 0x28 bytes big. We should also update the 'reg' property to:

	reg =3D <0x7e104000 0x28>;

Regards,
Nicolas


--=-BrzURT1nntfCQobYCsCl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl3ShDsACgkQlfZmHno8
x/42dQgAiWoADYCp4IVFQLfny8DRGulI2ckkAswc80iZXIZSayMSqYsAogWqMDq1
IqOc4PUpzunlVDayHHLM4gxhvPZ+vVPbyQocAITnMo+kYw+CMdRKiwVSYw1ISuMx
idBzkpcpDNHRh84KoSxR+hCwFjZEKqG72OdwwMEuDQQ14V6MSUFoj0OTCfYBAWJF
KKYSn+GccciW0VwPzqXMNYDALxv6J3vhdDeOBskGwP4XCGdPu6VX5SBlFF2opS70
x7wIyX5Trf2w36VOihV2klVNf8QovaqpNzGpL73+3TjdwJV/zfuDRzTPrbRQdpj9
nQRFpEalCmqp7XUN1DxQFZ+yR9XAfw==
=OhCk
-----END PGP SIGNATURE-----

--=-BrzURT1nntfCQobYCsCl--

