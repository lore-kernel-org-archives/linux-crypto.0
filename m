Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 010A7C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 16:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC626221E2
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 16:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbgLWQBp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 11:01:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:58788 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgLWQBp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 11:01:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 43A63ACF1;
        Wed, 23 Dec 2020 16:01:02 +0000 (UTC)
Date:   Wed, 23 Dec 2020 17:00:57 +0100
From:   Petr Tesarik <ptesarik@suse.cz>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Torsten Duwe <duwe@lst.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephan =?UTF-8?B?TcO8bGxlcg==?= <smueller@chronox.de>,
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
Message-ID: <20201223170057.7c8fd710@ezekiel.suse.cz>
In-Reply-To: <CAHmME9ooV1HRGO4bLsNKqv1EjDsUYsM6TcMbmEL=4CejTB+1ZQ@mail.gmail.com>
References: <20201130151231.GA24862@lst.de>
        <CAHmME9p4vFGWh7+CKF4f3dw5r+ru5PVG0-vP77JowX8sPhin1g@mail.gmail.com>
        <20201130165339.GE5364@mit.edu>
        <CAHmME9pksS8ec17RAwCNJimt4B0xZgd3qYHUPnaT4Bj4CF7n0A@mail.gmail.com>
        <20201218132519.kj3nz7swsx7vvlr5@valinor.lan>
        <20201223132851.55d19271@blackhole.lan>
        <20201223151014.57caf98b@ezekiel.suse.cz>
        <CAHmME9ooV1HRGO4bLsNKqv1EjDsUYsM6TcMbmEL=4CejTB+1ZQ@mail.gmail.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Z+YdJ+mMHvgvuEAz.pJLK3V";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--Sig_/Z+YdJ+mMHvgvuEAz.pJLK3V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Dec 2020 15:32:55 +0100
"Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> On Wed, Dec 23, 2020 at 3:17 PM Petr Tesarik <ptesarik@suse.cz> wrote:
> > Upfront, let me admit that SUSE has a vested interest in a FIPS-certifi=
able Linux kernel. =20
>=20
> Sorry, but just because you have a "vested interest", or a financial
> interest, or because you want it does not suddenly make it a good
> idea. The idea is to have good crypto, not to merely check some boxes

I never suggested that this should serve as a supportive argument. I was ju=
st trying to be honest about our motivations.

I'm a bit sad that this discussion has quickly gone back to the choice of a=
lgorithms and how they can be implemented. The real issue is that the RNG s=
ubsystem has not developed as fast as it could. This had not been much of a=
n issue as long as nobody was really interested in making any substantial c=
hanges to that code, but it is more apparent now. Torsten believes it can b=
e partly because of a maintainer who is too busy with other tasks, and he s=
uggested we try to improve the situation by giving the RNG-related tasks to=
 someone else.

I have not seen a clear answer to this suggestion, except Jason offering hi=
s helping hand with Nicolai's cleanup patches, but nothing wrt Stephan's pa=
tches. So, what is the plan?

Petr Tesarik
SUSE HW Enablement Team

--Sig_/Z+YdJ+mMHvgvuEAz.pJLK3V
Content-Type: application/pgp-signature
Content-Description: Digitální podpis OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHl2YIZkIo5VO2MxYqlA7ya4PR6cFAl/jabkACgkQqlA7ya4P
R6cEBgf+PcUW8Z/pkOT7Dc2JOAZJ5iMJXmOEGKLvG42J6pZ5P7f00bw7KP8fCBty
H56op4nW/kpSJ57neekDzz0w84iaQwtSNCgBvpaDWayIXurrEcPNzpQknLSR8NHX
qVfwQO6lLmYRJPHMcVHdiwDAD50mBzVpNuCCfJjQNVeVJXT5Qcq0H0cvj9WtU7HP
IxxnEZmC++fukffpZvW3E4cBntb6BPTT3nVtQwKHcUPLgSNsnojKhCPYIxse8Tzz
vum5nMTlhNhxnHkcblfqnk0Cnp9eS2eM6OeYlNQ+4LK1gF0ZcBvjBNCeoLw/5Nbx
/1rXFSsJ8UsuJ9Wh1e0paTx8iyeVpA==
=Sd6I
-----END PGP SIGNATURE-----

--Sig_/Z+YdJ+mMHvgvuEAz.pJLK3V--
