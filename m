Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4692246AA8C
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 12:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785326533; cv=none; b=QJ26L07ZonPBj457Czw6O1ekYmuyzlTv6cmUdfvCQlZW/aT6yE/VasrKBjsyxtyKG0VjlhZbB5L+ICT9J9+Dfxgja3vjAPSdiLLHSV/F9EfGBKwah2usvaGkETpMVkbhVc93Exo3m3Od17t7cxtX8m/cu6wRA5lh+zWlPCuVQlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785326533; c=relaxed/simple;
	bh=+9fC9W8Gi/N72iyUIca7ZyTdcf8iNfeBfA0r9hqJKNg=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nlZCK2NNIH1tf7eHeE9eJMk1ZlWU2ufkq/FL1exSuGhqaSJUhDDvVK9oW+efWTk969+wmlUr3bKddw2a0Fym4o29EwXWPgR6yTbjUC7Y8DJTQC56rIO2xU6VF3xAuMfkY6KPPmKK1vd0yGlUhRY58O0qhmUqjCApdBBcHdCCg58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TfheBuyN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TfheBuyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF431F000E9
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 12:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785326532;
	bh=lDhpdhv1V/2Mmx+BQS7lBsREzTSL9OED0Q1oe1sMhkQ=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=TfheBuyNx4ybA2qvyXwHgUsFRk7A/VQMSxA5wEpghnvZXwDmJ2LAOM3NBzQ7+iFHK
	 qtL4H8pmgrqUeGpUHofgDiEGVkQAILC8pZ02iANY+wB6jT9IQasH74oOJlHvDzigI1
	 YEQNEzCx3DQetMHY9oV2y//gVUHf8mlS6FsLfRF3SCScRVeYhCBnydxKHugQfitwbE
	 S7RPeaU5Swd18E05iWxI8ikqXGIBjhfAzJveUWRpNmf6zBPEyXtcfV0CVmUsIwC3Ql
	 1xsjGpYvbpsTTGmiEZCGOdl6oGFu+tIwAiW/oUw1SRQXw7Iak9xEZbPad+GpganjIi
	 ElixZJAkZQ0vA==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-39ca300db70so7481471fa.2
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 05:02:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrUMqZHVHDHQXFTEOfQvVI4Ii96aMRdJ8IzwR3OdyaCHIeott3eqVzKJecOwQPtSzu9tk/EtMylut41zaU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz95KU3Lu8dj6FQzbOlhQ1ON8Kv8jhjyB8XlglqVwPsKLFPZv4Y
	jdS6EGZOVZMXFb2RCYv591YEJ0Gpsto3FIXWsOWCHR7pyxpMiOMutpgoY3ratip7C/9ubgHZx5T
	T8XI7e14h14DBqX/Tt1g4Vpk474eEPt3XUTu8RXoCMA==
X-Received: by 2002:a2e:bc11:0:b0:39c:7059:10 with SMTP id 38308e7fff4ca-39f51eee674mr11861711fa.39.1785326530728;
 Wed, 29 Jul 2026 05:02:10 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 29 Jul 2026 05:02:08 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 29 Jul 2026 05:02:08 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260728152241.GA4281@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2026072410-drained-acts-3502@gregkh> <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com>
 <2026072412-decrease-sandbag-70a1@gregkh> <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>
 <20260724141414.GB1876@sol> <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
 <2026072455-subtly-prayer-0a8a@gregkh> <20260724150932.GA6763@sol>
 <2026072428-ungodly-outsource-b20c@gregkh> <20260724155144.GA2032@sol> <20260728152241.GA4281@quark>
Date: Wed, 29 Jul 2026 05:02:08 -0700
X-Gmail-Original-Message-ID: <CAMRc=Mch_3fFqq+khutEMQG3P-ojBE2dnLy_U2_gDV4e1ro6aA@mail.gmail.com>
X-Gm-Features: AUfX_mynAmI1M4yUWJz7xnT60AuUua6HXQnjCMgvWNABYi_64AGSY4Ma6_uoTVQ
Message-ID: <CAMRc=Mch_3fFqq+khutEMQG3P-ojBE2dnLy_U2_gDV4e1ro6aA@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce - Remove driver
To: Eric Biggers <ebiggers@kernel.org>
Cc: Bartosz Golaszewski <brgl@kernel.org>, linux-crypto@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-msm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Demi Marie Obenour <demiobenour@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 28 Jul 2026 17:22:41 +0200, Eric Biggers <ebiggers@kernel.org> said:
> On Fri, Jul 24, 2026 at 08:51:44AM -0700, Eric Biggers wrote:
>> It is consuming a lot of the community's time to help maintain,
>> including dealing with LLM-found bugs, with no clear benefit to anyone.
>> Even considering *just today* we can see someone sent a bug fix:
>> https://lore.kernel.org/linux-crypto/20260724081537.191992-2-thorsten.blum@linux.dev/
>
> Another example:
> https://lore.kernel.org/linux-crypto/d5de5a55-eb35-4ad5-8d53-12e188e156cb@oss.qualcomm.com/
>
>> It definitely *was* causing problems before it was disabled via the
>> crypto priority system (which made it unused in the kernel) and dropped
>> it from AF_ALG (which removed most of the unprivileged attack surface).
>> When anyone accidentally used it, it caused at least a huge performance
>> problem, and sometimes other problems too like filesystem hangs.  It was
>> an issue for years.
>
> This actually seems to have been an overly-optimistic characterization!
> As per
> https://lore.kernel.org/linux-crypto/d5de5a55-eb35-4ad5-8d53-12e188e156cb@oss.qualcomm.com/
> this driver drains the battery on every system with the module loaded,
> even when no crypto requests are actually sent to it.
>

Are you seriously complaining about people sending fixes to a driver we want
to see fixed? We don't remove maintained drivers, this has been the kernel
policy for years. Unfortunately if we want to fix it, then it'll take some
work involving sending patches to the mailing list.

I think it's time for Herbert to decide before I respin any of the series in
progress.

Thanks,
Bartosz
