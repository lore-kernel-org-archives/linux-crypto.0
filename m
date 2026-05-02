Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BB8263C9F
	for <linux-crypto@vger.kernel.org>; Sat,  2 May 2026 20:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777754542; cv=none; b=ChNHHBn4pG/mj6ePMJFq+WemhW7kkPDFhWqLVo5+Qgic8oI9NKLs6udIlVkkg9X05y3QRyci1KcdJHJkPbnhNATHT2XCTPnEmcCi9cFNkP16bhGxpzRZeEPKKWVnH1vF0ME6xML9V4vMMK5OudQTpZL9K4C+/M8jj78sG6NmfYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777754542; c=relaxed/simple;
	bh=rzCuw4KubAEBoo5OPUJZ1rLUpMwWAr4ksYeDuDUG9sg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kl3x3X8+ddhsmPhTURW4MFEzP5mLp4el2K8hnLcsUeC72JT7fwDVQ177ZeWyyDr32Yf1Wls87MY2PnPjY44PNyjj9lhtUs1nGxdhtVVT51diD8NsDjhzxMVWl+96+7/jeXXOUT9RyQH8QEBjkyir5qq+/hAZpdBROZRxInAsAWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oenQ7+lc; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oenQ7+lc"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-79a46260385so37058867b3.3
        for <linux-crypto@vger.kernel.org>; Sat, 02 May 2026 13:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777754540; x=1778359340; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fmUEYuw8u4LFnKQA/NeB79TolKqpNXTvZCl8uTW1eC4=;
        b=oenQ7+lcnabKECy8NzCm9x7CpZqzO4W7Hb+//cU6OakM+Eg1V8YMRubdxzYXP5juKh
         YuIIKARIY24cgzrV7Zx3mozLza+3fNxy44qVKnLIKl2eeX/Ki3KrG2BCijtCDRJrtFOJ
         DM9ZR7jkPNsfhvyZPpbx+Q5nJPP96A/83sPWglH8JILUs8ISNk9F+x5Z0RnBAraaU9/B
         cd/9gbW+gJzSHHKD8J/JuppPk4e0L+vNVJQI31QQgVLbZnUjnwrhLwvrV9nxg29LSVUk
         EX5EOwWJJ/U8nNAN0KDrMGZ8nSj2gWpJ5UNpIT9f487iPs1kBuL+sMxLbiHuVEMmnxB0
         8Sug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777754540; x=1778359340;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fmUEYuw8u4LFnKQA/NeB79TolKqpNXTvZCl8uTW1eC4=;
        b=ACgax49xx6oGTY78SuSqDeDhBXEk0JXvb4DCl8dFi1j1OAni59sJTvVf4XS/9zQr+o
         pxkE9O8E5dUpNgse7aZ9vqzvCFSqb2wZHea5pv8UUptBSvnhTUMaXjGR1Qh8Jq6cYFMm
         sQ6O+srTfX+3zJcCLdqqzpWC/h73GROES0OJHwDScU0satpUkqHop8PjpGI8ktv+ISZ4
         +NAJum4Zp83zQhZrKviivWuFPsoyGbHekz2w+RQHDWFsiw3IH0VFICLOfXcWs7mC81lF
         945SkxhgOFVL+kgB8FxeQPtv6EP65qdfIarpRD3/cn73t1d29jgSHFctij2831Wj2Fpp
         FOXg==
X-Forwarded-Encrypted: i=1; AFNElJ9X3m0GI5p9AvP1fd1ryeWjnmkDuwdA+JhZ3CcLeb9OKArEjA5icm2U1YY9shHuy8VtVE/AShlz82SLdww=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1y+9mvUc0C5WLMScn6a078h+WbfCrkejt7MPCEmo4wRcmwJqY
	o1zrrnJNKHeBNyjUojKppalBgB5ip83QmIu09yGOIMuGJmixgyiZrdZrmNoaF39K
