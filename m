Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0866F46C4B9
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 18:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658600; cv=none; b=YmlTzdUWz3XbCWKKs5XuquyGl5WNciDYqylfOkVH7jpcHE5JBCex3Ny1M2iOLAVa/NxzIrXc4YGPgy8xgf3GQa+Svp9VWeDDIHhtucN5KR2YTi0urRxb78kYR6ykiL5I0xj0yQZaiY5pbW7NM39xGiUrNqQ3L9KQjC3yMtyrYp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658600; c=relaxed/simple;
	bh=LNdnzpazzuv6KgNDSO5w75/e63ZEaUyhEq0HWDIPJLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IOsdTozKUNnDog7uT1swe/nT+ghYBGayQVQL7ejIG/qlcsxzfY7G4suRn8WmzDEHZRzr6sXWovary8XMuE74EJMRKVc+qMKT8RmUH7JIhN1XYfhdKIsSTUmoEHvpZzveYjZqgDEAPB+O9ysQ3XYm4Gu88PIlCUdyBXNwcTKnReI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lkllFWal; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lkllFWal"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-667923d86a7so5824940d50.0
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 11:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784658597; x=1785263397; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yr++tEeY/mG9S6zA/+0OKmjDd8N/tDAdIfu+UBfLIk4=;
        b=lkllFWalxCYHjEb74mkWLiiGwKAasH0yAHoVVabExONjJQs1pN4HIlsV/MaeBjdoAi
         hwqgaFWjXpRs8p0dfH86H4guMSBQAf2dInaMLxFqWibFS550bXFZnMflLCFMWMolBLac
         wKW4LdGAEvWKXQwWGPt5Sxvp3IK0HqbM2vu7lNwdEHZulQuA0jya9J6QbYgXvop0T0Sm
         3FHpjANjiO+35TBSKQF5/mH6XqIFVk7SMxvBHEw3Fbzj6kqoU4/hNBkBiqlooCTBms4J
         kcH523vZA1ZtzQPLNbZTSPoxtUMyuUsx7MfkZbNQ0W0ZTcAgNYidZB5da0BC9RwRfQQ5
         rCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784658597; x=1785263397;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yr++tEeY/mG9S6zA/+0OKmjDd8N/tDAdIfu+UBfLIk4=;
        b=rnEyQek+eo3gNEWlFq6XGot8LOoaBlDpB+ChpcY/pl/Yze+8qDj4VfMA1qD0MxALmX
         aFSCcvg4zMNUPB79tE+fNLlxoBVqxClwqwLzEaHjuoZ0fmSgOpxgoMWnGi28LxuObZN/
         JqRGwWo2yWVMPGd+DgTXTIKda9RB1fTL7iSF7UM8voHHxDnlmaJt1cby16SFGal4InAE
         /Z8eNss36BH5fmejeTJgD2mWmWCydcywctViM8U2SPIP4EHTtpylkFIwwOYs5Wi4Z9T2
         myjaA0e7Gy84hExFzhVChrL9PSIG14Q6IoVprq9XqD2SKdGqRr75pR0xqQj2xpdv5s6O
         LtLg==
X-Forwarded-Encrypted: i=1; AHgh+Rq9LG0PNMQXUqOmMG1KnIWSwoySEI+xcv82ksO4YIoXKNo8nDTH3TwGXRlXaICfYy0x5uwh/4N0mEL9ZhI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVH0luZYYEh1zNNZ7dEg+suCQe42K2ZyuMO7Vy/73ZxJ/dtuYi
	ZnsxcwGC+sS3ylxW56zes+J5oTzCq6GpDqUXYHJII/fm6gabUNOdneSG
X-Gm-Gg: AR+sD118gdKpHb+1/F5w7ejFDcbduN3qTdX1x6eg94JXm0uPg06hZdeDTPtJaWNkIy8
	PQA1KoK/oljT8hNBxVjnGWt01arEu6RYntJ4p50Lsfglt/L08CLDFVZwShBhURpAXrGke/AscOH
	Nz6xghVY7fowsx0xYwwqFaHEaSrR4uGKkP0NuLn57tVJ72xhe0j5ZzjhzWwg1lxn94YRp+zo2WF
	TQdx4Xj82Ka1jtxKn9chfRgQ/MMW5oBnP6GtULWDs8XM859tbWM0pIi33ctZ76wC3q2peULrSLP
	pur4qRD9tidKJbVF6lOmDn9rEVtIHNbZR1pSu4DRcY6HqjxtM0rAQvCy9azcmEMnWu2PU9aX/5s
	KkVkaxxYSCfPXo+l5aiDaUErungeav8upK/vYWHYbtJhZ1IMyOjZepEFZw/p4W0wKzAc6wmNsLb
	eea2cZ
X-Received: by 2002:a53:bb05:0:b0:667:7bd5:f01a with SMTP id 956f58d0204a3-6688e29239bmr219594d50.0.1784658596750;
        Tue, 21 Jul 2026 11:29:56 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6689052164esm36384d50.4.2026.07.21.11.29.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 11:29:54 -0700 (PDT)
Message-ID: <c826b73d-6307-4237-a065-b7a8487350ce@gmail.com>
Date: Tue, 21 Jul 2026 14:29:39 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Russell King <linux@armlinux.org.uk>,
 "David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 stable@vger.kernel.org, brgl@kernel.org
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <alnlaCXmoLRAlr96@gondor.apana.org.au>
 <20260721082501.6128-1-bartosz.golaszewski@oss.qualcomm.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260721082501.6128-1-bartosz.golaszewski@oss.qualcomm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------bwB4FvPIOQoH8HIWNe7kb9Th"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------bwB4FvPIOQoH8HIWNe7kb9Th
