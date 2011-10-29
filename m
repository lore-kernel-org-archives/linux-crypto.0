From: Valdis.Kletnieks@vt.edu
Subject: Re: linux-next: Tree for Oct 25 (crypto)
Date: Sat, 29 Oct 2011 19:20:27 -0400
Message-ID: <49073.1319930427@turing-police.cc.vt.edu>
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au> <4EA75759.3050900@xenotime.net> <20111026062717.GA10230@gondor.apana.org.au> <7836.1319699116@turing-police.cc.vt.edu>
            <20111027074544.GA19905@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1319930427_32791P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Linus <torvalds@linux-foundation.org>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:45999 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab1J2XVz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 29 Oct 2011 19:21:55 -0400
In-Reply-To: Your message of "Thu, 27 Oct 2011 09:45:44 +0200."
             <20111027074544.GA19905@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--==_Exmh_1319930427_32791P
Content-Type: text/plain; charset=us-ascii

On Thu, 27 Oct 2011 09:45:44 +0200, Herbert Xu said:
> On Thu, Oct 27, 2011 at 03:05:16AM -0400, Valdis.Kletnieks@vt.edu wrote:

> > Are there any use cases where a config (probably embedded) would wantq
> > CRYPTO_USER but not CRYPTO_NET?  Would seem a shame to pull in the entire
> 
> Since the CRYPTO_USER interface sits on top of netlink I don't
> see how you could possibly avoid NET.

Oh, OK.  The original bug report looked like just some utility functions not
defined, so I didn't pick up on the "it needs netlink" aspect of it.

--==_Exmh_1319930427_32791P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOrIo7cC3lWbTT17ARAqLTAJ4tO11YTXGnzUPMNF9qFITPhJwAvACgmV/x
UnTxPqqbZqAARe095NBobOc=
=XJkt
-----END PGP SIGNATURE-----

--==_Exmh_1319930427_32791P--
