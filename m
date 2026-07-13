Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7652BE02C
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 19:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783972578; cv=none; b=TB3KdxznNwkkkzkUQOhizIbttHaNQ92I/zCrAzopG90bj3KE1zF8MaPj/lE0I8IbLzueZfhQ8zbPqewHy4+tWhnL+ngAPdCXTSrna/RmCiBej01JMx9xemy+YwZROdOlYP4yEyZ7pRbgZhN3RSwBQU1TimYxwFVdc3X/oc4p9Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783972578; c=relaxed/simple;
	bh=DkpHIkyA78b9pvW76RGxZGm+Wk1vMcZtNbkqBaNR7QA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=r8NYawswukuVvE7nx1ZyGSzWgYH/bzsbHyCZAElmgjNgVY/msxGk92f0a55DQ5p8FRPZythwpB2gdDTa8RSo4DWMbQwsqXHOVqMtki5q+LUHCbw/tcdXukClT9VUJJnW7HORh2yGK9YuA8bXmLWYC/asuD1zRo7XIOil/0THWHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pVPRGyWO; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pVPRGyWO"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-81e69a2db34so56104817b3.0
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 12:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783972576; x=1784577376; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:content-language:references:cc
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=q68YkVUsAq88sLtazB65v1PXfjC68MwiD7btmXhogW0=;
        b=pVPRGyWOm489H+VbX71HU2xdQzOwIeAUzBCxdJp/E5qlC4YlQi/yZYt89NjcYPTY+x
         japI7YuxJea3dw/QXGBjNsW9IRkaxg8Li8mR+bu08hVe3IZ2y4LOUGyz0CJ3kCOlMuZl
         ZoWC5YEYqpw90hk6fdOo3IHBhANKR7ADfG7lHTpYBTiQj1wJpD1Hi93o4YrGDup40I6v
         rLpN5Ay/dzDes2wdj2WQvebchLNlbaA0oikMFJCgBxYDxDCRnmW1bft4hckK7yy39mUR
         /qWeHsuEdX5j/1vubuArFq5D0IQL/9mcohNUSFyNLPEVmVD0/ZCW3JAA4AG7ePHOdiay
         sYzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783972576; x=1784577376;
        h=content-type:in-reply-to:autocrypt:content-language:references:cc
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q68YkVUsAq88sLtazB65v1PXfjC68MwiD7btmXhogW0=;
        b=IgNlbugjETqrOv8AboUNP5obc5rpS/VrVvE9N0bWkaKNdrjXntDK+AFpij+/2KDsAF
         3g4eLXw3jQsJqsAVnU4YUFh422wESGgUvEVGr5n8QBn1D/s6E1NvW0ETfX4np9yIACgs
         Z8rgY/jDaiN77MUGQ9EXAEocDiGjetiEnyzM411FPCubt7sfAOSryg2sFOjp/oiZkvLw
         WSSRGfmUHthq31PKDwjVorOXv2m8BQk2MB+bXOc/ACSDDXX0p7nRp2wg3BxQBXczkRKc
         kqybLFTof2ABpsN0DQNM8YYlUqR9Y67BLUSl7wz0z+p7yphEgRFXhoKuA0QnGgVMMUYv
         YZtg==
X-Forwarded-Encrypted: i=1; AHgh+Rq/QbYALPFxNyuYyAnKSVcx1QZTKuvLBswu+KdbGrBI36/Eh6FJOpSJsLDJaJCHKqflxi5Xnd2Azdeu3mc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc0+sLmOQGb4drV8eVozm3nU4AFEy8SgJ0fWela82bYk4zBHtA
	Fi5zR4VvxLmqhCWGxCHPi4MOFaX7qDRB0PXHV3XnZFa6n+GuPw4YxsY+
