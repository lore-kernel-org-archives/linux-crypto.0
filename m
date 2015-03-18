From: mancha <mancha1@zoho.com>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Wed, 18 Mar 2015 19:09:05 +0000
Message-ID: <20150318190905.GA25129@zoho.com>
References: <20150318095345.GA12923@zoho.com>
 <550972A7.9030100@iogearbox.net>
 <1426691374.2212055.242060697.4DDF89CA@webmail.messagingengine.com>
 <4937031.1sk5yglzr8@tauon>
 <20150318171402.GB24195@zoho.com>
 <5509BAC3.6090201@iogearbox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Cc: Stephan Mueller <smueller@chronox.de>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	dborkman@redhat.com, cesarb@cesarb.eti.br
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5509BAC3.6090201@iogearbox.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 18, 2015 at 06:49:55PM +0100, Daniel Borkmann wrote:
> On 03/18/2015 06:14 PM, mancha wrote:
> ...
> >Patch 0001 fixes the dead store issue in memzero_explicit().
>=20
> Thanks! I have issued the fix for the memzero bug to Herbert in
> your authorship as discussed, also giving some more context.
>=20
> For the 2nd issue, lets wait for Cesar.
>=20
> Thanks again!

Excellent!=20

Cheers.

--mancha

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVCc1RAAoJEB4VYy8JqhaDY9AP/2ruLd646gRu9ase7S8ziuew
Q6t0FpWbuaJxAzjVwNgOZ6u9+gzG2SbcQ0OKSjGebzBAmddQhCkkT3XRzzN3J0Zc
x7k0IpzjX6FkKIa54nbUkZ8uROREA+oUMNQ/1+8fwK9lKuJZJnLlvBjK7Yk0IUMt
x5Hn3fh5j9qNukOzi1tXear9tXD5vu3OL5+bTSUrnXawcEGrOhR1Cse6+YRjzKCe
kohb5p8pHg0AaNEUm7H2x7JRPZha/M12JFcd7pdiHPeqa5PpMAGR4Q8I3R1zNIy2
U24In371t5TZufUFyiaTfXXe0Uy0S5U7wPJs/xnpcYwpN9lmCYDonDEg8fqa2mzu
8tlO5V4hkPYQpeHCzImZDeyXIbmmfPiA1ZEcDbkczGcM2eRdWEQNSQ8kQZ8jQ/VW
3J0hsZ8E0g8XZLdXgkcLx5R/qMH+54mFN71Num6DHNiPHiEZGIi6ssgfeiQkQOxP
VpIVfSun2t4wiSoa8eqoSupUR6NJ80g7GTcSqRAlA45IEJMlT5DgrUPHXzagWUeu
dOAH0q/T5xiNV9ZNdxk1JhKRvDaR2lnVF8QKoVx9ZklGHeW0jD7BnX8bZ/OyiXZQ
3XQXqDBkU71JEZiRFR7/puoGA5ZmaX8+TLfbvifZ80/4jaobodUTTpP56Ey4zCTQ
oaBu3xtC8Jiw/Tp0xJ9a
=wmcJ
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
