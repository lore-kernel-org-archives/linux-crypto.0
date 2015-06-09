From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] crypto: drbg - use pragmas for disabling optimization
Date: Tue, 9 Jun 2015 13:22:58 +1000
Message-ID: <20150609132258.26f6b108@canb.auug.org.au>
References: <3181127.KGS6GDHCq6@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/l2q7TJoL1q4vS+nB_0gT27f"; protocol="application/pgp-signature"
Cc: herbert@gondor.apana.org.au,
	Peter Zijlstra
	<public-peterz-wegcikhe2lqwvfeawa7xhq@plane.gmane.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Linux-Next <linux-next@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
	Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <3181127.KGS6GDHCq6@tachyon.chronox.de>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Sig_/l2q7TJoL1q4vS+nB_0gT27f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Stephan,

On Tue, 09 Jun 2015 04:08:49 +0200 Stephan Mueller <smueller@chronox.de> wr=
ote:
>
> Replace the global -O0 compiler flag from the Makefile with GCC
> pragmas to mark only the functions required to be compiled without
> optimizations.
>=20
> This patch also adds a comment describing the rationale for the
> functions chosen to be compiled without optimizations.
>=20
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

I will add this as a fix patch to the crypto tree merge today (unless
someone yells at me).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/l2q7TJoL1q4vS+nB_0gT27f
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVdlwXAAoJEMDTa8Ir7ZwVD+AP/1lO++xTQsvNYmgKcqX8mL+I
/+RCH07+KtNbellYu+jax1FT2zxa0MOQJCXbI7VT5qPwsds5fPAJV2pKzUnvSolk
xOHflZ6UAAIcDvhuCVepk03vGll0BnIjFSk6wJvqJSpJLh9WUX/tYAyHIqx3g2OM
XDuWorLqy5Jp9oTQc8n0oRvRObmEnjHkYXKYWQ3PHmkbY5mov+IEWQMI2wxH0SSA
9/o3iXinkbxxSDjU8VewMQF2hx5KQ1dAoTPfeXYx6waA5nzZzpZ6hzMzjQmYiipu
6uKSEU+E6DTaO3DhwZvL/rKy1JxfkoHdiNm3uVF4mxeIBo8FF7gdm/2fBfv4jySR
E+2h8vGMsIlKstR9ADUNrD6SyU97nDIoXL8OkCOQ34dfZYY3fhITj4n+OOO8O39P
SSRZwiWVAXwYWmL1/eKj5nFsA7Fh27Z+/6uJFG7P9f1ebbuLf7S7s2eQp1xRbVhN
h74CQMl8/vL+njwWffYzsRWsjyIDd5A06MNkOE7AmATqtgHPJxUAGlOllqmpYhiv
R9wqvVEZ2iM6jBnKD08P6GuLNEoEsTMeUPJi+PXDfXSsWglYchl9RNWVR+mgssHG
/jSmw0zVoPgk12wjCBLkiHiWxtLXvTQCq+H4Wd2BX8/+00p0NAQZ2lmXj9MjuJ6E
DT4wJHDOyhjIawmPK6nQ
=YgA9
-----END PGP SIGNATURE-----

--Sig_/l2q7TJoL1q4vS+nB_0gT27f--
