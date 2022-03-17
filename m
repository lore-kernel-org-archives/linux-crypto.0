Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3DAC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Mar 2022 07:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiCQHNU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 03:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiCQHNS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 03:13:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066C116A6BB
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 00:12:00 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nUkIe-000655-TI; Thu, 17 Mar 2022 08:11:56 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nUkIc-001Ca4-6m; Thu, 17 Mar 2022 08:11:52 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nUkIZ-009iQ3-LV; Thu, 17 Mar 2022 08:11:51 +0100
Date:   Thu, 17 Mar 2022 08:11:51 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Simo Sorce <ssorce@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kernel@pengutronix.de, Ard Biesheuvel <ardb@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Vladis Dronov <vdronov@redhat.com>
Subject: Re: [PATCH] crypto: arm/aes-neonbs-cbc - Select generic cbc and aes
Message-ID: <20220317071151.ekr757ggancxp7wj@pengutronix.de>
References: <20210917002619.GA6407@gondor.apana.org.au>
 <20211026163319.GA2785420@roeck-us.net>
 <20211106034725.GA18680@gondor.apana.org.au>
 <729fc135-8e55-fd4f-707a-60b9a222ab97@roeck-us.net>
 <20211222102246.qibf7v2q4atl6gc6@pengutronix.de>
 <YcvCglFcJEA87KNN@gondor.apana.org.au>
 <20211229110523.rsbzlkpjzwmqyvfs@pengutronix.de>
 <YjE5Ed5e1jjFFVn3@gondor.apana.org.au>
 <20220316163719.ud2s36e5zwmtmzef@pengutronix.de>
 <YjJq0RLIHvN7YWaT@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rriz7ajmd4ine7ee"
Content-Disposition: inline
In-Reply-To: <YjJq0RLIHvN7YWaT@gondor.apana.org.au>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--rriz7ajmd4ine7ee
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Herbert,

On Thu, Mar 17, 2022 at 10:55:13AM +1200, Herbert Xu wrote:
> On Wed, Mar 16, 2022 at 05:37:19PM +0100, Uwe Kleine-K=F6nig wrote:
> >
> > # CONFIG_CRYPTO_CBC is not set
>=20
> This was the issue.  The failure occurs on registering __cbc_aes
> and the reason is that the neonbs cbc-aes requirs a fallback which
> isn't available due to CBC being disabled.
>=20
> I have no idea why this started occurring only with the testmgr
> change though as this should have been fatal all along.

Yesterday I wondered about that, too. I didn't check, but I guess
00b99ad2bac2 was introduced between the testmgr regression and its fix
and the failure looks similar enough for me to not having noticed the
difference? Or my config somehow changed somewhere there (though I used
the same defconfig in each bisection step).

> ---8<---
> The algorithm __cbc-aes-neonbs requires a fallback so we need
> to select the config options for them or otherwise it will fail
> to register on boot-up.
>=20
> Fixes: 00b99ad2bac2 ("crypto: arm/aes-neonbs - Use generic cbc...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>=20
> diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
> index 2b575792363e..e4dba5461cb3 100644
> --- a/arch/arm/crypto/Kconfig
> +++ b/arch/arm/crypto/Kconfig
> @@ -102,6 +102,8 @@ config CRYPTO_AES_ARM_BS
>  	depends on KERNEL_MODE_NEON
>  	select CRYPTO_SKCIPHER
>  	select CRYPTO_LIB_AES
> +	select CRYPTO_AES
> +	select CRYPTO_CBC
>  	select CRYPTO_SIMD
>  	help
>  	  Use a faster and more secure NEON based implementation of AES in CBC,

I tested your change and that indeed fixes booting for me. Thanks!
However I think there are two problems involved here, and you only fix
one of them with your patch.  Your change makes
simd_skcipher_create_compat() succeed, but aes_init() still has a broken
error handling. So if I do

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs=
-glue.c
index 5c6cd3c63cbc..ee9812ee33b7 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -546,6 +546,11 @@ static int __init aes_init(void)
 		algname =3D aes_algs[i].base.cra_name + 2;
 		drvname =3D aes_algs[i].base.cra_driver_name + 2;
 		basename =3D aes_algs[i].base.cra_driver_name;
+		if (i =3D=3D 1) {
+			/* simulate a problem to test the error path */
+			err =3D -ENOENT;
+			goto unregister_simds;
+		}
 		simd =3D simd_skcipher_create_compat(algname, drvname, basename);
 		err =3D PTR_ERR(simd);
 		if (IS_ERR(simd))

the BUG is back.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--rriz7ajmd4ine7ee
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmIy3zQACgkQwfwUeK3K
7An5kQf9FOHl+DOc2LXwu+fDudp/+3Na6sDMFto7xhJSyiNkSs7G9+DFtHnPRtEf
mpvAQ5ilzCOPAO5v5RAFr1HS/I2iYWNHF1nhefEISjT1O19B+7ZP1i/JsJB4D4j4
DjceH1P6HPleuZIYUpRuufUz6/+AcqDPCndhVpAqMHPbWg0WPQnp37AwJUZiGTKw
p9MLgSRYmxqtGSMRarW/btAv6DzYMwoT4qKCWonIG5NksY010ZcGSwYQURdiJpWg
2pRk7fxvkiSyYskZ6m7rU5RHRef6TJxhC+6K0k3XWz7ApaM2/k84fgR6YXIhEHvZ
oHe7ioM9RmaupjJE90VZwfv1ZJsTLA==
=U+SI
-----END PGP SIGNATURE-----

--rriz7ajmd4ine7ee--
