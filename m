From: Valdis.Kletnieks@vt.edu
Subject: Re: Runaway loop with the current git.
Date: Sun, 07 Dec 2008 22:23:12 -0500
Message-ID: <34909.1228706592@turing-police.cc.vt.edu>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk> <20081207155507.GA15355@gondor.apana.org.au> <ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com> <20081207160921.693f637a@lxorguk.ukuu.org.uk> <20081207163151.GA31838@ioremap.net> <20081207170108.39dfd93f@lxorguk.ukuu.org.uk> <ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com> <20081207172855.55fee78f@lxorguk.ukuu.org.uk> <ac3eb2510812070939h17ef6316hea96fe89f01207a6@mail.gmail.com> <20081207175118.09c633e8@lxorguk.ukuu.org.uk>
            <ac3eb2510812071022le85080aiea301609fa8a50b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1228706592_4679P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Evgeniy Polyakov <zbr@ioremap.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41692 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbYLHDY1 (ORCPT
	<RFC822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 22:24:27 -0500
In-Reply-To: Your message of "Sun, 07 Dec 2008 19:22:41 +0100."
             <ac3eb2510812071022le85080aiea301609fa8a50b1@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--==_Exmh_1228706592_4679P
Content-Type: text/plain; charset=us-ascii

On Sun, 07 Dec 2008 19:22:41 +0100, Kay Sievers said:

> We are _not_ loading a console driver that way, we try to load the
> console device itself, not the driver. There is no driver for 5:1 in
> any module.

Semantic quibbling, trying to paper over stupidity.

It doesn't really matter if it's a "console driver" or "the console device
itself".  If you're in modprobe loading *any* piece of "all the stuff needed
to make open("/dev/console") work", the last thing you want to be doing
is opening /dev/console to complain about something not working.

As Alan said several times now, there really *is* a requirement that early
userspace has its act together.

--==_Exmh_1228706592_4679P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJPJMgcC3lWbTT17ARAj8ZAJ0aSsSs4GmyNUjCJjyefIvfpp2CRQCgzDnR
OZit34V9O9KpEAj/gpldVoE=
=WB9/
-----END PGP SIGNATURE-----

--==_Exmh_1228706592_4679P--
