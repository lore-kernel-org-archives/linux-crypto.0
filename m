From: mancha security <mancha1@zoho.com>
Subject: Re: [PATCH crypto-2.6] lib: make memzero_explicit more robust
 against dead store elimination
Date: Wed, 29 Apr 2015 14:54:00 +0000
Message-ID: <20150429145400.GA12861@zoho.com>
References: <85dfdd23d98412a183546e2e7659a6a2bed1fca8.1430230786.git.daniel@iogearbox.net>
 <20150429130816.GA8526@zoho.com>
 <5540E42F.70607@iogearbox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Mark Charlebois <charlebm@gmail.com>,
	Behan Webster <behanw@converseincode.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sender1.zohomail.com ([74.201.84.155]:35582 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423009AbbD2Oyk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Apr 2015 10:54:40 -0400
Content-Disposition: inline
In-Reply-To: <5540E42F.70607@iogearbox.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2015 at 04:01:19PM +0200, Daniel Borkmann wrote:
> On 04/29/2015 03:08 PM, mancha security wrote:
> ...
> >By the way, has anyone been able to verify that __memory_barrier
> >provides DSE protection under various optimizations? Unfortunately, I
> >don't have ready access to ICC at the moment or I'd test it myself.
>=20
> Never used icc, but it looks like it's free for open source projects;
> I can give it a try, but in case you're faster than I am, feel free
> to post results here.

Time permitting, I'll try setting this up and post my results.

>=20
> From what I see based on the code, i.e. after that buggy cleanup
> commit ...
>=20
> commit 73679e50820123ebdedc67ebcda4562d1d6e4aba
> Author: Pranith Kumar <bobby.prani@gmail.com>
> Date:   Tue Apr 15 12:05:22 2014 -0400
>=20
>     compiler-intel.h: Remove duplicate definition
>=20
>     barrier is already defined as __memory_barrier in compiler.h
>     Remove this unnecessary redefinition.
>=20
>     Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>     Link: http://lkml.kernel.org/r/CAJhHMCAnYPy0%2BqD-1KBnJPLt3XgAjdR12j%=
2BySSnPgmZcpbE7HQ@mail.gmail.com
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>=20
> ... it looks like it's currently using the _same_ gcc inline asm
> for the barrier on icc instead of what that commit intended to do.
>=20
> So funny enough, we don't actually use __memory_barrier() at the
> moment. ;)
>=20
> Nonetheless, having a look might be good.

Nice catch, 73679e50820 is indeed buggy because ICC defines __GNUC__
(unless -no-gcc is used). That should be reverted.

Bug aside, according to [1], ICC does support GNU-style inline asm so
for the purposes of barrier_data(), it would be interesting to see if
it affords better/worse DSE protection compared to __memory_barrier().

--mancha

[1]
https://software.intel.com/sites/products/documentation/doclib/iss/2013/com=
piler/cpp-lin/GUID-5100C4FC-BC2F-4E36-943A-120CFFFB4285.htm


--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVQPCHAAoJEB4VYy8JqhaDymYP/jl1JXulbxsR3ndzyjpHDdAF
vpR6NHJ0FW33FqWM6O/TVvReBzblXYpTYuwNbHe/J28pQ7sxCixn9SFz5X3bVlI4
by1axVCumWTYA3v3LIq/EcCl5kkxaSskdTOvT7xmY4FUm5szb8c1EDEbnijmKKsg
fra0pJd1xrJr6jYRO/MYTtbmz6f30g1G68ocK/LUtrw12cjaCnmwh2ySZjHToa6A
Rb9rRWtRl+PC5aEUA6syaUlO9BCN1WIH5cjKuVwByK2c/BUAjHAy01P3qVCAlv3f
w/etFLOpNei4SBo7zdB/JJ/OUmzjJxDc6cu1qiWNhSYoR97g0pVsAlDa+zZdO7oy
kul9No5iAHspo/kjV0l3lpV43HdEpVAuHY4fQtL3JSkwUMjcjJGd3GvQNsAuhVQt
jqY3WBL6dze98Nf4t2ABnr9n2OneYM6L7U/rVu9UHZROCMcrL9EUA746gIE+m2rX
2DVcKACQ/7tp5rnve6+uVVszngiW+ef2c0wLsnpTGN9yrd8oRv1PX5B92fo9Wyoc
Lqr6AUX3tv5hgMfb3jVev8VUNNOkfSa+pmlR5t6dsJ3wEDOxGoSVnyqNSL6vxR+j
aQ9O3/4cS8Bp624IeFdFcctIJvM/yeUsQgwJxY0pTHJJwyR3tR4rGTv61vXv4GxZ
au1AKeWE01uHLBXgLT4r
=Dnhr
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
