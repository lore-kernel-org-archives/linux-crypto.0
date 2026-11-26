Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795726612;
	b=FIBZxIw7EDBieHVHYA6x0WjWxbK1X8mjdw6n72NB3Y59iG9G96LxFNujcYp6tNpU0+TJ
	 +k4mQGDDst3uEvK/Dc1LkMH7U30vuyvZDYvKEuLq6U5y5gMe5kO2mGUWwWUuj4Id/GzRP
	 ZRZHolm6V6/kLd2YVEJcy5pL81D9wwZVEJQ7W658nhcKP3Nu6NO5/xK7lvv/CZMpzqjhZ
	 nau5pIeQ+Du4z/8ZNEM58VgcBDGmZSjq9MZKMMpccH6CKD98nlruirwtLOMW9X0jqq+vH
	 tVsBN32WFK6q1ZXFJLEUxdAKWi+FywZ70YBDAMd2wJyawZ4ykedJyVFAOW3jcjD9TnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795726612;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=J2xOUqGDpOcUOu3sLIJBbDevE/Rw3DN4OPxbPxhIrBk=;
	b=1p+UCmG0W6TjE5Jq+KbXVikILk6ijrmgbdYlnTty8zI4GLuHZtrI2eLtxOG3E4gIJbzV
	 +eCjGRz5tKdYTMQlI6q4ch4NNGM1r8plXrZJComthMUXNhLKUdLulAHZDYhnKrFxwGEQ+
	 0/JaSeGxGLcXrFrnjA2YM9ZZ1YRObElyIj84O7l+GWXVDhkqqLnocDe3sOoYHc8jSNWKC
	 VExu9lbQ+0eb1+UVoDAuy05yumNZBkGfA9l61Dd9IEKAgufuibFceu1fuktpVGDQcH1GY
	 z6tBoe4J0DatdTUK5k4mTT+dnISTCdaZJDQnVk8cxDsGPRRIEkPHyBy5MIBFamOWtZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SvYTdyRr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B32606A31C;
	Thu, 26 Nov 2026 20:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SvYTdyRr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CCF1F0092C;
	Thu, 26 Nov 2026 20:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795726612;
	bh=J2xOUqGDpOcUOu3sLIJBbDevE/Rw3DN4OPxbPxhIrBk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SvYTdyRrp+O1ghmvs1+98tTSMy3dwiD609/o/78PAd8DLkLZV3Jlxy6xbq/ovG8Q0
	 IdLEchtXfCCJtDmJXhrwjYwt6WTCjfzYOR27anQeERzGkIQE5Cr66MipEF3TBU7/99
	 ZZViuBFu63ZzeNnu9bcSpceh3GqFy4PtLzErz+aQZ/BoGx9OPQjA7Q3S+SPxKHnbXp
	 9VYBMzosFKH8egrbOxfqijpHMpONqU96C6kzoe9MNgaE/Y6t6xJ/FWuFD82M8yz3C9
	 AJR0mDNRpamBQRZgmuEWB6t4JeGl59po7ZgBzAXz/PNgGukceB0hs6m1+hntGLCwNe
	 nwvGnNPYrYfIA==
Message-ID: <sashiko-outbox-236180@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 03/11] KEYS: trusted: Validate public_len before
 reading key attributes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>, keyrings@vger.kernel.org
Cc: dm-devel@lists.linux.dev, linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org, "Ahmad
 Fatoum" <a.fatoum@pengutronix.de>, "Alasdair Kergon" <agk@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Benjamin Marzinski" <bmarzins@redhat.com>, "David
 Gstir" <david@sigma-star.at>, "David Howells" <dhowells@redhat.com>, "David
 Laight" <david.laight.linux@gmail.com>, "David S. Miller" <davem@davemloft.net>, "David
 Woodhouse" <dwmw2@infradead.org>, "Eric Biggers" <ebiggers@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "Ignat Korchagin" <ignat@linux.win>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "James Morris" <jmorris@namei.org>, "James
 Prestwood" <prestwoj@gmail.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Jonathan
 Corbet" <corbet@lwn.net>, "Lukas Wunner" <lukas@wunner.de>,
 =?utf-8?b?TWFyZWsgQmVow7pu?= <kabel@kernel.org>, "Mike Snitzer" <snitzer@kernel.org>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Mimi Zohar" <zohar@linux.ibm.com>, "Paul
 Moore" <paul@paul-moore.com>, "Peter Huewe" <peterhuewe@gmx.de>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Sumit Garg" <sumit.garg@kernel.org>
In-Reply-To: <20261126205021.2200819-4-jarkko@kernel.org>
References: <20261126205021.2200819-1-jarkko@kernel.org>
 <20261126205021.2200819-4-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 20:56:44 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] KEYS: trusted: missing Fixes trailer for tpm2_load_cmd() bounds
  check
--

commit 3494ad506e5fb0237e39afbd811ef50539770763
Author: Jarkko Sakkinen <jarkko@kernel.org>

> KEYS: trusted: Validate public_len before reading key attributes
>
> tpm2_load_cmd() reads the 32-bit objectAttributes field at pub + 4
> without checking that public_len is at least 8 bytes. Reject blobs with
> public_len < 8 before dereferencing pub + 4.
>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

[Severity: Low]
The unvalidated get_unaligned_be32(pub + 4) read in tpm2_load_cmd() was
introduced by commit e5fb5d2c5a03 ("security: keys: trusted: Make sealed
key properly interoperable").  Should the commit message include:

  Fixes: e5fb5d2c5a03 ("security: keys: trusted: Make sealed key properly i=
nteroperable")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126205021.2200=
819-1-jarkko@kernel.org?part=3D3
