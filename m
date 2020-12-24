Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B309C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Dec 2020 19:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C189224B1
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Dec 2020 19:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgLXTOt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Dec 2020 14:14:49 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:53336 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgLXTOt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Dec 2020 14:14:49 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C471D1C0BBC; Thu, 24 Dec 2020 20:14:04 +0100 (CET)
Date:   Thu, 24 Dec 2020 20:14:04 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Torsten Duwe <duwe@lst.de>
Cc:     Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Willy Tarreau <w@1wt.eu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        And y Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Petr Tesarik <ptesarik@suse.cz>, simo@redhat.com
Subject: Re: drivers/char/random.c needs a (new) maintainer
Message-ID: <20201224191404.GC22388@amd>
References: <20201130151231.GA24862@lst.de>
 <CAHmME9p4vFGWh7+CKF4f3dw5r+ru5PVG0-vP77JowX8sPhin1g@mail.gmail.com>
 <20201130165339.GE5364@mit.edu>
 <CAHmME9pksS8ec17RAwCNJimt4B0xZgd3qYHUPnaT4Bj4CF7n0A@mail.gmail.com>
 <20201218132519.kj3nz7swsx7vvlr5@valinor.lan>
 <20201223132851.55d19271@blackhole.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="L6iaP+gRLNZHKoI4"
Content-Disposition: inline
In-Reply-To: <20201223132851.55d19271@blackhole.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--L6iaP+gRLNZHKoI4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Any updates on that?
> >=20
> > I don't believe Torsten's concerns are simply about *applying* patches
> > but more about these long periods of radio silence. That kills
>=20
> Exactly. I could live with replies in the style of "old" Linus like:
> "Your code is crap, because it does X and Y". Then I knew how to
> proceed. But this extended silence slows things down a lot.

Well... you know. We now have code of conflict, so maintainers are not
supposed to tell submitters that their code is ****. So... you get
silence.
								Pavel
-- p
http://www.livejournal.com/~pavelmachek

--L6iaP+gRLNZHKoI4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/k6HwACgkQMOfwapXb+vKjKwCeLahvFkONH2dzKd2+FUqQrxp2
2n0AoJECF5MFsKgHxjma1T0j/jv8v9+2
=AiSD
-----END PGP SIGNATURE-----

--L6iaP+gRLNZHKoI4--
