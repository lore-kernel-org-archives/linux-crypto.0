Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9577B3F39E2;
	Sun,  4 Oct 2026 18:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.189.121.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791139832; cv=none; b=b6ZzyCR1bjHUZQVX79GfvVLKaMR9VgmJ030Yfnv6T1e5vxwwiWSa0SUFxrIhanNoe2WIfCZe4TTxDOBsIH1sVkShciKTs/Wi6wud0OnioT71RmgzXA/e+VRP5a+O17JNajMDFHOlqxs9eQ2UieyInysm3EywmPlhTJO5sEfgYaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791139832; c=relaxed/simple;
	bh=X9/o782vWzVabCQMJ0PTl+M2J7G9le8630Tw3+gOuPE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lk5yZyk3OudxL0DrIsBE8zxp1qWOADTRHQX78FSVbB5Xml58FlFNiBvxrvPciHWRmjb5bC7Evhz6YSH9yDhyEml0xXUgwt9ZKKksOawGHkC4vNw4nCp+txUkLpAWFxtSos5oFXaYo3X8I5RUzwRYjXQR7WV6qci1K7uqs9vId5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no; spf=pass smtp.mailfrom=itx.no; dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b=D+AUPKgL; arc=none smtp.client-ip=91.189.121.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b="D+AUPKgL"
Message-ID: <20ca329f09a274b28beba7aaa1d919e3b81d61c7.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1791139828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X9/o782vWzVabCQMJ0PTl+M2J7G9le8630Tw3+gOuPE=;
	b=D+AUPKgL3UHtlckJhNLhGys9CH1xFMNASFRBoq7KH/wwaRCg6KZDJOdEF6gBJr2ERRvbuQ
	mJlZ3NvVXqt1YyoCtJT8+qKVd9oZ13h9PHJl/Nq3SieOQPu58nR0FT+at8OI8UOx72433x
	8GqmgsNohwhLTFCczadwyrCjR52Du7U=
Subject: Re: [PATCH v2] lib/crypto: sparc/aes-xts: Add optimization using
 the AES opcodes
From: Stian Halseth <stian@itx.no>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel
 <ardb@kernel.org>,  Herbert Xu <herbert@gondor.apana.org.au>, "David S.
 Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 linux-crypto@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Date: Sun, 04 Oct 2026 20:50:25 +0200
In-Reply-To: <20261004180208.GD1906@quark>
References: <20261002072110.1221579-1-stian@itx.no>
	 <20261004180208.GD1906@quark>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-rhk+bWrrDw2T4T9ZCpTa"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


--=-rhk+bWrrDw2T4T9ZCpTa
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable



On Sun, 2026-10-04 at 20:02 +0200, Eric Biggers wrote:
> On Fri, Oct 02, 2026 at 09:21:10AM +0200, Stian Halseth wrote:
> > +#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_XTS)
> > +ENTRY(aes_sparc64_xts_encrypt_128)
> [...]
> > +ENTRY(aes_sparc64_xts_encrypt_256)
> [...]
> > +ENTRY(aes_sparc64_xts_decrypt_128)
> [...]
> > +ENTRY(aes_sparc64_xts_decrypt_256)
>=20
> These four functions are almost identical.=A0 They should each just
> invoke
> a macro that expands to different code only in the parts that are
> actually different, like what the __aes_xts_crypt macro in
> lib/crypto/riscv/aes-riscv64-zvkned-zvbb-zvkg.S or the _aes_xts_crypt
> macro in lib/crypto/x86/aes-aesni.S do.
>=20
> This will generate the same object file with way fewer lines of
> source.

Thanks, reworking, testing, and sending a v3.

/Stian

--=-rhk+bWrrDw2T4T9ZCpTa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCasKf8gAKCRDoeAEuJe36
VmA/AQCodVt8Jc6r8ZQthPXWzMzL+uPhPqrs1F2/nFymxHXD6gEAz2CW0o2eSrjR
argnbL7hkowPnUp+zhr1vXG8g1nSdQ8=
=CrAr
-----END PGP SIGNATURE-----

--=-rhk+bWrrDw2T4T9ZCpTa--
