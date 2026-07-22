Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C84747986B
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 15:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784735191; cv=none; b=a6W1vviWZ41p0vXeEGnZKlA1++YrfmLcfJMfEcC1hIe439eJfNlp2YTRLcKArjw/3G4yL6NRyC3jYDDNteH4vTuh2Zg7qO+t3eFdgshQdCntt9WOvWRhC+sKQBFjaBcSW2JIvgzhcacyzBIq7GteV6lw5beChTkQPVLjYFNXy04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784735191; c=relaxed/simple;
	bh=AInC2gpUbzb8I65oNlygwh2NK7VqWSrYwlf/18VlcKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kEhVK/ADtGTaJ9R5c+9/D+o+a33yfZtQqSo0xry8HkElqGVT64/54YoywGsqLMXRgRgBSU9HAfoWwC2iWaVW+bTCub4o+i2fAxgUzq0O1qZryKGw8asZIlHJuTYjVdH5K+N4SXmxDIuz5wVfG6MswjH89aGq9eZvcMFeJy/xOtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pWr/gaNb; arc=none smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pWr/gaNb"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-6685483aad2so3603319d50.0
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 08:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784735184; x=1785339984; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=h+DcHVzO50mtkCMyVvHEUPPqgiYR6razHjnBQNDI87Y=;
        b=pWr/gaNbgngJpaC7Y8aaHbDPvenC2oLjJpUH56dab3lkL2grNJ0yptjDuPHTpu+265
         bpYqgBQGLYuidkFWNPSK+yykHIF0PvZzhqlZPqfdhHif+wprzAtn3x+9KNipBkxWQVBf
         lK2EOXmsT50o7jbZ+PZiok9GHUmCq4emGTFQ4x/4SvzFKKreSNMYTyD6G2uy5KAXlFM4
         OFS2iZfqirtE5nI4hw5esI44WJCRT4O1j3IuT3HyH4Ox44V5GVBBiFCWe7COLKiUe5iK
         Vm6Cg6CARi6CG9Sapwz0V9sE8fTazcGYWy4aIGIWxDsukMYim4/DCTZT47iN/xgWaCU7
         h5Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784735184; x=1785339984;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h+DcHVzO50mtkCMyVvHEUPPqgiYR6razHjnBQNDI87Y=;
        b=pMiIo+zgR0auoVCPeFBaztwAu+9L5C1OvkUybEXwNcmgpH6cWVAzZRez5YccY+iVZr
         na6s7130kHKYxZCADhaI1pxeHTsBoMh3rnFnOO2dYWj1xuaLOa8MvfHOSvfhJh9volln
         bIOe2ajkvCG0xWFqSIUSjAv27D+w/aTh4X9g57lvW0VvLVmAsKYvkdHtxRkM7sA9N/iP
         gQIwJncbLy1hNYf7VDUCFou66bN5mhcqeCNWIvSIghYY6YNu5vbrQ+AumsuZnDgHi4xk
         aK64zhaBY+mNreWRBo+Q7xJEQzUQdNkE93J1MfrZw5zeWRHsl8LGJWkZPVmO02FFJUUG
         SVKQ==
X-Forwarded-Encrypted: i=1; AHgh+RoD3acW2akeRNtb4rj04G0qBOPXS3pnGQodlNRqtn/5eP3QTQrGWQk7GrxGgp/I9KUnnSJApgQVsaa/vLE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi6gR2XxOVB6m8XwsiGS02vIpdlatGzA65FCSih9uveo/kdjsC
	DyXcZB77ef/j9SvH6XzKdJS4kiKgCybi80h5ryerVYyvMV6yM2lwQUX3
X-Gm-Gg: AR+sD12I9s0f2v4HvqYZhgjc0MHrUO8eHQaNVOnZNoie8YYmIUty1qzOMS6oWvSPzt8
	glbEu0zCGZV1rB1SXWlVpmNWPoPHGs1ZHKp2PmU1YwqG1QcfpPoZgd8gv8G+E2+MBKxpWzolJA1
	PtJSDqhUy87oMBqeaRdfKtEmRhQVUYPde8RA5eipyTfD+31E/brujDuiYmz03K0xYMOKBXMY+uA
	yoVH6VgXfjxcjbbybiauD6NTsHYYmMc6Bl0M3J/o2nDLdbXzd82vNvBk+irfNX36yUXD97IBSCt
	xd89OnE9kCh0naSm/U2DL/IwHF5o/Eu9UR8Chr9iA/XSoMlWCJXfZ3qHbn3RxO8p5lo0/JuREHJ
	Up5i46/UpX5S1gmgNdkMEhrlPRM05mdFDQrZT8SZDRw4nT/boHcvepuL9zZVZRYBFnZY/qPX4m0
	uV57gx
