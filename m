Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A717BC43381
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 12:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D92164F2B
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 12:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240198AbhCDMIt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 07:08:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:53830 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234686AbhCDMIU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 07:08:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D80BFAAC5;
        Thu,  4 Mar 2021 12:07:38 +0000 (UTC)
Message-ID: <d6e5b3be7e2add03b8d00a931b7fe254cd39077e.camel@suse.de>
Subject: Re: [PATCH v3 1/2] dt-bindings: rng: bcm2835: document reset support
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
        Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?ISO-8859-1?Q?N=EDcolas?= "F. R. A. Prado" 
        <nfraprado@protonmail.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 04 Mar 2021 13:07:36 +0100
In-Reply-To: <20210223170006.29558-2-noltari@gmail.com>
References: <20210222194510.14004-1-noltari@gmail.com>
         <20210223170006.29558-1-noltari@gmail.com>
         <20210223170006.29558-2-noltari@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ECKm3qOS91U+uJWquTGZ"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--=-ECKm3qOS91U+uJWquTGZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alvaro,

On Tue, 2021-02-23 at 18:00 +0100, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> Some devices may need to perform a reset before using the RNG, such as th=
e
> BCM6368.
>=20
> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> ---
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

I can't claim I fully understand all the meta stuff in shemas, so I general=
ly
just follow the patterns already available out there. That said, shoudln't =
this
be at the end, just before the examples? Maybe the cause of that odd warnin=
g
you got there?

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

I belive you can't really make a property required when the bindings for
'brcm,bcm6368-rng' were already defined. This will break the schema for tho=
se
otherwise correct devicetrees.

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

Regards,
Nicolas


--=-ECKm3qOS91U+uJWquTGZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAmBAzYgACgkQlfZmHno8
x/4dVQf+JZcSZkUQMTFgFCfh820ujn+nyaM6c0hQgaTUCslzyj5MXBafaxVb8YQ9
Nt8RP4jv+QcG50qoeIHzu25DghMGv9KvJE9IJ6DJ8ZWOA5OlLN46pq6YkuhFVhgn
LODAnXDiAmrFA1/mB6r9sQkZWJUbsIBujImMHvC2Rh2W+/capocznMXAw6Ts1xwW
dcxmgjOT1pmm+rFhggzluwGcbcYNPibwo16mRc1Gft7K/IrLxus+ySJ4eutSWDKt
hU8iD92fuYKwlCJzvpLnEo2nUAA20Y9knhzyX/ah0rm3R6f8nVFU/lR2s/WCkCwF
X6OFwW541Y94/FDEWOPXENCdl9sLVw==
=BoaX
-----END PGP SIGNATURE-----

--=-ECKm3qOS91U+uJWquTGZ--

