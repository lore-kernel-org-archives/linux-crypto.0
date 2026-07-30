Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FCD35E950
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 16:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785429641; cv=none; b=pX6ooKrotFD9rluVOXTtK2lP9vIhUpY0A17rXoFUv1/oC4fdq9TOyrW6MEMey667SNH+h+nY/feMhvFXOfsAUIZGS0YCkC2aFozOt73l/0jc8oq5N5lPVhB58l0OUYw4rAEtcHEHjDrVZkMr+bkTYsLm2jKZZD9eAcWV2dKlGgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785429641; c=relaxed/simple;
	bh=MDmncVH+R1f9SNuCm3TxZ87o8ZL83l/aYHCM3HJKBXc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oUKpZesNBetnQ8raTf1rjG8HIf7BeKB+6vLaP/o64knbxHYxvAEsZ7OzHtMtt91s+alxpwV5mJbHrSA/WmP1Hr9JUmnBKXQeXTk36U29Wiq0uasWZllL6Y6+SmQSNCmLYb95LSeobcuElrdvzUGFvva+FppBCSDv17ZSdKXUuOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cezdU55Y; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cezdU55Y"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-81ed2a06b9eso118717b3.3
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 09:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785429639; x=1786034439; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YfpnUPF7TlTq7vSAp+ZqT2dgaYktImF1Phgue3yKrAI=;
        b=cezdU55YG9d58j99fyRmRxbtj3BRXRpC6lJmRoCueBW9COK7Y99PupjhmrwEm52k+I
         Ze4e6GfOt3cP4R7W9bkUK3bOknkp5GNOT28HWahgzY6q17NGMklcFBkrtxZwg3euShSE
         TiN6TknXWLNXmovWiEpNpubHa4UglOzEqKt3u8CCv9EImdpwih6KpHbdMWnhCafBgi4A
         7/qkpPc6FqyNJAVOSKpcB5CnJ+NMzVB7PaAIY+IKVUU5dTPjuoD3NaTkVRTdyQUdURgo
         ImShKV3J6xKSovjNj2NJNQSLWe7q12Try+w6xcPLAs59aWx5dnOXC51UtrKZ0cnDAVMu
         FAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785429639; x=1786034439;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YfpnUPF7TlTq7vSAp+ZqT2dgaYktImF1Phgue3yKrAI=;
        b=XppI52BqJdqWkvBHwVI3nCIu91BFh+BgVV5oYcOXvi0cXA6m3dEF9M3cZp/nrCp3YO
         B1huC7qJpTpEMJaKXuvI5q0IG0cuANKUCorJmy8rFkmSlcT3D1x0AqE8B7U0QpvPXbiS
         Vc3jRWIZTlJpxMq89hngSddm5s+zSiWld7XLxoSyMD5K9xYP2PrrGPd9rp5XCsN5lEhn
         hXvxW2XKtdk9hV26Qa1LqkjyG6eJRkQxNyeBb6ZPRQu91OUjORgVHycqndbYWz+77cSQ
         Y0YhEC6agpbjp2lnxOEBZUGph2GamWCImLqV53DX5ORTkCg9m3nrxwiQasQ/Lybq3k8A
         63IQ==
X-Forwarded-Encrypted: i=1; AHgh+RqklYnCBXeHF6CC8saL3NexWr50X71gFtcpuwgmzs0foutMMfcmNW9b0dtMD1vorRPb7zblr0Lr+w2E61M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNRvvQr/hMcn6uE7+yFtX8UtegzJo85sjzbZrYLsGZN8ZXOm2P
	hX4GxKz1s5fP2dCNBgmbT8hDXmfMzRWqJNTQLOc/PbNJjkF8+9yEcpFY
X-Gm-Gg: AR+sD10B/qHQ/rLXKuMli0I1Z5VasHZIWPMNYwxkQCUkMKAA60gauKWFM0mk+5kdwws
	6q6dRziZIdX8+lRePnSQ5yi0/G1no42x2tf3PotfshsE7JA+Kq2xxEux4Y1vekAeWrq87SumRH9
	jZOfoS86fEmZbxlmen2KULd6WP3x9zFxtyOeuo5BHe4YKNtY1Fg/239GqR1hkXNXa+qrp1BhYfp
	sDlnYRYBs9R2SwVwgL1A6P7J0+yqeIfrK4W3Ps2y8Y14c6Q5tLHbBRUF0YSy1orzMy74RT586Zh
	LRT1km0T92rv1h5QV6QHXqUo/KWCKqMckP7O8VzUK88WlNI1phRuzmbQMB3Fzw0Gwo2i33pjV50
	V0+T6u7miCi+dXxK3W+tcFNRzQLTEJGTiCdS61ao7JBa4SqDBsNixcdU3ruDCXTmif1zO373OsF
	0WrQpMVflSrLv1m8S4wp+b9HBJXD5oqeVCsvTrsn91WEeqP9PmfM5T54ULPAAQLEg=
X-Received: by 2002:a05:690c:6307:b0:80b:bc16:8a2a with SMTP id 00721157ae682-81fb8a61e5dmr22019597b3.36.1785429638853;
        Thu, 30 Jul 2026 09:40:38 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fb8a8dc3asm13141507b3.25.2026.07.30.09.40.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 09:40:37 -0700 (PDT)
Message-ID: <38162447-df7e-4fbc-b438-b48181d10186@gmail.com>
Date: Thu, 30 Jul 2026 12:40:22 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Remove driver
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
 Eric Biggers <ebiggers@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Bartosz Golaszewski <brgl@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-msm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
