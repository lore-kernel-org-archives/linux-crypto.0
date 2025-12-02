Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3ED2F617B
	for <linux-crypto@vger.kernel.org>; Tue,  2 Dec 2025 10:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764670460; cv=none; b=DrR3EqOzpTPGN4a19wJhYfRMKINut32dW00So4fLvObdihFG4xRbAl+Nx9zEfHDE1sunDWMBBJiPM/CNViuorKOGgsqElpm1ELwu7eMW7L4H0o+XntFAzgpwozWm9mYjo3/ozcgBFFeXJpmNLQO0dz2m+QrRANWNM22K9wp5GCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764670460; c=relaxed/simple;
	bh=M9xbVcQMi/2cHE4U+bFX1hYeZTyCyVaUK2Ni3iNUVg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPFAwBOZEpjY063RTxpAYxUCmQiCVPJzuITPBiTjO2UZoeZSbS7bFQWTGGOOlBLxPZTkeK5EvWiymc0BJIhLJP5vZyCTsZPFXmK1tu7LlvFD6G5rrPKJwh2ooJ8AcTP8DtvOFGqQ0mVKdCY/jYjq/agsgqm2Zj0zru2xUoR21rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NJOazr9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NJOazr9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DDBC4CEF1;
	Tue,  2 Dec 2025 10:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764670459;
	bh=M9xbVcQMi/2cHE4U+bFX1hYeZTyCyVaUK2Ni3iNUVg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NJOazr9x/6UJiJlEKcGoY1u0WvTtkdTJK4bvfyTRykym2mX4mnfFzJyzNK9GAOpzF
	 PorU1/enTo7qTIJhi9RJG3tdyW9T8OITU9vCAP6duMsal8CkAdnHkBnY8hlgRlNS74
	 rWRz1bSyvhBbGcXgZbnoKoFq941XHWCglZoVpFkv1BojWY0LeLu4ra0J++NRn2SOhs
	 SleakNB6p78wMCTFutmtKBTv7Cvz6BDg/C0LrgukeMOtqMhXjAXdv7VrD2pdTttmuq
	 Du/sc92jb9ZLwvgES5wMA60EEJ/x92ZIS0Cbz00Q4+R1bD5Gh7PYGE0Vibl9NC0F58
	 g1Ll0g0of8OOw==
Date: Tue, 2 Dec 2025 11:14:15 +0100
From: Alejandro Colomar <alx@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: jason@zx2c4.com, ardb+git@google.com, ardb@kernel.org, arnd@arndb.de, 
	kees@kernel.org, linux-crypto@vger.kernel.org, torvalds@linux-foundation.org, 
	Aaron Ballman <aaron@aaronballman.com>
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <ei7wbiu6m2lvso3gbc4ohvz3h575anjxqm64zqi7lg3pzilaxy@go4bjuiv3exr>
References: <aRi6zrH3sGyTZcmf@zx2c4.com>
 <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
 <20251202015750.GA1638706@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4dz4sag5irk6ez4e"
Content-Disposition: inline
In-Reply-To: <20251202015750.GA1638706@google.com>


--4dz4sag5irk6ez4e
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: jason@zx2c4.com, ardb+git@google.com, ardb@kernel.org, arnd@arndb.de, 
	kees@kernel.org, linux-crypto@vger.kernel.org, torvalds@linux-foundation.org, 
	Aaron Ballman <aaron@aaronballman.com>
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <ei7wbiu6m2lvso3gbc4ohvz3h575anjxqm64zqi7lg3pzilaxy@go4bjuiv3exr>
References: <aRi6zrH3sGyTZcmf@zx2c4.com>
 <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
 <20251202015750.GA1638706@google.com>
MIME-Version: 1.0
In-Reply-To: <20251202015750.GA1638706@google.com>

[CC +=3D Aaron BAllman]

Hi Eric,

On Tue, Dec 02, 2025 at 01:57:50AM +0000, Eric Biggers wrote:
> On Tue, Dec 02, 2025 at 02:12:47AM +0100, Alejandro Colomar wrote:
> > Be careful about [static n].  It has implications that you're probably
> > not aware of.  Also, it doesn't have some implications you might expect
> > from it.
> >=20
> > -  [static n] on an argument implies __attribute__((nonnull())) on that
> >    argument; it means that the argument can't be null.  You may want to
> >    make sure you're using -fno-delete-null-pointer-checks if you use
> >    [static n].
>=20
> The kernel uses -fno-delete-null-pointer-checks.

Ok.

> As for the caller side, isn't it the expected behavior?  NULL isn't
> at_least n, unless n =3D=3D 0 (see below).

NULL is not an array of zero elements.  NULL is an invalid pointer,
often used as a sentinel value.

Consider for example the freezero(3) function from OpenBSDs libc.  If
we could use arrays of void, we could define it as

	void
	freezero(size_t n;
	    void p[n], size_t n)
	{
		if (p !=3D NULL)
			explicit_bzero(p, n);
		free(p);
	}

Where p is either a null pointer, or a pointer to an object with at
least n bytes.

Often, APIs will want nonnull pointers, but this isn't special of [n].
APIs taking null pointers are rare per-se.

