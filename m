Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F5E356A0D
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 19:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786648196; cv=none; b=OhBTar1DZiPOih2FTfoGYs5Osn5RYqW++Y6aWAS62YthRrMqG77bm0pIsFiTCtPKQFQqBWWzqb5VQjJB7En0LpEHTFMQvWrxtZL8kQYZN3Rqudng8JehG9G0J7Wm1vcupC9Fj/3oZcbHyxn06g8v7tpp8tL0CpxTkUvIbnnwED4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786648196; c=relaxed/simple;
	bh=J4JFqcLdedRU7+R6sdj8/jYF9LI6Fz5ZYLh2J12HKzw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ghr7UHdKXADcotl6hfl0YqSjUo1Urk4LohjA/hbG3N9RJWOlYC5Vn+YLQv8A8BQm1QEEyLKWknbtsblU428Z4Jf/76IQmtO4ovrElU9+yaZb+0zlh6ZptHJV+ck7TMtUapWE9EiGGEEAn41QI/nYeqbe4l3sSBupqxUNRfb0q4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZeogDSZV; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZeogDSZV"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-66c711b7f2aso346778d50.3
        for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 12:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786648194; x=1787252994; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CH8QJWbiTZSTmOX6SA35bZzI1sSsujgIbdHxX53JqF8=;
        b=ZeogDSZVs0aJxPAUxTFai42uL6gBJfQOcrZXFfcfyWv++9TXfaev8hCE2NRNj+zE/l
         C7dMeGOF7fKzRwPTYdzZ5Wo+xiDgNpA9Myl7R0OuVLd7b4le5+FPYQEaelLyQOyMmXZ6
         mvhuePurCdvcoxQweF5VDYAfpT+L+u2RDJ9DNvt+fkw6w0LlnvQlHOfVgqUBWtdHzxtD
         RQpB1ILQmqdD4Gdu84kX9YBIrR5XQAIgddZjD96n0UmbC7CvCGyjg67J0DxX16b9xudH
         DTIhe8FP+oq9PDbbsv2/Ns5BTIl/3ENHpoLNaJ6dfQwRot9rPf0uZzEXU0YzA4FROjY5
         7nLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786648194; x=1787252994;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CH8QJWbiTZSTmOX6SA35bZzI1sSsujgIbdHxX53JqF8=;
        b=hf/QczKZlrNn3pn7XXmpuZHTHgAJjCUBXDXd3k/cfJm/DNNslZancgSUKxLOmhU3B+
         3eNNQAKwSdeetjY6ERKzK4eayWXKh2ZsOEaR1NR7Na0yxlDy14Y2rczFFg77u7zZqzew
         CJwVjX3YWLSrnF8H+4m+BkI9xYZGuJ1oUtpMhhC0jx2X9/S72crDmI8aFUN6+1BfDxSE
         SUDnuNA2LdAOG7Cg2i0zymRI5ZMOBpeLbi5pkT1XrYEIyUFRMifDt5x7z7OakLTB+Gwy
         jzViwKhCnO2n7MgEPSpig+IwJRaKibm1OXtFqp3ewZlXZx+uGvJW4206cRWjYI8toGNa
         3clw==
X-Gm-Message-State: AOJu0YySMQiCN0QnFBs1Vouj2QZ0lLcCuYC6cZja2wOEBsLx60kk0ri7
	4ZHXEtDoiP14fF97zLRnGdM3otVXhLjDKCOOWU74YJB85MLAJFKoHos5
X-Gm-Gg: AR+sD11iACvtMVHLY5gtA47Z1NP+Rc+MyWWzwqIy/69Q+gl5AMI6fOrxbjXDUutou/C
	3+OpQ3EQi+92QcYVP5uO0O/0xFLmKJQwR0FsnbETRff/VtWFnzfAhjoquhLws/b3kgW4jmSuEmK
	x+vRklB2aQcl7R8iAm0JHGK7h0V+iYlWpY35ZgKgb5Bd/1Ur7Ck13cUMep03Vf65LtWGEks4Blg
	XVeZeEUefdbyyH7//MaJroG9rrRR0f2HncMQzevEJQFoaCwFG1EobHd1wQ1GtPXV6pzxZKukgJE
	s95ZPvNHSwS14WZuvUeo7CN/yU6ETase175hD/hS6XD4/MPYs5eRa2e9Z6slSOIvhSleYSuDKtW
	zX6SOb2+7RHd9Hop2RciS0aMj6N9J0tAmvw0SrokJovXQ2NHqW2vL+Wu+582Q/J6+QMmDn3wi9g
	/VBWsz/3vXud2xQRQkv+78iwUGpHrkELhV1Vj7QvnZNqU6BfhHZ6Xv5jB9zBxkK+W8ci9gc7ohK
	A==
X-Received: by 2002:a05:690e:d08:b0:66c:2d72:38d9 with SMTP id 956f58d0204a3-66c72b1d9e1mr353282d50.11.1786648193908;
        Thu, 13 Aug 2026 12:09:53 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-836c1777930sm3475807b3.31.2026.08.13.12.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2026 12:09:52 -0700 (PDT)
