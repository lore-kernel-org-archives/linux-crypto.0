Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18F9C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 18:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C24F261029
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 18:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242780AbhIWSxb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Sep 2021 14:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242811AbhIWSxb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Sep 2021 14:53:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373F6C061574
        for <linux-crypto@vger.kernel.org>; Thu, 23 Sep 2021 11:51:59 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mTTp1-0003IF-UK; Thu, 23 Sep 2021 20:51:51 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mTToo-0007OL-8G; Thu, 23 Sep 2021 20:51:38 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mTToo-0004PU-7E; Thu, 23 Sep 2021 20:51:38 +0200
Date:   Thu, 23 Sep 2021 20:51:34 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Olivia Mackall <olivia@selenic.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] MAINTAINERS: Remove Matt Mackall as his identity is
 obsolete
Message-ID: <20210923185134.vkokv3kglkjklkkf@pengutronix.de>
References: <20210920080635.253826-1-u.kleine-koenig@pengutronix.de>
 <CAMuHMdVAjtF2GKXgHgbmjUnMdWxqSpusKV_EieF2wEWezdqrPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7rnfxr5b22heuaq6"
Content-Disposition: inline
In-Reply-To: <CAMuHMdVAjtF2GKXgHgbmjUnMdWxqSpusKV_EieF2wEWezdqrPQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--7rnfxr5b22heuaq6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, Sep 20, 2021 at 03:01:25PM +0200, Geert Uytterhoeven wrote:
> On Mon, Sep 20, 2021 at 11:52 AM Uwe Kleine-K=F6nig
> <u.kleine-koenig@pengutronix.de> wrote:
> > The mails I sent to Matt on September 14 and 20 both were refused by the
> > MTA responsible for selenic.com (i.e. waste.org) with:
> >
> >         554 5.7.1 <mpm@selenic.com>: Recipient address rejected: This i=
dentity is obsolete
> >
> > Also the most recent commit that involved him (ignoring "Cc: Matt
> > Mackall <mpm@selenic.com>" footers) is commit 330e0a01d54c (MAINTAINERS:
> > Theodore Ts'o is taking over the random driver) where he was removed
> > from the entry for random number drivers in 2012.
> >
> > So drop him completely from the list of maintainers.
> >
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > ---
> >  MAINTAINERS | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index d7b4f32875a9..805630c67a1f 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -6812,7 +6812,6 @@ F:        drivers/media/usb/em28xx/
> >
> >  EMBEDDED LINUX
> >  M:     Paul Gortmaker <paul.gortmaker@windriver.com>
> > -M:     Matt Mackall <mpm@selenic.com>
>=20
> Perhaps this should be replaced by
> "Olivia Mackall <olivia@selenic.com>" instead?

I think we need some feedback from Olivia here? At least I don't know
more than I wrote in the commit log and so I'm not in a position to
decide anything here.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--7rnfxr5b22heuaq6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmFMzLMACgkQwfwUeK3K
7Ak2lAf+KpzyLszB2tlawn0Jr7OKP3tXXdSMb+HQPvRi6UMoYz7qM0PwaaSXmRWQ
qcbsWUYzZAa/wAldjrQ1vvNnn2AVn/nZ+nxc0zsC36TVPE/q54TxLzOlOhhaoyZS
zJ7UHyUQ3cv6Lpq7KJ9aM116CLieCa9rIkJHqweVfdZRw1vD8YpNOKfsE3cAXwLb
+8tnEYX4v9enVyiKysf5uYArrDV/ZjAF0fQDf66m/6fvGMpXhsvN5GAtGo2O1VhN
u+g48E8eP6YJjH5THkeororXKquoNRxZ6j48bfpy/Np4RkfGSlR+D1cVguuR/9o7
HDvT+ccdZ/ZQahwYy+q+BSj//DNQ6g==
=6qxm
-----END PGP SIGNATURE-----

--7rnfxr5b22heuaq6--