> > -  [static n] implies that n>0.  You should make sure that n>0, or UB
> >    would be triggered.
>=20
> There isn't any reason to use it on an array parameter with size 0,
> though.  Unless someone uses it on a VLA where the size is a previous
> function parameter, but that's not what this is wanted for.

Indeed, be careful about the latter.  In this specific case, it may be
not the case, but you should be aware of this issue in case you consider
using [static n] more often.  This could be a footgun.

> > -  [n] means two promises traditionally:
> >    -  The caller will provide at least n elements.
> >    -  The callee will use no more than n elements.
> >    However, [static n] only carries the first promise.  According to
> >    ISO C, the callee may access elements beyond that.
> >    GCC, as a quality implementation, enforces the second promise too,
> >    but this is not portable; you should make sure that all supported
> >    compilers enforces that as an extension.
>=20
> While it would be helpful to get a warning in the second case too, the
> first case is already helpful (and more important anyway).

There are other ways to get the same diagnostic without the dangers of
[static n].

> > -  Plus, it's just brain-damaged noise.
> >=20
> > I recommend that you talk with GCC to fix the issues with
> > -Wstringop-overflow that don't allow you to use [n] safely.  That would
> > be useful anyway.
>=20
> It seems the ship already sailed decades ago, though: [n] has always
> been "advisory" in C.  [static n] is needed to make it be enforced, and
> surely it was done that way for backwards compatibility.

This is not true.

-  [n] is advisory in standard C, but in GCC, it can be mandatory,
   as long as you use proper compiler flags.

-  [static n] is unnecessary, and --except for the dangers mentioned
   above--, is entirely ignored by many compilers, including GCC.

	alx@devuan:~/tmp$ cat array-bounds.c=20
	void g(int a[43]);

	void f(int a[42]);
	void f(int a[42])
	{
		a[100] =3D 7;
		g(a);
	}

	void gs(int a[static 43]);

	void fs(int a[static 42]);
	void fs(int a[static 42])
	{
		a[101] =3D 8;
		gs(a);
	}
	alx@devuan:~/tmp$ gcc -Wall -Wextra -O2 -S array-bounds.c
	array-bounds.c: In function =E2=80=98f=E2=80=99:
	array-bounds.c:7:9: warning: =E2=80=98g=E2=80=99 accessing 172 bytes in a =
region of size 168 [-Wstringop-overflow=3D]
	    7 |         g(a);
	      |         ^~~~
	array-bounds.c:7:9: note: referencing argument 1 of type =E2=80=98int[43]=
=E2=80=99
	array-bounds.c:1:6: note: in a call to function =E2=80=98g=E2=80=99
	    1 | void g(int a[43]);
	      |      ^
	array-bounds.c: In function =E2=80=98fs=E2=80=99:
	array-bounds.c:16:9: warning: =E2=80=98gs=E2=80=99 accessing 172 bytes in =
a region of size 168 [-Wstringop-overflow=3D]
	   16 |         gs(a);
	      |         ^~~~~
	array-bounds.c:16:9: note: referencing argument 1 of type =E2=80=98int[43]=
=E2=80=99
	array-bounds.c:10:6: note: in a call to function =E2=80=98gs=E2=80=99
	   10 | void gs(int a[static 43]);
	      |      ^~
	array-bounds.c: In function =E2=80=98f=E2=80=99:
	array-bounds.c:6:10: warning: array subscript 100 is outside array bounds =
of =E2=80=98int[42]=E2=80=99 [-Warray-bounds=3D]
	    6 |         a[100] =3D 7;
	      |         ~^~~~~
	array-bounds.c:4:12: note: at offset 400 into object =E2=80=98a=E2=80=99 o=
f size [0, 168]
	    4 | void f(int a[42])
	      |        ~~~~^~~~~
	array-bounds.c: In function =E2=80=98fs=E2=80=99:
	array-bounds.c:15:10: warning: array subscript 101 is outside array bounds=
 of =E2=80=98int[42]=E2=80=99 [-Warray-bounds=3D]
	   15 |         a[101] =3D 8;
	      |         ~^~~~~
	array-bounds.c:13:13: note: at offset 404 into object =E2=80=98a=E2=80=99 =
of size [0, 168]
	   13 | void fs(int a[static 42])
	      |         ~~~~^~~~~~~~~~~~


> Perhaps people would like to volunteer to get gcc and clang to provide
> an option to provide nonstandard behavior where [n] is enforced,

GCC already enforces [n].  See above.  I'm using:

	alx@devuan:~/tmp$ gcc --version
	gcc (Debian 15.2.0-9) 15.2.0
	Copyright (C) 2025 Free Software Foundation, Inc.
	This is free software; see the source for copying conditions.  There is NO
	warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Clang doesn't enforce it.  Clang doesn't even enforce [static n].
