Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A496EC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jul 2022 20:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbiGLUAg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Jul 2022 16:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiGLUAg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Jul 2022 16:00:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4BE3C8D9
        for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2022 13:00:35 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1oBM3Q-0006FU-SA; Tue, 12 Jul 2022 22:00:20 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oBM3L-000ZR4-3x; Tue, 12 Jul 2022 22:00:15 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oBM3K-004mxU-9S; Tue, 12 Jul 2022 22:00:14 +0200
Date:   Tue, 12 Jul 2022 22:00:10 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, olivia@selenic.com,
        paul.gortmaker@windriver.com, dwmw2@infradead.org,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] MAINTAINERS: Change mentions of mpm to olivia
Message-ID: <20220712200010.kbx24o2nxobrhmey@pengutronix.de>
References: <20220712185419.45487-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3ugdib3frsqf57yr"
Content-Disposition: inline
In-Reply-To: <20220712185419.45487-1-f.fainelli@gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--3ugdib3frsqf57yr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 12, 2022 at 11:54:19AM -0700, Florian Fainelli wrote:
> Following this mercurial changeset:
> https://www.mercurial-scm.org/repo/hg-stable/rev/d4ba4d51f85f
>=20
> update the MAINTAINERS entry to replace the now obsolete identity.
>=20
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> This was first submitted by Uwe:
>=20
> https://lore.kernel.org/lkml/20210920080635.253826-1-u.kleine-koenig@peng=
utronix.de/

My variant was to drop Matt/Olivia. Given that we didn't get any
feedback from them, that's still what I would favour.

Without any feedback (and committment?) from Olivia, I tend to nack this
patch.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--3ugdib3frsqf57yr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmLN0scACgkQwfwUeK3K
7AnREAf+PlSlT47//PJVYU31Gt4GNAV4v2o/8joQSsAof8dic1OI0hclbKS7IOGG
w4DveYc5FjsI6/u0tO4+q2bdTS1Ehnj3L3RUmpOlsKJ386Pkv9ztnCn9fblY8b27
fbZCpPmPAwveg4rXLfGeFVaQ6GiJpmggU0k9RC/7wBsu29P7RVir/R8gA7Nm+bj3
B+3J1F/iwPCYufbmfpLLiGD+h5//FnkBjG/2eM6hcvLDf2pV9d86tXZkfH3JyUyc
lG6+s5bSvISc5Gd5a/FDJreHAJqkBBrntK+odt17xlpYGUcu3Z5OWQXgW2EXZCSU
OMRs+d1GEHHw1ftHLWcTVhV+eZ5xIA==
=O8jQ
-----END PGP SIGNATURE-----

--3ugdib3frsqf57yr--