X-Received: by 2002:a53:a7cd:0:b0:664:c81c:d1 with SMTP id 956f58d0204a3-6683bbef5d0mr5048088d50.45.1784735184185;
        Wed, 22 Jul 2026 08:46:24 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66890775512sm1566688d50.19.2026.07.22.08.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 08:46:23 -0700 (PDT)
Message-ID: <8e9101ce-e9ec-4111-a1a6-7a9a07788818@gmail.com>
Date: Wed, 22 Jul 2026 11:46:16 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Russell King <linux@armlinux.org.uk>, "David S. Miller"
 <davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 stable@vger.kernel.org
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <alnlaCXmoLRAlr96@gondor.apana.org.au>
 <20260721082501.6128-1-bartosz.golaszewski@oss.qualcomm.com>
 <c826b73d-6307-4237-a065-b7a8487350ce@gmail.com>
 <CAMRc=Me55rUmjjR+ZzdWd2ss9JJMZzJch0zKd4GqONBjCzFMYQ@mail.gmail.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <CAMRc=Me55rUmjjR+ZzdWd2ss9JJMZzJch0zKd4GqONBjCzFMYQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------TQU0bcIC0Lu6CqgUekKUIeTq"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------TQU0bcIC0Lu6CqgUekKUIeTq
Content-Type: multipart/mixed; boundary="------------uwrMxsbcaUPR63gc8Mct0hz9";
 protected-headers="v1"; hp="clear"
Message-ID: <8e9101ce-e9ec-4111-a1a6-7a9a07788818@gmail.com>
Date: Wed, 22 Jul 2026 11:46:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Russell King <linux@armlinux.org.uk>, "David S. Miller"
 <davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 stable@vger.kernel.org
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <alnlaCXmoLRAlr96@gondor.apana.org.au>
 <20260721082501.6128-1-bartosz.golaszewski@oss.qualcomm.com>
 <c826b73d-6307-4237-a065-b7a8487350ce@gmail.com>
 <CAMRc=Me55rUmjjR+ZzdWd2ss9JJMZzJch0zKd4GqONBjCzFMYQ@mail.gmail.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <CAMRc=Me55rUmjjR+ZzdWd2ss9JJMZzJch0zKd4GqONBjCzFMYQ@mail.gmail.com>

--------------uwrMxsbcaUPR63gc8Mct0hz9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 7/22/26 04:33, Bartosz Golaszewski wrote:
> On Tue, 21 Jul 2026 20:29:39 +0200, Demi Marie Obenour
> <demiobenour@gmail.com> said:
>> On 7/21/26 04:24, Bartosz Golaszewski wrote:
>>> On Fri, Jul 17, 2026 at 06:18:48PM +1000, Herbert Xu wrote:
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
>>>>>
>>>>> [1]: https://lore.kernel.org/r/20250704070322.20692-1-ebiggers@kern=
el.org/
>>>>> [2]: https://lore.kernel.org/r/20250615031807.GA81869@sol/
>>>>> [3]: https://lore.kernel.org/r/20260706-qce-fix-self-tests-v5-0-86f=
461ff1829@oss.qualcomm.com/
>>>>> [4]: https://lore.kernel.org/r/20260629-qcom-qce-cmd-descr-v20-0-56=
f67da84c05@oss.qualcomm.com/
>>>>> [5]: https://lore.kernel.org/r/20260524204537.GB110177@quark/
>>>>>
>>>>> Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")=

>>>>> Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
>>>>> ---
>>>>> Changes in v2:
>>>>> - Add Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine dr=
iver")
>>>>> - Add Cc: stable@vger.kernel.org
>>>>> - Link to v1: https://lore.kernel.org/r/20260712-qce-broken-v1-1-85=
e2bff17871@gmail.com
>>>>> ---
>>>>>  arch/arm/configs/multi_v7_defconfig | 1 -
>>>>>  arch/arm64/configs/defconfig        | 1 -
>>>>>  drivers/crypto/Kconfig              | 6 +++++-
>>>>>  3 files changed, 5 insertions(+), 3 deletions(-)
>>>>
>>>> Patch applied.  Thanks.
>>>
>>> Hi Herbert,
>>>
>>> I'd like to ask you to back this patch out. Admittedly I should have =
NAKed this
>>> under the v1 thread but I thought the discussion we had under the Shi=
kra series
>>> and the subsequent patch making myself the maintainer of this driver =
(note: Demi
>>> did not Cc me on this nor the Qcom mailing list at linux-arm-msm) as =
well as the
>>> pending series[1] fixing the QCE issues was enough to imply we should=
 not mark
