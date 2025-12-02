Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0802BE020
	for <linux-crypto@vger.kernel.org>; Tue,  2 Dec 2025 13:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764682938; cv=none; b=UO0W59r+Wa1teZFPJmNdREZknU8ZhwNXhx8PMVr1aEVyZSNlXm8RppOhYM5QNyxGdIDYs5ocnMHzw7rvv5OTjoiH0TficmQWeNutagiQQSkIOnPDgAS3EIAFnASs4Bj1PuJULSEdh/4NcRSSiZkGzo8QF/Rbr4JC06KKHJYUggA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764682938; c=relaxed/simple;
	bh=TQinm1NStv3tkLTyeewdIc9r+cM7OdP6FcGpq+tT2n0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pgNLGKEhF6OS+wwu2nd27btD6k7IQ8uoekOWBbuZ2Pn59sdHzdHpoHC8aiEPF4HO0oVpC307x7JJ7Aw0k8Zcc4VN7FBkAflnoKxENBllXwS2NCmOskYuGyPs8VRz9SysQcz5Poe9oOaRlXsOGBchOmjdmj8G8KYna5Qczn+apjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WV8eb/+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WV8eb/+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC08EC4CEF1;
	Tue,  2 Dec 2025 13:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764682937;
	bh=TQinm1NStv3tkLTyeewdIc9r+cM7OdP6FcGpq+tT2n0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WV8eb/+YM0QiBzx+O5oHg27uHh0RovW0E+EzpWxYqBx1YIp67URs2KYvv7W6NtWDf
	 9gP96EUyKJ5l+BsjG/woUcZwtH9C2NaQ6uUPi43ZIfoCgCTmnubqMbjLe8IeGWKYCX
	 MrHX9ek9xR77FgnBtTaDLeA9Az06BeMZxoiIIh78WvX69grBY+2jP1fTIW9ia3J22T
	 4NgsWOwuMPcezRBjgS8VHuCe3N3Ru2fcNFY5RoQb4E7yC6PWP283HtOCnGsUV84SxI
	 MbhxTSHGjcK2ZD31c4Ol3F7RJHL2AuQAVrhMtORhzg2TBSfvA9lnEE1sPbnZGLr9wp
	 zVin0Aq2vtK4g==
Date: Tue, 2 Dec 2025 14:42:13 +0100
From: Alejandro Colomar <alx@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: jason@zx2c4.com, ardb+git@google.com, ardb@kernel.org, arnd@arndb.de, 
	kees@kernel.org, linux-crypto@vger.kernel.org, torvalds@linux-foundation.org, 
	Aaron Ballman <aaron@aaronballman.com>
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <uqtp7y4smylm475jfn6krdvib66mjgxavnr5c6ciznslkwdlhd@k3awdazxphqt>
References: <aRi6zrH3sGyTZcmf@zx2c4.com>
 <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
 <20251202015750.GA1638706@google.com>
 <ei7wbiu6m2lvso3gbc4ohvz3h575anjxqm64zqi7lg3pzilaxy@go4bjuiv3exr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="n5ko2dtp6echg5cd"
Content-Disposition: inline
In-Reply-To: <ei7wbiu6m2lvso3gbc4ohvz3h575anjxqm64zqi7lg3pzilaxy@go4bjuiv3exr>


--n5ko2dtp6echg5cd
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
Message-ID: <uqtp7y4smylm475jfn6krdvib66mjgxavnr5c6ciznslkwdlhd@k3awdazxphqt>
References: <aRi6zrH3sGyTZcmf@zx2c4.com>
 <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
 <20251202015750.GA1638706@google.com>
 <ei7wbiu6m2lvso3gbc4ohvz3h575anjxqm64zqi7lg3pzilaxy@go4bjuiv3exr>
MIME-Version: 1.0
In-Reply-To: <ei7wbiu6m2lvso3gbc4ohvz3h575anjxqm64zqi7lg3pzilaxy@go4bjuiv3exr>