References: <20260724141414.GB1876@sol>
 <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
 <2026072455-subtly-prayer-0a8a@gregkh> <20260724150932.GA6763@sol>
 <2026072428-ungodly-outsource-b20c@gregkh> <20260724155144.GA2032@sol>
 <20260728152241.GA4281@quark>
 <15904301-fd03-45e5-b909-dfce52449726@kernel.org> <20260729145520.GA1702@sol>
 <50d9d0e4-28c9-42b6-8b71-e75682b4959c@oss.qualcomm.com>
 <20260729171850.GA4454@quark>
 <a5e953b8-89fb-4f65-a299-37352d9f6fa8@oss.qualcomm.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <a5e953b8-89fb-4f65-a299-37352d9f6fa8@oss.qualcomm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------t0ihQmACXOEWelq02XhLBP1h"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------t0ihQmACXOEWelq02XhLBP1h
Content-Type: multipart/mixed; boundary="------------2XlfptUy3V5rxBrmNjBlQbIv";
 protected-headers="v1"; hp="clear"
Message-ID: <38162447-df7e-4fbc-b438-b48181d10186@gmail.com>
Date: Thu, 30 Jul 2026 12:40:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Remove driver
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
 Eric Biggers <ebiggers@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Bartosz Golaszewski <brgl@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-msm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
References: <20260724141414.GB1876@sol>
 <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
 <2026072455-subtly-prayer-0a8a@gregkh> <20260724150932.GA6763@sol>
 <2026072428-ungodly-outsource-b20c@gregkh> <20260724155144.GA2032@sol>
 <20260728152241.GA4281@quark>
 <15904301-fd03-45e5-b909-dfce52449726@kernel.org> <20260729145520.GA1702@sol>
 <50d9d0e4-28c9-42b6-8b71-e75682b4959c@oss.qualcomm.com>
 <20260729171850.GA4454@quark>
 <a5e953b8-89fb-4f65-a299-37352d9f6fa8@oss.qualcomm.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <a5e953b8-89fb-4f65-a299-37352d9f6fa8@oss.qualcomm.com>

--------------2XlfptUy3V5rxBrmNjBlQbIv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 7/30/26 07:15, Konrad Dybcio wrote:
> On 7/29/26 7:18 PM, Eric Biggers wrote:
>> On Wed, Jul 29, 2026 at 06:55:20PM +0200, Konrad Dybcio wrote:
>>>>> Unfortunately removing it drains way more battery, because the buse=
s
>>>>> never hit sync_state and are kept at their maximum frequencies:
>>>>>
>>>>> [   18.021823] qnoc-glymur interconnect-1: sync_state() pending due=
 to 1dfa000.crypto
>>>>> [   18.029605] qnoc-glymur 16e0000.interconnect: sync_state() pendi=
ng due to 1dfa000.crypto
>>>>>
>>>>> (it transiently also pins DRAM and friends to max-freq which absolu=
tely
>>>>> kills battery life)
>>>>
>>>> Isn't that easily fixable by marking the node as "disabled" in the
>>>> device tree, or even just deleting it entirely?
>>>
>>> Avoided? Yes. Fixed? No. The DT is valid but Linux can't deal with it=

>>> [since the driver is gone]
>>
>> If needed we can keep a stub driver that just disables power and doesn=
't
>> register anything with the crypto API.  I can send a patch that does
>> that.
>=20
> I believe we (are going to) need something like that in the kernel
> for similar cases, however I'd rather see this driver kept/reinstated
> for the reasons Bartosz is arguing

What about removing all of the code that actually does cryptography?
The problem isn't that the driver can't be fixed, but that:

1. It requires additional maintenance, and not just by the driver
   maintainer.

2. Even if the driver never needed maintenance, the QCE is so slow,
   and the driver overhead so great, that the features currently
   exposed by the driver should never be used.

As Eric pointed out, the future use-cases Bartosz mentions should be
implemented by a driver that isn't in drivers/crypto.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------2XlfptUy3V5rxBrmNjBlQbIv--

--------------t0ihQmACXOEWelq02XhLBP1h
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmprfoAACgkQszaHOrMp
8lMBZQ/9H6ZnMZ4uJsLXk8rgQwcjpwkvE2geQEnARvBDB6Iqj12QyxW9XwqYXuCI
PfY3jgcYXQKXKQ+ym1t9Gzxp7cJSbofZaF9gEbem32oWVr6y/i77jmo+rXfnnfLb
bQzaRIx/6iVWvonQBG2zpNfcxN7FlWCWo2pb66X/S/NcSQIOtzDaOnU7K+uYGper
UVdhLsmoKl05OI1YOyQblE2dTyIAHGwEfpBOdxyIU1zxLZEnXSXsrJ9k4EUbH8WG
rSKbgOi2Z2ShTMb0KtopbDRvRvq3f4OltTP/esti0Zl42zrq9rQCTiHb9hU2KDFc
w8/KBdFUUj3J3vX7h56NiLtNEdONy5bECFf3WdlD90Q6ljA+wJTONcDM0Ltf9Lqb
RXXmVu17gzQGPKndNezR9Hry/h120dMAuh6MYSQdtbgSqMonOr64BinIABvJPq4B
2kyOatWo/Cl6J3ZRdAB57B0QGeOloazN/RtorcAY53ahQND16k3KXSWE47gd62lI
3VEF6pxF0Mn9MDCcgj6ZBgAnnzAUMSN2Vt9j+diV4hD+gKAsWVtjd6HEAyDpBonF
crI6EV9BI64v+xjL9mEv8uaMmSW6T6M3Fd90HcO/o1p7css3J2LZhCUD+rKQzaHC
DonTImuEaFapgVYepstb5q9eWIEb+mhH+k6UMeQQ16jEJWa/63A=
=zInT
-----END PGP SIGNATURE-----

--------------t0ihQmACXOEWelq02XhLBP1h--