Content-Type: multipart/mixed; boundary="------------WhrSX0Mdw2MzSwiD3n5At4Du";
 protected-headers="v1"; hp="clear"
Message-ID: <c826b73d-6307-4237-a065-b7a8487350ce@gmail.com>
Date: Tue, 21 Jul 2026 14:29:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Russell King <linux@armlinux.org.uk>,
 "David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 stable@vger.kernel.org, brgl@kernel.org
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <alnlaCXmoLRAlr96@gondor.apana.org.au>
 <20260721082501.6128-1-bartosz.golaszewski@oss.qualcomm.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260721082501.6128-1-bartosz.golaszewski@oss.qualcomm.com>

--------------WhrSX0Mdw2MzSwiD3n5At4Du
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 7/21/26 04:24, Bartosz Golaszewski wrote:
> On Fri, Jul 17, 2026 at 06:18:48PM +1000, Herbert Xu wrote:
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
>>>
>>> [1]: https://lore.kernel.org/r/20250704070322.20692-1-ebiggers@kernel=
=2Eorg/
>>> [2]: https://lore.kernel.org/r/20250615031807.GA81869@sol/
>>> [3]: https://lore.kernel.org/r/20260706-qce-fix-self-tests-v5-0-86f46=
1ff1829@oss.qualcomm.com/
>>> [4]: https://lore.kernel.org/r/20260629-qcom-qce-cmd-descr-v20-0-56f6=
7da84c05@oss.qualcomm.com/
>>> [5]: https://lore.kernel.org/r/20260524204537.GB110177@quark/
>>>
>>> Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
>>> Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
>>> ---
>>> Changes in v2:
>>> - Add Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driv=
er")
>>> - Add Cc: stable@vger.kernel.org
>>> - Link to v1: https://lore.kernel.org/r/20260712-qce-broken-v1-1-85e2=
bff17871@gmail.com
>>> ---
>>>  arch/arm/configs/multi_v7_defconfig | 1 -
>>>  arch/arm64/configs/defconfig        | 1 -
>>>  drivers/crypto/Kconfig              | 6 +++++-
>>>  3 files changed, 5 insertions(+), 3 deletions(-)
>>
>> Patch applied.  Thanks.
>=20
> Hi Herbert,
>=20
> I'd like to ask you to back this patch out. Admittedly I should have NA=
Ked this
> under the v1 thread but I thought the discussion we had under the Shikr=
a series
> and the subsequent patch making myself the maintainer of this driver (n=
ote: Demi
> did not Cc me on this nor the Qcom mailing list at linux-arm-msm) as we=
ll as the
> pending series[1] fixing the QCE issues was enough to imply we should n=
ot mark
> it as broken. Please consider applying [1] if the fixes in v6 are corre=
ct.
>=20
> Bartosz
>=20
> [1] https://lore.kernel.org/all/20260717-qce-fix-self-tests-v6-0-455775=
fe5f6c@oss.qualcomm.com/

Is the BAM locking patchset also needed?  My understanding is that
without it, the QCE driver can still produce wrong results due to races
with the TrustZone firmware.  Until it is merged and the self-tests
are fixed, the driver definitely needs to be marked BROKEN.

Also, what can the current driver do that cannot be done better using
software crypto?  I understand that you have future plans to add more
features to the driver, but those are not relevant to this discussion.

Finally, I very much appreciate the work you have done.  I don't
expect that the QCE driver will stay BROKEN forever.  This patch is
purely a reflection of the current state of the driver, the speed of
CPU-accelerated crypto, and the small message sizes used by the kernel.

That said, is drivers/crypto really the right place for a restricted
content driver?  A driver that uses dmabufs might be a better
alternative, and would be easier to integrate with the Direct Rendering
Manager (DRM) and Video for Linux 2 (V4L2) subsystems.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------WhrSX0Mdw2MzSwiD3n5At4Du--

--------------bwB4FvPIOQoH8HIWNe7kb9Th
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmpfup0ACgkQszaHOrMp
8lNIXA/8DrW/cEc/ISZNa5QRt1B4PVHPRp8ZF3WxLeXZ00x5yOpjJXw9NNKnQJKC
hI2VGY2b4lD2Yyd9gBc69s8RQJSXT/+rx2oc2C3J2ZxZdrgecBmXzo1dEnIb8RTO
tlkeOZ1nReACCYJGIDOLI1aAxahoaiMJ1j8xeG+8Lu9nZDzmgnITSRrmmbUUEnuD
JPkms3Wlbo9VQ4FzD9MHXJM1GY8SLOqmIw/HvR10c8cH2hdSM2l9GkLx2qkeTP0I
TUqj3eXLEHoxk60mdAf7VXtLekEzeYKyfQGyOd8jzhUGU0ehMOalryP5crKJ+MBd
XaJ4gM7Yk6otL1IWmgoMAUaMFeuO5e5wY4/9HURkIKckwbqAG6qHVA5idi7RwPn+
qpcAAsXExnH3Djx/PwTPmbi2hMg+fvqwzCmlkbRlGyZeYIB/2rMCDHjF4sTob38o
uHlxxDQBQVl82nPU4VRY1pQfWPIWiB4X9zjZBrPjmvNUd+Cu9MY2xWt09LNbqrHG
8Kc27b6TWHVHaF+sTM8BpyWtsQWulCoyEfPV2faJnW1xkAZ8ulLJVhesE8Cu6GsA
Hx1+rxchrmRrpMORSDopi8jsBIthth/DGZvFlosSItHhY1mcQkyGGIqdyNNoWkOS
8oXYeIL0sOUryCxEva2j1fmeRzsjgq+MMt8U5cVj9J9gkF7/dqo=
=eQgX
-----END PGP SIGNATURE-----

--------------bwB4FvPIOQoH8HIWNe7kb9Th--
