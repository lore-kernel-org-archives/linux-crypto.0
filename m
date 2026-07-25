Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328DE3F8EB7
	for <linux-crypto@vger.kernel.org>; Sat, 25 Jul 2026 17:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785001100; cv=none; b=FH0A2vCqq1T3R8uZHdh/Mibe9ArRaq3oXMt6958QhBBU1sPKHBGAwb0OvSaIdpFMuMEMzDDGJFoAy4OHmYu/eFOJPHlKoy5LSUoFJxEwtEa9AMPE4SMON+C7Oj/+xZ20xXHSSBU1zDw1t8YCKzx2HaYHdp1BmH0cSVS6LppvOvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785001100; c=relaxed/simple;
	bh=pTp18fyAAM/0sN10DjiOcE3NuT0ohGx2OknY4w/Sn/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nVoLeNH3c2DPtFzGjnbWJU269a9ssZmIeV6qt5ML1VHHpYhs0nX4y2MzusbYspGAkxPBimhhK931ZLp471uFx84mAIi7a9qpvy3prtGcF3JgKPGq/vSTvnbOuR6BmaFLzsE3XiAivozAlYGj9FkxdLfS66F9y+S5Kc+QCieyI90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b8oaX60L; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b8oaX60L"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7ff05e5d009so13141887b3.1
        for <linux-crypto@vger.kernel.org>; Sat, 25 Jul 2026 10:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785001092; x=1785605892; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TsABodENPiu91UKwsowi36mSYBdIiGJTh+xQVG4w3D0=;
        b=b8oaX60LDz+pZFmtR0hsYu8rr3OmDtJIOLInup+VSr/UVdasnkG5dUjmTiKAfYBPQ+
         tmuo7OFlRlG5mh705zXeEWwVhJ6layShPihQBvgLDmtH3tEZtDsAJw5TOdbkLkI8AVqM
         F70IFgM2kD1pe7j6nKiofRO+2+GZ7vIbhk9FT2C1fkkQM0n/1iXY1u14c/HzwSHKxhTa
         SkiHf+8yna6bdFJeEopmmvTFst+iLj3e34uVoUhOIWI0P/j7ji91DFooVFtl9jgOTyxW
         JZQjaGiMFFxSEzo0SplSEGdkQMntTMWsh3LeoaVprJxRddbMTBN8b/FfpGrOoYZ9cZ7g
         NwLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785001092; x=1785605892;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TsABodENPiu91UKwsowi36mSYBdIiGJTh+xQVG4w3D0=;
        b=oOZE8+KyEt08SgeEffzGlz0B6qwac9MzKtlpRI2aYBMPW+j5/T8TNbKw+WhXY9G1mY
         3+IYYm62p+g7qCUZeyJKFOsmo8Zvyr1xwWpVJ6N/5iYmfeMvw60WFdroth+qCI43l341
         yzWHgkGv0F+c+fxKL70tg1Aud9pAIstywsJ10sDIlEbgV9gHXZxeBdFmgwVwSlOBH7/N
         s37zd4A3rY6dHOgzR6ueQEXWNYZtWWouNfm2n7LTEDZ+URx47HWQ1JAwSbQqaxLcB1vQ
         Xq9UIEL0ytW48HBjIH+cDBBz4+01thLVhQt2yzOP2ngaR7O1+3BSzLzOORskUjdoZfj0
         z72w==
X-Forwarded-Encrypted: i=1; AHgh+RrkXcc1FRocdXbYaapffPafZGky/LwoZmMbYTaNJRZcqpmfYv/J16B+gA8hY1pgurZcA9lfLrolguLAXx0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzC1q22rOtdrpJaxTckOlFqSw/OOdfb/+lnBW6fvFAouHF8CYv
	U1T0FOsAFesDY/2sYYEljOUD1NZe47dkwGbUs+9J8N6DZJVBtADZOMO2
