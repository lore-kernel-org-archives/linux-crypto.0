Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1517C433E6
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 13:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A979F64F4C
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 13:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbhCDNcD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 08:32:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:52730 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241289AbhCDNbs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 08:31:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8ABA2ADDB;
        Thu,  4 Mar 2021 13:31:06 +0000 (UTC)
Message-ID: <c750ae9f6c55011c07868ba563ac8e5af3e01a2a.camel@suse.de>
Subject: Re: [PATCH v3 1/2] dt-bindings: rng: bcm2835: document reset support
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     =?ISO-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Cc:     Matt Mackall <mpm@selenic.com>,
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
        =?ISO-8859-1?Q?=22N=EDcolas?= "F. R. A. Prado\"" 
        <nfraprado@protonmail.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 04 Mar 2021 14:30:59 +0100
In-Reply-To: <419CC9A9-1C14-4D44-8305-3F7DFF656C1F@gmail.com>
References: <20210222194510.14004-1-noltari@gmail.com>
         <20210223170006.29558-1-noltari@gmail.com>
         <20210223170006.29558-2-noltari@gmail.com>
         <d6e5b3be7e2add03b8d00a931b7fe254cd39077e.camel@suse.de>
         <419CC9A9-1C14-4D44-8305-3F7DFF656C1F@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-m3cXGXZUPPGptSRcXp8J"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--=-m3cXGXZUPPGptSRcXp8J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-03-04 at 13:18 +0100, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
>=20
> > El 4 mar 2021, a las 13:07, Nicolas Saenz Julienne <nsaenzjulienne@suse=
.de> escribi=C3=B3:
> >=20
> > Hi Alvaro,
> >=20
> > On Tue, 2021-02-23 at 18:00 +0100, =C3=81lvaro Fern=C3=A1ndez Rojas wro=
te:
> > > Some devices may need to perform a reset before using the RNG, such a=
s the
> > > BCM6368.
> > >=20
> > > Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> > > ---
> > > =C2=A0v3: make resets required if brcm,bcm6368-rng.
> > > =C2=A0v2: document reset support.
> > >=20
> > > =C2=A0.../devicetree/bindings/rng/brcm,bcm2835.yaml   | 17 ++++++++++=
+++++++
> > > =C2=A01 file changed, 17 insertions(+)
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml =
b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> > > index c147900f9041..11c23e1f6988 100644
> > > --- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> > > +++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> > > @@ -37,6 +37,21 @@ required:
> > > =C2=A0
> > >=20
> > >=20
> > > =C2=A0additionalProperties: false
> >=20
> > I can't claim I fully understand all the meta stuff in shemas, so I gen=
erally
> > just follow the patterns already available out there.
>=20
> Well, that makes two of us :).
>=20
> > That said, shoudln't this be at the end, just before the examples?
>=20
> I don=E2=80=99t know but I can move it there =C2=AF\_(=E3=83=84)_/=C2=AF

Yes please do. See commit 7f464532b05 ("dt-bindings: Add missing
'additionalProperties: false'") which expands on why it is needed, and why =
it
should be at the end.

> > Maybe the cause of that odd warning
> > you got there?
>=20
> Which odd warning?

The one pointed out by Rob Herring's script, which I can reproduce too BTW.=
 On
the other hand I can't really tell what's wrong right away.

> I don=E2=80=99t get any warnings when running (or at least warnings relat=
ed to rig, because I get warnings related to other yamls):
> make dt_binding_check DT_SCHEMA_FILES=3DDocumentation/devicetree/bindings=
/rng/brcm,bcm2835.yaml
>=20
> >=20
> > > +if:
> > > +  properties:
> > > +    compatible:
> > > +      enum:
> > > +        - brcm,bcm6368-rng
> > > +then:
> > > +  properties:
> > > +    resets:
> > > +      maxItems: 1
> > > +  required:
> > > +    - resets
> >=20
> > I belive you can't really make a property required when the bindings fo=
r
> > 'brcm,bcm6368-rng' were already defined. This will break the schema for=
 those
> > otherwise correct devicetrees.
>=20
> Why not?
> Wouldn=E2=80=99t just be required for brcm,bcm6368-rng?

Well, do all 'brcm,bcm6368-rng' users absolutely need the reset controller?=
 If
so, the original binding is wrong, which should be mentioned and a 'Fixes:'=
 tag
should be added to the commit message. Otherwise, the requirement is option=
al.

Regards,
Nicolas


--=-m3cXGXZUPPGptSRcXp8J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAmBA4RMACgkQlfZmHno8
x/7rPAf+J04FGcPATCGmYKMHpyyL+ImHtpN3qzv3OQXQ2oSmUYXMxxZcq69ph1fx
CyVbaksI8BpmmVxnW+LXFFHdbBp9eRbXWy+6jNByWe09TDNDk5e8ETYq7TPdo8ul
ZIBTkzrrIIFnvliKOFQJaYZjzWEiWk+uRFpUN6Fsua/tUt/2fBvKabZqgrsvBJsV
p0i+T+U9q9436VixW9ZCAksjxwyZa7SeUct0ev+u/StWmyO2nPmG2fSDCBVaF5q6
zKLOVFJAwurSv9J5YC2P7f4NET9aYCP5S+71SH9uXWM7sX98ZCdHuPEhWk79geOO
vzL6yXGZq8WSt3FK7A37DAweCj0ang==
=hG4s
-----END PGP SIGNATURE-----

--=-m3cXGXZUPPGptSRcXp8J--

