Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FE6442118;
	Tue, 29 Sep 2026 21:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.189.121.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790717643; cv=none; b=MGnxDLpD7Yt31coxXta5eFZ4/0VzK5IO7cqDIihzwSjlxRGid85h6C+SHRwqNsldRyDu/5WrxGBsMrWI8C+kHAiB7PKEwOhjoBZrVI/T7GlSlUCz/LYoeyN3VsBX/Ko09j+pk0MOVtJrQVP75boj5HW4AueuhLmc8lOBsbIoLiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790717643; c=relaxed/simple;
	bh=Ge0W6isjSZHKFz3Dz+lxvrUe0hZDMWo2VAUPd1CeKMU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HYfI8kbfrZQDCSHw/tp3i0ZL7P++RNvF1ADTkRd+9FrfaBAootUtA0IOeNvQWfyJXaWIXWYTC3fvdIs8z4rE89/Bitcnl1K8WTg/JS1qabHlh/wUJLFNrSI9On6fHXrBX68sA6X+qAdTgdfLTmS8TNniFc3QUMct9H/Lm17xdpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no; spf=pass smtp.mailfrom=itx.no; dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b=G+9kw9Au; arc=none smtp.client-ip=91.189.121.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b="G+9kw9Au"
Message-ID: <a166f1e004b8c2d859232d87a3745f5faa480607.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1790717639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ge0W6isjSZHKFz3Dz+lxvrUe0hZDMWo2VAUPd1CeKMU=;
	b=G+9kw9AuRahZqkbUP+qgtfCWoyqxsuOAO5NE6oB4QodvzZgGv3K/VzgMRm1JHpejeI3nN9
	RGZR/N7VmGSvcMWiEO14szMNQHNu3tKJMeI3gQ9V3n0Bo4v79jYWEpwFUJ6JpVd8d94jZ3
	XuQodDgB502s26E4A8w6UrLERip7h4o=
Subject: Re: [PATCH] lib/crypto: sparc/aes-xts: Add optimization using the
 AES opcodes
From: Stian Halseth <stian@itx.no>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel
 <ardb@kernel.org>,  "David S. Miller" <davem@davemloft.net>, Andreas
 Larsson <andreas@gaisler.com>, linux-crypto@vger.kernel.org, 
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 29 Sep 2026 23:33:58 +0200
In-Reply-To: <20260929212459.GA2843629@google.com>
References: <20260929211218.4194135-1-stian@itx.no>
	 <20260929212459.GA2843629@google.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UaTXyDK7ReIS5hICzEGK"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


--=-UaTXyDK7ReIS5hICzEGK
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Tue, 2026-09-29 at 21:24 +0000, Eric Biggers wrote:
>=20
> It's a little late to be adding new optimized code in 7.3.=A0 But yes,
> full AES-XTS performance requires that it be implemented directly, so
> we
> should add this optimized AES-XTS code in 7.4 (assuming people still
> care about SPARC, which I guess you do).=A0 For 7.3 let's just suppress
> "xts-aes-lib" on sparc.=A0 I left it out of the patch
> https://lore.kernel.org/linux-crypto/20260925202353.10763-1-ebiggers@kern=
el.org/
> , but I guess it should be included after all.
>=20
Completely understandable. I was considering sending two patches at
first, one to suppress "xts-aes-lib" on sparc, and one with the
optimized code.
=A0
You're adding the suppression?=20

If yes, I can test the suppression on a T7-1 and a T4-1 when you have
it.=A0

For 7.4 I could send a v2 on top of it that takes sparc out of the
suppression again, without the Fixes: tag.

And yes, we really do care. The plan here is LUKS on NVMe on the M7 ;-)
SPARC is very much alive and kicking:
https://github.com/sparclinux/issues/issues

--=-UaTXyDK7ReIS5hICzEGK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCarwuxgAKCRDoeAEuJe36
VoFZAPwO6t1F+LcKuPPsNKhauH3c4At3Z7vZ0h5NuDJq9rkdsAD/TCKpIvyT0s2m
i+SkWtcue4LGi+MNg0Qj2nLuHGAIgg0=
=ZEiJ
-----END PGP SIGNATURE-----

--=-UaTXyDK7ReIS5hICzEGK--