X-Gm-Gg: AR+sD10PATErylJynkiE9JvhqverQrv1on99GHy9ySW5x/2jt63YNTs3ZdJO+yranwv
	FiSb5lqCPqF6+NaRNzAwQiGuDQ4c2FOwYhsRgWo4LxjHsJEwxmyb3AxKhjoioPYuyz4ZALLb/zU
	siIfCKcnvKwRCXvC2UwWqVWgwnPZb2k6bP8fNtwOP5gJPMGFGN94FYGplm1OBai7J/yp7BYz8CY
	O0qz/RxtJA67xmCYzIgKGKMNUBsU/FgwZTj4VGHowVnTdxHF/IcAVjY4fL8JHbVRA9E4AfnEWau
	Ym7zQ/B68CYtTj3KBxt/li4jwN6ZbOpzpO9e75GIdWCGcmQ+pRD3+Uwn7Z1ledhzktYAJwKNn2G
	CaujdLqpRJMFBNuRRqdiw8Y0YIra5o5Dyy7YdxY1wNzb+iFc3f5E9FgHBlwcmpwZ6FCMREsqeK0
	cCnNm6
X-Received: by 2002:a05:690c:692:b0:7dd:3463:6872 with SMTP id 00721157ae682-81f69e2f21amr10154877b3.41.1785001091612;
        Sat, 25 Jul 2026 10:38:11 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f6576ee52sm13270607b3.3.2026.07.25.10.38.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2026 10:38:09 -0700 (PDT)
Message-ID: <a7593240-bb61-4acd-b7ac-3d50b6efed0c@gmail.com>
Date: Sat, 25 Jul 2026 13:38:02 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
To: Dominique Martinet <asmadeus@codewreck.org>,
 Eric Biggers <ebiggers@kernel.org>
Cc: Harald Freudenberger <freude@linux.ibm.com>, acme@kernel.org,
 adrian.hunter@intel.com, alexander.shishkin@linux.intel.com,
 ardb@kernel.org, axboe@kernel.dk, corbet@lwn.net, davem@davemloft.net,
 edumazet@google.com, herbert@gondor.apana.org.au, horms@kernel.org,
 io-uring@vger.kernel.org, irogers@google.com, james.clark@linaro.org,
 jolsa@kernel.org, kuba@kernel.org, kuniyu@google.com,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
 netdev@vger.kernel.org, pabeni@redhat.com, peterz@infradead.org,
 skhan@linuxfoundation.org, willemb@google.com, linux-s390@vger.kernel.org
References: <amRntEmCUK-8wXcw@codewreck.org>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <amRntEmCUK-8wXcw@codewreck.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Qav0WqtOq9GpvT00AbFXKs8Q"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Qav0WqtOq9GpvT00AbFXKs8Q
Content-Type: multipart/mixed; boundary="------------9woazU20l50m9dxJk2VCDnaq";
 protected-headers="v1"; hp="clear"
Message-ID: <a7593240-bb61-4acd-b7ac-3d50b6efed0c@gmail.com>
Date: Sat, 25 Jul 2026 13:38:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
To: Dominique Martinet <asmadeus@codewreck.org>,
 Eric Biggers <ebiggers@kernel.org>
Cc: Harald Freudenberger <freude@linux.ibm.com>, acme@kernel.org,
 adrian.hunter@intel.com, alexander.shishkin@linux.intel.com,
 ardb@kernel.org, axboe@kernel.dk, corbet@lwn.net, davem@davemloft.net,
 edumazet@google.com, herbert@gondor.apana.org.au, horms@kernel.org,
 io-uring@vger.kernel.org, irogers@google.com, james.clark@linaro.org,
 jolsa@kernel.org, kuba@kernel.org, kuniyu@google.com,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
 netdev@vger.kernel.org, pabeni@redhat.com, peterz@infradead.org,
 skhan@linuxfoundation.org, willemb@google.com, linux-s390@vger.kernel.org
References: <amRntEmCUK-8wXcw@codewreck.org>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <amRntEmCUK-8wXcw@codewreck.org>

