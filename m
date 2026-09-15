Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9494BD782
	for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 15:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789487384; cv=none; b=XR3Gg25iVbnXCZzzvc6jim0hNt1RVamn8q9uflmBbnL42mm13cbcMDaxq8Rdc3+GeBcmM5xRuHQXiZO4XLHVxIkfZ8KbTXcD3QvjqaTJ3nUMrAmcQsLIb++X5v0mclQq+jsA8jTJkmhH7rlR2jFIr9CfPveaNp7QpZJNjHDXKoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789487384; c=relaxed/simple;
	bh=+XBllqbsJ71y2OMACCOWTTRe/OpCpvOrPstex5Z1CiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F82fThfasy6bUuysL/iDtWmJovBfWzPvCPJmVTlqMNUS5uGkbjcZKUNhLG4dRv754ASmi6MOwYFIjtIOiLUY2ySRt4Ea7AH1TnrOhq69ZBrJaJSxFT1n2xcKLjZRrWQuVCdWZsREszKC+nyeIQmn8tAsOXIcVB6h6SKGC+LvPzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OoyED1/R; arc=none smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OoyED1/R"
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d45ae011dso5828367b3.1
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 08:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789487381; x=1790092181; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0oyD/F9PlwtiOwMSHcssA0x8M3nxK1wxyEuv3ztZ73g=;
        b=OoyED1/R2+YB+q4oQsj7Es/RAPHnGm7GkWU1XMAXKKe2u6weZlTUTdn2Nems8scryq
         9L7paOBm19AfNa+6S4zfcA7+LSSWlpkPGvqCNc05SwoY0mE5U5QlSG8Fbt00U/c45V31
         FCA+eNF0IE5nU0ca1FueUY7ryYJwt8nqkuMuuPSXUmTdDCvGzWl0xMRCf3CJm8UEgdk5
         4JkBUJ+B47rqswzdN1xu7iWxU5oXcE0zL06Bdb4wKHZdAB2Em8NZ5JjQR2YIKfU/vV3+
         Uy4fl/t8yHzMI/QQ3nC0qNIXvmCeISXJj/fFP5yF1F+1ZbiKZPeFHFNuHRViBX2y3raH
         DwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789487381; x=1790092181;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0oyD/F9PlwtiOwMSHcssA0x8M3nxK1wxyEuv3ztZ73g=;
        b=x/1T1b1V1EkEk4jN+yK/VsByCJgnfyo0GkG+gWFqQCSAFQ36s+kczd6gOml0M1Nk+w
         GIJcdn9m34nooagm4yb67DsrMMpoM6GXIoYVRy6NpL2dD4n2c8+/Z1tZ7LoUrmAsK3ZT
         zDRr3WiAHktVVWzfKhW5hiRPdm0QXlKv0T2E64+SM607MQvFvdK5S9FhcmOyrJxIyLar
         lSxdB3JmE3dVuEpj78W8s007JeD1Alsd/FhJQaCCbSncnO3QhlmCuy9ixtsULCbvQrOP
         lNtHMPBqdgtefqTfECkCVMFwjvHGmMAFtSRzaZUdUD3TDwdBmq9q0lKifPehgoloqpeQ
         yWPw==
X-Forwarded-Encrypted: i=1; AKwUvByc5C9b5+/GV2ceJ0VKJZjMWIg0Ykhfo3K2O+VLT6Yja5elaIQoxheQD7vMvKQLxvqg3ET6b4xbSku2qO4=@vger.kernel.org
X-Gm-Message-State: AFuF++nS+3wY4W4tzFSaMiMo3NNbolKYYrmNQXvYT/uQImVFP3ZwAJ+B
	+qFMeSzGDMUoP1sKyZqkjK2vWDzoo5WO2jy4BuXBr9hmQcOllEHxwKcy