Message-ID: <0d2706c6-79fa-40fc-a24a-6d5ffbf02330@gmail.com>
Date: Thu, 13 Aug 2026 15:09:36 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Kuldeep Singh
 <kuldeep.singh@oss.qualcomm.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Krzysztof Kozlowski <krzk@kernel.org>, Eric Biggers <ebiggers@kernel.org>
References: <20260731050838.158825-1-ebiggers@kernel.org>
 <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>
 <3ba57269-3305-4d80-b3f2-aa82fa59b59d@gmail.com>
 <b9b655a9-c683-4c4e-ba0d-f98577dd2912@kernel.org>
 <20260801162900.GA2021@quark>
 <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>
 <20260801171242.GA3567@quark>
 <CAMRc=McL5QQRk8C8zzkHm+FUj-SAVi5PLJr2pXo8eNpaxXuALg@mail.gmail.com>
 <20260811224110.GC1905@sol>
 <CAMRc=MfVqphaVsfcmUXjGmu6m+F6nJYXgAPuTVjZBwFnd48BkA@mail.gmail.com>
 <bc95e0b0-2cc5-4ad6-a319-ae4e159b92fe@gmail.com>
 <CAMRc=Mcno_F2UuLXZ3ruaVSbYhssVK90m3KM=+dwskLMSp8TXg@mail.gmail.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <CAMRc=Mcno_F2UuLXZ3ruaVSbYhssVK90m3KM=+dwskLMSp8TXg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------i894QC0fu9NisDOBnbo7myGW"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------i894QC0fu9NisDOBnbo7myGW
Content-Type: multipart/mixed; boundary="------------iw28fzqMn9Gj0JhxTrO2tL3G";
 protected-headers="v1"; hp="clear"
Message-ID: <0d2706c6-79fa-40fc-a24a-6d5ffbf02330@gmail.com>
Date: Thu, 13 Aug 2026 15:09:36 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Kuldeep Singh
 <kuldeep.singh@oss.qualcomm.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Krzysztof Kozlowski <krzk@kernel.org>, Eric Biggers <ebiggers@kernel.org>
References: <20260731050838.158825-1-ebiggers@kernel.org>
 <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>
 <3ba57269-3305-4d80-b3f2-aa82fa59b59d@gmail.com>
 <b9b655a9-c683-4c4e-ba0d-f98577dd2912@kernel.org>
 <20260801162900.GA2021@quark>
 <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>
 <20260801171242.GA3567@quark>
 <CAMRc=McL5QQRk8C8zzkHm+FUj-SAVi5PLJr2pXo8eNpaxXuALg@mail.gmail.com>
 <20260811224110.GC1905@sol>
 <CAMRc=MfVqphaVsfcmUXjGmu6m+F6nJYXgAPuTVjZBwFnd48BkA@mail.gmail.com>
 <bc95e0b0-2cc5-4ad6-a319-ae4e159b92fe@gmail.com>
 <CAMRc=Mcno_F2UuLXZ3ruaVSbYhssVK90m3KM=+dwskLMSp8TXg@mail.gmail.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <CAMRc=Mcno_F2UuLXZ3ruaVSbYhssVK90m3KM=+dwskLMSp8TXg@mail.gmail.com>

--------------iw28fzqMn9Gj0JhxTrO2tL3G
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 8/13/26 07:53, Bartosz Golaszewski wrote:
> On Wed, 12 Aug 2026 18:33:45 +0200, Demi Marie Obenour
> <demiobenour@gmail.com> said:
>> On 8/12/26 04:07, Bartosz Golaszewski wrote:
>>> On Wed, 12 Aug 2026 00:41:10 +0200, Eric Biggers <ebiggers@kernel.org=
> said:
>>>> On Tue, Aug 11, 2026 at 08:42:55AM -0500, Bartosz Golaszewski wrote:=

>>>>
>>>>> No, the rationale has never been this. FWIW it can be that it's use=
d for
>>>>> testing of the crypto module on a supported platform and that is al=
ready
>>>>> enough of a reason to keep it upstream.
>>>>>
>>>>> As I've said before: we don't just drop maintained drivers from lin=
ux.
>>>>
>>>> We definitely do if the drivers are not useful or appropriate for
>>>> inclusion in the kernel, though the policy varies by subsystem.  Eve=
n
>>>> just last month an entire filesystem got dropped despite someone wan=
ting
>>>> to maintain it.
>>>>
>>>
>>> I suppose you're talking about EFS? A thing that can't even be tested=
 on real
>>> hardware? This is a much more extreme case. Here you have several peo=
ple
>>> representing the vendor saying they want to keep and maintain it. I'm=
 fine
