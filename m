Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F5535AC3B
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 21:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786654836; cv=none; b=EMcaDz1tP89E/G62wIQ9rkYpFQsz6q+AbaIdD5l2sqwigLr4noXNbsJLlQiDnfLtooXrQ1u17+OKIzOWOZguYKDnwnXLoq25/E95gcMAf3/eZI0uEfNocSPeaPH11xU7eTXnzR05xTtDnKS1DhGzVU8kkenz6TfWDtGSR7eWl+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786654836; c=relaxed/simple;
	bh=xFh0LEFN5aA14PaaDCQax5Fc0m8M2bX+My6L5MkIHX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oIT9shL5uZL8lQgAZlRU2ahpJ3rjmKJmzps+OwsgocX8/UH4u+/RomaVUx0Qdbuki3X4sgHx8TrcqtHivrpsdWOuBs2bctq8h0x8MUxKvD0xLWsRk2O09siTluHvua4UMtqn3jO3W4vF5R1cn5uzTmm6J0F6uzUDEHVBnNsn5ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=igQWrDTg; arc=none smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="igQWrDTg"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6689f36ae56so501287d50.3
        for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 14:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786654834; x=1787259634; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tvRQMeAfCmjXcZS+zU44bmjL4SnioTG0skf7ZXnNUTk=;
        b=igQWrDTgAI5R0424DOpANTXl7FswSkPc8D5vbPYOMRn9cGSzn1t1QQzdsGnGQ5Urao
         FYhDf8Yvh57yQbpfw13Mbo3lsdWTM/+xiI3/O0ZXDYXmT0auAZaZYUbORf4BDShVKk+3
         QbOR5wHgRLIbA1fML+wnR9fbiWg5ZMxi+lFY7SX46yKX+OGNyIav1YctQyZpYwyrGmtJ
         p54c/7KJi7ehHBwx68CSlah9p1NNu7r3ERcgu2v/zC966vfJGaY33FNexAQx8M0h6YOk
         nQKKcf8r0conDDriGJGwEzYhkSTle/lwZFKZ8PItkMIHig2iruva52vOao7DLMnxZHit
         P8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786654834; x=1787259634;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tvRQMeAfCmjXcZS+zU44bmjL4SnioTG0skf7ZXnNUTk=;
        b=PaM7xHvIBwRNZz/tXX0qWVN8p+4kaXUWiX8Saop9xtlwqXAcGIKR6qu47UML+GNkej
         lsqRR4FijKsNJiQ3WmbXgK9kwVYZnCbXv5O4QY1V9z635sEE1TqvFs+Vd2Mok1tIsxC6
         3yPBjC+gUxlNd3VSRtUwdtrth2mhpMrPHoE63ezJA/xTYGQYvn2fpaLQrMIqz5sVB+Ij
         kH+5zFp61qiQW9btbPLYRhI08ezNu9hqhhpiqqyQrjmuUMOmNSfCWKko+79QalV3fahm
         q0UTsClNhzb6pmng7QQ/UKmgSZ1tvd9253AaqFE5my6HYEhazya7hPLBx92EQWYScs5Z
         louQ==
X-Forwarded-Encrypted: i=1; AHgh+RoF7C4pLEO2otYLthqoRC+MlMG+8rfLUeTroNSaQQSAhNSJC4nv/IoMnDAz7ptdY6JAsHSiHiYe/y4jUmw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDwlAkHtICmAS5h5ZTkuXECJOVGnHhM7i3coMrEXj8uJ3QchwK
	LuAxKYBvqK4PGvcMC2s6NtNCOeukJd7U38HJ6SXQZI2nuATBHjI7LYji