X-Gm-Gg: AYBFou25jrPvU1mx6qVkQMU4zH3yYQzFJCN6+O7g1N655h35udwYbIj5vzgT4F+C5ve
	fbsrt8rqL8osOxC8czyGHzLkjsUUreg1MuYp66z70wSILTlXm4nl6yAaYKfCPU3fFPNt6N5jEH6
	SHxxzBF1dbuneMVuMkKMXi5ruh7abJYM3TeqOoP13Le4trSLsTVtNswwPKqO5PIhaXs7SWEmMtd
	Ir5R5TrZXrZIX1EAeUzHdYydGPem8DS5Pp4F1kVgwqZACJ/EszET1Sf5YeYqGZ7aRc/9suR5JCU
	/vBOveAlFTc12SHi1zNzbylHnhoQsLle+2wxG2+IWdJYswsSjI/xDoM8h76FpW8RLqbQUoORVrG
	swyt5TevFtXCJJIReL2WRbsWQJPu0/RwtQQ4aXkKgkaxIgTnJPNKa4gJ75jeWGHwNTUEa5r3Rir
	CDakVLxPH0RPw/n5JtNtRUp8NT3FHRbrqive24XfCH7LPMjpSm6N6vVyO5qqWSpLc9C6QrVFU8f
	3HSH0GvZaI9
X-Received: by 2002:a05:690c:6604:b0:866:4769:d60d with SMTP id 00721157ae682-890f27e0341mr7332937b3.22.1789487380614;
        Tue, 15 Sep 2026 08:49:40 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-884871190acsm49345007b3.23.2026.09.15.08.49.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 08:49:39 -0700 (PDT)
Message-ID: <00a0910e-0c15-4f5a-add0-3cbc3457972f@gmail.com>
Date: Tue, 15 Sep 2026 11:49:33 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/12] crypto: qce - remove the BROKEN label
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Stanimir Varbanov <svarbanov@mm-sol.com>,
 Eneas U de Queiroz <cotequeiroz@gmail.com>,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, linux-crypto@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
 Eric Biggers <ebiggers@kernel.org>
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
 <20260910-qce-fix-self-tests-v7-9-cdbd2718af14@oss.qualcomm.com>
 <20260910143140.GA5719@quark>
 <CAMRc=McDHXWRfYTwRasdBCXMnoVkXK9T7RB+gBNgCsGof-euyg@mail.gmail.com>
 <c08519bb-b912-4d34-a164-5a9d65162716@gmail.com>
 <CAMRc=Mf6A98R_NxFaBiMp+N8JuzwZsSdfowwe0XvkMsUCZCL5A@mail.gmail.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <CAMRc=Mf6A98R_NxFaBiMp+N8JuzwZsSdfowwe0XvkMsUCZCL5A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------vuZP1Q4ZVZ0NeQeK20nvEN3W"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------vuZP1Q4ZVZ0NeQeK20nvEN3W
Content-Type: multipart/mixed; boundary="------------IByifCyeWEU0H7y66NiZ3XNB";
 protected-headers="v1"; hp="clear"
Message-ID: <00a0910e-0c15-4f5a-add0-3cbc3457972f@gmail.com>
Date: Tue, 15 Sep 2026 11:49:33 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/12] crypto: qce - remove the BROKEN label
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Stanimir Varbanov <svarbanov@mm-sol.com>,
 Eneas U de Queiroz <cotequeiroz@gmail.com>,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, linux-crypto@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
 Eric Biggers <ebiggers@kernel.org>
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
 <20260910-qce-fix-self-tests-v7-9-cdbd2718af14@oss.qualcomm.com>
 <20260910143140.GA5719@quark>
 <CAMRc=McDHXWRfYTwRasdBCXMnoVkXK9T7RB+gBNgCsGof-euyg@mail.gmail.com>
 <c08519bb-b912-4d34-a164-5a9d65162716@gmail.com>
 <CAMRc=Mf6A98R_NxFaBiMp+N8JuzwZsSdfowwe0XvkMsUCZCL5A@mail.gmail.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <CAMRc=Mf6A98R_NxFaBiMp+N8JuzwZsSdfowwe0XvkMsUCZCL5A@mail.gmail.com>

--------------IByifCyeWEU0H7y66NiZ3XNB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 9/15/26 05:46, Bartosz Golaszewski wrote:
> On Fri, 11 Sep 2026 20:35:58 +0200, Demi Marie Obenour
> <demiobenour@gmail.com> said:
>> On 9/11/26 07:14, Bartosz Golaszewski wrote:
>>> On Thu, 10 Sep 2026 16:31:40 +0200, Eric Biggers <ebiggers@kernel.org=
> said:
>>>> On Thu, Sep 10, 2026 at 03:00:50PM +0200, Bartosz Golaszewski wrote:=

