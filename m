From: Michael Halcrow <mike@halcrow.us>
Subject: Re: RSA support into kernel?
Date: Fri, 6 Jul 2007 08:36:37 -0500
Message-ID: <20070706133636.GH23191@halcrow.us>
References: <20070706.040533.30182871.davem@davemloft.net> <E1I6ncC-0007e3-00@gondolin.me.apana.org.au>
Reply-To: Michael Halcrow <mike@halcrow.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="o71xDhNo7p97+qVi"
Cc: David Miller <davem@davemloft.net>, johnpol@2ka.mipt.ru,
	gautam.singaraju@gmail.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:44904 "EHLO
	nlpi001.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbXGFNus (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jul 2007 09:50:48 -0400
Content-Disposition: inline
In-Reply-To: <E1I6ncC-0007e3-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--o71xDhNo7p97+qVi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 06, 2007 at 09:12:52PM +0800, Herbert Xu wrote:
> So far the only proposed user for RSA in-kernel seems to be module
> signing and I'm staying well away from that debate :)

eCryptfs uses RSA.

Right now it has to defer to a userspace daemon to perform the
operation.

Mike
=2E___________________________________________________________________.
                         Michael A. Halcrow                         =20
       Security Software Engineer, IBM Linux Technology Center      =20
GnuPG Fingerprint: 419C 5B1E 948A FA73 A54C  20F5 DB40 8531 6DCA 8769

"This is about humans being human."                                 =20
 - Carl Sagan=20

--o71xDhNo7p97+qVi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iQEVAwUBRo5FZNtAhTFtyodpAQO9jAgAmCPiGap1u/Qd5Zogb/hxtpoNF8/7Vx+z
FWnIbzI9jK8g1PBxXGkYVASQ/rPbT/yhX3Zg53jrJm+8RqDAQDY/Ca1qAUvDtD57
R5Mo/eSSlwuvAMVsLFDYYINeER3fpIX7wdrwB5VTN6YKz9eJFhsNqMUSQ8mCSbbV
qEzFUq8EdcYsaxSZ56uIXSSphneKXIDAzWCu5hjbLtr71WSkvXKe4kVZKElb1LrB
SGxxPajTCnjuw1z9VL5Tp2pOfyX3pWRSnoiCxUjwl2Aco0hu+Nl+0X2qsVkkmBSx
0MoeTrZ+FAY0QBDlPbtR6N5kD4NvV94WXnfQPi5DC66730nwLufk4Q==
=4vHb
-----END PGP SIGNATURE-----

--o71xDhNo7p97+qVi--