X-Gm-Gg: AeBDievmkxuNUSoqHUKiAbwbgrQqw3QLHLpNL+Ui62tBvEsJSXR7yb3yW0WE/VxXl+a
	168uxKFiIhLg47Yb9v6O0yxj2T/GduBCa4VjgJlb9kTvn1tMjakmJOQqAvjFxmLBuHgIXiU5atC
	fDkJ8kE2Gcq68AbpTbNL1wi/tCbXGkmC+jZW8GviJEVbIpk2ERLldtds6gVhchprlZ93MgUGPrl
	v2STm58Z9IdmMGgg0q8a/F2Imz8GHglP7pjELvxOD36AJ3P2o9e+4i0bSMzfuX1TiI8KepjHfbu
	j8KzGnXJKnWTirSJsvzdLmLEh4MFQR/bd4pz1r+ZqwIqRGxP52sIZKc+qJVYcnnUvKxcPtFIqGc
	DdA0kdYKEhFvx+rXT5s0SVy79kwI+KNzVEa2wqI2mi1EXq6FO54iIm7M19o8tRLt9ayNkMExwkp
	S2K2Zu3jMX5yFLbPrQ3N2cJsCQxrYCMyBsj9uecUPulM0BdPGZvQNPMFNnmEuJTJDtyiHv6hY5c
	33vF0PLbgfBsGVdnldFe5qVmcZkRhybjdlJywVg/HH8vQdImJJz
X-Received: by 2002:a05:690c:e566:b0:7b4:53df:b02 with SMTP id 00721157ae682-7bd770b45bcmr36217877b3.28.1777754539651;
        Sat, 02 May 2026 13:42:19 -0700 (PDT)
Received: from [10.138.34.110] (h69-131-150-190.cncrtn.broadband.dynamic.tds.net. [69.131.150.190])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd66525651sm28182957b3.3.2026.05.02.13.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2026 13:42:18 -0700 (PDT)
Message-ID: <066d6e56-3b54-40a6-962c-932fedcdc489@gmail.com>
Date: Sat, 2 May 2026 16:42:01 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: AF_ALG hardening
To: Simon Richter <Simon.Richter@hogyros.de>,
 Eric Biggers <ebiggers@kernel.org>
Cc: Jan Schaumann <jschauma@netmeister.org>, iwd@lists.linux.dev,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
References: <afJorKIje4O6dXbH@netmeister.org>
 <d6111caa-db61-498a-92cb-ea7a0aa0a5e2@ehuk.net> <87se8dgicq.fsf@gentoo.org>
 <afL-QhLfEKqHZqka@eldamar.lan> <20260430071917.GB54208@sol>
 <177abb5d-8ba9-4bb9-8b23-9fbc868ed3cd@gmail.com> <20260501180028.GA2260@sol>
 <19837ef5-e5b6-45f4-8336-3ce07423dfb1@gmail.com>
 <20260501201841.GA2540@quark>
 <c13dd3c5-ddc1-431e-bc7d-2de39c551f8e@gmail.com>
 <20260502033556.GA3872267@google.com>
 <3cc88b2d-fbd6-4e47-b82c-3c685fec0581@gmail.com>
 <9f020da7-97c5-41cc-b0f1-d8aab1bb39ec@hogyros.de>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <9f020da7-97c5-41cc-b0f1-d8aab1bb39ec@hogyros.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------niMEkCTt5ax09ch5y2go3Q8L"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------niMEkCTt5ax09ch5y2go3Q8L
Content-Type: multipart/mixed; boundary="------------7u0qb8fUCMQJnhdIuMBgcjYR";
 protected-headers="v1"
Message-ID: <066d6e56-3b54-40a6-962c-932fedcdc489@gmail.com>
Date: Sat, 2 May 2026 16:42:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: AF_ALG hardening
To: Simon Richter <Simon.Richter@hogyros.de>,
 Eric Biggers <ebiggers@kernel.org>
