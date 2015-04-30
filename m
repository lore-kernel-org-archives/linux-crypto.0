From: mancha security <mancha1@zoho.com>
Subject: Re: [PATCH crypto-2.6] lib: make memzero_explicit more robust
 against dead store elimination
Date: Thu, 30 Apr 2015 06:17:11 +0000
Message-ID: <20150430061711.GD12861@zoho.com>
References: <85dfdd23d98412a183546e2e7659a6a2bed1fca8.1430230786.git.daniel@iogearbox.net>
 <20150429130816.GA8526@zoho.com>
 <5540E42F.70607@iogearbox.net>
 <20150429145400.GA12861@zoho.com>
 <55416C8B.1070909@iogearbox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="q9KOos5vDmpwPx9o"
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Mark Charlebois <charlebm@gmail.com>,
	Behan Webster <behanw@converseincode.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sender1.zohomail.com ([74.201.84.155]:35699 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbbD3GRd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Apr 2015 02:17:33 -0400
Content-Disposition: inline
In-Reply-To: <55416C8B.1070909@iogearbox.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--q9KOos5vDmpwPx9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 30, 2015 at 01:43:07AM +0200, Daniel Borkmann wrote:
> On 04/29/2015 04:54 PM, mancha security wrote:
> >On Wed, Apr 29, 2015 at 04:01:19PM +0200, Daniel Borkmann wrote:
> >>On 04/29/2015 03:08 PM, mancha security wrote:
> >>...
> >>>By the way, has anyone been able to verify that __memory_barrier
> >>>provides DSE protection under various optimizations? Unfortunately,
> >>>I don't have ready access to ICC at the moment or I'd test it
> >>>myself.
> >>
> >>Never used icc, but it looks like it's free for open source
> >>projects; I can give it a try, but in case you're faster than I am,
> >>feel free to post results here.
> >
> >Time permitting, I'll try setting this up and post my results.
>=20
> So I finally got the download link and an eval license for icc, and
> after needing to download gigbytes of bloat for the suite, I could
> finally start to experiment a bit.

Ugh.

> So __GNUC__ and __INTEL_COMPILER is definitely defined by icc, __ECC
> not in my case, so that part is as expected for the kernel header
> includes.
>=20
> With barrier_data(), I could observe insns for an inlined memset()
> being emitted in the disassembly, same with barrier(), same with
> __memory_barrier(). In fact, even if I only use ...
>=20
> static inline void memzero_explicit(void *s, size_t count)
> {
>   memset(s, 0, count);
> }
>=20
> int main(void)
> {
>   char buff[20];
>   memzero_explicit(buff, sizeof(buff));
>   return 0;
> }
>=20
> ... icc will emit memset instrinsic insns (did you notice that as
> well?) when using various optimization levels. Using f.e. -Ofast
> -ffreestanding resp. -fno-builtin-memset will emit a function call,
> presumably, icc is then not allowed to make any assumptions, so given
> the previous result, then would then be expected.

I didn't get around to installing ICC so thanks for sharing the very
interesting results.

> So, crafting a stupid example:
>=20
> static inline void
> dumb_memset(char *s, unsigned char c, size_t n)
> {
>         int i;
>=20
>         for (i =3D 0; i < n; i++)
>                 s[i] =3D c;
> }
>=20
> static inline void memzero_explicit(void *s, size_t count)
> {
>   dumb_memset(s, 0, count);
>   <barrier-variant>
> }
>=20
> int main(void)
> {
>   char buff[20];
>   memzero_explicit(buff, sizeof(buff));
>   return 0;
> }
>=20
> With no barrier at all, icc optimizes all that away (using -Ofast),
> with barrier_data() it inlines and emits additional mov* insns!  Just
> using barrier() or __memory_barrier(), we end up with the same case as
> with clang, that is, it gets optimized away. So, barrier_data() seems
> to be better here as well.

For now, seems we're good with barrier_data should things like the LTO
initiative pick up steam, etc.

Cheers.

--q9KOos5vDmpwPx9o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVQcjmAAoJEB4VYy8JqhaD+Q4P/2u3bCkoN3OdibPQLorKMGbU
189wR2tIDST5I4FQyvxVcIzAnWMm3a+GjsgiqCIPdjeqrtwuIzpw3qUdMb5igIy/
mPpxZQBjbRj59NJ80GBivKLe861ka7T02YMWvSm0sEajgPuwL3djNXcmtiyoOujw
yI2Gyvs87BL44KcjaGP5sWgLe9jLnF91masVlv3FdoD7rHJKFKCsnXvlpkBeHYoJ
byjXeSuq8DxnfwHORkt0cgH+lZtKDkuhOq3WVq0HpMaug2fMYszQPVOI6Kfe19hf
mqVgCETwRR/HxIlXVc4czwDjankaBhDGLYNqLlvnzlIlWwm6oyxE38YEFGUlmBg+
v1bmL0E1F7438MzzTXUlZSulJsyaU3jI7POKEg3nHvcWiMBheJl+3LV8Xu0tcvjh
52TZsUXfH/LBSK7ykXdyQhbLJMwDKCkrXawJlFH8xfGb9hZtvGfTVqF65fkDLdZ1
NwTTbOgguJ8w/W7pZ/4zRQOA4+QNYfvI5eCGtQjt9eOHQHOzn6LMsyuIXsL3L1o9
p18AlWxF4Cx93NDXwrxs8DDKd/I01lbv20Y0NGMYT4Pj3He7sHetzTKfzBnB6wDr
7Tlvz7PEJEsJdspj7LHduPnZ7LQzexSR+fg3afHJfHLz+PssWu6YF3Vz7ZhEltEd
hKHd0Sel5WQB3I4KDJ4O
=/l/T
-----END PGP SIGNATURE-----

--q9KOos5vDmpwPx9o--
