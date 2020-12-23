Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47868C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 14:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 254C523329
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 14:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgLWOLI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 09:11:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:36218 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728650AbgLWOLH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 09:11:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 26C84ACBA;
        Wed, 23 Dec 2020 14:10:25 +0000 (UTC)
Date:   Wed, 23 Dec 2020 15:10:14 +0100
From:   Petr Tesarik <ptesarik@suse.cz>
To:     Torsten Duwe <duwe@lst.de>
Cc:     Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
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
Message-ID: <20201223151014.57caf98b@ezekiel.suse.cz>
In-Reply-To: <20201223132851.55d19271@blackhole.lan>
References: <20201130151231.GA24862@lst.de>
 <CAHmME9p4vFGWh7+CKF4f3dw5r+ru5PVG0-vP77JowX8sPhin1g@mail.gmail.com>
 <20201130165339.GE5364@mit.edu>
 <CAHmME9pksS8ec17RAwCNJimt4B0xZgd3qYHUPnaT4Bj4CF7n0A@mail.gmail.com>
 <20201218132519.kj3nz7swsx7vvlr5@valinor.lan>
 <20201223132851.55d19271@blackhole.lan>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_IUhqCg4NMQQz6WMa=7Sj.s";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--Sig_/_IUhqCg4NMQQz6WMa=7Sj.s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Dec 2020 13:28:51 +0100
Torsten Duwe <duwe@lst.de> wrote:

>[...]
> > collaboration and disengage people. More than simply reviewing patches
> > I would expect a maintainer to give directions and drive the
> > community. Asking Jason to review Nicolai's patches was a step towards
> > that, but I believe we still could benefit from better communication. =
=20
>=20
> Even regarding this I'm not so sure it was a good idea. Jason seems to
> narrow the proposed changes down to "FIPS certification", when it
> actually is a lot more. I think his motivation suffers because of his
> personal dislike.

Upfront, let me admit that SUSE has a vested interest in a FIPS-certifiable=
 Linux kernel.

However, it seems to me that nobody can be happy about keeping the current =
status quo forever. Even in the hypothetical case that the RNG maintainer r=
ejected the whole idea merely because it makes it possible to achieve NIST =
compliance, and he detests standards compliance, it would still be better t=
han no decision at all. The silence is paralyzing, as it blocks any changes=
 in upstream, while also making it difficult to maintain an out-of-tree imp=
lementation that aims at becoming upstream eventually.

The only option ATM is a fork (similar to what the Xen folks did with XenLi=
nux many years ago). IOW the current situation demotivates contributors fro=
m being good citizens. I hope we can find a better solution together.

Petr Tesarik
SUSE HW Enablement Team

--Sig_/_IUhqCg4NMQQz6WMa=7Sj.s
Content-Type: application/pgp-signature
Content-Description: Digitální podpis OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHl2YIZkIo5VO2MxYqlA7ya4PR6cFAl/jT8YACgkQqlA7ya4P
R6eokwgAj+Mbln2v2lOrPiQVcRJ7E8KJyKJJcaHIL49im6+0qt+RM8prwb+ofsMT
VbqnllCxKUJhzOauxAWIMMFmE/1pWO1CGzvOdVzC0wRIYaLQ/n/emkFvkZfgy+Oe
4oG7NPG6/KZsEe54grkNE5MH6pYDkmpKGc3KHP98eGZ89UBIzNTTX4IVTtyjOjVN
PS9LSn4wPQHwMMxTUrL5geSy3VKnc8XelWBKk2QswnXGDgTdTE48ZBlU9/GZ2zLQ
dHSQSiD0WOTavcYh6D2BzypV+JnoOr49B1ZCTAjLRU02LZUqJCLKErC9YkXo9fu6
+y/zbi0ICYuMf4p343iugPDrkrWJ3w==
=FT6Z
-----END PGP SIGNATURE-----

--Sig_/_IUhqCg4NMQQz6WMa=7Sj.s--