Cc: Jan Schaumann <jschauma@netmeister.org>, iwd@lists.linux.dev,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
References: <afJorKIje4O6dXbH@netmeister.org>
 <d6111caa-db61-498a-92cb-ea7a0aa0a5e2@ehuk.net> <87se8dgicq.fsf@gentoo.org>
 <afL-QhLfEKqHZqka@eldamar.lan> <20260430071917.GB54208@sol>
 <177abb5d-8ba9-4bb9-8b23-9fbc868ed3cd@gmail.com> <20260501180028.GA2260@sol>
 <19837ef5-e5b6-45f4-8336-3ce07423dfb1@gmail.com>
 <20260501201841.GA2540@quark>
 <c13dd3c5-ddc1-431e-bc7d-2de39c551f8e@gmail.com>
 <20260502033556.GA3872267@google.com>
 <3cc88b2d-fbd6-4e47-b82c-3c685fec0581@gmail.com>
 <9f020da7-97c5-41cc-b0f1-d8aab1bb39ec@hogyros.de>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <9f020da7-97c5-41cc-b0f1-d8aab1bb39ec@hogyros.de>

--------------7u0qb8fUCMQJnhdIuMBgcjYR
Content-Type: multipart/mixed; boundary="------------hu1RKiH9X1kKYgZXYrkdFbVM"

--------------hu1RKiH9X1kKYgZXYrkdFbVM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 5/2/26 04:19, Simon Richter wrote:
> Hi,
>=20
> On 5/2/26 13:52, Demi Marie Obenour wrote:
>=20
>>> Of course, it'll also be a fair a bit of work, and unfortunately I al=
so
>>> expect pushback from people who (incorrectly IMO) think that AF_ALG
>>> performance is important, even moreso than security.
>=20
> AF_ALG performance (time/power) is important in the way that it's=20
> literally the only point to its existence. If all it provides is extra =

> overhead over a software implementation, then it makes no sense to keep=
 it.

The only reason for keeping it is for compatibility with existing
userspace.

>> If one cares about crypto offload performance, they would be better
>> served by creating a better interface to it than AF_ALG.  AF_ALG is
>> a horrible API with (presumably) tons of overhead.  I know the QAT
>> driver and an Nvidia BlueField DPU accelerator driver both bypass it.
>=20
> The API is designed to be zerocopy, that's why it's this horrible=20
> combination of socket API and splice(). The general assumption here is =

> that it does not make sense to offload small requests in the first=20
> place, and application programmers are aware of that.
>=20
> The use case is "I have a file or pipe full of data and a device with a=
=20
> kernel driver that should process it, can we somehow avoid copying the =

> data to userspace only to immediately copy it back to kernelspace?"
>=20
> This copying is even more silly if the actual question I have in=20
> userspace is "what is the SHA256 checksum of this file?" or "what is th=
e=20
> SHA256 checksum of the string 'blob 8794311528\0' followed by this=20
> file?" (where you can see why anyone would ask such a silly question an=
d=20
> prefer to use the dedicated hardware that processes 24 GB/s over the CP=
U=20
> at 100 MB/s)

Do you have a specific device that has such hardware and can use an
upstream kernel?  I have yet to see any concrete examples.

>> Furthermore, AF_ALG only supports symmetric algorithms.  These
>> algorithms are inexpensive in software, so the cost of going to an
>> accelerator and back is enormous compared to the cost of a single
>> operation.
>=20
> Yes, initial setup cost is high, so this only makes sense for large=20
> requests or batches (submitting individual requests is generally cheap,=
=20
> the difficulty is ensuring the data is accessible to the hardware).
>=20
> That's also why there are no asymmetric algorithms: these aren't=20
> generally used on large amounts of data, so it's never worth it to=20
> offload these.

Asymmetric cryptography is far more expensive than symmetric
cryptography.  Tens of microseconds or more on a high-end CPU
I believe.

That is more than enough time to justify going to an accelerator and
back, if the accelerator can do the job significantly faster.

