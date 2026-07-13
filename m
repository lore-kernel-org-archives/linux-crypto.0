Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B7843802B
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 14:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783953731; cv=none; b=Eo131S0VUUi3HOBY99Y7Y3J7XmbhUYPxESVXzsabDc2hGtIoAjXuM2l3b5J0jJWKaZwg0byri9cCipgXQKanAnR9OC08skmqkYdB7/36pTX1krYeDAHeZiYrjd8a3noP464nD7PGNJB5M+3o863LifygjS+u2aRQwlC7rBrGJ4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783953731; c=relaxed/simple;
	bh=S+hUrX4UmHdBbTNTfu8x7BK9Py7AAXh5lQGsCyI9mnw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VwrsI8+tZZw6iyou6uTbEdh1h4rXzOrp8/6eTOYaiaRCZLxdX2GOtoDJbu9RnkVhWzlH6IC+OIzO9HAEu2M0c8QJGLp9CftmvWsmtZtU8TPJNW8JCZAkuCM3LdCMzxol9e1DFRMKY0Do5Lf9yKmoVWGgYdmPldf4rlv/qtaFlrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R4HAIwM1; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R4HAIwM1"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8114a4542b2so43592617b3.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 07:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783953728; x=1784558528; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4sS30IZO9xgrRuQONEDSV3EuRt3cRzbQGdJ4Ntn94wY=;
        b=R4HAIwM1JaP94Sqn2JhUbmBSVuSThhCI8kJq4VqaqKPu01bEQ18PRoAB7p1hLp+4cp
         C5A6bxaMEh1u02f9lLZR5OJJMddBNy1gJZ8TYEn22DFgO7JUXFXkc10OKMUXBAr82I9A
         DoI7B9JZttK0EvK+roBAXuCEw9mRhtguc2wQuwSh5sQ5u0aH4YZFBbLTmO6h/xfdLVHW
         M4RsbKXRUywopDf6PSSrCusEey/PQpGFEHZfGBdLoQDRvQNf0oU7UH85JoGz4W4jdIbH
         3wTk998EPaBHAfuE84gGs5P+K5ADO95SQLE49gJiOc8IfbhDa6bvQDWdTaCrcPjUJRu3
         4R4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783953728; x=1784558528;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4sS30IZO9xgrRuQONEDSV3EuRt3cRzbQGdJ4Ntn94wY=;
        b=gd74xvMZ38Ox6XeG0KM5z077eH3/gB7QGdcETuOM+GD5Bdd/pzINDeIj46EH9V8ZjD
         TxUl/jpPpDqfU0DZL9t/3KPVIaNGNg6KYDt08EYbgtg1lSLpanzQDTFZg95mJfqaSPBd
         4bAXK9HtgWg1bhwHKzhdctJjtzkjRAtX2rRsFLEfI+1o5/saXuFy2OJUjSiJ3/ffbJsq
         ZMvsWjV2m0Qafgr3RT1f7Jm5MrS3fbMpct4CpBsBxfGF7GlQ4nmpGFmEJG8S4QnrOtUV
         s9sAqnL85ijOrYxemHXra2K/fB+o7l8tXmJDsD7sk4WkCazh8zHWQhV4ostGyYchfo2y
         1nDw==
X-Forwarded-Encrypted: i=1; AHgh+RoNp12gPeXPDk8hOrFC9rnNvCZ86j2EHHwoDs9wWgWozEwUCt/BOyA9IzDezuQHLmUrCwfJvDCcyENHTog=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6+o7bdMdoRbkom3FnwIij4CRHmYoUX0Sk9usaUg87Wp2QwVl5
	QepwVQBT6UAEJbfCmNWDM11U9Gb04l1Mf29cdABYIJCupf8BSWve3JS7
X-Gm-Gg: AfdE7cmxOWiWSi0E9mgi6dhKWqCkRmmTuu6BjF1D6f4zkfHHUPNeY2pqg3IDXjWJkgR
	D9gZ9R1H9ay+Dv8+VMVnegApaP4yHj2Gm1EQtHFYNWvK8H9Tfu/ANvEukrufNSbq5dFoA2mf5Iz
	IL9tGkMJ6cSJaE5wJTU4o2AY6+x/WP7wZRDPIff50ltnQ3vdEOPoq/8m9xYaauYY9w6fEnH7GgO
	9cU+KhPzFt0zC92aHVb7dkTYuwQOWgiRXyUxeLhiw8PZ9rsciPKRp4l+BcZF2PPTzPedOYxgTMH
	zPnYBwrtgvsUMFyFlmgXYwO+UAVahJfePnQpWKXya1J3yzkytPvIkWtKucd9L46jOb7Xc3oPRie
	aedv58G/aRJkkl30RViorFK2M62q+uG07gjlJ08cro2mq7znrPDTC8P3nBvM9rMJlSTsbiV05R2
	No5yWZYjFyA1qErq4=
X-Received: by 2002:a05:690c:e293:b0:81e:a3a0:701b with SMTP id 00721157ae682-81ea3a070a0mr30319527b3.9.1783953728330;
        Mon, 13 Jul 2026 07:42:08 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81e6be98dfbsm116532447b3.2.2026.07.13.07.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 07:42:07 -0700 (PDT)
