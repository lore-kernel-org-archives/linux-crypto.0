Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E044DC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Dec 2021 10:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244207AbhLVKh7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Dec 2021 05:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236568AbhLVKh7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Dec 2021 05:37:59 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7173C061574
        for <linux-crypto@vger.kernel.org>; Wed, 22 Dec 2021 02:37:58 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mzz0M-0006MJ-Ox; Wed, 22 Dec 2021 11:37:54 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1mzz0M-005zAG-4F; Wed, 22 Dec 2021 11:37:53 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mzz0L-000531-6s; Wed, 22 Dec 2021 11:37:53 +0100
Date:   Wed, 22 Dec 2021 11:37:39 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>, kernel@pengutronix.de
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <20211222103739.udxraiiklz6giolt@pengutronix.de>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <20211026163319.GA2785420@roeck-us.net>
 <20211106034725.GA18680@gondor.apana.org.au>
 <729fc135-8e55-fd4f-707a-60b9a222ab97@roeck-us.net>
 <20211222102246.qibf7v2q4atl6gc6@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="42ytetziqhc4fssi"
Content-Disposition: inline
In-Reply-To: <20211222102246.qibf7v2q4atl6gc6@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--42ytetziqhc4fssi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello again,

I mistyped an address in my report's Cc: list. If you respond please
s/xx/x/. My keyboard's x key sometimes gerates two x :-\

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--42ytetziqhc4fssi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHC/+wACgkQwfwUeK3K
7AncBQf/ebajVEYIAmZPRZ2DBY3B7rzZtGr42yIkRUmMOWISgdlkibOVNcfE87Md
0E0Bij5Q8BaKwXhq367FJJMk24D3y1IhQ+iLfnCNys7SURL1a3VMQnZATOGomyMy
gfiLUsTP3v+7bZks30Sd+2odnUJYXPN35P6RFvvPJjpDzBkkeamAZ/I4Qa3OAPPr
biKgHi4MkfWIcoTgB+wm41D9elrRQ3zPG+5b+/X9+qf1Ov2uISt2e+t/DngAPsXM
v5eBmVJuuSMBpHioyGoeCXkRUG8LAiIrENE6qcOrOdAxL/3oUwKF592wWiA78qDP
PON8lbK0YUBIUjwmmwAO39icrQrXHA==
=umwu
-----END PGP SIGNATURE-----

--42ytetziqhc4fssi--
