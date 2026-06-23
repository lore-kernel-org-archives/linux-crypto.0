Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E183BD63B
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 07:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782198921; cv=none; b=N8oiOoesLtQrDrSd5spx/dDGpwVKEzmFB50e0xkfWBahNlFJkVs5Y8eZ9VCydgATMTFfdy/i3EebEb20UcAflct+aAhPFJchSr+IhE4SojefK+dYwZeDDB9Yxr8muam5ZreN4KT5pX2rSOzStHQYc/VoUbQg+nJFi0fYrA81Li4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782198921; c=relaxed/simple;
	bh=BkIrv3PeQJrIrIyJpIE7lPE0AkoiwGoLxnXFFNdR3Go=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EiNjygliURWNumZnxwptkOnRSpOdIXp8YvaXWXxsNqV09XIl48Ni8y3/q7qGnBJ3FyEm6MWSY8y2wcljkQ7bOfmt8P8RP5rIfZsZMgUFqzp1jb1Aku61NSMkXeqJses0YR8a/vqdHkmL75MSaU4Q6/lHi9sZLe29OCiWNqrZpO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YULqLzxC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YULqLzxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899BA1F00A3E
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 07:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782198920;
	bh=6+U07TSbyfoGNdA2P/aBkTcdGl+S1M9ab9Yxk/ZPUzI=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=YULqLzxCrdobVNjKQ2ZqvgsdWJB2h6JQAKhLZG6XiWzS3P9MEboRU7kwYwPoF5FsG
	 tYNvitt9UZhkKMCCn3S9ufSpfjpiNUR6TXdHmzFgCZOFap5rTZsbPOdAcOLlFB+M38
	 w7/VXBDd9MzHVWvYKaWvHUOSkD47fVrhG4jlDLlObKZYsGcwrY7GIokDfLcfCH7zRI
	 WEOR9LN5limT2Y0AXUFyScAkkQvSSH8mRmEQXCCXc4pxYlUnmH+Ki0hquGHSHUJbNw
	 fyNrGMn3aYnkddaaFMUs2R1UUmggx66UyS6WhN2Ei0me22gAoqRTL1QPsUaW3sXz3Q
	 MriVxbN2dp4zQ==
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-39677aed4d3so44432861fa.2
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 00:15:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+GtwdPV/KdRSJyBFBFUW8QGX59P5jp9tulfZQ3/J3V5al7vLCu1zneVEifh+sJkBb7gmE9IcX+jPt7fts=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCqn0D8jf/sgHRYa0FP5RWgJP/ClXSoF8eBm2MeKBmO+xU/N0N
	wwsBtCp2OWDsuSIdWBJgwuZD8u4LibR3FuQOExgAZQf0JVoaYxUBfMx+ThpABsJzgZ+rvu6G6+C
	9G7yL5bHVc/fe8CHgr8Xuz8+rruq+pkGSxRy3DKDfCQ==
X-Received: by 2002:a05:6512:238c:b0:5ad:2a73:8a0a with SMTP id
 2adb3069b0e04-5addc486646mr466863e87.20.1782198919228; Tue, 23 Jun 2026
 00:15:19 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 23 Jun 2026 03:15:17 -0400
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 23 Jun 2026 03:15:17 -0400
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260622181909.GA1250822@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
 <53b1fa61-9692-42fd-a295-98bbeacbcd9a@oss.qualcomm.com> <20260619164506.GA3223@sol>
 <CAMRc=MdJJRPBeNtAUr82b4zv7vLjrRQ76Q3bJHQYEigaE2Hqog@mail.gmail.com> <20260622181909.GA1250822@google.com>
Date: Tue, 23 Jun 2026 03:15:17 -0400
X-Gmail-Original-Message-ID: <CAMRc=McxsU8h7ZFFRX+MsrufeWZaXzQv_QZpF3zZWTvOQr6A+A@mail.gmail.com>
X-Gm-Features: AVVi8Cdztrg_PDv4XwvulJ3y8k7gxEzu4r1Z1W6KytPslNOCvABFoRyn5h6EeHI
Message-ID: <CAMRc=McxsU8h7ZFFRX+MsrufeWZaXzQv_QZpF3zZWTvOQr6A+A@mail.gmail.com>
Subject: Re: [PATCH 0/5] Shikra: Add DT support for ice, rng and qce
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Vinod Koul <vkoul@kernel.org>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Konrad Dybcio <konradybcio@kernel.org>, 
	Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>, 
	Harshal Dev <harshal.dev@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, Bartosz Golaszewski <brgl@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 22 Jun 2026 20:19:09 +0200, Eric Biggers <ebiggers@kernel.org> said:
> On Mon, Jun 22, 2026 at 04:25:12AM -0400, Bartosz Golaszewski wrote:
>> On Fri, 19 Jun 2026 18:45:06 +0200, Eric Biggers <ebiggers@kernel.org> said:
>> > On Fri, Jun 19, 2026 at 02:13:28PM +0530, Kuldeep Singh wrote:
>> >> On 21-05-2026 18:47, Kuldeep Singh wrote:
>> >> > This patchseries attempt to enable sdhc-ice, rng and qce on shikra
>> >> > platform similar to other platforms.
>> >> >
>> >> > Previously, the 3 dt-bindigs/DT changes were sent as individual series
>> >> > and with feedback received, clubbed them together as all belong to same
>> >> > crypto subsystem.
>> >> >
>> >> > Here's link to old patchsets.
>> >> > QCE: https://lore.kernel.org/lkml/20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com/
>> >>
>> >> Hi Eric,
>> >>
>> >> As selftests issues for QCE are now fixed[1], so shikra series should be
>> >> good to proceed? as your concerns[2] are now addressed.
>> >> I am waiting for merge window to end and will send next rev post that.
>> >>
>> >> [1]
>> >> https://lore.kernel.org/linux-arm-msm/20260617-qce-fix-self-tests-v3-0-ecc2b4dedcfd@oss.qualcomm.com/
>> >> [2] https://lore.kernel.org/lkml/20260522024912.GC5937@quark/
>> >
>> > If you think that then it sounds like you need to read what I actually
>> > said.  The fixes are appreciated but don't change the big picture.
>> >
>> > - Eric
>> >
>>
>> Eric,
>>
>> I mentioned it in another thread[1]. This series is not adding any new features
>> to the QCE driver, it describes the hardware. The SoC *does have* this IP and
>> no matter the state of the support in the kernel, there's nothing wrong in
>> extending the existing bindings and adding new dts nodes.
>>
>> Thanks,
>> Bartosz
>
> It enables the driver on a new platform.  So it very much has a real
> effect.  It's not just adding a hardware description without a user.
>

The driver can be disabled by not building it. The hardware description in dts
must reflect the reality. This is what dt-bindings and devicetree sources do:
they *describe* the hardware. It's up to the systems integrator to build the
relevant driver or not.

Let's wait for DT maintainers to respond to v2 once it's out.

Bartosz