On Tue, Dec 02, 2025 at 11:14:20AM +0100, Alejandro Colomar wrote:
> [CC +=3D Aaron BAllman]
>=20
> Hi Eric,
>=20
> On Tue, Dec 02, 2025 at 01:57:50AM +0000, Eric Biggers wrote:
> > On Tue, Dec 02, 2025 at 02:12:47AM +0100, Alejandro Colomar wrote:
> > > Be careful about [static n].  It has implications that you're probably
> > > not aware of.  Also, it doesn't have some implications you might expe=
ct
> > > from it.
> > >=20
> > > -  [static n] on an argument implies __attribute__((nonnull())) on th=
at
> > >    argument; it means that the argument can't be null.  You may want =
to
> > >    make sure you're using -fno-delete-null-pointer-checks if you use
> > >    [static n].
> >=20
> > The kernel uses -fno-delete-null-pointer-checks.
>=20
> Ok.
>=20
> > As for the caller side, isn't it the expected behavior?  NULL isn't
> > at_least n, unless n =3D=3D 0 (see below).
>=20
> NULL is not an array of zero elements.  NULL is an invalid pointer,
> often used as a sentinel value.
>=20
> Consider for example the freezero(3) function from OpenBSDs libc.  If
> we could use arrays of void, we could define it as
>=20
> 	void
> 	freezero(size_t n;
> 	    void p[n], size_t n)
> 	{
> 		if (p !=3D NULL)
> 			explicit_bzero(p, n);
> 		free(p);
> 	}
>=20
> Where p is either a null pointer, or a pointer to an object with at
> least n bytes.
>=20
> Often, APIs will want nonnull pointers, but this isn't special of [n].
> APIs taking null pointers are rare per-se.
>=20
> > > -  [static n] implies that n>0.  You should make sure that n>0, or UB
> > >    would be triggered.
> >=20
> > There isn't any reason to use it on an array parameter with size 0,
> > though.  Unless someone uses it on a VLA where the size is a previous
> > function parameter, but that's not what this is wanted for.
>=20
> Indeed, be careful about the latter.  In this specific case, it may be
> not the case, but you should be aware of this issue in case you consider
> using [static n] more often.  This could be a footgun.
>=20
> > > -  [n] means two promises traditionally:
> > >    -  The caller will provide at least n elements.
> > >    -  The callee will use no more than n elements.
> > >    However, [static n] only carries the first promise.  According to
> > >    ISO C, the callee may access elements beyond that.
> > >    GCC, as a quality implementation, enforces the second promise too,
> > >    but this is not portable; you should make sure that all supported
> > >    compilers enforces that as an extension.
> >=20
> > While it would be helpful to get a warning in the second case too, the
> > first case is already helpful (and more important anyway).
>=20
> There are other ways to get the same diagnostic without the dangers of
> [static n].
>=20
> > > -  Plus, it's just brain-damaged noise.
> > >=20
> > > I recommend that you talk with GCC to fix the issues with
> > > -Wstringop-overflow that don't allow you to use [n] safely.  That wou=
ld
> > > be useful anyway.
> >=20
> > It seems the ship already sailed decades ago, though: [n] has always
> > been "advisory" in C.  [static n] is needed to make it be enforced, and
> > surely it was done that way for backwards compatibility.
>=20
> This is not true.
>=20
> -  [n] is advisory in standard C, but in GCC, it can be mandatory,
>    as long as you use proper compiler flags.
>=20
> -  [static n] is unnecessary, and --except for the dangers mentioned
>    above--, is entirely ignored by many compilers, including GCC.
>=20
> 	alx@devuan:~/tmp$ cat array-bounds.c=20
> 	void g(int a[43]);
>=20
> 	void f(int a[42]);
> 	void f(int a[42])
> 	{
> 		a[100] =3D 7;
> 		g(a);
> 	}
>=20
> 	void gs(int a[static 43]);
>=20
> 	void fs(int a[static 42]);
> 	void fs(int a[static 42])
> 	{
> 		a[101] =3D 8;
> 		gs(a);
> 	}
> 	alx@devuan:~/tmp$ gcc -Wall -Wextra -O2 -S array-bounds.c
> 	array-bounds.c: In function =E2=80=98f=E2=80=99:
> 	array-bounds.c:7:9: warning: =E2=80=98g=E2=80=99 accessing 172 bytes in =
a region of size 168 [-Wstringop-overflow=3D]
> 	    7 |         g(a);
> 	      |         ^~~~
> 	array-bounds.c:7:9: note: referencing argument 1 of type =E2=80=98int[43=
]=E2=80=99
> 	array-bounds.c:1:6: note: in a call to function =E2=80=98g=E2=80=99
> 	    1 | void g(int a[43]);
> 	      |      ^
> 	array-bounds.c: In function =E2=80=98fs=E2=80=99:
> 	array-bounds.c:16:9: warning: =E2=80=98gs=E2=80=99 accessing 172 bytes i=
n a region of size 168 [-Wstringop-overflow=3D]
> 	   16 |         gs(a);
> 	      |         ^~~~~
> 	array-bounds.c:16:9: note: referencing argument 1 of type =E2=80=98int[4=
3]=E2=80=99
> 	array-bounds.c:10:6: note: in a call to function =E2=80=98gs=E2=80=99
> 	   10 | void gs(int a[static 43]);
> 	      |      ^~
> 	array-bounds.c: In function =E2=80=98f=E2=80=99:
> 	array-bounds.c:6:10: warning: array subscript 100 is outside array bound=
s of =E2=80=98int[42]=E2=80=99 [-Warray-bounds=3D]
> 	    6 |         a[100] =3D 7;
> 	      |         ~^~~~~
> 	array-bounds.c:4:12: note: at offset 400 into object =E2=80=98a=E2=80=99=
 of size [0, 168]
