Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A038C001DE
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Aug 2023 10:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbjHIK6e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Aug 2023 06:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbjHIK6e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Aug 2023 06:58:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFAE1736
        for <linux-crypto@vger.kernel.org>; Wed,  9 Aug 2023 03:58:33 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qTgtW-0006mz-0e; Wed, 09 Aug 2023 12:58:26 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qTgtQ-002Btt-Vi; Wed, 09 Aug 2023 12:58:20 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qTgtQ-00Benj-6W; Wed, 09 Aug 2023 12:58:20 +0200
Date:   Wed, 9 Aug 2023 12:58:20 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Thomas BOURGOIN <thomas.bourgoin@foss.st.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        kernel@pengutronix.de, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH 1/3] crypto: stm32/hash - Properly handle pm_runtime_get
 failing
Message-ID: <20230809105820.5yp3jzv4spe47qb4@pengutronix.de>
References: <20230731165456.799784-1-u.kleine-koenig@pengutronix.de>
 <20230731165456.799784-2-u.kleine-koenig@pengutronix.de>
 <f9ddac2f-28c0-1804-a1de-b8c8e9972638@foss.st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qnbrkttfbi4cwbot"
Content-Disposition: inline
In-Reply-To: <f9ddac2f-28c0-1804-a1de-b8c8e9972638@foss.st.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--qnbrkttfbi4cwbot
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Wed, Aug 09, 2023 at 09:44:30AM +0200, Thomas BOURGOIN wrote:
> Thanks for the modification.
> This should be applied for fixes/stable.
> Please add Cc: stable@vger.kernel.org in your commit message.

I usually let maintainers decide if they want this Cc line and in
practise the Fixes: line seems to be enough for the stable team to pick
up a commit for backporting.

If your mail means I should resend the patch just to add the Cc: line,
please tell me again. Should I resent patches 2 and 3 then, too?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--qnbrkttfbi4cwbot
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmTTcUsACgkQj4D7WH0S
/k4PvAf+NtyM4693UO7qpqnYA6x60QAg/Awzi4N9QfoT8iWI23vi8dSDyXDE5+iy
ReRoSY5fCiP+cJA7NBIx/Vnt7PRvfwXHYqNffsXFkhc9fg4cOZ4iAKtohB5ZkxXz
+YknmR6hUmJVfSvKOacTAGVWCt7axVXCBO2srn+QAN2QdYB8e1zSLE9Eb9jtIMq8
tm/akmS6Wqx1qcba2lrVtLmnSbp9leBtCWX9A8nZzHKD/mTjsAiASu4mvL2iLiPa
eJNSmmklJ2/nRFty2vRA46dNQaGEdbvRFqHeyKlsmh39MBQqUK4s8RgVziNzAUa+
ixIGXyq03yhMu2e3EOpTuV+yw1713Q==
=eSvF
-----END PGP SIGNATURE-----

--qnbrkttfbi4cwbot--
