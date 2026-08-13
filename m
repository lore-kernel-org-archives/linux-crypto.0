Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804133BADB2
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 11:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786621995; cv=none; b=rH/fRKaLMYaediOb7x6ql21I0RLsaZT6UH9c7Nfh9FfjOaG9+OYu+5MDShjw6c3Wyt6vhbljzTcI1X3oFDbrxcQ9/WXDHROR1qGr+HuapKpfr24M+CGNNFCx37M7xTYphEneOz+RGGi0Kx7PYwnWfPPV5HVixSCtTKs16xMHMZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786621995; c=relaxed/simple;
	bh=eLY7d3f0fRdJ0tg2Vni+U8UOOhNK1ExC1G/3KQ9o7Wc=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=In+zDJeG0nO6j4mcAG6w1HAQnx9pinrl9q6XNSyXJj7rUr91ouBJc9oiVGz1QuWQHbu26buagDx5fTd+NeXlNIxLlcSSI9bxQ1f3mED0/I75lX66Ox7HXLOqKs77cyztyASNw6U8x5EGgCnbhFNuhACkbi+wJ/088HjBjChYspY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UgV2RCTF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UgV2RCTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AA61F00A3A
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 11:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786621994;
	bh=+fm+CeLKS/2B3l8wNfarjP4MGGPunmU90uKBggPTChU=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=UgV2RCTFFoe8cwLWNUIuifb5WIdiXPPM+iHiuDr5ZPq8ELyvYb68lIF4yk9xDAscA
	 RRj0FaaUn8MtYxfa+3KL2YuVm6AsqYRCy0ZG+CpE6kqGLweRa3LDBkpFmgYDBpahX0
	 COJKUDCse9eswFdo0/fPFyQXIIIRh7b2tL/fE+pPvrDgTm4vgcnfevykwbaAzms+eT
	 p+yBX+2wruAjjBivWwkVjbw1EsLyqzbTDL5CurY53cakXLv1EqeWhohDod/i5G0aSN
	 oWYmg+o6xU0KnpUo7Phb6BpL7s7np2B5/FHrLup7a0Clf+Qpwin9W5YszwqKIbhUMF
	 wfHDP6vh85i/Q==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3a115c08b0bso10183611fa.0
        for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 04:53:14 -0700 (PDT)
X-Gm-Message-State: AOJu0YxqNQEC9aa1FSwnkuS1beTT5Zs108Mmpjxbq2zbfaVqf4phPMtK
	t2TFRTTs7ZvIx3ASz26X/QXedAjDXMnjIxpW7xvfs9xRv+E1uw+kYgffBEpnM0QqMhAUSbNb5Mx
	/t2Y0VupnlVKROFC0yn3H/1ug2ff2DGZOLbjKRHJ7Sw==
X-Received: by 2002:a2e:be05:0:b0:39f:bc94:eba1 with SMTP id
 38308e7fff4ca-3a11a6b7762mr7298321fa.16.1786621992909; Thu, 13 Aug 2026
 04:53:12 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 06:53:11 -0500
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 06:53:11 -0500
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <bc95e0b0-2cc5-4ad6-a319-ae4e159b92fe@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731050838.158825-1-ebiggers@kernel.org> <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>
 <3ba57269-3305-4d80-b3f2-aa82fa59b59d@gmail.com> <b9b655a9-c683-4c4e-ba0d-f98577dd2912@kernel.org>
 <20260801162900.GA2021@quark> <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>
 <20260801171242.GA3567@quark> <CAMRc=McL5QQRk8C8zzkHm+FUj-SAVi5PLJr2pXo8eNpaxXuALg@mail.gmail.com>
 <20260811224110.GC1905@sol> <CAMRc=MfVqphaVsfcmUXjGmu6m+F6nJYXgAPuTVjZBwFnd48BkA@mail.gmail.com>
 <bc95e0b0-2cc5-4ad6-a319-ae4e159b92fe@gmail.com>
