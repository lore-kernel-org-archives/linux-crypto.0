Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8E6352030
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 19:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783972147; cv=none; b=E/lNjxIMnmDucyVTZeh2LAHcPEHip9sjg4Wn3znhTAPbnmWzehBHPelec90n50W7hzMWHpWFJspp1B4k7nXSiOqdM2oI2HRSy0jAGCCFnLCr3uskr0mhMZj26kPjlNW9YHiMjoy7U99Sx1x3sEw0wOAg6BqMe9OCTzYm2dnBWgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783972147; c=relaxed/simple;
	bh=ZzYnsmKixhrXa3Fm5QIuH6+nuKAf7+GS2Y5AW16oGUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VRaYoalHg1ojLvFFr4Cf4PHvrwJ5qypYgm5NQbQpcvWjlSJvhcFofOWFWd7+p7liFdosuek/eurrQxo/iW4l1ZmlhtqbH5R7XJs60CzDfXSh8fudWwd+q2m8dPUTwFFRjf1wtabChv+hGNucGz9f7zuMbe7nOTV+FKcHe/6F3Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H44DtkCw; arc=none smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H44DtkCw"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-664db84f074so5384813d50.0
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 12:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783972145; x=1784576945; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n2Nhmjf1P25H7Nc2LjCEV+3VIdZwevh4O2RWWuW3P00=;
        b=H44DtkCwgNbmUp4Qzh27tO/L9Uz++6vBBzs+qTrLQ70qHxeP6H5tX+uBbtYXGQD6fN
         pSfb93togs1d+ABr7eLu6Mnyk6JEW8ZyZZ9FOwWzMG7x3IaIpQKyr3k4bARN98u0XqRe
         7c8R7qg+pVQYe8VyvQq5j5AA7vDCX//CFXNGpSBonZ33RvrNpRo2QfHUANS2gV8kj5ef
         zuCDOlPkj3NFT5KidsQseolep3G1UVmc5OZ33wvXUNyOcYWlCx9RTYQCyqPXEY5pqsfB
         f4tWvryxA5dOgY2TeG/DpCzc+fFP1S0lOWfw5TOKXRepD0qYnWfjffWmLR5/HFjkHVat
         JqLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783972145; x=1784576945;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n2Nhmjf1P25H7Nc2LjCEV+3VIdZwevh4O2RWWuW3P00=;
        b=d92xHZzD/aaZVuO1IKqhMJx76UrBBhaueN5hl5HL7MXmqZYbpOIdOkmpfGQ71u9ocD
         X9dbzow1YHxVDuavwpi9zIMuy1ozD06YymZt7TIZZJCDx8oFkk3ep9EeVoWUQhmLn0nG
         EHz0clfbnGscmyLDZI2O5RWMoBB2/rb/uur7RsIypCMibd2qlnyvq7bq2KrUcNQlUNu8
         td/UaERTfJ2Krv1TFaRAS7wcqU6a2zyLMGeTP/O85DXvvhbGuR1FV1fpbj4CGNHeL3UB
         nCqbQdXTlGmA0Tq5En/yRZs7kChQEHbVks7fUT5UCVqDyiGv+sv/TMWxJm5lvxpgVGGA
         j5Ag==
X-Forwarded-Encrypted: i=1; AHgh+RqZ7qOC0meozooj+gVm1HC8nd1atYvWGqR8/izBJB/G4oXE4kD8Ff1+1C75uMtYd5kVmZ7GFORuZvj3nsk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtO8SWXWl8f9xkAQLAXaHM9HMxRDih1tCw8xge+qoATY7FdyQ9
	1boMXWMUQUGuRX/o/FZTo2O6W/8omZq6cnizDUF79St9nkoF8gROae6W
X-Gm-Gg: AfdE7ckC5pY10L8ZSS9gJMUJ9NriB7D/o3IHlstNhe0I3oXuW0AiZ9G0rx7dS6ekajD
	dHXuhJBm3LyMHDA3v2mBuCicCV6WrvVK704QE0VyeFMkRVEx0Qg6ovnFUXjaGoDxCzraIU9aD0i
	53ehrFM+rl/LNXMZxoTX+iGx8OGMMtVxORZjUfDwCVxt5e+MPtejUA9xVYsWvWpEtX3Qd9jFx/i
	6WQnqLcHnC73iDrlDj1vPGezErluk+dcX8UoovC0EOyC6QCAGjHflEdtHbsN/Tr659GTPC7EQNJ
	w61l5XAkWJujM1PWeH2ynigTKMRWW6AbWMmVxHtW0lnC4Uqy0GzooZ/g4Ki2DbagKMtNnZK6SPs
	6+cCm11n2+BFEPLXjLPQvKUwpdLbiXgSr0XGHNiMP9yIxWwhIBTwv1snApMPaxDT6DkqW2nvuee
	zlSeyUeTROMsl6z2n6H0EQOaD9zARJbjYTRyG9
X-Received: by 2002:a05:690e:1246:b0:667:ff9c:21dc with SMTP id 956f58d0204a3-667ff9c2a33mr1497202d50.93.1783972144782;
        Mon, 13 Jul 2026 12:49:04 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-667879d8818sm14496185d50.13.2026.07.13.12.49.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 12:49:03 -0700 (PDT)
