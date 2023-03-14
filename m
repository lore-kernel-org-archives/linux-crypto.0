Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF0CC6FD1F
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Mar 2023 09:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjCNJEU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Mar 2023 05:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjCNJET (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Mar 2023 05:04:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEEF53D98
        for <linux-crypto@vger.kernel.org>; Tue, 14 Mar 2023 02:04:17 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pc0Zp-00028X-Et; Tue, 14 Mar 2023 10:04:13 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pc0Zm-0042Qk-01; Tue, 14 Mar 2023 10:04:10 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pc0Zl-004mGh-6q; Tue, 14 Mar 2023 10:04:09 +0100
Date:   Tue, 14 Mar 2023 10:04:09 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 3/3] hwrng: xgene - Improve error reporting for problems
 during .remove()
Message-ID: <20230314090409.pwcveukfk55z2cuk@pengutronix.de>
References: <20230214162829.113148-1-u.kleine-koenig@pengutronix.de>
 <20230214162829.113148-4-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="peai7gxfisy2rzgi"
Content-Disposition: inline
In-Reply-To: <20230214162829.113148-4-u.kleine-koenig@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--peai7gxfisy2rzgi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, Feb 14, 2023 at 05:28:29PM +0100, Uwe Kleine-K=F6nig wrote:
> Returning an error value in a platform driver's remove callback results in
> a generic error message being emitted by the driver core, but otherwise it
> doesn't make a difference. The device goes away anyhow.
>=20
> As the driver already emits a better error message than the core, suppress
> the generic error message by returning zero unconditionally.

I forgot to add a S-o-b line here. Stephen Rothwell pointed that out for
the applied patch in next.

I don't know how/if Herbert will fix this, but for the Record:

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--peai7gxfisy2rzgi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmQQOIUACgkQwfwUeK3K
7An9cgf/Ru9/qmysAyhIjHi+x61DNqz574oRDN4ae4AX4JjS0nbD11S7vOU/2QIY
5zWFPeYQiTkVhkBPrDBWdse6erElsTaAYeN6OHkfMdFOftGC3fvhvGXLqR84Lf6h
DIbYxI3uXfkvB2n9clfwbJw3Y8CTsexc00KOyMi2d5ZPU+fjgWYd65F53mcmx0sV
FDfyqrW9+jszLRHsISWCxT5dS55G5BxNUaiM9EsRr0E8ZhuhrB4sQgGQxMV8iMff
NSJ/lmj1Qo8dO6eq1xOz9Arrdm1aZ3E5x43AxeVTeXgYe/0oaqruhd6w1RuOorJ+
NaQOf5qV311gV4A/0dOcYpL44xeexA==
=44z9
-----END PGP SIGNATURE-----

--peai7gxfisy2rzgi--
