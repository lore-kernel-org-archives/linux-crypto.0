Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89A4341AB6
	for <linux-crypto@vger.kernel.org>; Wed,  3 Dec 2025 18:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764784904; cv=none; b=ALUAGd3RWkm5ARdhE/jg94pSgQKSa50c2xUbhDrvCyI/wDuxi/tAwMB3OgUtzXjcbo3scmlDu9Z82XvpeBg8bpQkyCNLBkfCH1eXJHpUTQ82zHjig1q90cDDjLfU8TiLsogY2IwVPMzVSOuhF93JZgRZzsLoT8tSBSqmChBziCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764784904; c=relaxed/simple;
	bh=a1DdVG10pfZn8+vI7w0dYCVqOHz+aIr+TXZQTpQJztw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HlwHnfukfaGgTND0pAx7uT5/Y/kUONhEgMA2qUoxvwM8nh4ECe49VHiyXYSICUNB3mWGPyF60xWaIsngtzYJOP+7RYp6wp7kdXvvEHZXcW1x18drPLz1NfVMUzEg47r/b+atd+7DaTBh4bWyL2UIf1NMgxWb5B1Fc6K7YOyq8PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QspKTDhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QspKTDhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2B1C4CEF5;
	Wed,  3 Dec 2025 18:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764784904;
	bh=a1DdVG10pfZn8+vI7w0dYCVqOHz+aIr+TXZQTpQJztw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QspKTDhF+bYwgjpIy+9CCqNKNihyOyqIyFiGgUGR2a1PDGe/rsNrKgneUTz7fMwua
	 UMG965P+/2LPl3uwQ3Xp4Y+/SCRp/EEZHrcQTTN0Vh52On8nbjuFhVRHYPEx577KEl
	 yEKAABxT7G7/HFObhgMtY03txHiO3mo5FXOY4/myjWXWR1PnTEyhxj88VsLpTaY1gC
	 /fBbt3ehMRx5HQ9CG3ELY9RHjziWmT5I6fpx7mBGhP5V0Or7TXZomhQ7f2h4QWI4LP
	 Z8k52HFHAIRH8xpgm7PksQRKN4rEMTNjU6CYuOHEUFL3T2eIQ1S1DIbTboKNiOeCmn
	 45Uv9JS3Qsb3Q==
Date: Wed, 3 Dec 2025 19:01:39 +0100
From: Alejandro Colomar <alx@kernel.org>
To: Daniel Thompson <danielt@kernel.org>
Cc: jason@zx2c4.com, ardb+git@google.com, ardb@kernel.org, arnd@arndb.de, 
	ebiggers@kernel.org, kees@kernel.org, linux-crypto@vger.kernel.org, 
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <o3yq4m3ihmynvcrrp6u2xshngxtgso2cqrdhfazyxxm7udvs46@wzyl6qu4lmqt>
References: <aRi6zrH3sGyTZcmf@zx2c4.com>
 <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
 <aTByNvAYRhZI07cJ@aspen.lan>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zssjfvcno33m4l7f"
Content-Disposition: inline
In-Reply-To: <aTByNvAYRhZI07cJ@aspen.lan>


--zssjfvcno33m4l7f
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Daniel Thompson <danielt@kernel.org>
Cc: jason@zx2c4.com, ardb+git@google.com, ardb@kernel.org, arnd@arndb.de, 
	ebiggers@kernel.org, kees@kernel.org, linux-crypto@vger.kernel.org, 
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <o3yq4m3ihmynvcrrp6u2xshngxtgso2cqrdhfazyxxm7udvs46@wzyl6qu4lmqt>
References: <aRi6zrH3sGyTZcmf@zx2c4.com>
 <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
 <aTByNvAYRhZI07cJ@aspen.lan>
MIME-Version: 1.0
In-Reply-To: <aTByNvAYRhZI07cJ@aspen.lan>

Hi Daniel,