Clang is in fact quite bad at diagnosing array bounds violations.
Aaron, could you please fix this in Clang?

	alx@devuan:~/tmp$ cat array-bounds.c=20
	void g(int a[43]);

	void f(int a[42]);
	void f(int a[42])
	{
		a[100] =3D 7;
		g(a);
	}

	void gs(int a[static 43]);

	void fs(int a[static 42]);
	void fs(int a[static 42])
	{
		a[101] =3D 8;
		gs(a);
	}
	alx@devuan:~/tmp$ clang -S -Weverything array-bounds.c=20
	array-bounds.c:6:2: warning: unsafe buffer access [-Wunsafe-buffer-usage]
	    6 |         a[100] =3D 7;
	      |         ^
	array-bounds.c:15:2: warning: unsafe buffer access [-Wunsafe-buffer-usage]
	   15 |         a[101] =3D 8;
	      |         ^
	2 warnings generated.
	alx@devuan:~/tmp$ clang-21 -S -Weverything array-bounds.c=20
	array-bounds.c:6:2: warning: unsafe buffer access
	      [-Wunsafe-buffer-usage]
	    6 |         a[100] =3D 7;
	      |         ^
	array-bounds.c:15:2: warning: unsafe buffer access
	      [-Wunsafe-buffer-usage]
	   15 |         a[101] =3D 8;
	      |         ^
	2 warnings generated.

> and
> then push to get the C standard revised to specify that behavior.

I'm working on convincing the C Committee regarding this at the moment.
In the meantime, we have GCC available.

>  It
> sounds great to me, but that would of course be a very long project.

Not so much.  GCC is here already.  And the C Committee could be
convinced.

> In the mean time, we don't need to delay using the tool we have now.

Are you sure [static n] is a tool?  I don't see any compiler diagnosing
it differently from [n].  Neither GCC nor Clang diagnose it, from what
I've shown above.

> > On the other hand, to resolve the issue at hand, how about an
> > alternative approach?
> >=20
> > void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src=
_len,
> >                                const u8 *ad, const size_t ad_len,
> >                                const u8 nonce[XCHACHA20POLY1305_NONCE_S=
IZE],
> >                                const u8 key[CHACHA20POLY1305_KEY_SIZE]);
> >=20
> > #define xchacha20poly1305_encrypt_arr(dst, src, slen, ad, ad_len, nonce=
, k)\
> > ({                                                                    \
> > 	static_assert(ARRAY_SIZE(nonce) =3D=3D XCHACHA20POLY1305_NONCE_SIZE);\
> > 	static_assert(ARRAY_SIZE(key) =3D=3D CHACHA20POLY1305_KEY_SIZE);  \
> > 	xchacha20poly1305_encrypt(dst, src, slen, ad, ad_len, nonce, k);\
> > })
>=20
> No.  That would be more code, would double the API size, and make it the
> caller's responsibility to decide which one to call.

You could name the function as __xchacha20poly1305_dont_call_me_directly()
to make sure it's never called.

>  And often there
> won't be a correct option, as the caller may have arrays that are larger
> than the required size, or a mix of arrays and pointers, etc.

If you want to enforce a minimum array size, you could change the static
assertions to do >=3D instead.

You could also lift the check when the input is a pointer:

	static_assert(!is_array(nonce)
	              || sizeof(nonce) >=3D XCHACHA20POLY1305_NONCE_SIZE);

It all depends on what you need exactly.


Have a lovely day!
Alex

>=20
> - Eric

--=20
<https://www.alejandro-colomar.es>

--4dz4sag5irk6ez4e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmkuu/AACgkQ64mZXMKQ
wqkHERAAmhAxDmECHVMsrvqV50mcRnbC62xfcs1GmhMUDsFWk4qsz5tS6Qo4YInO
J7PdfUiWibZuOAlpSnWCedSGo5MztPU+DxZMXT7udvRMjjMC0szb+4yADi7Uc7h5
vy447TMAdvpqYt6o5vrkV0/yQfHGGmjpx3RzVXgoC+a7uDnMCkq0m/4OG0lsxmLO
JgWGnjIhv4gXK6O4LtQcxbikg96R7WxhZufgX7ndULa3ZRbpqDoRkff8y4P4pi5o
yS2/O+i/AuUfhUJRJxNZJJmxIa+dgJhc2AIzlwFBiK/wJiC7T/LmacvYpBs58dhP
5Q8K9e1tJSF841ifVsBT8+IkwsrZyk8tkRM3CdyvepUD3SYmfHErGbMxp2smnEv2
SyNFATiPX23M/dpY1r+FO4E5ba5Ky5U0fZd6PoMW9PIpEnozy32BS8Pc+MVACCRp
cMvkd3yNVattmCXyIdzza6wfz7/prpijVs0MTamoCbaVuPKne4hSjNL62K4tr5g9
pYwRYB4G86rGpsIg/3j9taIL4DD5NEfiU7nTIlZ+Cc9cAcv5DsdLd6KKzw2adCoS
B3HeAAyowRM1UBkNgWAzlWGugFKwdI9OpRovBRZ9nUzQ0AKCWjkgdUOEE/GyNk6E
OpNT7Nd1K+ngBZqzPYgTAKgxi5gz5StWfxGhiGK6bnwTV2sRuEA=
=8Ucj
-----END PGP SIGNATURE-----

--4dz4sag5irk6ez4e--
