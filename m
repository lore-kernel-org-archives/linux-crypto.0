Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795863457;
	b=FNMbB31IjEgb1bDHHdRO79ubIHc5FFGmJLd7/JMdv++PtHy1f8o8sCbobig8xrzEJeQ2
	 SogLGOPx3Cp7IhPUNTLpQi3GB9az4j2jLAqRgTxwd89pRyOsnbuSj8exm96R18y8T+xQn
	 FDOU1ZMda3RGyU9lUjIFb46WmfkxkzHalaDcagZGkc4rObkp14aXdv8QX5iAVYDiBLOrE
	 TMcFbVGTuA5c15YB0uU7kSEtO1WdL3OT0BKgONZwtEOcRX5BiV8sjhupr8b1+fYr3rv8O
	 NxN2fM97Kr4YnxtDUoubNXjb56DWmfoXXsovbvEPjCTJxLx5jDOV5IOi723oXLpUTtw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795863457;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=mobBjjFFPCz2Cia1f60OPkXKKYnf+20qvRBBH5tD8ro=;
	b=kFHagcSP8V6tXCdqakXVZ3Yy7lQGPH6AMUtDMSs0l6e3KPDkGr3D8L2Up5KJxlo2+lyq
	 PH1YsyYNJc2QhxC8PByXmvelhK7QZwxGp0RRVVDj3TBtn328M9e2E0Qnnso7wNZIaDWT8
	 +gESCAEpvR8Wn7krktdepSfJ4yulzvUXHBsbYMNStk15eWBgvdIBRcXplzaOkQvuWHcAT
	 azMSngT6B+YUFPGCrd/ODkFYbrRCsNLfKWJNsGG16SmILeY0pcTuIFZictu8VGG1hBtkG
	 WHwkJoLKwXb8k8kjenVJhnCtLl9pkva2mZhKAo3nt9XtmAzRKqd9ezocXlKoKHM9IGw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="j/yB1g/v";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E3D606A31C
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 10:57:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65E3D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=j/yB1g/v
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c505b2e1cb9so1582152766b.2
        for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 02:57:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795863456; cv=none;
        d=google.com; s=arc-20260327;
        b=ckz/C5VQmcjvEY24JkiO2A8WqVEnJmXbIEQ/U4fTNib2i/Yua/9ZIfs2XlRoqL+ynK
         o2QR7fbBCDwqu6izqhfC553RL+qAmwEwBa7bi2mlSAyJSSE0TqOFtmjPf9KVEBGezniS
         dYJ7ojPAxpUViPhceCk6iWeL673I4hSUIDGMALYrE8iEg4ryml1V7+qt8H7OXJZc+uDp
         /2FtaaVdL7RxLOTnaXbzmhCMNuE0kznImpZgmvEk155m9Od36Bse1TQdSMfCJXPZf+Ye
         cDCRbxXt/TyoDtF0XtNwVOKquOJNHhC/NTWmX/+iZ190ANXqqmyWjb1n1Z8g/w7z+g7a
         SGtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mobBjjFFPCz2Cia1f60OPkXKKYnf+20qvRBBH5tD8ro=;
        fh=WyU7cQaBsPk1SKOyh7mYaa0mgGcgCkA3yHcaGjn0i6Y=;
        b=RbbGO4+li5gWbAMK7Z5ycVr7NjHIYJ16lRjgKxicLHM6cGURE62WeWlJ8vZKED100C
         cYo9BSb0j1yAA2a3DytVBcQtXH7Swlr/4oWhG4gtV5Yse1csB/Pc3SdjC8IqJSPCNbRP
         iR9gAY6ANJkLnoN2nT86A9XUudM9DAhwM5atUeQoSHDPJ6JkhcZCbNCJ/QUOZq2gRQTo
         nmaTD7SsafEVPqTTR+oZAg03tOnFgcvL+kfDk7m3jCwUF/ALqgPpg3yx5RCcIjGJbzGU
         V/74WcAK5kF0Y27BcDvrKCj4Q/fwPApSoRxlfXhDq1Wd/YDQAynj/KyCYA7/N560l6Vk
         mOgA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795863456; x=1796468256; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mobBjjFFPCz2Cia1f60OPkXKKYnf+20qvRBBH5tD8ro=;
        b=j/yB1g/v0RHER9QiFOPlg9DfpQpk14yy2hklhHrQaCVGHMZawi20gHaaEESwJro5cP
         3Ze4DzqTUAglzzwx9+KjicdulWu4KeLEbCTHNmBwFplhkIr8KZg181nKS0EISCD0JntQ
         xhID/MbrJzr9jSAzuj+JoRc1IjNsl12SVvDqXgxNvFzYGwd29Mfa/zO8D8gjElQmN+DN
         HDwDdJfVFW6lZpn4UPzkODtGag2wC3/Tr6Go07vlm+uugzMe3gAio3Ri4c5i4p2PQX7a
         dnhyor+M2XhvuHnOfZM/wUgNCbFQaKz/ZrCtdP2kG/2abkch4dIifjI4vnnW/u8KDwwW
         twVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795863456; x=1796468256;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mobBjjFFPCz2Cia1f60OPkXKKYnf+20qvRBBH5tD8ro=;
        b=Un4ZjnXK9LuwUpaeh9prGmzV13/JXJYncRHd27N1tUi1aGbu+yWSZpLnOG+uj8oB08
         9VVDfl3nugfwS/kzYsBIHyjao5afYyn3nN/C0l16bSyMmgGotshk/w2PmOy+Sb23TmIB
         fO8gJkKL7CRzY4R5k0uOlspAl9nH6bGpzrnhMj6tWSEQgw18Zw/Jqzs5UqJxgv63DOn8
         pqiMWM8nt5Svf8Trh+RVKs+Edh1VeAc6qjubP5ful+JxZUWDDyFyyN0b8+J/bex9dP81
         VX1YqFKzC/pdit5U0jktuMh2mEbGg9zVHjGz9jpWaYYYr5l00Kfr7iIPpZcZCYe3i7PT
         Yvxg==