>>>>> All self-tests now pass.
>>>>
>>>> Have the other bugs that were reported been fixed?  For example:
>>>> https://lore.kernel.org/linux-crypto/20260723202704.GB110634@quark/
>>>> https://lore.kernel.org/linux-crypto/20260723183438.GB93534@quark/
>>>> https://lore.kernel.org/linux-crypto/20260723205342.GC110634@quark/
>>>>
>>>
>>> I will get to these too. For now, the series allows the self-tests to=
 pass,
>>> I assume it it's enough to not keep the BROKEN label.
>>
>> Personally, I think the driver should stay BROKEN until all the
>> known bugs have been fixed.  The self-tests aren't enough for HW
>> crypto drivers.
>>
>>>>>  	help
>>>>>  	  This driver supports Qualcomm crypto engine accelerator
>>>>
>>>> As this patch would make the kconfig option visible again and would
>>>> result in everyone running "make oldconfig" being asked about it, it=

>>>
>>> I don't mind changing the symbol if you prefer it to avoid any accide=
ntal
>>> `make oldconfig` carry-overs.
>>>
>>>> needs to be fixed to accurately document why anyone would want to en=
able
>>>> this option.  As you've stated, it's actually just for "testing".  T=
he
>>>> false claim that it's an "accelerator" also needs to go.
>>>>
>>>
>>> "Offloader" for lack of a better word?
>> Could it be called a "decelerator"?  That would give users an idea
>> of what to expect from the driver.  Maybe explicitly mention that
>> you will take at least a 50x performance hit?
>> --
>=20
> Yeah, very funny. Jokes aside: "Offloader" says what it both *aims* to =
do and
> really *does* without claiming it *accelerates* anything.

This wasn't meant as a joke, but I could see how it could be seen as
one.  Sorry about that.  No offense intended.  "Offloader" also works.

As an aside, I trust that you are doing the best you can.  Maintaining
an unpopular driver is not an enviable task.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------IByifCyeWEU0H7y66NiZ3XNB--

--------------vuZP1Q4ZVZ0NeQeK20nvEN3W
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmqpaQ4ACgkQszaHOrMp
8lM6BBAAiz3vwhbkTZCjeNU85AKdXDPBAQecchq8P22HNlj9MpKYAYGpg/VSPyJP
MDYb1PN5Cm/D3ZbFYkqICuAa8PInhA+knhDP+Iz5867DS+fAom4I6BTrxXKDvWmT
0sdQLCSExrxY24OUP9i5ajSrlTZhSJbeo2rV0MImi5I6qM7YJc2d+WXyXES2j+Eu
Y6YK+/siNC1N4qbN97B3zzacMc1fs0pQzNsq3Pbe0Z3UdUHyIcibNOsoM5r3LYye
2CPpF0BRIROL7ydGrcsgNS38W0PuPHajbNZsyjlagWor7Pk3zTZCtuonqgDINoZ6
io6remDuynXyozSSXP5gj+xfg34evwbrbDOgrDZYRfD1e32bnTFvEoqcqjNM1Q9D
axP3Y+b1nAxE/aD+xWJX7Jp1QkrvdJaWfwk29I+uI3vLlZau5YzEjqaGfuKMWSP+
+H+guHBTUEDMi7jSv8JVM22v7VhGRew7KAsCvJGHcf+yA4A5zQSb5GKLHI+wnb4f
klWhIHk92C6bD4Vg9FjSl3AKtjs27fgGO4m4y9q/Y3zNdWO5aPT7o3CYs6I8OyXB
Sf2lqGihrj8nCbi+MWOzrlSigFO/Y7lre+qk34vYX59S64sM70tRxywyTBvF8967
aLm4WfQRy1Zz0CMeyFZ4qTw2g0uH955BXAQKP/UsosVImYv6ysU=
=8w5m
-----END PGP SIGNATURE-----

--------------vuZP1Q4ZVZ0NeQeK20nvEN3W--
