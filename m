Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD316C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 15:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7922764F8C
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 15:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhCDPMw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 10:12:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:57906 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233928AbhCDPMe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 10:12:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CA401AEBE;
        Thu,  4 Mar 2021 15:11:52 +0000 (UTC)
Message-ID: <c76c82668142710ba5a7a8454759c9aa2423d72f.camel@suse.de>
Subject: Re: [PATCH] hwrng: bcm2835: set quality to 1000
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?ISO-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andrew Lunn <andrew@lunn.ch>, Matt Mackall <mpm@selenic.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stijn@linux-ipv6.be, ynezz@true.cz
Date:   Thu, 04 Mar 2021 16:11:50 +0100
In-Reply-To: <66AED5A4-3227-47CA-A4A2-B5AD6A571AAC@gmail.com>
References: <20210220174741.23665-1-noltari@gmail.com>
         <YDFeao/bOxvoXI9D@lunn.ch> <9b86c773-7153-1e18-472a-f66b01c83173@gmail.com>
         <20210303092019.GB8134@gondor.apana.org.au>
         <66AED5A4-3227-47CA-A4A2-B5AD6A571AAC@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-tF7nKy1ApkUrE/NT/hRA"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--=-tF7nKy1ApkUrE/NT/hRA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-03-03 at 10:29 +0100, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> Hi Herbert,
>=20
> > El 3 mar 2021, a las 10:20, Herbert Xu <herbert@gondor.apana.org.au> es=
cribi=C3=B3:
> >=20
> > On Sat, Feb 20, 2021 at 08:12:45PM +0100, =C3=81lvaro Fern=C3=A1ndez Ro=
jas wrote:
> > >=20
> > > I ran rngtest and this is what I got:
> >=20
> > This is meaningless except for sources that have not been whitened.
> >=20
> > Your justification needs to be based on what the hardware does or
> > is documented to do.
>=20
> Ok, so I guess that we=E2=80=99re never setting that value to anything si=
nce there=E2=80=99s
> no public documentation about that =C2=AF\_(=E3=83=84)_/=C2=AF.

@Florian, is there a way you might be able to get the official value?

Regards,
Nicolas



--=-tF7nKy1ApkUrE/NT/hRA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAmBA+LYACgkQlfZmHno8
x/4mpQgAtv3mCg9PtALi+43qvHdRpWuxh2In743JgcDCQZy8dF9b8SeAynKQE58x
ejixPpOGqzJb1DBuw0Y07w5AsUBDos7ciO5KNtcaW+IqetkIJ9O47gqqe6u+VEui
X9uAG/lUtn1VdUtQp1ybUyqWkxTdu2nO/IUO8Jb0ZUXbFt5JI/zEfhoJGdnf+Mct
fWK132jWOFvxakd++IoCntKsUnim7nyz0fjPWvDYhhUptvdjBn60S2aWaauzk6MA
i04ek+sOycamBbg94IcFvMcXmO1L6xLL2YpBn6Rfd5gvvE3QEyEq7tOER4VoO0t9
8Cw+oBf2QT6W+62KOG5Uf25d+U1qKQ==
=k9q4
-----END PGP SIGNATURE-----

--=-tF7nKy1ApkUrE/NT/hRA--

