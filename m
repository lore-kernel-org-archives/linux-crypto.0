Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7520BC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Dec 2022 17:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiLWRrc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Dec 2022 12:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiLWRrc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Dec 2022 12:47:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F21E1B9C0
        for <linux-crypto@vger.kernel.org>; Fri, 23 Dec 2022 09:47:31 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1p8m8k-00035B-P9; Fri, 23 Dec 2022 18:47:26 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1p8m8g-001Gn7-6C; Fri, 23 Dec 2022 18:47:22 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1p8m8f-007POs-GV; Fri, 23 Dec 2022 18:47:21 +0100
Date:   Fri, 23 Dec 2022 18:47:19 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: caam - Prevent fortify error
Message-ID: <20221223174719.4n6pmwio4zycj2qm@pengutronix.de>
References: <20221222162513.4021928-1-u.kleine-koenig@pengutronix.de>
 <Y6VK4IJkHiawAbJz@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4voh3jrqjlnm7uvs"
Content-Disposition: inline
In-Reply-To: <Y6VK4IJkHiawAbJz@gondor.apana.org.au>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--4voh3jrqjlnm7uvs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 23, 2022 at 02:29:52PM +0800, Herbert Xu wrote:
> On Thu, Dec 22, 2022 at 05:25:13PM +0100, Uwe Kleine-K=C3=B6nig wrote:
> > When compiling arm64 allmodconfig  with gcc 10.2.1 I get
> >=20
> > 	drivers/crypto/caam/desc_constr.h: In function =E2=80=98append_data.co=
nstprop=E2=80=99:
> > 	include/linux/fortify-string.h:57:29: error: argument 2 null where non=
-null expected [-Werror=3Dnonnull]
> >=20
> > Fix this by skipping the memcpy if data is NULL and add a BUG_ON instead
> > that triggers on a problematic call that is now prevented to trigger.
> > After data =3D=3D NULL && len !=3D 0 is known to be false, logically
> >=20
> > 	if (len)
> > 		memcpy(...)
> >=20
> > could be enough to know that memcpy is not called with dest=3DNULL, but
> > gcc doesn't seem smart enough for that conclusion. gcc 12 doesn't have a
> > problem with the original code.
> >=20
> > Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> > ---
> >  drivers/crypto/caam/desc_constr.h | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> Does this patch fix your problem?
>=20
> https://lore.kernel.org/all/Y4mHjKXnF%2F4Pfw5I@gondor.apana.org.au/

Using

	if (data && len)

fixes it (that's the patch that b4 picks for the above message id :-\),

	if (!IS_ENABLED(CONFIG_CRYPTO_DEV_FSL_CAAM_DEBUG) && len)

makes the problem go away, too. But I wonder if the latter is correct.
Shouldn't the memcpy happen even with that debugging symbol enabled?

> If not please send me your kconfig file.

(It's a plain arm64 allmodconfig)

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=C3=B6nig         =
   |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--4voh3jrqjlnm7uvs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmOl6aQACgkQwfwUeK3K
7AmihAf9H/w2F3oDM6uvf5HktZ+6qpmKs6xTCa0tnkKBTX2Fb2zi9rHZPo2r33Cg
ZjT1+f5mFfKKN2N5kfV2ibY8m85nIdWvqbrVDEDzAhLU/pWrUCVYGVLl2Voy6LPU
FjGDuCo3GGCL1st84GimKp1two6RQAuRNgBzTvOSI1mJ/fZ4vNXVSZ9n7UtuEDgX
cOL2YWOXm/H5/yJ36QfIJ4MqPQYLkCs6RQsVWUoC11uCqJvea8WSqA9yXw5j4AaD
g99Zrj79KFeSjygfOROf4/zKCU/IAQw/qqwmGeEZuA4O2/ncq0g7dk6c7PYKvcPm
zvMV1sFbSFQZZJ+lP6XyedlKJ9BC1w==
=pWt7
-----END PGP SIGNATURE-----

--4voh3jrqjlnm7uvs--