X-Forwarded-Encrypted: i=1; AL+hErFDMGM3gR6tQNXC4hCNlXgu/XRvZe1mkwuM6RPmJYFG8qS72C6bopvmGCkcEIutJRh6aQctjsICkERRjWI=@vger.kernel.org
X-Gm-Message-State: APuU4Z8/zuf1B+YFNGNBTKspAqTgpqwGLC1SdCRuVDnhx/Adbt0cA7P0
	hKp9lq0b3OmdPGqPE6D4BVHSrsoXat7Fk/J1pAgC2nEFC4CFTyWMKbkkLzkJMRV9ULBtPrScrFp
	Ezd6qN3IQCsdEPcA0MB+/+paqfn9DQTMZDXWE
X-Gm-Gg: AZFdTZfhjyuHUCSyA+ZJLleI5k21Ey4kBQlPUh7EL7AW8WJWqBtI6eDyKNKkaxNyDAe
	DHgKNo+JM2uOh/GHSR8pudMYYVRBRpos//BJF7H1gAHixfCTsCIOoYl5gT/jqWjo8DvNg67ycEE
	bwdtZpUTMxab4TfELu8KM9ae8blacODBcLneoMa4ByAnkdVdCLWwlKJMMqR5ydne/WHr23dUK6/
	PiqJXBByTtpzGPnUd+CtBMh9ElmDdGCdMxM2gR42piJFt3FCwVEDe7B/WoQCx72awmQmY0LTvEH
	8wYPIxw86ObE+ZmDJTeIS7HXztEyfCePZnkbCTd2FIVJuAVV+YeTUcqmuAgdFp6I85gnq8dV1dP
	57DYZ7DdKihwU/EuN8dPpRyyPgcijwPLiG9s=
X-Received: by 2002:a17:907:a4cb:b0:c4c:ddd1:cffa with SMTP id
 a640c23a62f3a-c513ab48b7emr2139426966b.29.1795863455664; Sat, 28 Nov 2026
 02:57:35 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261127165747.512950-1-16567adigashreesh@gmail.com> <0a8bfbb3-f9d8-4de9-b134-ee562548aece@app.fastmail.com>