Message-ID: <dcf16dac-e26d-42b0-a0e7-32990446f7bf@gmail.com>
Date: Mon, 13 Jul 2026 15:49:00 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
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
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <2026071320-encode-modify-6193@gregkh>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------vgImv900avlh0tVHitrPh5xj"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------vgImv900avlh0tVHitrPh5xj
Content-Type: multipart/mixed; boundary="------------ETtg58S8PChwJVaC0HzUiT8C";
 protected-headers="v1"; hp="clear"
Message-ID: <dcf16dac-e26d-42b0-a0e7-32990446f7bf@gmail.com>
Date: Mon, 13 Jul 2026 15:49:00 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
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
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <2026071320-encode-modify-6193@gregkh>

--------------ETtg58S8PChwJVaC0HzUiT8C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 7/13/26 11:31, Greg KH wrote:
> On Mon, Jul 13, 2026 at 10:42:04AM -0400, Demi Marie Obenour wrote:
>> On 7/13/26 09:07, Eric Biggers wrote:
>>> On Mon, Jul 13, 2026 at 06:47:07AM +0200, Greg KH wrote:
>>>> On Sun, Jul 12, 2026 at 05:31:31PM -0400, Demi Marie Obenour via B4 =
Relay wrote:
>>>>> From: Demi Marie Obenour <demiobenour@gmail.com>
>>>>>
>>>>> This driver is harmful:
>>>>>
>>>>> - It is much slower than the CPU [1] [2].
>>>>> - It Has a history of bugs [2] [3].
>>>>> - It does not have exclusive access to the hardware [4], causing ra=
ces
>>>>>   with the secure world.
>>>>> - It register its implementations with too low a cra_priority for t=
hem
>>>>>   to be actually used [5].
>>>>>
>>>>> Therefore, disable it to ensure that nobody builds it into kernels =
they
>>>>> intend to ship.
>>>>>
>>>>> In the future, the driver will be used for processing restricted me=
dia
>>>>> content.  However, the kernel does not currently support this.  Sin=
ce
>>>>> the driver will have future uses, allow building it if COMPILE_TEST=
 is
>>>>> enabled.
>>>>
>>>> Why not just delete it now, and then bring it back when it is needed=
 in
>>>> the future?  Otherwise this will just trip up the static code checke=
rs
>>>> who will attempt to "fix" things in it.
>>>
>>> That makes sense to me, but Qualcomm pushed back on deletion:
>>> https://lore.kernel.org/linux-crypto/20260602-qcom-qce-broken-v1-1-a4=
ef756089e0@oss.qualcomm.com/
>>>
>>> But I've still not seen any evidence that this driver is useful for
>>> anything or has any users.  Even Qualcomm seems to be unwilling to ma=
ke
>>> such claims; they only claim that the IP is used (i.e., not in Linux)=

>>> and that new features are planned.
>>>
>>> - Eric
>>
>> Here is my reading of Qualcomm's statements:
>>
>> QCE is currently used by the Arm secure world.  In the future, QCE
>> will be used by the kernel as part of restricted content playback.
>> Qualcomm wants to add the needed features to the existing driver.
>> This will not use the crypto API.
>=20
> Why is a crypto driver not going to use the crypto API?

I suspect that the restricted content playback use-case involves
QCE decrypting data stored in kernel memory, using keys inaccessible
to the kernel, to memory inaccessible to the kernel.  The crypto API
can't express this.

>> I would be fine with the driver being removed, but not if it means
>> another out-of-tree Android driver.
>=20
> It's not another out-of-tree Android driver if nothing in Android
> actually uses it :)

Nothing uses it *yet*.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------ETtg58S8PChwJVaC0HzUiT8C--

--------------vgImv900avlh0tVHitrPh5xj
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmpVQSwACgkQszaHOrMp
8lOTZg/+J7VZdIiJw1B68LNMjCivUN153yqTLpN9zrY5X2j10DRj3fsnS/8S0DU2
mCSIjkUljEp6N6NI5bmALO5CXYnIsL7PPjq2/2qhzuLUrxEMf255RRLFg+Yei3OG
OVEp9tXyvrRCBuvrSKXyxMkUKAzKhJEaBEv0NVAuMsYuytTqvuAc6A6+sUvESRco
CFpnGzsfwRXpu/+M30+HTWGTOElO8ReeYR9vTWyrcP8fUQXeGCV9gBcyZrkzH5Rk
ICqvs7N0mQXtSd/v9EpxjiDOd49GF+Gg2PKk5XyyEy/m8p4zDey5KI5fEcsBCzlR
JMLyCwuI/yMQHlGYeCCNLrgM3HTm80hJo+6fVIl4Fd29QZelhaIfh65SdF1/9rXn
z3XcBKgjG6INHmGrmY3FGzYtlJODu99ojT8PHbEz3Wd4t87aRaJxZD0ICfTrJPEt
iJ+9cRKn6TSk9pj3IjOzYRDQ8a8zMQcESxmr/TNTSv63SLlRsLnibkKIgR9wwPyh
1LlpafCxmeyhmYB8Kr+p36zlYXoln3GSDl+5MDzlv3FqI95RA0UJqIzBwtOlsbRK
BUO8ECuHNejjLydzZnsKOlYpKJrQQ8Lx307tPTboG74oO3kWI5Ep3XEWT1/EJyyp
ZfrjHfL9CQmwDsCwBcmT9eFi3zT4OGdm0/El15HCB2fuTQlp8bU=
=oS9l
-----END PGP SIGNATURE-----

--------------vgImv900avlh0tVHitrPh5xj--
