Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDD8C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Dec 2020 19:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A956227BF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Dec 2020 19:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728805AbgLXTUf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Dec 2020 14:20:35 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:54624 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbgLXTUf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Dec 2020 14:20:35 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9192B1C0B9B; Thu, 24 Dec 2020 20:19:53 +0100 (CET)
Date:   Thu, 24 Dec 2020 20:19:53 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Petr Tesarik <ptesarik@suse.cz>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, Torsten Duwe <duwe@lst.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
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
        Ard Biesheuvel <ardb@kernel.org>, simo@redhat.com
Subject: Re: drivers/char/random.c needs a (new) maintainer
Message-ID: <20201224191953.GD22388@amd>
References: <20201130151231.GA24862@lst.de>
 <CAHmME9p4vFGWh7+CKF4f3dw5r+ru5PVG0-vP77JowX8sPhin1g@mail.gmail.com>
 <20201130165339.GE5364@mit.edu>
 <CAHmME9pksS8ec17RAwCNJimt4B0xZgd3qYHUPnaT4Bj4CF7n0A@mail.gmail.com>
 <20201218132519.kj3nz7swsx7vvlr5@valinor.lan>
 <20201223132851.55d19271@blackhole.lan>
 <20201223151014.57caf98b@ezekiel.suse.cz>
 <CAHmME9ooV1HRGO4bLsNKqv1EjDsUYsM6TcMbmEL=4CejTB+1ZQ@mail.gmail.com>
 <20201223170057.7c8fd710@ezekiel.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KdquIMZPjGJQvRdI"
Content-Disposition: inline
In-Reply-To: <20201223170057.7c8fd710@ezekiel.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--KdquIMZPjGJQvRdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > On Wed, Dec 23, 2020 at 3:17 PM Petr Tesarik <ptesarik@suse.cz> wrote:
> > > Upfront, let me admit that SUSE has a vested interest in a FIPS-certi=
fiable Linux kernel. =20
> >=20
> > Sorry, but just because you have a "vested interest", or a financial
> > interest, or because you want it does not suddenly make it a good
> > idea. The idea is to have good crypto, not to merely check some boxes
>=20
> I never suggested that this should serve as a supportive argument. I was =
just trying to be honest about our motivations.
>=20
> I'm a bit sad that this discussion has quickly gone back to the choice of=
 algorithms and how they can be implemented. The real issue is that the RNG=
 subsystem has not developed as fast as it could. This had not been much of=
 an issue as long as nobody was really interested in making any substantial=
 changes to that code, but it is more apparent now. Torsten believes it can=
 be partly because of a maintainer who is too busy with other tasks, and he=
 suggested we try to improve the situation by giving the RNG-related tasks =
to someone else.
>

(Please wrap at 80 columns).

To play devil's advocate, does RNG subsystem need to evolve? Its task
is to get random numbers. Does it fail at the task?

Problem is, random subsystem is hard to verify, and big rewrite is
likely to cause security problems...=20

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--KdquIMZPjGJQvRdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/k6dgACgkQMOfwapXb+vKu7wCeLUlepOplD8RS0tg/IjNLo/ap
jMwAoLh7hnX+vaJNu/JeKDc4R2QoO4K7
=Lwnx
-----END PGP SIGNATURE-----

--KdquIMZPjGJQvRdI--