>>> it as broken. Please consider applying [1] if the fixes in v6 are cor=
rect.
>>>
>>> Bartosz
>>>
>>> [1] https://lore.kernel.org/all/20260717-qce-fix-self-tests-v6-0-4557=
75fe5f6c@oss.qualcomm.com/
>>
>> Is the BAM locking patchset also needed?  My understanding is that
>> without it, the QCE driver can still produce wrong results due to race=
s
>> with the TrustZone firmware.  Until it is merged and the self-tests
>> are fixed, the driver definitely needs to be marked BROKEN.
>>
>=20
> No, we currently don't ship TZ firmware that could cause such interacti=
ons.
> The only driver that currently suffers from such races is the NAND driv=
er
> which races with the modem firmware and it too will use the BAM locking=

> feature once it's upstream. However we do plan to support DRM using thi=
s IP
> and this is when it'll need to account for possible races. IOW: BAM loc=
king
> is not strictly required to fix the QCE.

Thanks for the correction.

Will updated firmware alone cause races, or does the kernel need to
opt-in to firmware features that can cause them?  I want to make sure
that a firmware update will not cause the driver to start racing with
the secure world.

(Nit: DRM usually stands for "Direct Rendering Manager" in Linux.)

>> Also, what can the current driver do that cannot be done better using
>> software crypto?  I understand that you have future plans to add more
>> features to the driver, but those are not relevant to this discussion.=

>>
>=20
> We can offload crypto operations to the QCE saving CPU cycles but more
> importantly, the QCE provides HW based isolation which some vendors car=
e
> about.

Would you mind explaining what you mean by "HW based isolation"?
While some crypto engines support keys that Linux doesn't have access
to, Linux only supports this on IBM mainframes.  Linux does support
using hardware-wrapped keys for inline storage encryption, but those
do not use this driver.
>> Finally, I very much appreciate the work you have done.  I don't
>> expect that the QCE driver will stay BROKEN forever.  This patch is
>> purely a reflection of the current state of the driver, the speed of
>> CPU-accelerated crypto, and the small message sizes used by the kernel=
=2E
>>
>=20
> That may have been true when you sent the v1 but with a set of proposed=
 fixes
> it'll no longer be the case.

I trust (and have always trusted) that you can fix the driver.
I apologize for not CCing you on the patch submission.

>> That said, is drivers/crypto really the right place for a restricted
>> content driver?  A driver that uses dmabufs might be a better
>> alternative, and would be easier to integrate with the Direct Renderin=
g
>> Manager (DRM) and Video for Linux 2 (V4L2) subsystems.
>> --
>=20
> These are future plans, yes. But right now we do have active users of t=
his
> IP and now also a maintainer - yours truly - who stepped up and is acti=
vely
> working on this module. With the fixes applied, the driver will again p=
ass
> crypto self-tests and should not be BROKEN.

With your patch, does the driver also pass stress tests, such as
multiple threads using it in parallel with varying algorithms and
message sizes?

If so, then I agree that the driver should no longer depend on
BROKEN, but I still question whether it is useful in its current form.
That's not specific to QCE, though.  I would say the same about many
other drivers.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------uwrMxsbcaUPR63gc8Mct0hz9--

--------------TQU0bcIC0Lu6CqgUekKUIeTq
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmpg5ckACgkQszaHOrMp
8lO+Fg//U+kk24Rg8dMnY3eAHTPzBun+SQCvZSwgGg0OvhxkDdrNmbnNkyqEAOW/
zyX4cLq3yO/GdoSMtQRGJ+FmsF44sZeML+hrR5412/3qwg4JFMXICOJ2jGc6DZ4p
bkDHr5mteg3gT6WQN8qPKn9LCrtkNP05XKzsH1o2MCXJEjlmVbsUL8uJzqDXGtUL
AMOsdMWvJyKj513aL2oLMlb/LVrIFOGPmfj2gi5MX2/NAf5uFZaCGqUVeCo7ld/6
ARmabreDLIoCZUt7hWf1ucNPL/0ORAr3af74tEGg5YV07x9iBCDmSQO5aeFWuWcZ
62mTdJQ0Fukbp/Tjoj15pTsEISWAnBVBTQ4oLiZSpJoxXQquf6e/33x5pi9YRKzp
E9C58PDV9fR7S0nCjP4kqLTUgthFrooxaBmctiJjyn99kKeVvWaTwGNokjMzbGec
ifq3rbML4ywEVzA3vsDU42PZqJY36PpdxATJ/t5pDb4g72+x7HbMKfMw1hMjDBOb
jfsmxyXARS1RSvLsy23pdlqzPtIU24J/mv/YzTKoLZXtP/oTYGKvkQa9jqlw9FM1
4VjxeN1h8hu1Pap8SnVFnRBMKBLIg3K7APwM1sKbsxqueYU75LEIV7sVfsBMi1px
iJtuXU8ATVhm4jfIEzHqrQTp+9nPAkdcJ5miWn13ddT5ECQaTxk=
=NKLC
-----END PGP SIGNATURE-----

--------------TQU0bcIC0Lu6CqgUekKUIeTq--