>>> having my own tree and sending PRs to Herbert if he agrees and you ar=
e of
>>> course entirely free to disregard any patches targetting it.
>>
>> Would you be okay with one of these options?
>>
>> 1. Make the stub driver as the default, with
>>    the real driver guarded by an off-by-default Kconfig option.
>>
>> 2. Keep the driver as is (with the power management issue fixed),
>>    but don't register any algorithm implementations with the crypto AP=
I.
>>
>> 3. Only register algorithm implementations with the crypto API if a
>>    non-default Kconfig option is selected.
>>
>> 4. Only register algorithm implementations with the crypto API if a
>>    non-default module parameter is selected.
>>
>> 5. Move the driver out of drivers/crypto, delete the algorithm
>>    registrations, and then add support for restricted media content
>>    decryption later.
>>
>> The last option would be my preferred one.
>>
>=20
> I actually have a slightly different spin on the stub driver. I'd like =
to
> keep the driver future-proof and avoid all kinds of needless churn when=
 we
> do get to the secure dma bufs and restricted media playback (and we wil=
l get
> there eventually :) ).
>=20
> Can we make the QCE into an MFD driver with the core binding to the DT =
node
> and handling the interconnect bandwidth, while the part handling crypto=

> algorithms becomes its cell and is moved into a separate module? This o=
ne can
> be disabled in defconfig by default and I don't even mind it being guar=
ded with
> CONFIG_EXPERT. The core module would remain in arm64 defconfig.
>=20
> With that: any future extensions providing support for more functionali=
ties of
> this IP can simply be implemented as more MFD cells while we can also k=
eep
> chipping away at the existing code and use it for testing the BAM pipe =
locking.

I'm not familiar with MFD drivers, but this sounds like the best
of both worlds.  The driver stays upstream, but anyone who doesn't
explicitly need it can ignore it.

>> Also, if Qualcomm has customers who use the QCE via the crypto API,
>> is Qualcomm aware of _why_ they made that choice?  From Eric's and
>> my perspective, that seems like a very strange decision, unless there
>> are factors that Eric and I are not aware of.
>>
>=20
> SM8650 with the QCE is FIPS 140-2 certified and apparently this makes
> a difference. Don't ask me if that makes sense, I don't claim to unders=
tand
> the legal aspects of it.

That sounds like the kind of thing that would cause someone to use
a worse implementation of cryptographic algorithms =F0=9F=99=82.

For what it is worth, many common uses of kernel cryptography can't
use the QCE.  This notably applies to the CSPRNG (/dev/urandom etc),
storage encryption, and AF_ALG.  Therefore, I expect that anyone who
needs FIPS 140 compliance with Linux needs to ensure that the software
crypto is certified, as that's what actually gets used in most cases.
>> Finally, would you be willing to have a group call to discuss this
>> at some point?  That might be a more suitable venue for this kind of
>> discussion, and could potentially lead to a conclusion faster.  Also,
>> while at least I couldn't sign any NDAs, there might be information th=
at
>> you could discuss there that you cannot post to a public mailing list.=

>=20
> Sure, I'm fine to have a call. If you think about coming to Linux Plumb=
ers this
> year, I'll be there all week and it's a good place for such a discussio=
n too.
>=20
> FYI I've only been online for a couple days this week and I'm going off=
line
> again until the end of August with the exception of August 26th when I'=
ll be
> able to chime in again. Any call would too have to happen in September =
at the
> earliest.
That's fine.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------iw28fzqMn9Gj0JhxTrO2tL3G--

--------------i894QC0fu9NisDOBnbo7myGW
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmp+FnsACgkQszaHOrMp
8lMIfw/+Kqprcz6oo8QmpcPVroEZnU8mBZm1kTqPFF+gxGc26IAQJGGXHb/yrvfx
VIidixfHFA26THV6qcQsgygKHEKsJsgboUximTQZoMs3jW2PACfU43CJf+puDbsp
WeBpYme2gDmPuWONQStHDyUPX8IoIM4H3uu8I8swnmqcFbug6UJ9GHQ2aPbkxMcO
5SX9AxB9pSoMwPXrdEH5jhGNKxKzmZ6wLoA76JMBzny+/8QvYQPSuAFM/b2FXJO+
KayMYCXYIodfolW7+jt9kEv5cf33qLDzfvLMiJRjnAG8/amEMTnAHjgCh3w3DqlO
2Mh+RY6W495XGMU4zTHbZxUENPhd0FB4hs7ZeelA2sHtMjr6/Rc1uEbWFmLSJAmH
DtX9atgq4cU311LpqAEVxCeGQl9K/Xstvk44ke9p4xDjLM8PVmkt/dBHW5YoCScF
lCKkyVfVlE+BIIPu6LYs6HMzl10QxI1bDDol5EjUYJDwu5b0phMgrKykxAbz6/Qf
lQJBbNb6fHX8WAPm9zZN0+GyXARuQrv3zZn3tU8R0S9w5/GvMF/kT1SX999coXmQ
V/yjzkxwJEaiXq7xb7ulNcR0l+61LMq8daThzyyDLcc0hqMyLTAbYygRiHxNs6Hl
xdnpw7Zn8UPo4BZ+UkLlVG74V0U4gYzsGLlNcD23vAsfnaI3RTQ=
=Of7Y
-----END PGP SIGNATURE-----

--------------i894QC0fu9NisDOBnbo7myGW--