In-Reply-To: <0a8bfbb3-f9d8-4de9-b134-ee562548aece@app.fastmail.com>
From: Shreesh Adiga <16567adigashreesh@gmail.com>
Date: Sat, 28 Nov 2026 16:27:24 +0530
X-Gm-Features: Aa3M54rmGSfYNxy7pHhSSoqElaP_IgtUtSj4rhQH7L7x4RNEPoAgGO3wgIrZFAA
Message-ID: <CA+-x59ZsGJYZ3gh-NKRrUb=jpsMx+gkgt+QCBKyfFQGUAiLiwQ@mail.gmail.com>
Subject: Re: [PATCH v3] lib/crc: arm64: Add NEON PMULL+EOR3 crc64_nvme implementation
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Demian Shulhan <demyansh@gmail.com>, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ard,

On Sat, Nov 28, 2026 at 3:18=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> wr=
ote:
>
>
>
> On Fri, 27 Nov 2026, at 17:57, Shreesh Adiga wrote:
> > Add a crc64_nvme implementation which benefits ARMv8.2 and
> > later processors with the SHA3 extension.
> >
> > Usage of EOR3 from SHA3 extension improves performance by 20% compared
> > to the regular PMULL without EOR3 on Cortex-X925 measured in userspace
> > benchmark for 512 byte input size.
> >
> > Move the existing PMULL implementation into a __always_inline function
> > and instantiate it twice with a boolean parameter which controls when
> > EOR3 is used. This is only enabled for AArch64 since the SHA3 extension
> > is not available in AArch32.
> >
> > Use static_branch mechanism for dispatch in arm64 and enable the EOR3
> > variant when the CPU is determined to be not slower due to EOR3 and
> > PMULL sharing pipeline stage. Currently Neoverse N2 is placed on the
> > list to disable EOR3 based on Software Optimization Guide mentioning th=
e
> > pipeline V0 being used by both PMULL and EOR3 and V used by EOR.
> >
> > Tested on KUnit for correctness on both AArch32 and AArch64.
> >
> > Signed-off-by: Shreesh Adiga <16567adigashreesh@gmail.com>
> > ---
> > Changes in v3:
> >  Avoid running EOR3 routine on Neoverse N2.
>
> Ugh I don't like this at all.
>
> Obviously, the h/w designers did not understand very well that EOR3
> has much wider use beyond SHA-3.
>
> ...
> > @@ -29,6 +36,21 @@ static inline u64 crc64_nvme_arch(u64 crc, const u8
> > *p, size_t len)
> >  #define crc64_mod_init_arch crc64_mod_init_arch
> >  static void crc64_mod_init_arch(void)
> >  {
> > -     if (cpu_have_named_feature(PMULL))
> > +     /*
> > +      * On Neoverse N2, EOR3 can only issue on V0 pipeline, which PMUL=
L
> > +      * also uses, so the EOR3 variant has lower throughput than plain=
 EOR
> > +      * as per documentation in Arm Neoverse N2 Software Optimization
> > Guide.
> > +      */
> > +     static const struct midr_range eor3_slow_cpus[] =3D {
> > +             MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
> > +             {}
> > +     };
> > +
> > +     if (cpu_have_named_feature(PMULL)) {
> >               static_branch_enable(&have_pmull);
> > +
> > +             if (cpu_have_named_feature(SHA3) &&
> > +                 !is_midr_in_range_list(eor3_slow_cpus))
> > +                     static_branch_enable(&have_eor3);
>
> Does this check the MIDR of the CPU that happens to be loading the module=
?
Yes I believe it is only checking the CPU which happens to be loading
the module.
It doesn't cover heterogeneous SoC which have different cores.
Based on my reading, Neoverse N2 systems are homogeneous core systems
used in cloud hosting by Azure Cobalt 100.
Apart from this I checked the manual for A710 and A715, which have
similar pipeline to N2 but I'm not sure if there is any system where
this code would run since on Phones I'm assuming nvme is usually not
used.
Given that Big.Little system like Snapdragon 8 Gen 2 would also have
cores like X3 which would be faster with EOR3 I am not sure if it
needs to be disabled on A710 and A715.
Even the N2 case, I don't have access to that CPU and this approach is
based on previous advice by Demian to avoid EOR3 everywhere even if
available.

I still need to investigate the binutils <2.40 build failure and come
up with a fix and then send out a new patch probably in a couple of
days.
Kindly let me know if you have feedback related to the current
approach for handling EOR3.

Thanks,
Shreesh