--------------9woazU20l50m9dxJk2VCDnaq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 7/25/26 03:37, Dominique Martinet wrote:
> Thank you both for your time replying
>=20
> Eric Biggers wrote on Fri, Jul 24, 2026 at 06:09:51PM +0000:
>> On Sat, Jul 25, 2026 at 01:32:12AM +0900, Dominique Martinet wrote:
>>> There's not much I can do about the vendor's kernel I'm stuck with, b=
ut
>>> that doesn't make having encryption material not accessible to usersp=
ace
>>> useless as a concept;
>>> forgetting about the sysctl for now, what are the alternatives API th=
is
>>> kind of implementations could be based on?
>>>
>>> I guess I should start looking at how tpm backed encryption works,
>>> some other day, it's getting late here...
>>
>> First, we should remember that implementing hardware-bound keys via a
>> standalone crypto engine is a dated approach.  Inline crypto engines a=
nd
>> CPUs, which work much better than and are much easier to use than lega=
cy
>> standalone crypto engines, can support hardware-bound keys as well.  T=
he
>> former is already supported, and is already being widely used, in the
>> kernel via the hardware-wrapped inline crypto keys feature.  For the
>> latter, see e.g. RISC-V High Assurance Cryptography.  In the CPU case =
no
>> UAPI is even needed; userspace can just use it directly.
>=20
> Thank you, this is exactly what I was asking about - my background isn'=
t
> crypto and ultimately whatever direction is implemented will depend on
> $vendor and I'll just be following along, but I'll read up on this.
>=20
> "Inline crypto engine" seems to be a qualcomm marketing term, but from
> looking at their doc the API seems to be PKCS#11 smart card?
> Having worked on these for some other hardware I can't say I find it
> easier to use than af alg, but it's definitely something that can be
> worked out.

The Qualcomm Inline Crypto Engine is a type of inline encryption
hardware.  Inline encryption hardware is integrated in the I/O path,
so using it doesn't involve any extra copies or interrupts.  The data
goes from memory to crypto hardware to the I/O target, and from the
I/O target to crypto hardware to memory.  The ciphertext is never
written to memory.

In the case of the Qualcomm Inline Crypto Engine, the I/O target is
the the storage device.  On Android, that's eMMC or UFS.  I would be
very surprised if the Inline Crypto Engine was any slower than the
storage device connected to it.

In Linux, inline storage encryption is exposed via the blk-crypto
framework.  It works very well and is widely used on Android.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------9woazU20l50m9dxJk2VCDnaq--

--------------Qav0WqtOq9GpvT00AbFXKs8Q
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmpk9HsACgkQszaHOrMp
8lOjDA//WdudKCsYd4EOeGAM3aieLtjj76rGYztK+AN03rlrekbuRjKfdi5rGqvl
CBJlSGsY/t3sI+l7RcGn6/UrExCEIHyn1T4ZZCuoing0/W5vQHKUs3HHy4rITs5L
xjnIb07/dInn++O082yVF1n5YwLNLOmRApXFYwD6+aOFLM1wCuXrYKXWUdcTLRGg
PGExszD2QPJKA329UZSfP/iM02svhONaGXioEyTAbJw7aIUErTWFMt90Di1z8Fj5
51Fvkj0YawiQXNg3+YzSC6mJCeTWuZy8R5OEYc5BSDN4cakZyiaG2cedKGZNJMfB
MAcCsNov4fqgpuFeglR5eibzZpy0a7Y2nj/LKQkjQeoHNloYm5XGFpHA0TL1ryLj
gJNBn28DolzkwoOj3y5bcCx3wMNNujjh00yPmvaewmDMNDQuqcYTs+udikfc8lap
GhIiR9zpctGfoYQFRbyoUw8MFN3I5CllKcMkqQtDtCIcgA+UL8NbqYSRIth90p2c
WR0vpZHL1OdhlaVEo1PTNN5OWuThQPUoQCBc6/bQbb/bGAboZLKRRDiFfeIcREat
6j8+oB6mLtGB8+vZVgKW/NaKjmRG0yxJ3i5vRA+IrXskQH6ya2yFpwVT8lTMnvOZ
hz9A6o5cnQKH+mnhG3IUUAC0+KqM2dcBoNbyvzp7JUzpvkcy2no=
=M8sN
-----END PGP SIGNATURE-----

--------------Qav0WqtOq9GpvT00AbFXKs8Q--
