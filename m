Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E61C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Mar 2022 21:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243024AbiCPVpn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Mar 2022 17:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351384AbiCPVpl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Mar 2022 17:45:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8D31125
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 14:44:25 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nUbRM-0000yn-KP; Wed, 16 Mar 2022 22:44:20 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nUbRM-00185O-0u; Wed, 16 Mar 2022 22:44:18 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nUbRJ-009dKV-Vb; Wed, 16 Mar 2022 22:44:17 +0100
Date:   Wed, 16 Mar 2022 22:44:17 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Simo Sorce <ssorce@redhat.com>, Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kernel@pengutronix.de, Guenter Roeck <linux@roeck-us.net>,
        Vladis Dronov <vdronov@redhat.com>
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <20220316214417.khho2qno76bby3qm@pengutronix.de>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <20211026163319.GA2785420@roeck-us.net>
 <20211106034725.GA18680@gondor.apana.org.au>
 <729fc135-8e55-fd4f-707a-60b9a222ab97@roeck-us.net>
 <20211222102246.qibf7v2q4atl6gc6@pengutronix.de>
 <YcvCglFcJEA87KNN@gondor.apana.org.au>
 <20211229110523.rsbzlkpjzwmqyvfs@pengutronix.de>
 <YjE5Ed5e1jjFFVn3@gondor.apana.org.au>
 <20220316163719.ud2s36e5zwmtmzef@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xg3yruzcshbn6abc"
Content-Disposition: inline
In-Reply-To: <20220316163719.ud2s36e5zwmtmzef@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--xg3yruzcshbn6abc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 16, 2022 at 05:37:19PM +0100, Uwe Kleine-K=F6nig wrote:
> On Wed, Mar 16, 2022 at 01:10:41PM +1200, Herbert Xu wrote:
> > On Wed, Dec 29, 2021 at 12:05:23PM +0100, Uwe Kleine-K=F6nig wrote:
> > > On Wed, Dec 29, 2021 at 01:05:54PM +1100, Herbert Xu wrote:
> > > > On Wed, Dec 22, 2021 at 11:22:46AM +0100, Uwe Kleine-K=F6nig wrote:
> > > > >
> > > > > I still experience a problem with the patch that got
> > > > > adad556efcdd42a1d9e060cbe5f6161cccf1fa28 in v5.16-rc1. I saw ther=
e are
> > > > > two commit fixing this one (
> > > > >=20
> > > > > 	cad439fc040e crypto: api - Do not create test larvals if manager=
 is disabled
> > > > > 	e42dff467ee6 crypto: api - Export crypto_boot_test_finished
> > > > >=20
> > > > > ) but I still encounter the following on 2f47a9a4dfa3:
> > > >=20
> > > > Perhaps you missed the last fix?
> > > >=20
> > > > commit beaaaa37c664e9afdf2913aee19185d8e3793b50
> > > > Author: Herbert Xu <herbert@gondor.apana.org.au>
> > > > Date:   Fri Nov 5 15:26:08 2021 +0800
> > > >=20
> > > >     crypto: api - Fix boot-up crash when crypto manager is disabled
> > >=20
> > > As 2f47a9a4dfa3 includes this commit, this is not the problem.
> >=20
> > Using the config snippet in this email thread I was unable to
> > reproduce the failure under qemu.  Can you still reproduce this
> > with the latest upstream kernel? If yes please send me your complete
> > config file.
>=20
> Still happens on 5.17-rc8, config attached.

I debugged that a bit further because the problem is in the way while
debugging another bug. What I learned is that without
CONFIG_DEBUG_BUG_VERBOSE a BUG results in hitting an undefined
instruction e7f001f2 on ARM.

After enabling CONFIG_DEBUG_BUG_VERBOSE this gets much more helpful:

[    1.630337] kernel BUG at crypto/algapi.c:461!

Digging a bit deeper the problem is that simd_skcipher_create_compat()
fails for aes_algs[1] in arch/arm/crypto/aes-neonbs-glue.c with -ENOENT
and then aes_exit -> simd_skcipher_free -> crypto_unregister_skcipher ->
crypto_unregister_alg stumbles over refcount_read(&alg->cra_refcnt)
being 2. Is this enough to understand the actual problem?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--xg3yruzcshbn6abc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmIyWi4ACgkQwfwUeK3K
7And/Af+I6LcoYaManGsaqRlBLHG5kHAPjyg2Zc8IOLjhw6QmjL8Kjf5fsXQjLMi
PO8/5S5VmlVXg1qPiULAdIJaohoZTbhfwXfGx/zg2kUXgC5uw+8TtqH/3nTEyePe
HOChzjOuBT4v4WZP5blpEUHCgZeEBdBCZp1YNXZXpiyVEliw3Oy6JLBXwYYxBQCH
XOXoMMEmzqxFXGlFtj7A7gBiRAshMDBgSXRmery0CchExdzFmphtH7Rj5Qf2YeYq
UwkoeI0wb1wvcj/b00xJJ9PBWbomnRL04JYS27ksLHUUmwsglAv/WESDetLZt46P
f/ZcS77ckjjJFOUypkIRbBkCxbFHAA==
=6LUO
-----END PGP SIGNATURE-----

--xg3yruzcshbn6abc--