> 	    4 | void f(int a[42])
> 	      |        ~~~~^~~~~
> 	array-bounds.c: In function =E2=80=98fs=E2=80=99:
> 	array-bounds.c:15:10: warning: array subscript 101 is outside array boun=
ds of =E2=80=98int[42]=E2=80=99 [-Warray-bounds=3D]
> 	   15 |         a[101] =3D 8;
> 	      |         ~^~~~~
> 	array-bounds.c:13:13: note: at offset 404 into object =E2=80=98a=E2=80=
=99 of size [0, 168]
> 	   13 | void fs(int a[static 42])
> 	      |         ~~~~^~~~~~~~~~~~
>=20
>=20
> > Perhaps people would like to volunteer to get gcc and clang to provide
> > an option to provide nonstandard behavior where [n] is enforced,
>=20
> GCC already enforces [n].  See above.  I'm using:
>=20
> 	alx@devuan:~/tmp$ gcc --version
> 	gcc (Debian 15.2.0-9) 15.2.0
> 	Copyright (C) 2025 Free Software Foundation, Inc.
> 	This is free software; see the source for copying conditions.  There is =
NO
> 	warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPO=
SE.
>=20
> Clang doesn't enforce it.  Clang doesn't even enforce [static n].
> Clang is in fact quite bad at diagnosing array bounds violations.
> Aaron, could you please fix this in Clang?

Self-correction: Actually, there's different enforcement in one case:

	alx@devuan:~/tmp$ cat array-bounds.c
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

	int
	main(void)
	{
		int a[2];

		f(a);
		fs(a);
	}
	alx@devuan:~/tmp$ clang -Weverything -S array-bounds.c
	array-bounds.c:25:2: warning: array argument is too small; contains 2 elem=
ents, callee requires at least 42 [-Warray-bounds]
	   25 |         fs(a);
	      |         ^  ~
	array-bounds.c:13:13: note: callee declares array parameter as static here
	   13 | void fs(int a[static 42])
	      |             ^~~~~~~~~~~~
	array-bounds.c:6:2: warning: unsafe buffer access [-Wunsafe-buffer-usage]
	    6 |         a[100] =3D 7;
	      |         ^
	array-bounds.c:15:2: warning: unsafe buffer access [-Wunsafe-buffer-usage]
	   15 |         a[101] =3D 8;
	      |         ^
	3 warnings generated.

