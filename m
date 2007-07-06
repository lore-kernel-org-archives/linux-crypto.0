From: Michael Halcrow <mike@halcrow.us>
Subject: Re: RSA support into kernel?
Date: Fri, 6 Jul 2007 10:41:17 -0500
Message-ID: <20070706154117.GI23191@halcrow.us>
References: <20070706.040533.30182871.davem@davemloft.net> <E1I6ncC-0007e3-00@gondolin.me.apana.org.au> <20070706133636.GH23191@halcrow.us> <f8b2ccd40707060741o82b4d53va3881eae7450366@mail.gmail.com>
Reply-To: Michael Halcrow <mike@halcrow.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="yzvKDKJiLNESc64M"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>, johnpol@2ka.mipt.ru,
	linux-crypto@vger.kernel.org
To: Gautam Singaraju <gautam.singaraju@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:58217 "EHLO
	nlpi015.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762250AbXGFQqQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jul 2007 12:46:16 -0400
Content-Disposition: inline
In-Reply-To: <f8b2ccd40707060741o82b4d53va3881eae7450366@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--yzvKDKJiLNESc64M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 06, 2007 at 07:41:18AM -0700, Gautam Singaraju wrote:
> I am considering RSA as an option for research purposes; though I
> need it only for decryption purposes. Any specific reason for
> running the daemon in user space?

That's where RSA is.

Mike
=2E___________________________________________________________________.
                         Michael A. Halcrow                         =20
       Security Software Engineer, IBM Linux Technology Center      =20
GnuPG Fingerprint: 419C 5B1E 948A FA73 A54C  20F5 DB40 8531 6DCA 8769

panic: kernel trap (ignored)

--yzvKDKJiLNESc64M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iQEVAwUBRo5inNtAhTFtyodpAQNlCQf8Ddk3dymDPMPoVDJHR78KcJ4eSZD0NbDV
Lwlwp54262mYNAfALCrs/t/CcUaJOWl3Zr0zPkWehu73HEsvbUZqVV2swyrgIFZY
kwELd/wA1ii5HJRhzZ9GcL9dJeUQb58aXoepZKmDcjTDjgXFYxSKWRm29h+zj9o0
z/WwqF5Fzj/YDtTHaCJhSticRaeZvXpPkIjQy4JZoOt1nNagU0dPD7GxZpoRva1k
0EfRtV97xJEt3eYguBiAx9sb9ndJ5ndpYUZxI4a/NMhdO1s8w2T0fP2yfr6KX0YJ
5Io4itFZl3S5m9ZdmI8VAFHI13oJEtP/EuqC3VqaP8V4MdtS+MMsWA==
=ckOc
-----END PGP SIGNATURE-----

--yzvKDKJiLNESc64M--
