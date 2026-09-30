Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97C53FE34D;
	Wed, 30 Sep 2026 06:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.189.121.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790750695; cv=none; b=YkJpvUfw4eYmlR7c4wspt4+xqT+0sDgVsBdn5cDzEiZ3xK5TZ+4PT61o6LZSfPmoQGEQbmCuDEdUZc3VsglEM8CXWQUIbURek9FZh26nN44IfuCc2VFCO7LWyW6NoyBlJ6YnFbNOd3u7TA4cF+eUJseFaDVXr167eTeRvqdrpKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790750695; c=relaxed/simple;
	bh=TML9Q7hytY92IHkv2U6wNoTEouaDhtAnORwVoeis380=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GBBG1pkXtwxsQlmYPcarT0IwGnKCCa5MA5zpT7P9Z62tbe/lbZX/uAyOWEEh0eV/Gy8sqeaIvn2HGYIo5+2xy6A0STMrbkXWi+FsjCimnrDXtvpFdifBR60cV0q3c78a4/OQkUP2dBxANtC/MdRhczOX5ilXKO6jyGelMl7jtW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no; spf=pass smtp.mailfrom=itx.no; dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b=aiw3+xmI; arc=none smtp.client-ip=91.189.121.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b="aiw3+xmI"
Message-ID: <ca018424c1e299520568a24ac04151fc55c9a685.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1790750669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TML9Q7hytY92IHkv2U6wNoTEouaDhtAnORwVoeis380=;
	b=aiw3+xmIp/e8LtN+dAjYTf3LU+SQg174Np1AxYjLSsE4bZ5yoKLZRN0noRP/nKgv+4LZyL
	gqmYVrfye4tHt7d7z1tAQZgmGPGCg8o9st72cCcnpUwczKEprYS84TH/uY8Kba/kyn0B94
	2vas/aeVHQhYcFxXaHrSD1pqCXNM4+8=
Subject: Re: [PATCH] lib/crypto: sparc/aes-xts: Add optimization using the
 AES opcodes
From: Stian Halseth <stian@itx.no>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel
 <ardb@kernel.org>,  "David S. Miller" <davem@davemloft.net>, Andreas
 Larsson <andreas@gaisler.com>, linux-crypto@vger.kernel.org, 
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 30 Sep 2026 08:44:28 +0200
In-Reply-To: <20260929225722.GA1921@sol>
References: <20260929211218.4194135-1-stian@itx.no>
	 <20260929212459.GA2843629@google.com>
	 <a166f1e004b8c2d859232d87a3745f5faa480607.camel@itx.no>
	 <20260929225722.GA1921@sol>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-dOsqCdaP3G4smrrZXt7J"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


--=-dOsqCdaP3G4smrrZXt7J
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable



On Tue, 2026-09-29 at 15:57 -0700, Eric Biggers wrote:
>=20
>=20
> It's in v3 now:
> https://lore.kernel.org/linux-crypto/20260929222752.36427-1-ebiggers@kern=
el.org
Thanks, I will test it. Should get the same results as in 7.2 on SPARC.
>=20
> > For 7.4 I could send a v2 on top of it that takes sparc out of the
> > suppression again, without the Fixes: tag.
>=20
> I suppose.=A0 QEMU support is normally required for new crypto library
> code, so that it is actually testable.=A0 That would rule out adding
> any
> "new" code using the SPARC crypto opcodes until support for them is
> added to QEMU (https://github.com/sparclinux/issues/issues/77).
I will have a look at this issue.
>=20
> I might be willing to make an exception for AES-XTS, since otherwise
> for
> parity with the "xts" template the library would need to gain an
> implementation of AES-XTS on top of AES-ECB.=A0 That would be annoying
> since it's inefficient, and SPARC is the *only* architecture that
> would
> need it, as on every other architecture AES-XTS was optimized
> properly.
That would be appreciated.=A0I'll see what I can do on the qemu side, but
that probably won't be in a release any time soon.
>=20
> Anyway, I'll be migrating the SPARC optimized AES-{ECB,CBC,CTR} into
> the
> library too.=A0 I'll need your help to test it, since it's completely
> untestable for anyone without SPARC hardware.=A0 (And it will soon the
> only arch with that property now that even s390 is being fixed...)
Just say the word and I will test it.

Best regards,
Stian

--=-dOsqCdaP3G4smrrZXt7J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCaryvzAAKCRDoeAEuJe36
VlQhAQCEr+u7WrL7kdDAx6es7SdhYErLBPydqnVSmgImHyKLugD/fYdPUyuN0h7E
8nw+5l4jkYoydJMAUNIFG4BSV9kszAQ=
=BgfU
-----END PGP SIGNATURE-----

--=-dOsqCdaP3G4smrrZXt7J--