X-Gm-Gg: AfdE7cl8QoMKPc1se5ULen7r24iAW+fnk/d04etlUe6AwTT2MWdpIPaedA+O4ShEEfD
	cABQtIGiBhvo/PJa8MBqA38FPDwsE1Zln/n4A1aDlqDgO9E1ZJ923ehSEuUZ//LY6Xn58Jc/L+3
	vm8OEwJP1Shl6XwQiD0Mfznge54stq9Us1v604aIo6eBX+yx7+TG52F6+A3rWlmpKCxC2Q77a0a
	f5QPCFIQeTBo6/O6mL/5Z+PflexHZOeW7mLBtyRxmvo4zlKu1hYtv6xlji8/qfnqzGu+qya8OKI
	Gws6+z1fcmuc2idQgZ1G7eRHPdSIWKkLWeIrxiltioEqQbnH1kZdEbtICVPqm9aY0MDnQJWqCW3
	/8tR1wUX2HoW4LLrxqB2sS5i5JLM5mdklN0CEkTJQD8lqM40UanCzHpkMox8pYHAEgVGk7Y8aBR
	8AFbi6KMrqHTt6Bb4=
X-Received: by 2002:a05:690c:480b:b0:81d:6af3:b9cd with SMTP id 00721157ae682-81e9015af55mr73668997b3.40.1783972575423;
        Mon, 13 Jul 2026 12:56:15 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81e6c1a32e2sm123459527b3.30.2026.07.13.12.56.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 12:56:13 -0700 (PDT)
Message-ID: <b5f56cbe-38ab-4772-a828-f77eb513a4ee@gmail.com>
Date: Mon, 13 Jul 2026 15:56:10 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
From: Demi Marie Obenour <demiobenour@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, stable@vger.kernel.org
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <2026071312-uncover-refining-8cac@gregkh> <20260713130745.GA2254@quark>
 <bd5821b9-7459-4db4-86ef-bd67fb645753@gmail.com>
 <2026071320-encode-modify-6193@gregkh>
 <dcf16dac-e26d-42b0-a0e7-32990446f7bf@gmail.com>
Content-Language: en-US
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <dcf16dac-e26d-42b0-a0e7-32990446f7bf@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------C8yGlXu1E0DNNa0TaKUJFVNn"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------C8yGlXu1E0DNNa0TaKUJFVNn
Content-Type: multipart/mixed; boundary="------------g4KQxFs8CLpWmawHNDGnmSMO";
 protected-headers="v1"; hp="clear"
Message-ID: <b5f56cbe-38ab-4772-a828-f77eb513a4ee@gmail.com>
Date: Mon, 13 Jul 2026 15:56:10 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
From: Demi Marie Obenour <demiobenour@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, stable@vger.kernel.org
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <2026071312-uncover-refining-8cac@gregkh> <20260713130745.GA2254@quark>
 <bd5821b9-7459-4db4-86ef-bd67fb645753@gmail.com>
 <2026071320-encode-modify-6193@gregkh>
 <dcf16dac-e26d-42b0-a0e7-32990446f7bf@gmail.com>
Content-Language: en-US
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <dcf16dac-e26d-42b0-a0e7-32990446f7bf@gmail.com>

--------------g4KQxFs8CLpWmawHNDGnmSMO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 7/13/26 15:49, Demi Marie Obenour wrote:
> On 7/13/26 11:31, Greg KH wrote:
>> On Mon, Jul 13, 2026 at 10:42:04AM -0400, Demi Marie Obenour wrote:
>>> On 7/13/26 09:07, Eric Biggers wrote:
>>>> On Mon, Jul 13, 2026 at 06:47:07AM +0200, Greg KH wrote:
>>>>> On Sun, Jul 12, 2026 at 05:31:31PM -0400, Demi Marie Obenour via B4=
 Relay wrote:
>>>>>> From: Demi Marie Obenour <demiobenour@gmail.com>
>>>>>>
>>>>>> This driver is harmful:
>>>>>>
>>>>>> - It is much slower than the CPU [1] [2].
>>>>>> - It Has a history of bugs [2] [3].
>>>>>> - It does not have exclusive access to the hardware [4], causing r=
aces
>>>>>>   with the secure world.
>>>>>> - It register its implementations with too low a cra_priority for =
them
>>>>>>   to be actually used [5].
>>>>>>
>>>>>> Therefore, disable it to ensure that nobody builds it into kernels=
 they