Date: Thu, 13 Aug 2026 06:53:11 -0500
X-Gmail-Original-Message-ID: <CAMRc=Mcno_F2UuLXZ3ruaVSbYhssVK90m3KM=+dwskLMSp8TXg@mail.gmail.com>
X-Gm-Features: AUfX_mxLj0BqXm4Ose-q9nkSpZaIi5poNDxpaETn2wXloBBECH8QMDb1EFqov7M
Message-ID: <CAMRc=Mcno_F2UuLXZ3ruaVSbYhssVK90m3KM=+dwskLMSp8TXg@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Bartosz Golaszewski <brgl@kernel.org>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 12 Aug 2026 18:33:45 +0200, Demi Marie Obenour
<demiobenour@gmail.com> said:
> On 8/12/26 04:07, Bartosz Golaszewski wrote:
>> On Wed, 12 Aug 2026 00:41:10 +0200, Eric Biggers <ebiggers@kernel.org> said:
>>> On Tue, Aug 11, 2026 at 08:42:55AM -0500, Bartosz Golaszewski wrote:
>>>
>>>> No, the rationale has never been this. FWIW it can be that it's used for
>>>> testing of the crypto module on a supported platform and that is already
>>>> enough of a reason to keep it upstream.
>>>>
>>>> As I've said before: we don't just drop maintained drivers from linux.
>>>
>>> We definitely do if the drivers are not useful or appropriate for
>>> inclusion in the kernel, though the policy varies by subsystem.  Even
>>> just last month an entire filesystem got dropped despite someone wanting
>>> to maintain it.
>>>
>>
>> I suppose you're talking about EFS? A thing that can't even be tested on real
>> hardware? This is a much more extreme case. Here you have several people
>> representing the vendor saying they want to keep and maintain it. I'm fine
>> having my own tree and sending PRs to Herbert if he agrees and you are of
>> course entirely free to disregard any patches targetting it.
>
> Would you be okay with one of these options?
>
> 1. Make the stub driver as the default, with
>    the real driver guarded by an off-by-default Kconfig option.
>
> 2. Keep the driver as is (with the power management issue fixed),
>    but don't register any algorithm implementations with the crypto API.
>
> 3. Only register algorithm implementations with the crypto API if a
>    non-default Kconfig option is selected.
>
> 4. Only register algorithm implementations with the crypto API if a
>    non-default module parameter is selected.
>
> 5. Move the driver out of drivers/crypto, delete the algorithm
>    registrations, and then add support for restricted media content
>    decryption later.
>
> The last option would be my preferred one.
>

I actually have a slightly different spin on the stub driver. I'd like to
keep the driver future-proof and avoid all kinds of needless churn when we
do get to the secure dma bufs and restricted media playback (and we will get
there eventually :) ).

Can we make the QCE into an MFD driver with the core binding to the DT node
and handling the interconnect bandwidth, while the part handling crypto
algorithms becomes its cell and is moved into a separate module? This one can
be disabled in defconfig by default and I don't even mind it being guarded with
CONFIG_EXPERT. The core module would remain in arm64 defconfig.

With that: any future extensions providing support for more functionalities of
this IP can simply be implemented as more MFD cells while we can also keep
chipping away at the existing code and use it for testing the BAM pipe locking.

> Also, if Qualcomm has customers who use the QCE via the crypto API,
> is Qualcomm aware of _why_ they made that choice?  From Eric's and
> my perspective, that seems like a very strange decision, unless there
> are factors that Eric and I are not aware of.
>

SM8650 with the QCE is FIPS 140-2 certified and apparently this makes
a difference. Don't ask me if that makes sense, I don't claim to understand
the legal aspects of it.

> Finally, would you be willing to have a group call to discuss this
> at some point?  That might be a more suitable venue for this kind of
> discussion, and could potentially lead to a conclusion faster.  Also,
> while at least I couldn't sign any NDAs, there might be information that
> you could discuss there that you cannot post to a public mailing list.

Sure, I'm fine to have a call. If you think about coming to Linux Plumbers this
year, I'll be there all week and it's a good place for such a discussion too.

FYI I've only been online for a couple days this week and I'm going offline
again until the end of August with the exception of August 26th when I'll be
able to chime in again. Any call would too have to happen in September at the
earliest.

Thanks,
Bartosz
