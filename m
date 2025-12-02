Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EBB2C21C1
	for <linux-crypto@vger.kernel.org>; Tue,  2 Dec 2025 21:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764710837; cv=none; b=sTT+GdHS1THTPxkasd99C8l+q9CWI1N3yKGhpDVH7hxJSVfvYZtjz+XgqcXwA0hlfWxQL5aFrbwci5nB3dVroJ49g957ZwB8xazgtUHmmCA51s0kWHGoDAGJZSouwJg0vAYpq8hiorG59Z4tbUTLqSLzXK70B5ttzJ0U4TmHtz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764710837; c=relaxed/simple;
	bh=cBC/8c2RVK6dgeCg1tjMN8e3hlbTOVKzjMnUQj1vuJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ly7HXNMUem+owXG+u+jyxO7Xvc5xrswaugjSqucNFs8mpo51b3GaW4JTWGWUrl8Tk3njFCHcNtYTCjqGr9Js4ctVimQAajs7GQXLXRQx40NKAY6WBZyzxNjZZyguA8oKCm5AUX8TcEJz8qzTTiklwHWuISu2SE7InRjr9sMtYBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KInweKfu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KInweKfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F40DC4CEF1;
	Tue,  2 Dec 2025 21:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764710836;
	bh=cBC/8c2RVK6dgeCg1tjMN8e3hlbTOVKzjMnUQj1vuJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KInweKfuu38v71d42aCVNl7OcNCc/IeBk6CSIy5/X8am/EhDQ36tuBdBYfl8uGFa9
	 MqemhXgSsIP11CLL2ti62TiNgMsxjaPVbXcPHQhK0MtLef7S7lauk7vyrlC5kdlEnr
	 QNnDjxFB1p4auTealSAJ9hYP9VTb22hRNZ5xS+RfDRs7/+w7KqHV3Oi02HgFzr7s5t
	 hVSwQ1vS2HOfaHDSzfaJ17k6333vAU/rhH6XX/gq6w6J6RO4PVkkrrmApDOD9XuAHO
	 HSz888aTFmLsix1/Tzxpy+Uqr0DDpthT4J/hktfCgqI6qj8q4s5zp6v18rCBPqkACh
	 1T7f8ZX8T7aiQ==
Date: Tue, 2 Dec 2025 22:27:12 +0100
From: Alejandro Colomar <alx@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: jason@zx2c4.com, ardb+git@google.com, ardb@kernel.org, arnd@arndb.de, 
	kees@kernel.org, linux-crypto@vger.kernel.org, torvalds@linux-foundation.org, 
	Aaron Ballman <aaron@aaronballman.com>
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <kkh7qyx2bs5tkcsg32f32pq6nhtab7ft432bwqdpvdlhxprw5g@tzt47wrkxfy6>
References: <aRi6zrH3sGyTZcmf@zx2c4.com>
 <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
 <20251202015750.GA1638706@google.com>
 <ei7wbiu6m2lvso3gbc4ohvz3h575anjxqm64zqi7lg3pzilaxy@go4bjuiv3exr>
 <uqtp7y4smylm475jfn6krdvib66mjgxavnr5c6ciznslkwdlhd@k3awdazxphqt>
 <20251202164949.GB1638706@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aoastgbxjfpyhrud"
Content-Disposition: inline
In-Reply-To: <20251202164949.GB1638706@google.com>


--aoastgbxjfpyhrud
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
Message-ID: <kkh7qyx2bs5tkcsg32f32pq6nhtab7ft432bwqdpvdlhxprw5g@tzt47wrkxfy6>
References: <aRi6zrH3sGyTZcmf@zx2c4.com>
 <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
 <20251202015750.GA1638706@google.com>
 <ei7wbiu6m2lvso3gbc4ohvz3h575anjxqm64zqi7lg3pzilaxy@go4bjuiv3exr>
 <uqtp7y4smylm475jfn6krdvib66mjgxavnr5c6ciznslkwdlhd@k3awdazxphqt>
 <20251202164949.GB1638706@google.com>
MIME-Version: 1.0
In-Reply-To: <20251202164949.GB1638706@google.com>

Hi Eric,

On Tue, Dec 02, 2025 at 04:49:49PM +0000, Eric Biggers wrote:
> On Tue, Dec 02, 2025 at 02:42:13PM +0100, Alejandro Colomar wrote:
> > > Clang doesn't enforce it.  Clang doesn't even enforce [static n].
> > > Clang is in fact quite bad at diagnosing array bounds violations.
> > > Aaron, could you please fix this in Clang?
> >=20
> > Self-correction: Actually, there's different enforcement in one case:
>=20
> Right, and it's the case that actually matters, which is kind of the
> point.  Maybe you missed the earlier discussions.

Yup, I only noticed about this because of LWN.

So, I've asked GCC to remove dubious diagnostics from
-Wstringop-overflow so that it doesn't need to be disabled by anyone.
<https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D122963>

I'm not entirely sure why the kernel can't enable it, but from what
I saw it seems it has something to do with some libc function.  That
could go to a separate -W flag, and then you could re-enable it.

However, please report a minimal reproducer that shows the false
positives you have.  That would be useful.

It would also be useful if (plural) you pushed Clang to diagnose [n]
just as [static n].  It makes sense to use [static n] temporarily
because that's what Clang diagnoses today, but it would be better if
Clang diagnosed the code without changing it.  I can try to ask them,
but if kernel maintainers ask for it, it will have more effect.

In my work convincing the C Committee of strengthening [n] semantics,
the hardest part is convincing members of the committee from Clang.
If Clang had this, we'd likely pass it in the committee.  They've told
me they're opposed to doing this work without clients requesting it, and
you'd be one such client.


Have a lovely night!
Alex

>=20
> - Eric

--=20
<https://www.alejandro-colomar.es>

--aoastgbxjfpyhrud
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmkvWaYACgkQ64mZXMKQ
wqlZqxAAoQw3Y57XIAOUTFXoVaJJ4kp6fv7mH1yhD5DkLgn9kWWer9a14Ltssv4+
X/tKrV/8/3oXpo/Z9PvlpRSJSfChtIUsJs9Ikv2j1hrchLfQzjgGA37IEY0E//D2
VSYSFXc53l3/eqFvm86W36+Sy/PNw1PPxC8UtifbqIxiPdzCCNHIAGHHiA2EOeqU
m+wWNpqciEz3nHU/vVbBW+p2t7eDqNgq0BL/xGCUN2YDTpI863jIBc4Yi9ESBZrw
YRhnSQqcYhvoW570tn1Akm1IFcWiCY2SUi9HUr8t79VlMLJ39QEDJKox/emD7+tr
IqynGAU2vFm6weWgg/ifdh3sR0+HIjv04UcsVVo2tnfhnMQUQP09O2K6YpLvmSVe
MevlYDGW4NyJaVgVXW2xiT3aRYUYkj4sPIBKofRPiHwawfJL6at6Q4olZ2iEWZ9g
BdkGaKdS5pRlufcDg+9iYyAVozww18PT5NPk70K2rJL4X2ACQvgA/0mxSBtcxftX
Xv4Tji/F4Y1RTfe+PKlbZVMFZiZrfIXxI8MDu+R8rBdwYHmZT2jL0LUvCxghYH7b
im8zzPi7oLp9JSXZ3uTPitHJKkkCtQ/5bSs59pPswg4W4qZ9WKeeAoaiA6fwu2Er
cYxKNPNy35v7jEYtS+f+XvsFw8FZVQBwT4NdgaLSs6DeHcvI6BU=
=kYRL
-----END PGP SIGNATURE-----

--aoastgbxjfpyhrud--
