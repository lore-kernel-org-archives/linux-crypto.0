Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A20418A30
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 13:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785158821; cv=none; b=XJ3JoikowrRyqxpg3TEqP2jJUz8eaXedGa5+6N2C35l0Sapb1/sw+cpnccD9S/r67M4bHPXi1Cu39BirdYBZp4t/adpqUI0muvSE/AGjzBJ/XVCbroMpD8K6IBtqr8uftlh0s2fFH00THbhQPkncNemAaNP4JQ9A87RFiglCXeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785158821; c=relaxed/simple;
	bh=H6GJJD6LYy/HU3i+t8pVe/lvsGICNNduF+jvUpDidUQ=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jGAdR7sNNhe+FDgDeit+5UVsNoTPh4ITHlWzfoNcl0Hla4QxQvj6uo9grDUC6vNDQVOv/XEFKQh7LOMUVQNea/Kx+gYXpUbQVyt9hj5tsh54kZE2BAD5+P1ai5JCxePSKa1FOYQiPl9z1f2XPq/qs5A1Ndp5/hDpYrVGYmsSrQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hs83fVEV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hs83fVEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9FC1F00AC4
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 13:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785158819;
	bh=hMzu0YZPeujF4hgLIyl5V7nNY+ZvYerUPeUqAqta3NU=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=Hs83fVEVIPs1CW/EchwUpduulAUtn2HGPJNdpZjXRJSEnx12nJFDxCJXvuNQZWBXJ
	 2EUu6zE6YrJjBad1Hin+D9U+QJdJ3vSAy4CfpvN11gjiRsDDbmfxdU3v2Nr1i5JyHK
	 dIx1LHTwS609tV6HrLS5iqdr+h+h5gAz/7+wNQ4/loc4DO2lTRymyQbyFV77WprgQC
	 JdorA7WSiBZKogRBIQ7nLoYirElu6PMJIUE4L2FinQSc8qVEA4TwoXuFIFAat5Rkhm
	 uk+30ex3VhiB04Q5E7G1wIRn/rLWTo1iTzh86VQaypMLatpA2TWduEqJFJo2rMx02S
	 eqRq/akHMXrqg==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b2a22c52c1so3064460e87.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 06:26:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp6BmrNW5dCvQtgcH0jCIcLDiFzfEF9TLTQxgh2kE7DzGsDi2iw9gmGqlPOuSuFRmmByEiL2p6sON1tD/A=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywtot56vr/8AIRE74Cw7+29avW7BMS92pZE+f/Yhg8R9O66SLSk
	cQ3funxWc5+uCK2HIa+VnQSjgTj+E/adSjhKLdY5fuv/+KtbDW83FeWJR6SAQv8yXSvg0h6bEY1
	9Xon7JA2iuDHdYCp8Tw8qt3hAQsi/OpzgvEBB9ce1oQ==
X-Received: by 2002:a05:6512:10d5:b0:5ae:c063:6397 with SMTP id
 2adb3069b0e04-5b2c1b28bfemr1598059e87.15.1785158818476; Mon, 27 Jul 2026
 06:26:58 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 27 Jul 2026 06:26:56 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 27 Jul 2026 06:26:56 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260724155144.GA2032@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724050645.223799-1-ebiggers@kernel.org> <2026072410-drained-acts-3502@gregkh>
 <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com>
 <2026072412-decrease-sandbag-70a1@gregkh> <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>
 <20260724141414.GB1876@sol> <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
 <2026072455-subtly-prayer-0a8a@gregkh> <20260724150932.GA6763@sol>
 <2026072428-ungodly-outsource-b20c@gregkh> <20260724155144.GA2032@sol>