X-Gm-Gg: AR+sD11Ip4SLeK4o9fzPOD0ipXLiFaYKQ4AvbFd71el0N5PAhwlHSXuF/MwJjSPj8SH
	/X398oHdA4F97DsADPOfNsYO1vJLbAdbq8KBgXxu8qNE2OT5iwi+iTFN7POLcu0RuSK3pX5e8bJ
	O4bQPGhAAePHcrbHYr89kKkd8esO284Si4AWAHqjLmQ7GhpdINnhnB+Qgy0VRonNwjN76UK+1gw
	AnerWraDkq2U4UAykn8bxSXeIUI1DZUnY7tnFmQRfuS+4OpShbLCJQLEiMTf5Mh+sACDZvXPA6p
	NFt9auzxti2clE5XifAgLG8soFcNOt0Z+IUhTwKH01lRd8Uj1RDzinZTicyUNUVR620ykwhF0C2
	c+L9FMYdIwcSmXvWRuiZ3CJ+3EYwYUJ96Hj96KTBCcR9F0epTcEU977lW5E5GmWrGaQTKzMKWbg
	Io7XQkm/1a6Be8jMPkqJWB1zGULdJUYzkJGFcUO1B+ncGCV9JrHKdD9Cqu6fWOukE=
X-Received: by 2002:a05:690e:4d2:b0:66a:c376:6f86 with SMTP id 956f58d0204a3-66c72ba12femr447411d50.8.1786654833598;
        Thu, 13 Aug 2026 14:00:33 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66c573c183fsm1372691d50.12.2026.08.13.14.00.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2026 14:00:32 -0700 (PDT)
Message-ID: <b7e697ee-ce3b-4c81-afb8-00205c2997f3@gmail.com>
Date: Thu, 13 Aug 2026 17:00:28 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
To: Eric Biggers <ebiggers@kernel.org>
Cc: Bartosz Golaszewski <brgl@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-msm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Krzysztof Kozlowski <krzk@kernel.org>
References: <b9b655a9-c683-4c4e-ba0d-f98577dd2912@kernel.org>
 <20260801162900.GA2021@quark>
 <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>
 <20260801171242.GA3567@quark>
 <CAMRc=McL5QQRk8C8zzkHm+FUj-SAVi5PLJr2pXo8eNpaxXuALg@mail.gmail.com>
 <20260811224110.GC1905@sol>
 <CAMRc=MfVqphaVsfcmUXjGmu6m+F6nJYXgAPuTVjZBwFnd48BkA@mail.gmail.com>
 <bc95e0b0-2cc5-4ad6-a319-ae4e159b92fe@gmail.com>
 <CAMRc=Mcno_F2UuLXZ3ruaVSbYhssVK90m3KM=+dwskLMSp8TXg@mail.gmail.com>
 <0d2706c6-79fa-40fc-a24a-6d5ffbf02330@gmail.com>
 <20260813201019.GA987015@google.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260813201019.GA987015@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------VV74HMKUvFY0IstpkeEw3GQi"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------VV74HMKUvFY0IstpkeEw3GQi
Content-Type: multipart/mixed; boundary="------------vXcDquSo5DAmeTNxhw1azXQg";
 protected-headers="v1"; hp="clear"
Message-ID: <b7e697ee-ce3b-4c81-afb8-00205c2997f3@gmail.com>
Date: Thu, 13 Aug 2026 17:00:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
To: Eric Biggers <ebiggers@kernel.org>
Cc: Bartosz Golaszewski <brgl@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-msm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Krzysztof Kozlowski <krzk@kernel.org>
References: <b9b655a9-c683-4c4e-ba0d-f98577dd2912@kernel.org>
 <20260801162900.GA2021@quark>
 <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>
 <20260801171242.GA3567@quark>
 <CAMRc=McL5QQRk8C8zzkHm+FUj-SAVi5PLJr2pXo8eNpaxXuALg@mail.gmail.com>
 <20260811224110.GC1905@sol>
 <CAMRc=MfVqphaVsfcmUXjGmu6m+F6nJYXgAPuTVjZBwFnd48BkA@mail.gmail.com>
 <bc95e0b0-2cc5-4ad6-a319-ae4e159b92fe@gmail.com>
 <CAMRc=Mcno_F2UuLXZ3ruaVSbYhssVK90m3KM=+dwskLMSp8TXg@mail.gmail.com>
 <0d2706c6-79fa-40fc-a24a-6d5ffbf02330@gmail.com>
 <20260813201019.GA987015@google.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260813201019.GA987015@google.com>