which GCC also warns, but under -Wstringop-overflow, which is the issue
the kernel has.

	alx@devuan:~/tmp$ gcc -Wall -Wextra -S -O2 array-bounds.c
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
	array-bounds.c: In function =E2=80=98main=E2=80=99:
	array-bounds.c:24:9: warning: =E2=80=98f=E2=80=99 accessing 168 bytes in a=
 region of size 8 [-Wstringop-overflow=3D]
	   24 |         f(a);
	      |         ^~~~
	array-bounds.c:24:9: note: referencing argument 1 of type =E2=80=98int[42]=
=E2=80=99
	array-bounds.c:4:6: note: in a call to function =E2=80=98f=E2=80=99
	    4 | void f(int a[42])
	      |      ^
	array-bounds.c:25:9: warning: =E2=80=98fs=E2=80=99 accessing 168 bytes in =
a region of size 8 [-Wstringop-overflow=3D]
	   25 |         fs(a);
	      |         ^~~~~
	array-bounds.c:25:9: note: referencing argument 1 of type =E2=80=98int[42]=
=E2=80=99
	array-bounds.c:13:6: note: in a call to function =E2=80=98fs=E2=80=99
	   13 | void fs(int a[static 42])
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
	In function =E2=80=98f=E2=80=99,
	    inlined from =E2=80=98main=E2=80=99 at array-bounds.c:24:2:
	array-bounds.c:6:16: warning: array subscript 100 is outside array bounds =
of =E2=80=98int[2]=E2=80=99 [-Warray-bounds=3D]
	    6 |         a[100] =3D 7;
	      |         ~~~~~~~^~~
	array-bounds.c: In function =E2=80=98main=E2=80=99:
	array-bounds.c:22:13: note: at offset 400 into object =E2=80=98a=E2=80=99 =
of size 8
	   22 |         int a[2];
	      |             ^
	In function =E2=80=98fs=E2=80=99,
	    inlined from =E2=80=98main=E2=80=99 at array-bounds.c:25:2:
	array-bounds.c:15:16: warning: array subscript 101 is outside array bounds=
 of =E2=80=98int[2]=E2=80=99 [-Warray-bounds=3D]
	   15 |         a[101] =3D 8;
	      |         ~~~~~~~^~~
	array-bounds.c: In function =E2=80=98main=E2=80=99:
	array-bounds.c:22:13: note: at offset 404 into object =E2=80=98a=E2=80=99 =
of size 8
	   22 |         int a[2];
	      |             ^

Cheers,
Alex