> It would make sense to offload asymmetric algorithms if there was a=20
> secure key storage inside the device, but AFAIK the API does not suppor=
t=20
> that, or even the notion of on-device contexts.
>=20
> It is not a good API, and it sits on top of the ahash/acomp/acrypt=20
> interfaces which are also unfriendly to accelerator hardware.

Not surprised.

>> For offload to even a very fast accelerator to make sense,
>> one must be able to deeply pipeline requests.  However, this creates
>> a huge amount of additional complexity for software.
>=20
> Software that has requirements like that is already complex -- if I hav=
e=20
> a few thousand workload packets, I need a worker pool.

Or a thread-per-core architecture.

> If I don't have these requirements, then indeed I am better off with a =

> software-only solution in userspace, because it is not relevant from a =

> performance standpoint.
>=20
>> Asymmetric accelerators also don't have a better alternative in the
>> form of inline encryption hardware.
>=20
> Quite a number of architectures do not have inline encryption support, =

> and these are more likely to use offload hardware even for smaller=20
> requests (e.g. for power saving).

Please provide a real-world example where that using the accelerator
really does save power compared to running the cryptography on the CPU.

>> I think a high performance interface to hardware cryptography (and,
>> more importantly, compression) would look much more like RDMA.
>> There would be a kernel driver that did the bare minimum to provide
>> isolation between userspace programs, and a userspace driver that
>> was responsible for abstracting over the hardware.
>=20
> Offload hardware comes in two flavours: the high-throughput kind, built=
=20
> into devices where no one cares about power, and the=20
> lower-power-than-the-CPU-doing-it kind.

Again, please provide benchmarks.  I have yet to see a real-world
example where the accelerator is faster for short (read: realistic)
message sizes.  Eric Biggers has provided many where it is far slower,
and didn't find any situation where it saved power.

For very long messages, yes, it can be faster.  But I have yet to
see a situation where (a) performance for large files matters and (b)
there is an accelerator worth using.

Network and storage encryption is obviously performance-critical,
but it uses small messages.  Furthermore, both of them are well-suited
to inline cryptographic engines, which are much more efficient.

I mostly associate large file encryption and hashing with things
like verifying software updates.  On large systems, this matters
because a human is waiting.  However, these systems are also ones
for which software cryptography is very fast.  On small systems,
I expect update validation to be much less performance-critical.

> The former can easily provide user contexts even in virtualized=20
> environments, but the latter is generally found in systems that do not =

> even have an IOMMU. Either we have two distinct interfaces for these, o=
r=20
> we need one that can handle either.
>=20
> My feeling is that no one is happy with either AF_ALG or the=20
> asynchronous interfaces in general, so I think they should be removed=20
> completely, and there should be a separate "offload" SIG that creates=20
> new interfaces that are actually usable with current hardware.
>=20
>  > 1. Get rid of zero-copy support (splice()).
>  > 2. Get rid of AIO support.
>  > 3. Only allow software implementations.
>=20
> That makes sense if we're forced to keep the interface for now, but it =

> means that offload support through the crypto subsystem is completely=20
> dead, and anyone wanting to support offload hardware needs to go=20
> elsewhere. Can we get a definitive statement that this is intended?

AF_ALG is dead.  Much of the rest of the kernel is moving from the
crypto API to the software-only crypto library.

Offload is far more complex than software cryptography, so there needs
to be a substantial benefit to justify using it.  Have you seen any
real-world cases of this?  Inline encryption hardware (both in storage
controllers and in NICs) is definitely a win, but it doesn't use the
crypto API at all.