--------------vXcDquSo5DAmeTNxhw1azXQg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 8/13/26 16:10, Eric Biggers wrote:
> On Thu, Aug 13, 2026 at 03:09:36PM -0400, Demi Marie Obenour wrote:
>>> SM8650 with the QCE is FIPS 140-2 certified and apparently this makes=

>>> a difference. Don't ask me if that makes sense, I don't claim to unde=
rstand
>>> the legal aspects of it.
>>
>> That sounds like the kind of thing that would cause someone to use
>> a worse implementation of cryptographic algorithms =F0=9F=99=82.
>>
>> For what it is worth, many common uses of kernel cryptography can't
>> use the QCE.  This notably applies to the CSPRNG (/dev/urandom etc),
>> storage encryption, and AF_ALG.  Therefore, I expect that anyone who
>> needs FIPS 140 compliance with Linux needs to ensure that the software=

>> crypto is certified, as that's what actually gets used in most cases.
>=20
> Well there's that, and also the Inline Crypto Engine (which is actually=

> being used and is unrelated to QCE) has its own FIPS certification.
>=20
> Which upstream kernel feature, if any, is QCE being used with?  I have
> asked this multiple times and still not gotten an answer.
Historically AF_ALG has been used to access FIPS-certified crypto
from userspace, but that no longer can be used with QCE.  Most kernel
features reject CRYPTO_ALG_ASYNC, CRYPTO_ALG_ALLOCATES_MEMORY, or both.
If I exclude tests and fallback paths of other drivers, that leaves
crypto/asymmetric_keys/public_key.c (hashing), BPF, MACsec, OpenVPN
data channel offload, ecryptfs, Ceph, SMB, IPsec, mac802154, TIPC, TLS,
and crypto/kpp.c.  AF_ALG only allows offload drivers for cbc(paes),
which QCE doesn't implement.  QCE is broken with IPsec and probably
some other networking protocols, as it would wind up taking a mutex
in softirq context.

Is there anything on that list that you don't plan to convert
to the crypto library?
> Does the perceived value perhaps come merely from "offering" FIPS
> certified cryptography on the system -- then not actually using it in
> practice?  That can maybe be understandable in some cases, but it's als=
o
> not really something that belongs upstream where actual technical merit=

> is expected.  Also, could ICE be enough to check that checkbox?

I agree with all of these points.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------vXcDquSo5DAmeTNxhw1azXQg--

--------------VV74HMKUvFY0IstpkeEw3GQi
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmp+MGwACgkQszaHOrMp
8lMutg/7B8gdX1TvVmKM/z92g+DZ5EUqQvQugMMX2Hm5Hapj0zV5f3XpCTx9ilQu
IoOC/+nzo1rmTjawbSbriqVqzUUFE6E/7TlNOybweN1D238b3B71GysDXdXAoqtK
FpF12cfj14UNvIHyYOXAC+F6UOPsl7fvdyhTsmgt7u4NBLtCdmWiAAjOsRFo8hcy
qn8TvX09Aa80S5MNdGX+tyuQKeDnJpMG+Y0+OJP2aDoVvnNP8XIwpymqHjbGP83K
jNqC7PCAKh7w0GF77zgllOiFjKMBBwKZDHYjm2vuPxvdMI0KkgXxl5PPbYsY0GWM
54p+dbXH1ketTyhhiMBs1Boe8DtnU4ZztylIu5y3MVDJBYUl9RjPWncXaVtW0MMD
sKCvK1EZo08ggWHoeB0cMImesx5LiowAcnmoKml94gctWDGAZ1dFcsZt9TlaWguM
osf7jofxrf+2DT3LCIRP3Evef45yzA3+MbDe1p8G4yD+Fmi3ZXwwNHWhrGCStS+r
ZBg5kkvH+bddB6U83XWSQ9J9hWQa4Mu3szL+DUh1eu6jwrpw5axSGK2s6ilm8fuR
VvinREf48xFMhwQ2hKVkWiwKR6EBgiQDFOmKVUokAgShKmEokb3EVrfMgfiXIpCy
ImAPt5v/QSItBHKTUFAbePfVxmBswlAl0DMIuwG+SE6vSjKpgsE=
=tY7Q
-----END PGP SIGNATURE-----

--------------VV74HMKUvFY0IstpkeEw3GQi--