>=20
> 	alx@devuan:~/tmp$ cat array-bounds.c=20
> 	void g(int a[43]);
>=20
> 	void f(int a[42]);
> 	void f(int a[42])
> 	{
> 		a[100] =3D 7;
> 		g(a);
> 	}
>=20
> 	void gs(int a[static 43]);
>=20
> 	void fs(int a[static 42]);
> 	void fs(int a[static 42])
> 	{
> 		a[101] =3D 8;
> 		gs(a);
> 	}
> 	alx@devuan:~/tmp$ clang -S -Weverything array-bounds.c=20
> 	array-bounds.c:6:2: warning: unsafe buffer access [-Wunsafe-buffer-usage]
> 	    6 |         a[100] =3D 7;
> 	      |         ^
> 	array-bounds.c:15:2: warning: unsafe buffer access [-Wunsafe-buffer-usag=
e]
> 	   15 |         a[101] =3D 8;
> 	      |         ^
> 	2 warnings generated.
> 	alx@devuan:~/tmp$ clang-21 -S -Weverything array-bounds.c=20
> 	array-bounds.c:6:2: warning: unsafe buffer access
> 	      [-Wunsafe-buffer-usage]
> 	    6 |         a[100] =3D 7;
> 	      |         ^
> 	array-bounds.c:15:2: warning: unsafe buffer access
> 	      [-Wunsafe-buffer-usage]
> 	   15 |         a[101] =3D 8;
> 	      |         ^
> 	2 warnings generated.
>=20
> > and
> > then push to get the C standard revised to specify that behavior.
>=20
> I'm working on convincing the C Committee regarding this at the moment.
> In the meantime, we have GCC available.
>=20
> >  It
> > sounds great to me, but that would of course be a very long project.
>=20
> Not so much.  GCC is here already.  And the C Committee could be
> convinced.
>=20
> > In the mean time, we don't need to delay using the tool we have now.
>=20
> Are you sure [static n] is a tool?  I don't see any compiler diagnosing
> it differently from [n].  Neither GCC nor Clang diagnose it, from what
> I've shown above.
>=20
> > > On the other hand, to resolve the issue at hand, how about an
> > > alternative approach?
> > >=20
> > > void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t s=
rc_len,
> > >                                const u8 *ad, const size_t ad_len,
> > >                                const u8 nonce[XCHACHA20POLY1305_NONCE=
_SIZE],
> > >                                const u8 key[CHACHA20POLY1305_KEY_SIZE=
]);
> > >=20
> > > #define xchacha20poly1305_encrypt_arr(dst, src, slen, ad, ad_len, non=
ce, k)\
> > > ({                                                                   =
 \
> > > 	static_assert(ARRAY_SIZE(nonce) =3D=3D XCHACHA20POLY1305_NONCE_SIZE)=
;\
> > > 	static_assert(ARRAY_SIZE(key) =3D=3D CHACHA20POLY1305_KEY_SIZE);  \
> > > 	xchacha20poly1305_encrypt(dst, src, slen, ad, ad_len, nonce, k);\
> > > })
> >=20
> > No.  That would be more code, would double the API size, and make it the
> > caller's responsibility to decide which one to call.
>=20
> You could name the function as __xchacha20poly1305_dont_call_me_directly()
> to make sure it's never called.
>=20
> >  And often there
> > won't be a correct option, as the caller may have arrays that are larger
> > than the required size, or a mix of arrays and pointers, etc.
>=20
> If you want to enforce a minimum array size, you could change the static
> assertions to do >=3D instead.
>=20
> You could also lift the check when the input is a pointer:
>=20
> 	static_assert(!is_array(nonce)
> 	              || sizeof(nonce) >=3D XCHACHA20POLY1305_NONCE_SIZE);
>=20
> It all depends on what you need exactly.
>=20
>=20
> Have a lovely day!
> Alex
>=20
> >=20
> > - Eric
>=20
> --=20
> <https://www.alejandro-colomar.es>



--=20
<https://www.alejandro-colomar.es>

--n5ko2dtp6echg5cd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmku7K8ACgkQ64mZXMKQ
wqkjKQ/+LfyDs2BqIQwJdJHSu2Jy43E4JIOodtboTBWY0C0kUTvxOISUz1H2KyvP
xFLKmBFBi9eKOGjqzm1vbA4GmGoSVUSpIgoUUPykRxlbr/oirE531DMKurgWcVNk
lo1EKitynHnNv8WHeRUFeaJxvDMiHULBr18ZUPlagb/jzfcdLSOgwMNMFAGfTXCr
C4fAr+TdTVMmCIbVMNBSZRMoKLms0pJvnyv8ZJp9VOWHJ5HZPdo4RMQSxfLEBsyt
viIrjFoYeAbCIoZUXEDV1MjzOk+T/ea+o6u8f+kQsPugPoA9A3wFdzmNELtG6+o8
A8d+YdaJ2sVbYF0Gz0e0M6ZtiPXVorrTRTFpiG1uUIYMtNlQugbhWFIctWIor1mv
fHE2lbqJu9nV14ry1ITP2kewXlrTwvNgUKp9teagAcp+htIyC5Szi6H/XcdAN107
hOH7SISdLWmqOdjVip8WbAPlMfUUt1DMb1KvTUProMyIQZBZk1wo+5eN0jG+m8vB
0+rWvxh7IlOXU5oItDzga2a5upRbPZsK89hy+AUl6LLDR2VfYFCOE8K6oA0bHtVP
9TINgISe6Db+ldfCLjEki0uUFmrRmxB5iBp+iTLz1hVw2fZ9WKoLDR/6S0/+Q5MC
RwGhRoaqiG38nNbV5zU0NGmA9NT/LbCKpUlaoKBMUWabBUd/Le8=
=FTaa
-----END PGP SIGNATURE-----

--n5ko2dtp6echg5cd--