It's easy to provide synthetic benchmarks where offload is a win, but
synthetic benchmarks don't justify a giant CVE magnet.  If offload is a
win in the real world, then it should be possible to demonstrate this.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
--------------hu1RKiH9X1kKYgZXYrkdFbVM
Content-Type: application/pgp-keys; name="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBFp+A0oBEADffj6anl9/BHhUSxGTICeVl2tob7hPDdhHNgPR4C8xlYt5q49y
B+l2nipdaq+4Gk6FZfqC825TKl7eRpUjMriwle4r3R0ydSIGcy4M6eb0IcxmuPYf
bWpr/si88QKgyGSVZ7GeNW1UnzTdhYHuFlk8dBSmB1fzhEYEk0RcJqg4AKoq6/3/
UorR+FaSuVwT7rqzGrTlscnTDlPWgRzrQ3jssesI7sZLm82E3pJSgaUoCdCOlL7M
MPCJwI8JpPlBedRpe9tfVyfu3euTPLPxwcV3L/cfWPGSL4PofBtB8NUU6QwYiQ9H
zx4xOyn67zW73/G0Q2vPPRst8LBDqlxLjbtx/WLR6h3nBc3eyuZ+q62HS1pJ5EvU
T1vjyJ1ySrqtUXWQ4XlZyoEFUfpJxJoN0A9HCxmHGVckzTRl5FMWo8TCniHynNXs
BtDQbabt7aNEOaAJdE7to0AH3T/Bvwzcp0ZJtBk0EM6YeMLtotUut7h2Bkg1b//r
6bTBswMBXVJ5H44Qf0+eKeUg7whSC9qpYOzzrm7+0r9F5u3qF8ZTx55TJc2g656C
9a1P1MYVysLvkLvS4H+crmxA/i08Tc1h+x9RRvqba4lSzZ6/Tmt60DPM5Sc4R0nS
m9BBff0Nm0bSNRS8InXdO1Aq3362QKX2NOwcL5YaStwODNyZUqF7izjK4QARAQAB
zTxEZW1pIE9iZW5vdXIgKElUTCBFbWFpbCBLZXkpIDxhdGhlbmFAaW52aXNpYmxl
dGhpbmdzbGFiLmNvbT7CwY4EEwEIADgWIQR2h02fEza6IlkHHHGyiLVf/5wiwQUC
X6YJvQIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRCyiLVf/5wiwWRhD/0Y
R+YYC5Kduv/2LBgQJIygMsFiRHbR4+tWXuTFqgrxxFSlMktZ6gQrQCWe38WnOXkB
oY6n/5lSJdfnuGd2UagZ/9dkaGMUkqt+5WshLFly4BnP7pSsWReKgMP7etRTwn3S
zk1OwFx2lzY1EnnconPLfPBc6rWG2moA6l0WX+3WNR1B1ndqpl2hPSjT2jUCBWDV
rGOUSX7r5f1WgtBeNYnEXPBCUUM51pFGESmfHIXQrqFDA7nBNiIVFDJTmQzuEqIy
Jl67pKNgooij5mKzRhFKHfjLRAH4mmWZlB9UjDStAfFBAoDFHwd1HL5VQCNQdqEc
/9lZDApqWuCPadZN+pGouqLysesIYsNxUhJ7dtWOWHl0vs7/3qkWmWun/2uOJMQh
ra2u8nA9g91FbOobWqjrDd6x3ZJoGQf4zLqjmn/P514gb697788e573WN/MpQ5XI
Fl7aM2d6/GJiq6LC9T2gSUW4rbPBiqOCeiUx7Kd/sVm41p9TOA7fEG4bYddCfDsN
xaQJH6VRK3NOuBUGeL+iQEVF5Xs6Yp+U+jwvv2M5Lel3EqAYo5xXTx4ls0xaxDCu
fudcAh8CMMqx3fguSb7Mi31WlnZpk0fDuWQVNKyDP7lYpwc4nCCGNKCj622ZSocH
AcQmX28L8pJdLYacv9pU3jPy4fHcQYvmTavTqowGnM08RGVtaSBNYXJpZSBPYmVu
b3VyIChsb3ZlciBvZiBjb2RpbmcpIDxkZW1pb2Jlbm91ckBnbWFpbC5jb20+wsF4
BBMBAgAiBQJafgNKAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRCyiLVf
/5wiwYa/EACv8a2+MMou9cSCNoZBQaU+fTmyzft9hUE+0d5W2UY1RY3OsjFIzm9R
/4SVccfsqOYLEo+S0vQMIIIqFEq3FCpXXwPzyimotps05VA8U3Bd7yseojFygOgK
sAMOAee2RCaDDOnoJue01dfZMzzHPO/TVdp3OvnpWipfv5G1Xg96rwbhMLE3tg6N
xwAHa31Bv4/Xq8CJOoIWvx6fcmZQpz01/lSvsYn0KrfEbTKkuUf0vM9JrCTCP2oz
VNN5BYzqaq2M4r+jmSyeXLim922VOWqGkUEQ85BSEemqrRS06IU6NtEMsF8EWt/b
hWjk/9GDKTcnpdJHTrMxTspExBiNrvpI2t+YPU5B/dJJAUxvmhFrbSIbdB8umBZs
I3AMYrEmpAbh5x7jEjoskUC7uN3o9vpg1oCLS2ePDLtAtyBtbHnkA4xGD7ar8mem
xpH9lY/i+sC6CyyIUWcUDnnagKyJP0m9ks0GLsTeOCA0bft2XA6rD6aaCnMUsndT
ctrab42CV5XypjmC4U1rPJ8JQJUh1/3P48/8sMH+3krxpJ06KNWNFaUbaMTGiltZ
7x9DngklSYrX0T+2G4kVXNmjaljwkoLahwLla2gUWwBSyofXdqyhQdwZsp01KXNQ
UCyT/Pg+aDcm/E7OMV3d4lf7g/CSxiX2GSEe6BlhSz+Lmd7ZJ3g32M1ARGVtaSBN
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
EtJuZYM5blWncBOJCoWMnBEcTEo/viU3GgcVRw=3D=3D
=3Dx94R
-----END PGP PUBLIC KEY BLOCK-----

