Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F7A1C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 19:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43B6F20715
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 19:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfKTTpR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 14:45:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:60970 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726440AbfKTTpR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 14:45:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 63673AFCB;
        Wed, 20 Nov 2019 19:45:15 +0000 (UTC)
Message-ID: <073219d4e46bab9fb6ba972ebc2ee2f3b55abf55.camel@suse.de>
Subject: Re: [PATCH v3 4/4] ARM: dts: bcm2711: Enable HWRNG support
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
Date:   Wed, 20 Nov 2019 20:45:12 +0100
In-Reply-To: <20191120031622.88949-5-stephen@brennan.io>
References: <20191120031622.88949-1-stephen@brennan.io>
         <20191120031622.88949-5-stephen@brennan.io>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-EQFLnI4F4oDM522MqmL9"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--=-EQFLnI4F4oDM522MqmL9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-11-19 at 19:16 -0800, Stephen Brennan wrote:
> This enables hardware random number generator support for the BCM2711
> on the Raspberry Pi 4 board.
>=20
> Signed-off-by: Stephen Brennan <stephen@brennan.io>
> ---
>  arch/arm/boot/dts/bcm2711.dtsi | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.d=
tsi
> index ac83dac2e6ba..ed0877d5a1e9 100644
> --- a/arch/arm/boot/dts/bcm2711.dtsi
> +++ b/arch/arm/boot/dts/bcm2711.dtsi
> @@ -92,10 +92,9 @@ pm: watchdog@7e100000 {
>  		};
> =20
>  		rng@7e104000 {
> -			interrupts =3D <GIC_SPI 125 IRQ_TYPE_LEVEL_HIGH>;
> -
> -			/* RNG is incompatible with brcm,bcm2835-rng */
> -			status =3D "disabled";
> +			compatible =3D "brcm,bcm2711-rng200";
> +			reg =3D <0x7e104000 0x28>;
> +			status =3D "okay";

Small nitpick, the 'okay' status is set by default, so no need for this. Bu=
t
it's something we can edit out once we pick the patch.

Regards,
Nicolas


--=-EQFLnI4F4oDM522MqmL9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl3Vl8gACgkQlfZmHno8
x/49PQf/Tah+83leeq/AYVqsmeAlWU9tVFZ6DV4o9XFtXocYffZlQtscjV5mLpXU
4CfcjTwUdIn/Cfk70ZXXqD7EsQ9XUGN6pfNiP/rPffSSTKAUd7wektykwl9YQaAN
DcJBMRbPy+TPZDYaLu7DtGMpLe9HYj1p1onNEoKfW8XBqOPRirBQv1KfYTFMQyq4
ZCXnvMz6F4PxpUf/Ybgv3KB3twfd8c1vF9arPEh06PKfTozUbnUu0gEqjgLvwi6a
NP+K9oMo/5HMnOARh9znTaRJu/jKSjoiyCM0Jsisd6z6TDEe8PezgkxpdjIm6k79
p6f8JA13izZl3k2g8I5ZBnG+xuWyBQ==
=gzPL
-----END PGP SIGNATURE-----

--=-EQFLnI4F4oDM522MqmL9--