On Wed, Dec 03, 2025 at 05:24:06PM +0000, Daniel Thompson wrote:
[...]
> > Be careful about [static n].  It has implications that you're probably
> > not aware of.  Also, it doesn't have some implications you might expect
> > from it.
> >
> > -  [static n] on an argument implies __attribute__((nonnull())) on that
> >    argument; it means that the argument can't be null.  You may want to
> >    make sure you're using -fno-delete-null-pointer-checks if you use
> >    [static n].
> >
> > -  [static n] implies that n>0.  You should make sure that n>0, or UB
> >    would be triggered.
> >
> > -  [n] means two promises traditionally:
> >    -  The caller will provide at least n elements.
> >    -  The callee will use no more than n elements.
> >    However, [static n] only carries the first promise.  According to
> >    ISO C, the callee may access elements beyond that.
>=20
> This description implies that [n] carries promises that [static n] does
> not. However you are comparing the "traditional" behaviour (that is
> well beyond the scope of the standard) on one side with ISO C behaviour
> on the other.
>=20
> It makes sense to compare ISO C behavior for [n] (where neither of the
> above promises applies) with ISO C behaviour for [static n]...

Clang seems to implement the ISO C behavior, so in retrospective, the
comparison I did seems appropriate.  By moving from the GCC/traditional
behavior to the Clang/ISO one, a project would be lowering quality.

Plus, there's still the issues about n>0 and nonnullness.

The only reason why it makes some sense to use [static n] in the kernel
is because it's moving from no-rules to some rules.  But the real
problem here is that the kernel needs to turn GCC's -Wstringop-overflow
off, and that's what the kernel do some effort to re-enable.

If you show a minimal reproducer of what the problem is with
-Wstringop-overflow, I may be able to help with that.

In general, [static n] is bogus and never to be used, except temporarily
while other issues get fixed, like in this case.

> >    GCC, as a quality implementation, enforces the second promise too,
> >    but this is not portable; you should make sure that all supported
> >    compilers enforces that as an extension.
>=20
> ... and equally it makes sense to compare the gcc/clang warnings for
> [n] versus [static n] as recommended here.

Clang is really bad at both [n] and [static n].  If you need to rely on
clang for array bounds, you're screwed.

> However it should not be motivated by [static n] carrying few promises
> than [n], especially given gcc/clang's enforcement of the promises is
> a best effort static check that won't cover all cases anyway.

GCC is quite good at those diagnostics; it might not cover all cases,
but that's better than what ISO or Clang will promise.


Have a lovely night!
Alex

--=20
<https://www.alejandro-colomar.es>

--zssjfvcno33m4l7f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmkwev4ACgkQ64mZXMKQ
wqmhWBAAlofEAJYP8xp0dcM6q9Ia5TIvU2zV2veT3Dp4icvFnwjELXR+zo8tK0/O
epvheGcz5gOpc4zWEU77VBdEdxTJQpRPBuIMZ56oaxIoj7RkY1ocWO1d6Xd7ZA1k
ZmCNffp+8t9uFJnspkWmID9QSBAzWScbDaqvihBi8RQnTOayND8hDmWgwspT0/xH
Vzfu6vDzS4nKfHadNGdf/mgkgBlYAQOfrKwTKV3pyR5mB/njLBCcCdJ28kMH/Z4/
VKepdytyTuVb+Up26+IjHye1+Zmvk0IF23f2UrgYdLqcP3g6fV76GsHWnj1ohdb/
D1wDEsgu4IcxA7JZ5vwBTYBZBPkx75MQs7noHCEd7NOK6xieWSy0W2REPO+LnmfB
pr/htUL362+Jml5qSRw+hvqI330g7y2gC5kpAGBZ0KVDvcDg8JAnFGa/W4sCpS0Z
7OetwwbhsO8qqR34XnkDHxj6y5qjuCIblcBYtyKeWMYawtz9Wcy34HQTLKP9nkV4
zbjM+9pJjLtS9mh3ra6sIk6q2V3da2enJ8IrGMhW1sVg5j5FX0AD8eZckYQACUNE
q9mtDmWTw1girDlWbQQDwZTGw2uC/YlXH9Dj8sPectGJhhWjJzTYw6S5sk4iqvtM
AtBtI7ZpDmjtnLPxXnm85gkDQN+EqSWdRrZ7W0Cn6qNICkdqXkg=
=ESUs
-----END PGP SIGNATURE-----

--zssjfvcno33m4l7f--
