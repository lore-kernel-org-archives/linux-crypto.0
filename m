Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8DCC001E0
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jul 2023 08:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbjGZIKe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jul 2023 04:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbjGZIKG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jul 2023 04:10:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4261D72A9
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jul 2023 01:02:21 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qOZTH-0006oX-GG; Wed, 26 Jul 2023 10:02:11 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qOZTG-002BZR-PP; Wed, 26 Jul 2023 10:02:10 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qOZTG-007sRt-4u; Wed, 26 Jul 2023 10:02:10 +0200
Date:   Wed, 26 Jul 2023 10:02:10 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] crypto: caam/jr - Convert to platform remove callback
 returning void
Message-ID: <20230726080210.sxutixvvkxbt5rwq@pengutronix.de>
References: <20230726075938.448673-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="n5pqf6mu6ik2qblr"
Content-Disposition: inline
In-Reply-To: <20230726075938.448673-1-u.kleine-koenig@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--n5pqf6mu6ik2qblr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Wed, Jul 26, 2023 at 09:59:38AM +0200, Uwe Kleine-K=F6nig wrote:
> -		dev_err(jrdev, "Device is busy\n");
> +		dev_warn(jrdev, "Device is busy, fasten your seat belts, a crash is ah=
ead.\n");

I intended to make this higher-priority than dev_err. So this should be
a dev_alert instead of dev_warn. I'll wait a bit before resending to
allow feedback. If you intend to apply it before, please fix-up
accordingly.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--n5pqf6mu6ik2qblr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmTA0wEACgkQj4D7WH0S
/k5SJAf+PmQVULn68TWm8ttFPOfQtWYtMINF857vVFIb8nO//ikmdc9Buiqx4d1y
53t7NiLl8tYCd9/zHQL/DBP6YC4n7dhdCNwzRR8dCqji7PtKDCAwdbV/Bae9MBCj
/NjG7YR1AdqYcJE2ia9Nt7XZBEO8v7yik/SfCX/MoY6+6bHyaalYC8v+cWtOLQFQ
xnV+OgByh+ZuFbpDopumbMzISeTYh/By/NXnGQB4MkfpOzVIowpr8ep7dpeqM3ir
arN1f+4+CaL6smKj+2Bl3hUxTmrCMuenX6cBiz+5nSixItqJvO9fmlWaEYHqp5dH
R28tKAPkkKHP66YoTMkhAdYE7JSUYQ==
=Zemh
-----END PGP SIGNATURE-----

--n5pqf6mu6ik2qblr--
