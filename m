Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671D73F9D2
	for <linux-crypto@vger.kernel.org>; Tue,  2 Dec 2025 01:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764637972; cv=none; b=HR+B5GeZCaS7yWchegLJ0ACcaikXua9YDde4CgI4KEsb5I0pxkZZfPCra3xXhMMcpzevMR1W2/1Mah50KR1qO1fKrs3m87sIdE1I6hUk6+rQOMBPCx03JCGbuUoVRWggnsgzIY3kgs3MiZSj6JRZpwNzVB1d2u3wT25IFzmRkHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764637972; c=relaxed/simple;
	bh=FiAg5nyE5vT3srUowyIAU4ZgTQy0Kb/yLtKfM6DQeik=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=sCbLDXyAMci9SK3Ix4uPnsFL0Km2xDXZ33oB8unPO0wqbHwu5rmXflfYzb7Z2MxoKXIUDPfPBjFgSHevXkBM2/QbMU0iSFgBgY/aj7edR7q1oblAdobcYbHL2Cqhz0MpbEK9y5XTwammpz3g+YxvC6gZ0qPU+sSjlhJogogQAjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lVQt5wdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lVQt5wdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DF5C116C6;
	Tue,  2 Dec 2025 01:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764637971;
	bh=FiAg5nyE5vT3srUowyIAU4ZgTQy0Kb/yLtKfM6DQeik=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=lVQt5wdOlc6HozOdw3jHeC75qZ6jmYQq9Fou+dNORLh7S1QXhtwM+BkEpGlOiatR+
	 bVQuDsFrMM3IYDQnD266eCgbfo0s58Gy/h/Na6x9FlUWJCG7yPp9TYWaXBv78iM98N
	 AznadQD3gKe4OxDpc9ZiajRt72Angh48sA7jqYfeZ5fYeTgeAYYqrDM9l87F5RcKCL
	 ODC8kBskCUbt1N4aJ7hS+SY7eAS8WYIJ44XuotQg52TWHxAJz+kPXPNr8HmgJr9Ir8
	 Zt+EQJQnAGlrjA0mntlP8qWCt/MfUBtVcP9riOwoKmTYZRiFja/AAoljlXChmGvqgh
	 TwAgi0XX7dXGQ==
Date: Tue, 2 Dec 2025 02:12:47 +0100
From: Alejandro Colomar <alx@kernel.org>
To: jason@zx2c4.com
Cc: ardb+git@google.com, ardb@kernel.org, arnd@arndb.de, 
	ebiggers@kernel.org, kees@kernel.org, linux-crypto@vger.kernel.org, 
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="csuifxpkcrg47dk4"
Content-Disposition: inline
In-Reply-To: <aRi6zrH3sGyTZcmf@zx2c4.com>


--csuifxpkcrg47dk4
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: jason@zx2c4.com
Cc: ardb+git@google.com, ardb@kernel.org, arnd@arndb.de, 
	ebiggers@kernel.org, kees@kernel.org, linux-crypto@vger.kernel.org, 
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
MIME-Version: 1.0
In-Reply-To: <aRi6zrH3sGyTZcmf@zx2c4.com>

Hi,

Jason said:
> On Sat, Nov 15, 2025 at 09:11:31AM -0800, Linus Torvalds wrote:
> > So *if* we end up using this syntax more widely, I suspect we'd want
> > to have a macro that makes the semantics more obvious, even if it's
> > something silly and trivial like
> >=20
> >    #define min_array_size(n) static n
> >=20
> > just so that people who aren't familiar with that crazy syntax
> > understand what it means.
>=20
> Oh that's a good suggestion. I'll see if I can rig that up and send
> something.

Be careful about [static n].  It has implications that you're probably
not aware of.  Also, it doesn't have some implications you might expect
=66rom it.

-  [static n] on an argument implies __attribute__((nonnull())) on that
   argument; it means that the argument can't be null.  You may want to
   make sure you're using -fno-delete-null-pointer-checks if you use
   [static n].

-  [static n] implies that n>0.  You should make sure that n>0, or UB
   would be triggered.

-  [n] means two promises traditionally:
   -  The caller will provide at least n elements.
   -  The callee will use no more than n elements.
   However, [static n] only carries the first promise.  According to
   ISO C, the callee may access elements beyond that.
   GCC, as a quality implementation, enforces the second promise too,
   but this is not portable; you should make sure that all supported
   compilers enforces that as an extension.

-  Plus, it's just brain-damaged noise.

I recommend that you talk with GCC to fix the issues with
-Wstringop-overflow that don't allow you to use [n] safely.  That would
be useful anyway.

On the other hand, to resolve the issue at hand, how about an
alternative approach?

void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
                               const u8 *ad, const size_t ad_len,
                               const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
                               const u8 key[CHACHA20POLY1305_KEY_SIZE]);

#define xchacha20poly1305_encrypt_arr(dst, src, slen, ad, ad_len, nonce, k)\
({                                                                    \
	static_assert(ARRAY_SIZE(nonce) =3D=3D XCHACHA20POLY1305_NONCE_SIZE);\
	static_assert(ARRAY_SIZE(key) =3D=3D CHACHA20POLY1305_KEY_SIZE);  \
	xchacha20poly1305_encrypt(dst, src, slen, ad, ad_len, nonce, k);\
})


Have a lovely night!
Alex

--=20
<https://www.alejandro-colomar.es>

--csuifxpkcrg47dk4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmkuPQkACgkQ64mZXMKQ
wqkqMA/9EMXqOFkfh2MosTvvpbvIDEshQf4NKhrfsXCNTm08S4cGBX7/U/5iJjdv
FQjTSE63R1seY7zFRpoSV/2vKDnajJLs3EnYRyQ8SgoyQCNq8L1B1G3GMt6JS1g/
1D0k+gobjKCb3t6mW/q3BFpikvWFiqNioTJhpC9KU/NyDKPBVr6KAElqqiMhNbVe
kMNGtYIshslUL/WA2ddhrcv6a8kuA16Bby5Pl5xT0k3HVXW9bHNm5MPkgVeYnMVW
YMaRANKnqhKPdRe+jru2I8aQPsYVeQLnNALfUF7y73TW4R42hXRSAuG6Ly6vQlSE
C4ag5KB8ZZA6l/lZKIhQVcnIb3iS0RjNbPAvFBW//+KnnPM+klGunu3LsvPt65cU
T2HC7zLPIlOaIhMOTWS7JqZQYf/f80u968Q9skDus3mjTs8y6Qhz4VPBC3xcn7KL
aLZmdngG8m/AtNGy2cjobuRbSY215WeoHtqQ2o6HRdScThNy+tDclvrUBnTwo2Ei
ya8HNPTjhTV2X8BetsCSHFJpwgXou78FK80ioexDSGU4DhCcDo7+h+oXFcebnQdc
jJ6mBY4JvadBP4Zq980QXzY18BhyEErBl7ayX4HG5VeCKsSP0/fLboJLkKtOPHlq
r2KdhlS4hxG5aDfFzBZMi4U+q/kca+mk/6WsEqWW6wapV973bys=
=KpDg
-----END PGP SIGNATURE-----

--csuifxpkcrg47dk4--