>>>>>> intend to ship.
>>>>>>
>>>>>> In the future, the driver will be used for processing restricted m=
edia
>>>>>> content.  However, the kernel does not currently support this.  Si=
nce
>>>>>> the driver will have future uses, allow building it if COMPILE_TES=
T is
>>>>>> enabled.
>>>>>
>>>>> Why not just delete it now, and then bring it back when it is neede=
d in
>>>>> the future?  Otherwise this will just trip up the static code check=
ers
>>>>> who will attempt to "fix" things in it.
>>>>
>>>> That makes sense to me, but Qualcomm pushed back on deletion:
>>>> https://lore.kernel.org/linux-crypto/20260602-qcom-qce-broken-v1-1-a=
4ef756089e0@oss.qualcomm.com/
>>>>
>>>> But I've still not seen any evidence that this driver is useful for
>>>> anything or has any users.  Even Qualcomm seems to be unwilling to m=
ake
>>>> such claims; they only claim that the IP is used (i.e., not in Linux=
)
>>>> and that new features are planned.
>>>>
>>>> - Eric
>>>
>>> Here is my reading of Qualcomm's statements:
>>>
>>> QCE is currently used by the Arm secure world.  In the future, QCE
>>> will be used by the kernel as part of restricted content playback.
>>> Qualcomm wants to add the needed features to the existing driver.
>>> This will not use the crypto API.
>>
>> Why is a crypto driver not going to use the crypto API?
>=20
> I suspect that the restricted content playback use-case involves
> QCE decrypting data stored in kernel memory, using keys inaccessible
> to the kernel, to memory inaccessible to the kernel.  The crypto API
> can't express this.
>=20
>>> I would be fine with the driver being removed, but not if it means
>>> another out-of-tree Android driver.
>>
>> It's not another out-of-tree Android driver if nothing in Android
>> actually uses it :)
>=20
> Nothing uses it *yet*.

That said, deleting the driver is also an option.  I don't have a
problem with that myself, but Qualcomm does.  I figured that
marking the driver BROKEN would be less objectionable.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------g4KQxFs8CLpWmawHNDGnmSMO--

--------------C8yGlXu1E0DNNa0TaKUJFVNn
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmpVQtoACgkQszaHOrMp
8lMiWw//WlbyclsseubZEFwpF3D7kF/tsmijPxTxd3+XD5FohrzBTMAA7RbPwETV
S71upvd2zrIbVDUwy/eYWdFd7YvSYAenqtihZKHHYZDydYKI6C47qIxOHgPV/wJK
K1W941NRAXX0PaK8BoyciEiEmy2Jztz9/A6pCxUCnl1vDkj7sk9p7mb6538dxqbK
Nm6qpfoPkd0gx5YsmDJDb/UnHlxPG6k3+xUgk03wB5uDzockJ4bkCx9H5G21uckh
AljsQc8kFUa0eQOgYXHTV8zOGx/Qz9F+9AIq9DoUC3bQqVpkw3b/eQxrvtykIry+
sJERfMRQa+oQjrkhYFIXJHVJWLRnA3AgY8kNOki2u4EpBORwfZcaauVjPi5e43aR
se8BNILtUW7ODV26LuyfMDONeEn5zyApO6wLVY39+koPR1J9g7QBzphNecwKYt7V
oplp/ZImB67NXkYAgwm7lFQyFrHl7IlLPnPEhELUMRbZcM7ilcAQbStR70wC+6vO
F02SHWhEr0sznkq0Y1YvTFF6IOM2J7rm+jQ8sjc1+g+9NwuNYJIyZnxAeHUwLYPx
WUXO6TIUQSIfRUmch4hfjq3R3b76fzjVyNmxZ1aHk5MtEzjTgmb+qEcYEOgJRQ2K
c2iWRd7o+KaJmwiZnHglgqw1lHPsVd2EGEeqg/zJGusjsQfgPxE=
=JMJV
-----END PGP SIGNATURE-----

--------------C8yGlXu1E0DNNa0TaKUJFVNn--
