Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99009C433E9
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 12:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80FC364F2C
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 12:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240343AbhCDMJW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 07:09:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:54274 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240373AbhCDMJT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 07:09:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CAF82AE47;
        Thu,  4 Mar 2021 12:08:37 +0000 (UTC)
Message-ID: <4da2069125bb6ae52f0e786d67994966e299ebd1.camel@suse.de>
Subject: Re: [PATCH v5 1/2] dt-bindings: rng: bcm2835: document reset support
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     =?ISO-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 04 Mar 2021 13:08:36 +0100
In-Reply-To: <20210304073308.25906-2-noltari@gmail.com>
References: <20210304073308.25906-1-noltari@gmail.com>
         <20210304073308.25906-2-noltari@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-tjGlIJA8Bhhn95v4z4X8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--=-tjGlIJA8Bhhn95v4z4X8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry Alvaro I missed you sent a v5 already. See my comments in v3.

Regards,
Nicolas

On Thu, 2021-03-04 at 08:33 +0100, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> Some devices may need to perform a reset before using the RNG, such as th=
e
> BCM6368.
>=20
> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> ---
> =C2=A0v5: no changes.
> =C2=A0v4: pass dt_binding_check.
> =C2=A0v3: make resets required if brcm,bcm6368-rng.
> =C2=A0v2: document reset support.
>=20
> =C2=A0.../devicetree/bindings/rng/brcm,bcm2835.yaml   | 17 ++++++++++++++=
+++
> =C2=A01 file changed, 17 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml b/Do=
cumentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> index c147900f9041..11c23e1f6988 100644
> --- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> +++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> @@ -37,6 +37,21 @@ required:
> =C2=A0
>=20
> =C2=A0additionalProperties: false
> =C2=A0
>=20
> +if:
> +  properties:
> +    compatible:
> +      enum:
> +        - brcm,bcm6368-rng
> +then:
> +  properties:
> +    resets:
> +      maxItems: 1
> +  required:
> +    - resets
> +else:
> +  properties:
> +    resets: false
> +
> =C2=A0examples:
> =C2=A0=C2=A0=C2=A0- |
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rng@7e104000 {
> @@ -58,4 +73,6 @@ examples:
> =C2=A0
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0clocks =3D <&periph=
_clk 18>;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0clock-names =3D "ip=
sec";
> +
> +        resets =3D <&periph_rst 4>;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0};



--=-tjGlIJA8Bhhn95v4z4X8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAmBAzcQACgkQlfZmHno8
x/4I5QgAqH8iPmySuMTTr17Uc7Kg3HHpkc4jS9fYAyfPB4SX1CD88wXXht5VqyGp
Te/xNXA5pqvsYl0Ui66pM8Rd87f7vjW1RynmKSFeFbIwBs8tEZQ6r8aMm6pt3cXd
g0+ZVBpVb/sYsM6Cmbc25EWoJYfzvEHMa+zuVJEVxOyaQFdlVPaKsCI4oEbIUz8+
4s3yam2oVipTN5GzYh7aSM+l5GUK1b/kZtpxxlk3a4C9HVyNi/FfCEOTeYmRi054
wJL4CvERNbFuX+3C/IJCHUuTBJT7lT8WmevEcJ8uv+hL2iRkNMVeMMgf5x38ViWo
IDAUGeat55U8qCLNHShDNJrq4f+Dlg==
=QEvf
-----END PGP SIGNATURE-----

--=-tjGlIJA8Bhhn95v4z4X8--