Message-ID: <bd5821b9-7459-4db4-86ef-bd67fb645753@gmail.com>
Date: Mon, 13 Jul 2026 10:42:04 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
To: Eric Biggers <ebiggers@kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, stable@vger.kernel.org
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <2026071312-uncover-refining-8cac@gregkh> <20260713130745.GA2254@quark>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260713130745.GA2254@quark>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------nYfoXj7NIprLjHcWWLiG1q0Z"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------nYfoXj7NIprLjHcWWLiG1q0Z
Content-Type: multipart/mixed; boundary="------------wRuOocDMoOdDXxzSZPA0Jyyg";
 protected-headers="v1"; hp="clear"
Message-ID: <bd5821b9-7459-4db4-86ef-bd67fb645753@gmail.com>
Date: Mon, 13 Jul 2026 10:42:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
To: Eric Biggers <ebiggers@kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, stable@vger.kernel.org
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <2026071312-uncover-refining-8cac@gregkh> <20260713130745.GA2254@quark>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260713130745.GA2254@quark>

--------------wRuOocDMoOdDXxzSZPA0Jyyg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 7/13/26 09:07, Eric Biggers wrote:
> On Mon, Jul 13, 2026 at 06:47:07AM +0200, Greg KH wrote:
>> On Sun, Jul 12, 2026 at 05:31:31PM -0400, Demi Marie Obenour via B4 Re=
lay wrote:
>>> From: Demi Marie Obenour <demiobenour@gmail.com>
>>>
>>> This driver is harmful:
>>>
>>> - It is much slower than the CPU [1] [2].
>>> - It Has a history of bugs [2] [3].
>>> - It does not have exclusive access to the hardware [4], causing race=
s
>>>   with the secure world.
>>> - It register its implementations with too low a cra_priority for the=
m
>>>   to be actually used [5].
>>>
>>> Therefore, disable it to ensure that nobody builds it into kernels th=
ey
>>> intend to ship.
>>>
>>> In the future, the driver will be used for processing restricted medi=
a
>>> content.  However, the kernel does not currently support this.  Since=

>>> the driver will have future uses, allow building it if COMPILE_TEST i=
s
>>> enabled.
>>
>> Why not just delete it now, and then bring it back when it is needed i=
n
>> the future?  Otherwise this will just trip up the static code checkers=

>> who will attempt to "fix" things in it.
>=20
> That makes sense to me, but Qualcomm pushed back on deletion:
> https://lore.kernel.org/linux-crypto/20260602-qcom-qce-broken-v1-1-a4ef=
756089e0@oss.qualcomm.com/
>=20
> But I've still not seen any evidence that this driver is useful for
> anything or has any users.  Even Qualcomm seems to be unwilling to make=

> such claims; they only claim that the IP is used (i.e., not in Linux)
> and that new features are planned.
>=20
> - Eric

Here is my reading of Qualcomm's statements:

QCE is currently used by the Arm secure world.  In the future, QCE
will be used by the kernel as part of restricted content playback.
Qualcomm wants to add the needed features to the existing driver.
This will not use the crypto API.

I would be fine with the driver being removed, but not if it means
another out-of-tree Android driver.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------wRuOocDMoOdDXxzSZPA0Jyyg--

--------------nYfoXj7NIprLjHcWWLiG1q0Z
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmpU+TwACgkQszaHOrMp
8lM0sg/+NtNC5D8H6H5FF+mtgtI524SAKrmSaD6q4CgYobBMqrbIKKrlPawqqCy3
QfjHuNxHCPJqvxLa/yB/gjV3zDnDuoA4hN5PAdV/xxfNf9LRNWIYjIXj6fO+2U63
lKagoJ81eZLzoDOjhB+IU4wxzm4++G7ytTnBm655AhbgjsA/DkxL+G+LHc7oE+yv
PH8JBwcZ8cCyB+1G515eL0qUHI+agSk6QqRGBiqdGcIZ4zonBZ+LotBMgDO3ys3Y
LyupckYaF4++AQNRZRFczibT7GPMrdWIFNvC5gF9zqA/p6grhLRjt0B+xRh/6myq
CkW09gjIw4O5Mxc0r74EuavG2RVgE9ad9ynSuBAjmFSfkxshgwQVb1dW5FoKe2GH
YpV+VJ5IL13iUo2kiA4mmjWf+p8i01oz3AH7ZPJhil0BdiJC1SfOJtjPR3x6z5BK
Tf9LXYbGTflxbrDJeHLBkXWXAphypzyDzd0XnyxPgaK8ZN+HZYu4L2nGKSWm1ExX
ptplcBr6LG6wcexNqbiwdieXASHjRDBRfoymXRfE1Wl8XW6ibaUWEf5ZBgmNEYh3
oE/QVQSs2JNTv2+cBg7DBhgNY3Tor/oFT0lKofQ0PCVt3VhqU+4pQVM4JbAkEXQv
EUuJu86r1tYXUPHCFWlbja6PPST6HRHTuO4/QTUqsxLa92XvHlo=
=lwCg
-----END PGP SIGNATURE-----

--------------nYfoXj7NIprLjHcWWLiG1q0Z--