--------------hu1RKiH9X1kKYgZXYrkdFbVM--

--------------7u0qb8fUCMQJnhdIuMBgcjYR--

--------------niMEkCTt5ax09ch5y2go3Q8L
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmn2YaMACgkQszaHOrMp
8lPGKRAAiEY2SlNX1XOiA0OMpWM6dJQIEBe/I9Uf3HFWT8JwoiXfbBunjN06+Z9r
zQHdKdiYjrQTJNlryBsOVgHqvE8sfFBeln/RAqixOHwg16ForlGRLvYeggR8R61A
L7PYSGCyPrd2QpJUuFBdbbMRl6oy40MW8PNUKSMZ9NzsD/yMy0Ov5s5me4g/BROf
evq2xcvXUqU2wgVaN90XwYJN11JvwWK/t1fgPAOJrRBI1xfW0WhJjn/OJfN3Oakh
UrDgzLXmgeoTd4103zR5B2O8yWFrrUwb0QBDeQw27LMif5HZZSza3au9P4J3TNx/
QWuPjCI422CY1Ciep5dhdFJ1tk2qi0UVxN2UygoR0NCESWSTQ5zHodT24RNosAWN
+K5aEHPJYlCD4meaKKqQssXRs64e88Ug69K4pft2ABdWLaD0rTfMOAEmSLh0Uyk/
vqPbdH00FmGqvTbZ3+Ul+4iGxiAr394bxHbWdIBW5u/sgUMz7CaNxH80CXFTgfSl
d5/4Qnbm4zGQJ46Xl7K9dA44/2m2X1GxBRaggh4QfiPn1MiNYsQqj3n3JxvMe8jW
xlV7Ad9BgNqE9cTU1iQ5eZqN5VA4GTMZrdg6ANnV+cSwmbTG9PlWlA48jztEnE+7
Jh/6FbToQgP1gc3T0Shp0arQvEBWXzpS7zHXE+dPs297m6gb4EU=
=NhiF
-----END PGP SIGNATURE-----

--------------niMEkCTt5ax09ch5y2go3Q8L--
