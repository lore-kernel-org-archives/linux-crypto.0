Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1BC0EB64DD
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Aug 2023 08:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjHAIOm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Aug 2023 04:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbjHAIOc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2023 04:14:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5B5268F
        for <linux-crypto@vger.kernel.org>; Tue,  1 Aug 2023 01:14:18 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qQkWC-0006Al-Jf; Tue, 01 Aug 2023 10:14:12 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qQkWA-000L8P-BY; Tue, 01 Aug 2023 10:14:10 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qQkW9-009Zxh-CS; Tue, 01 Aug 2023 10:14:09 +0200
Date:   Tue, 1 Aug 2023 10:14:08 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Gaurav Jain <gaurav.jain@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [EXT] [PATCH] crypto: caam/jr - Convert to platform remove
 callback returning void
Message-ID: <20230801081408.nbu6j7srg5mt7sbj@pengutronix.de>
References: <20230726075938.448673-1-u.kleine-koenig@pengutronix.de>
 <AM0PR04MB6004495B1BC8F72A1EC6EED0E705A@AM0PR04MB6004.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bungxktlem4uxc2u"
Content-Disposition: inline
In-Reply-To: <AM0PR04MB6004495B1BC8F72A1EC6EED0E705A@AM0PR04MB6004.eurprd04.prod.outlook.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--bungxktlem4uxc2u
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Gaurav,

On Mon, Jul 31, 2023 at 09:56:22AM +0000, Gaurav Jain wrote:
> > -----Original Message-----
> > From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > Sent: Wednesday, July 26, 2023 1:30 PM
> > To: Horia Geanta <horia.geanta@nxp.com>; Pankaj Gupta
> > <pankaj.gupta@nxp.com>; Gaurav Jain <gaurav.jain@nxp.com>; Herbert Xu
> > <herbert@gondor.apana.org.au>; David S. Miller <davem@davemloft.net>
> > Cc: linux-crypto@vger.kernel.org; kernel@pengutronix.de
> > Subject: [EXT] [PATCH] crypto: caam/jr - Convert to platform remove cal=
lback
> > returning void
> >=20
> > Caution: This is an external email. Please take care when clicking link=
s or
> > opening attachments. When in doubt, report the message using the 'Repor=
t this
> > email' button
> >=20
> >=20
> > The .remove() callback for a platform driver returns an int which makes=
 many
> > driver authors wrongly assume it's possible to do error handling by ret=
urning an
> > error code. However the value returned is (mostly) ignored and this typ=
ically
> > results in resource leaks. To improve here there is a quest to make the=
 remove
> > callback return void. In the first step of this quest all drivers are c=
onverted
> > to .remove_new() which already returns void.
> >=20
> > The driver adapted here suffers from this wrong assumption. Returning -=
EBUSY
> > if there are still users results in resource leaks and probably a crash=
=2E Also further
> > down passing the error code of caam_jr_shutdown() to the caller only re=
sults in
> > another error message and has no further consequences compared to retur=
ning
> > zero.
> >=20
> > Still convert the driver to return no value in the remove callback. Thi=
s also allows
> > to drop caam_jr_platform_shutdown() as the only function called by it n=
ow has
> > the same prototype.
> >=20
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> >=20
> > note that the problems described above and in the extended comment isn't
> > introduced by this patch. It's as old as
> > 313ea293e9c4d1eabcaddd2c0800f083b03c2a2e at least.
> >=20
> > Also orthogonal to this patch I wonder about the use of a shutdown call=
back.
> > What makes this driver special to require extra handling at shutdown ti=
me?
> >=20
> > Best regards
> > Uwe
> >=20
> >  drivers/crypto/caam/jr.c | 22 +++++++++-------------
> >  1 file changed, 9 insertions(+), 13 deletions(-)
> >=20
> > diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c index
> > 96dea5304d22..66b1eb3eb4a4 100644
> > --- a/drivers/crypto/caam/jr.c
> > +++ b/drivers/crypto/caam/jr.c
> > @@ -162,7 +162,7 @@ static int caam_jr_shutdown(struct device *dev)
> >         return ret;
> >  }
> >=20
> > -static int caam_jr_remove(struct platform_device *pdev)
> > +static void caam_jr_remove(struct platform_device *pdev)
> >  {
> >         int ret;
> >         struct device *jrdev;
> > @@ -175,11 +175,14 @@ static int caam_jr_remove(struct platform_device
> > *pdev)
> >                 caam_rng_exit(jrdev->parent);
> >=20
> >         /*
> > -        * Return EBUSY if job ring already allocated.
> > +        * If a job ring is still allocated there is trouble ahead. Once
> > +        * caam_jr_remove() returned, jrpriv will be freed and the regi=
sters
> > +        * will get unmapped. So any user of such a job ring will proba=
bly
> > +        * crash.
> >          */
> >         if (atomic_read(&jrpriv->tfm_count)) {
> > -               dev_err(jrdev, "Device is busy\n");
> > -               return -EBUSY;
> > +               dev_warn(jrdev, "Device is busy, fasten your seat belts=
, a crash is ahead.\n");
>
> Changes are ok. Can you improve the error message or keep it same.

What do you imagine here? "Device is busy" lacks urgency in my eyes and
is hard to rate by a log reader. Mentioning that something bad is about
to happen would be good. Do you want it expressed in a more serious way?
Something like:

	Device is busy; consumers might start to crash

?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--bungxktlem4uxc2u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmTIvtAACgkQj4D7WH0S
/k7sgAgAmpIC9rqvyLJDE+0R3GRTWXB8CEjbQOoZBQ/h/F/k5qsebXz2oE4VVo+N
XzNQzVbHOCNGJltpPsbr3pNRwjS/llfk3GZGE4Mb/qZvRfM6OWG67qv1dnf8Eu9o
kwUz1QaccDsU6yqDVoM0s5s5RIBFnBjT3hyAKUaqf6RbzbW4kDgz6xXnuySdWKfw
9VZ1yJ4nr3/GMktWELhID+W5356L5c9ElmcPl/4wux1msDmPHAjkkMN9tOy31pCg
tIFLqppxy9LYbkShdYEUrrujb6vgqxlQwGR683sqVmFDgkMFQcrrcGh9NDHV4JmN
bgAw7uuWbsy7WAWgDos1cLF29Gvwxg==
=Pz5c
-----END PGP SIGNATURE-----

--bungxktlem4uxc2u--
