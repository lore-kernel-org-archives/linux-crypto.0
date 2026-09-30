Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3964E1C76;
	Wed, 30 Sep 2026 14:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.189.121.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790777258; cv=none; b=poeVRXa9vsqJaZ+4Rxr6Sk5lFZULWbUcR5w7BlQYRJXf5UsQlN4ccbROHn6Q3y+Gq4HSrokm2FsFbCLyWjRTr68Py5OA3a1Z4pJ7d88sMSjRLTg8lb7OYvXHl39Hu5vdkAr0yCl4XWacPQjR9ob3ySkv+GbeUzuzh1ktbwb/JT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790777258; c=relaxed/simple;
	bh=UR1FYXTCZno0IO9mC9Ay76HwKoAD5Lif6Ovla1A24dQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IZzVhpQAn8jT3mFj5dSh1dqhZpRczTura6X/Td6s4SJ3FJoxLIySp5Jxl0RqFr0GacWdmbAxhGP7lzeelxQ9q9mQO5cKyZrtB5MwJ3sc15Us9QqDWq1qrrPdBxe3D5WaSVnZvcD/c86qCca/40Jh+PZZQ4d2tAJT2fpnORi8I38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no; spf=pass smtp.mailfrom=itx.no; dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b=a6lveC1q; arc=none smtp.client-ip=91.189.121.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b="a6lveC1q"
Message-ID: <8d3d3142d1ac323695a3ea2d5b3e2a10d2a129d6.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1790777237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UR1FYXTCZno0IO9mC9Ay76HwKoAD5Lif6Ovla1A24dQ=;
	b=a6lveC1qDPDDJIiSdO5KTXwuu9YoeAz1TXd+1xGN/GXB62++pC2UVOYPb/QVyAiD14NGoy
	2nSvodFfsWy7SGKrTwuKN9Y7Ne+wNfEW3Pm4Mk+NY6gkpwB1OiKgFaK+SOhaLR8qIqhS8K
	uKaRf29YesB8d0J0u7at7cTcjhiTPF8=
Subject: Re: [PATCH v3] crypto: aes - Fix undesired override of some
 optimized AES modes
From: Stian Halseth <stian@itx.no>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Eric Biggers
	 <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A
 . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 sparclinux@vger.kernel.org
Date: Wed, 30 Sep 2026 16:07:16 +0200
In-Reply-To: <3ea57d640ac7409fa37b15ec9e3f49126347e432.camel@physik.fu-berlin.de>
References: <20260929222752.36427-1-ebiggers@kernel.org>
	 <322e5255353e3a5f9e3840a496018edd980fb016.camel@itx.no>
	 <1f85bdb9614365fedda81fb649147da48bf7be13.camel@physik.fu-berlin.de>
	 <25c7a7c7bbe3c7f70fca559867e0883b9e4dc48d.camel@itx.no>
	 <3ea57d640ac7409fa37b15ec9e3f49126347e432.camel@physik.fu-berlin.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VqWkuqblbEmj0x0qk/l3"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


--=-VqWkuqblbEmj0x0qk/l3
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Adrian,

On Wed, 2026-09-30 at 11:27 +0200, John Paul Adrian Glaubitz wrote:
>=20
>=20
> > The T2 and T3 has a separate crypto unit, but not supported here.=20
> > Support was removed from the kernel in 6.14. Haven't tested it, as
> > I
> > don't have the hardware.
>=20
> Why was it removed? I'm not happy about such removals as long as the
> hardware is supported.

Looks like there were issues that prompted the removal:
https://github.com/torvalds/linux/commit/9cda46babdfe


>=20
> > Also worth noting, it's only used when the firmware lists the
> > machine
> > description's hwcap-list and the CFR has its bit set.=20
>=20
> Is that not the case by default?
Yes, on real hardware. Just mentioned to clarify that it doesn't cause
problems on hardware that doesn't support it.

> > I have no idea about Fujitsu's SPARC64 X family.
>=20
> I think SPARC64 X is not supported by the Linux kernel at all, is it?
>=20
There some chip detection for it, but I've never tested, or heard about
anyone actually using it.=20

sparc64: correctly recognize SPARC64-X chips
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D76950e6e54ccfc98a25b501dbb1bc879cce1aa29

cpu hw caps support for sparc64x:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D4e96377983d2e060dd89703f1846ad920af9e17f


--=-VqWkuqblbEmj0x0qk/l3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCar0XlAAKCRDoeAEuJe36
VsKAAQCAKHEc3I3iV4J2N1yMuV/RBUbp7izMvwDTmUKG5m0yTwD9EP7hn8upDIfR
p+Yt/HT+UlKC8HVMELF5LHLZgv7GQAw=
=2Rj7
-----END PGP SIGNATURE-----

--=-VqWkuqblbEmj0x0qk/l3--
