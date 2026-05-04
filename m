Received: from mail-4317.protonmail.ch (mail-4317.protonmail.ch [185.70.43.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D5B3E5599;
	Mon,  4 May 2026 18:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777919181; cv=none; b=qwrJ2ugeEVJIU9SWeswXGu5kH3T12iE7Hi5UsGTbpXVDv0wBYeBU4Rh6R8HfIT6+JD+J7poZ9LVN6FdvVzyY66MNdK5sEdpPXXhqofTNiw5g1GLURia8WPm8RnKlKFMlxE8YHMHQO9fNRfDgITIt6LC7BZ7ivzlbS7KHmWEj7HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777919181; c=relaxed/simple;
	bh=UaOnLB4kzFhagkSo1mRsv03uIvRALpIaTJO2y/9URNc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B/pfxwxoBV/Fd4zNKK1zvtdAfPXaArAGGAgPKQm4BfAN2fDiShp8diJOl3IqSVCqHCUX0ZKImH49xQsl51ME+WyzmFS/WsC7q/AAsUJw/WTCruCRGZ7HgYFA3qKDgDEc/Atij2vdOw3sIfTNtvD6ZuboEveN/qzh6zaANg3pykw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chesswob.org; spf=pass smtp.mailfrom=chesswob.org; dkim=pass (2048-bit key) header.d=chesswob.org header.i=@chesswob.org header.b=IlH8FO8n; arc=none smtp.client-ip=185.70.43.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chesswob.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chesswob.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chesswob.org header.i=@chesswob.org header.b="IlH8FO8n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chesswob.org;
	s=protonmail; t=1777919175; x=1778178375;
	bh=PR/X6lI251CoSCFQrPjdszYhdQtxyE+I9d8XZnIz22c=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=IlH8FO8nNRxMDkS/MOeqT85jDT0d18WjtJn1QiHbWwYgoqUH2UEduRf5FE+DnCuYl
	 f47MkJYeGe0fGdQaDIJKlkT73v2gXMbOV6qNi51kx5a9pYOrtLrejk9hkJ9UMPfqGH
	 VyMYrfxA/W2Y0152EXCZ7HH0cpw9iS1SSKZR0NWPs3MYFrOIDBVKltQ0vyCZ8p5yX8
	 +FciicrpHKTOv8ZOz93BA5K0wAwtTcqL8J3Sh83eETmwSXJCvVWp2csKVUykDYDsQ8
	 I9/uZwuss27Nnn/+Fc39MlJZeO1lekeKODBtfgokyN+oevtMBS9VVOfKR1ijrQhT0i
	 Md2yvIMA4dFRw==
Date: Mon, 04 May 2026 18:26:10 +0000
To: Eric Biggers <ebiggers@kernel.org>
From: =?utf-8?B?4pK2bMOvIFDimK5sYXRlbA==?= <alip@chesswob.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, Taeyang Lee <0wn@theori.io>, Brian Pak <bpak@theori.io>, Juno Im <juno@theori.io>, Jungwon Lim <setuid0@theori.io>, Tim Becker <tjbecker@theori.io>, Demi Marie Obenour <demiobenour@gmail.com>, Feng Ning <feng@innora.ai>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: af_alg - Remove zero-copy support from AF_ALG
Message-ID: <xxEJMG_wLMObY-emZXfETJ6HxxJQCY3OnYiBIUTyAWEMiAcr8QQd2t7c8O-Qj43zBGRv64st0_IrW9ABgaVwco9-puLVlIDh3ijeJ-cxXaE=@chesswob.org>
In-Reply-To: <20260504174733.GB2291@sol>
References: <20260504061532.172013-1-ebiggers@kernel.org> <mCm5pwZUNYtOVDph2baJg3eAzArddjvFpx3Wwh2qiZfZXYtv-aUjlISuRg5HjuIMzGo51hxCazaH47gp9B_q7I4R4LVePKGkvhO9D0P4nCY=@chesswob.org> <20260504174733.GB2291@sol>
Feedback-ID: 36787097:user:proton
X-Pm-Message-ID: 1afb90c6cdb9a12d85494210882da516a8ac3d32
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha512; boundary="------53ee95e391c4beb67b725744ebc23dbf7c3afdadd1f8e30ba44010d800038c0b"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------53ee95e391c4beb67b725744ebc23dbf7c3afdadd1f8e30ba44010d800038c0b
Content-Type: multipart/mixed;boundary=---------------------ee818561bc99d6503c9bebfbccd26cf0

-----------------------ee818561bc99d6503c9bebfbccd26cf0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;charset=utf-8

On Monday, 4 May 2026 at 19:51, Eric Biggers <ebiggers@kernel.org> wrote:

> On Mon, May 04, 2026 at 04:07:45PM +0000, =E2=92=B6l=C3=AF P=E2=98=AElat=
el wrote:
> > Syd sandbox uses AF_ALG zero-copy for its Force Sandboxing[1] and Cryp=
t Sandboxing[1].
> > Zero-copy means Syd does not have to copy sandbox process data into it=
s own address
> > space providing safety and security. Switching to read/write rather th=
an pipes and
> > splice breaks a fundamental safety guarantee for the sandbox. Please d=
o not break
> > userspace.
> >
> > Will sendfile(2) continue to work?
> >
> > [1]: https://man.exherbo.org/syd.7.html#Force_Sandboxing
> > [2]: https://man.exherbo.org/syd.7.html#Crypt_Sandboxing
> =


> It's very unclear what that feature (which I don't think anyone knew
> even existed) is trying to accomplish.  Regardless, this patch doesn't
> break the splice or sendfile syscalls.  It just makes them run a bit
> more slowly since the kernel will copy the data internally.  So I think
> your concern isn't justified.
> =


> > How can i test? Please help me.
> =


> If this is a feature you care about, perhaps you know how to test it?

Thank you very much for the explanation and excuse me I panicked.

> - Eric
> =



Best,
Ali
-----------------------ee818561bc99d6503c9bebfbccd26cf0
Content-Type: application/pgp-keys; filename="publickey - alip@chesswob.org - 0x55838BF3.asc"; name="publickey - alip@chesswob.org - 0x55838BF3.asc"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="publickey - alip@chesswob.org - 0x55838BF3.asc"; name="publickey - alip@chesswob.org - 0x55838BF3.asc"

LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgp4c0JOQkdFWGppUUJDQUNvakdh
OTlKTnVENVFVQUxFeWNsd2Uxd01MVjVySmN5ZUhrM3NIOEVZTExsS2sKNm9wNlJ1bGhjUHdvMW5O
UmdXRkM4ZVBRaVNqMUpFRHFlRjQ3eXU5Y0xDU3BLeDRJWUVCZmxiSkwwcEI4CkpZdUk4NSs1OVE1
MXZaeUJuU3pTclBkcUdjSDM2d05wZ2d0N2lTcHVCVjk3clRWeE1ndHU4S0RtUisvSgpXQWQ2aWJl
UE93b3pnd1ZQV0VJY1NQd0FaUFlrcHJ5YnVCQkNWb2dmbUxLN09FWTNGMlozTzEyeGFHYVUKOGF6
RU5XZkI2YWJPVXM1ajlOaXJFMW5OV1h2V3FPSEVVa3grVmdFTUlkR2JTWWc5Y0dicDljUjZZZUFS
CnlpK0Y0MGJYMWZCS2ZVNFI3ZDVJQXY0Y2g2OTUxMDdrMW9qYmJCRjZDWFZ3V0tSSzBlRng1Tit6
QUJFQgpBQUhOSldGc2FYQkFZMmhsYzNOM2IySXViM0puSUR4aGJHbHdRR05vWlhOemQyOWlMbTl5
Wno3Q3dJMEUKRUFFSUFDQUZBbUVYamlRR0N3a0hDQU1DQkJVSUNnSUVGZ0lCQUFJWkFRSWJBd0ll
QVFBaENSRE81K2JkClErS2JzQlloQkZXRGkvTXNPNG9Ja28wR1NzN241dDFENHB1d2ZRRUgvaXpy
ekJkbzFGMHhYRjdNdjkzVgpkS2xFbWxlVk8rYnVjdU5hb2huNzFCNnl1SW5EM1NLYUM1SHF0dENK
MFlnNEYvQmIwdDlVYjBrWGkxOFUKRnRKU0V0TmxpUXJRTVJLZno3cFVqTHAwWkR1Y2xlaDVKUURs
ZHVZYlBVWEdGRDdnNVN6M3M4OXJuYWdXCnFKZkdxcWVlMWRDcXJYN0l2N0xwU2ZVbDlLdzhwSmRG
aFlsby95RW9SLzVnM2k1Yy8wOWtyaDdSUmk0agpPdVBteFMzWHN0aTVRT0x1U2JFUFlhWmhpZnZn
R3JOcVRyUTY0QUxDSjQ2Q3ZrQVQ0UGptWnpncE03cHcKeURQNEFJM25WRDNSQ0U4SHY3SjR2TmdC
Z1dvL1hKRlcyd0EydUFJV2xzbTd1eFNjMWh5OFVLVzFnTVl4Cm9PM1daeGl0TWQrMk81L1VuakRB
MHovT3dFMEVZUmVPSkFFSUFLOVF1b1pvNnloYlAvTVpvNDZnZjY0ZAo3Nmc5NE84VnJ1amxwazVE
cjg3T0wvVGY1dS9XMVRiZWhCYWppN0s5Z0NLczlVZUtUYldyanVlRnltSSsKY1lGMzZiclIrVFgw
cjFyMGRRbjl4Y0M2UnRDNDArV3lOdER3dTk5Ym1VZkF1dnJ5QmdOOW9aVHF1azlFClUydEUydjBh
ZTQ4MzU1L3AwQmR4c3Z6SmNPTW1FWENDZUpYcUdQa0Nrd3Fnc3JxazRTVHFQS2VRWTZXcgpOU0NX
cnE3WTVVYWVJWXZaUm5kMFRjV0ZLWVJLbk5XNkI2TnplZFdjRGJRazV1OUs2RzN5SS9vTy9EdzQK
a25PanVCWUNBa1Vodzk0M1ZwSi81N3RwMDFzd2hjdjVlcHFCYUhLNVNSYTg4TytOWUlRODdNNE5m
Z3lFCkg3Z0lDY0RTT1lMVURUM0ZmN1VBRVFFQUFjTEFkZ1FZQVFnQUNRVUNZUmVPSkFJYkRBQWhD
UkRPNStiZApRK0tic0JZaEJGV0RpL01zTzRvSWtvMEdTczduNXQxRDRwdXdiNmdILzNsaE8wdFJm
NTZrOG5Lc0hQZ0wKWHlVTUVQZWtoVFVMdG04RXFkekozSkhMUTJlNFBxWTQydlJhNEdEUzY5aVNL
UVR6UlhvdWhQWnBId2tCCnpKTk4xK3AxQ2V0LzNiRzJza0hlMkxwV2tGVVBad256MEE4SkZFMEhr
RmpZcUVLYXk3ZUs0LzIxTGhKUQpCZEZUSDMwbVBOMytiMVU5dmtOblBPY0ZQbHhmbmNzekk2Rk1j
NnU4dnYxNDc3SkFJcE0yV0pQcXRkUWMKSncvT2dHcjFaRW5OWi9icktWK3RQeHlEdmxtUklsQTNI
TnlyN0Q5NWN2bFlkVHl5emcyb3dFZHRMa3dlCjI0eUNUbWdHNnVoL29SazFsenFYcWZHaEpDYVpD
Zi83MlhpcWxSaDFRUko1ejdIM1NMcHF3MUszVXlQbApaNHg4NTliSFJMODNXeGpiR1FLMU8vMD0K
PXNtSUEKLS0tLS1FTkQgUEdQIFBVQkxJQyBLRVkgQkxPQ0stLS0tLQo=
-----------------------ee818561bc99d6503c9bebfbccd26cf0--

--------53ee95e391c4beb67b725744ebc23dbf7c3afdadd1f8e30ba44010d800038c0b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wsC5BAEBCgBtBYJp+OSrCRDO5+bdQ+KbsEUUAAAAAAAcACBzYWx0QG5vdGF0
aW9ucy5vcGVucGdwanMub3JnrosanUaATdxv1zvo0qqMcwbspCcHHKdd4kfq
6DeKiE0WIQRVg4vzLDuKCJKNBkrO5+bdQ+KbsAAAIHEH/3/LRUM9YzeL2cmV
rZsH7dsmYchx1e1fn/MJqKGBohTKLslPS5VUPN5sTBTd8ZvRNrBZkvSNlLDJ
18YxPbLJGFtwHYOx/SPTrh85Cr18gas+fKOwqETAnHQ/liBnLUcW2q8si/qs
KVDr2DZ2qhOarTdC/Eu/zqJplyJTonWebmLbZ9VA/RcL/SWlwRNO9gaf9yjp
aCDVwAmkuqUP5BoR5JvgsZlDIgybAH9DppF7JK7xM1iU102DbHMNHP5W72VN
RLCBGzeutWa9HWCcHgkCizSoRE8B3+ls9w/QB8y9SDHSDvk6Ewd9c4VAdw5v
a/IxiVHzooDo2ip0tHT8XfZKHjk=
=wfTi
-----END PGP SIGNATURE-----


--------53ee95e391c4beb67b725744ebc23dbf7c3afdadd1f8e30ba44010d800038c0b--

