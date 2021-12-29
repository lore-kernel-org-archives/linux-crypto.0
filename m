Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CDBC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Dec 2021 11:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbhL2LFj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Dec 2021 06:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbhL2LFi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Dec 2021 06:05:38 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A05EC061574
        for <linux-crypto@vger.kernel.org>; Wed, 29 Dec 2021 03:05:38 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n2Wlu-0004rB-LS; Wed, 29 Dec 2021 12:05:30 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1n2Wlr-007HcB-Mm; Wed, 29 Dec 2021 12:05:27 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n2Wlq-0002ym-Eb; Wed, 29 Dec 2021 12:05:26 +0100
Date:   Wed, 29 Dec 2021 12:05:23 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Simo Sorce <ssorce@redhat.com>, Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kernel@pengutronix.de, Guenter Roeck <linux@roeck-us.net>,
        Vladis Dronov <vdronov@redhat.com>
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <20211229110523.rsbzlkpjzwmqyvfs@pengutronix.de>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <20211026163319.GA2785420@roeck-us.net>
 <20211106034725.GA18680@gondor.apana.org.au>
 <729fc135-8e55-fd4f-707a-60b9a222ab97@roeck-us.net>
 <20211222102246.qibf7v2q4atl6gc6@pengutronix.de>
 <YcvCglFcJEA87KNN@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="opay36myzyuuwwzp"
Content-Disposition: inline
In-Reply-To: <YcvCglFcJEA87KNN@gondor.apana.org.au>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--opay36myzyuuwwzp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 29, 2021 at 01:05:54PM +1100, Herbert Xu wrote:
> On Wed, Dec 22, 2021 at 11:22:46AM +0100, Uwe Kleine-K=F6nig wrote:
> >
> > I still experience a problem with the patch that got
> > adad556efcdd42a1d9e060cbe5f6161cccf1fa28 in v5.16-rc1. I saw there are
> > two commit fixing this one (
> >=20
> > 	cad439fc040e crypto: api - Do not create test larvals if manager is di=
sabled
> > 	e42dff467ee6 crypto: api - Export crypto_boot_test_finished
> >=20
> > ) but I still encounter the following on 2f47a9a4dfa3:
>=20
> Perhaps you missed the last fix?
>=20
> commit beaaaa37c664e9afdf2913aee19185d8e3793b50
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Fri Nov 5 15:26:08 2021 +0800
>=20
>     crypto: api - Fix boot-up crash when crypto manager is disabled

As 2f47a9a4dfa3 includes this commit, this is not the problem.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--opay36myzyuuwwzp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHMQO8ACgkQwfwUeK3K
7Amncwf/Y+JiiLAk1+LhtwMlsL72Rr64WgBCAESv7adsumXq0+VDjxmm2JVsEzc8
kkCs1GSA6MwcYJB6OH83MomACnDI7iwwGqzp/5PRhWdbxVMW0RLRINnzpo/k0rWB
ujErs82/7bW48lnPKq/GzXv2lKssoFMvGRW9zNtSKjtn0GmgjSxNu/sgG/9AjhNp
nUUUTZnGHoO6jjGJuJPc30HNDF6TGzgtLCp3i/fI16+6pTSRlGt7thzUkpx00nc4
0a2kwUdMwGvwPFaRPMcU05g/MdM48p19Q39P/2wcyE8haeFp17idJvhAR8Bml1Iq
yvWgB4bDbQaee8CVjPs4SSGvtWzgTQ==
=scMT
-----END PGP SIGNATURE-----

--opay36myzyuuwwzp--