Date: Mon, 27 Jul 2026 06:26:56 -0700
X-Gmail-Original-Message-ID: <CAMRc=Me_uO0oMqjyuZzs7AxjWoSyy-=rT1eshmFQcNH_3H2ygw@mail.gmail.com>
X-Gm-Features: AUfX_mxSGJIwgP_5kRNku_9aMjFsY22xgajMAr4jyELVwyozqMhKzWVoej7PhOg
Message-ID: <CAMRc=Me_uO0oMqjyuZzs7AxjWoSyy-=rT1eshmFQcNH_3H2ygw@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce - Remove driver
To: Eric Biggers <ebiggers@kernel.org>
Cc: Bartosz Golaszewski <brgl@kernel.org>, linux-crypto@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-msm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Demi Marie Obenour <demiobenour@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 24 Jul 2026 17:51:44 +0200, Eric Biggers <ebiggers@kernel.org> said:
> On Fri, Jul 24, 2026 at 05:25:46PM +0200, Greg Kroah-Hartman wrote:
>> On Fri, Jul 24, 2026 at 08:09:32AM -0700, Eric Biggers wrote:
>> > On Fri, Jul 24, 2026 at 05:04:46PM +0200, Greg Kroah-Hartman wrote:
>> > > On Fri, Jul 24, 2026 at 02:47:48PM +0000, Bartosz Golaszewski wrote:
>> > > > On Fri, 24 Jul 2026 16:14:14 +0200, Eric Biggers <ebiggers@kernel.org> said:
>> > > > >
>> > > > > And with the defaults QCE is *never* used.
>> > > > >
>> > > >
>> > > > It's almost EOD here and I'm going to disconnect for the weekend but I just
>> > > > wanted to say before I leave: this has never been a reason for an aggresive
>> > > > removal of any driver. We remove drivers when we stop supporting entire
>> > > > platforms, not mostly unused drivers on actively *supported* platforms where
>> > > > they can still be used for experimentation and testing. I'm fine with dropping
>> > > > this from arm64 defconfig but with fixes, the BROKEN tag should be removed
>> > > > and I definitely object to removing it from the tree. How many people still
>> > > > use greybus? Should we drop it from the kernel too? And I'm saying it as
>> > > > a project ARA alumni. :)
>> > >
>> > > I agree, if someone is willing to maintain it, and there are actual
>> > > in-kernel uses of it (meaning not just a stand-alone library that can
>> > > never be called either by userspace or hardware), it should stay.
>> >
>> > What would we be considering the in-kernel uses to be, then?  Just
>> > wiring it up to the framework is enough, regardless of actual use?
>>
>> I was meaning that we just don't want to have code lying around that is
>> impossible to use.
>>
>> I'll defer to the subsystem maintainer if they want to remove it or not
>> here, as that's their call, not mine.
>>
>> But really, if someone wants to maintain it, no matter how slow it might
>> be, I don't see the harm in keeping it if it's not causing any other
>> problems.
>
> It is consuming a lot of the community's time to help maintain,
> including dealing with LLM-found bugs, with no clear benefit to anyone.
> Even considering *just today* we can see someone sent a bug fix:
> https://lore.kernel.org/linux-crypto/20260724081537.191992-2-thorsten.blum@linux.dev/
>

I volunteered to provide that time. What's wrong with said bug-fix?

> It definitely *was* causing problems before it was disabled via the
> crypto priority system (which made it unused in the kernel) and dropped
> it from AF_ALG (which removed most of the unprivileged attack surface).
> When anyone accidentally used it, it caused at least a huge performance
> problem, and sometimes other problems too like filesystem hangs.  It was
> an issue for years.
>

Ok, feel free to remove it from arm64 defconfig, you can add:

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

> If the justification for keeping it is that it is disabled anyway, then
> I hope there's not going to be a contradictory push to enable it again.
>
> I don't think we should keep crypto drivers around just for
> "experimentation and testing".
>

This goes against the linux philosophy of encouraging the upstreaming of
drivers. This driver is a nice testing ground for the BAM pipe locking which
can't be easily tested on NAND but which will eventually become useful for it.

Is disabling it in defconfig an acceptable compromise?

Bartosz
