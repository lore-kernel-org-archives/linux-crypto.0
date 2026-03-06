Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF3335CBC4
	for <linux-crypto@vger.kernel.org>; Fri,  6 Mar 2026 11:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772795056; cv=pass; b=Td6E9hsPcZFqAKvgugArACkifwxT477Gze9o1w0ywdKG4pnDTHByDIOgX45SASWNPh67TgcH3D1OTBxIsLyMMbdp/rqkYElUednhP6OaW1xaGT4jz6iukk3Ngz2DCyGCySe6jmqhHkn1Piz/3LpTL7icEEGPmulDE0scDHVMABw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772795056; c=relaxed/simple;
	bh=TMUl2twD3WVb9bUpNILamvTXmAfNlYzQY+btVe3lQyY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SWlOfXWBWIe3Ain9vPUdGBVFwj96fOdYu/jg7KSFWrFgLjRdH7J6PW59VHIAoT+xzn56tE8js9vpvGuEEZ/zNx7oxOWuupmwJh4GAjeWZrPD7j0/NYo8qUy9N2Tm4hEEQlvU9QIFwg0SjXdi+52msS6gACvirbIlafutfpKdddM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZwnN+wWA; arc=pass smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZwnN+wWA"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-463a94f8475so6613359b6e.0
        for <linux-crypto@vger.kernel.org>; Fri, 06 Mar 2026 03:04:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772795054; cv=none;
        d=google.com; s=arc-20240605;
        b=DVvFwPU3h2xJe7HNvzQwHiTgXx7w7KO3ODR7OkuZS7Y3ZTY+39bT6agjR3+acv3lTq
         zU1P86C1tTEn1mH2/y15tBJ6CYDOknm2E9g0qE5gIW51Kda9GSom0rIxzeBxxhk8HJM9
         n/3G70f/o20U2fhpxW3+/Ckl2jmFrxhZWfouFI+mKD/y/8ETYhByjMqeZjNqHHfHiwfK
         Ok/25A5z3hx/tA9SomrW16ekA5hFgd/2+7ZfwF0J567FasisTeWSjO4n/NiwSFGVbR1h
         t9qPhul6GTGBuPtyCrMKNSsyCMQu3Adx/46aHlOc+B6NtuqfQA6KnICeoGbFr9upS2Ip
         oNhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4FBAY7Ptj233wihUnQns1LO/raURJqSuY43ghIQW2sU=;
        fh=7RgpRm0rw9xCBwoh4yPe0O8/X6cXtqdNiyw+Pr9WHYo=;
        b=QNjexARp9nATNT4+k6s9n0F5yGsGu6cdvAru0Pbmw6UE/M+VENHLRMl3nIqf3zfWwM
         xwuIX2xRjjPJrD8bG7gZbQ+j/C6NU8MTt1DtGr+HhzDcMiAiYnvMLQ9dy+JwWeIsxCO+
         Qqbqvmxu7gDhVyheKEde6UAT0TQp9s18OIOeMpDOAlTbM95VCkoYjMOovQ136RY+1vuy
         CVoG1Y2hi7THfl6oeLwfQiTXOMc42Ooy6XPn3d0KZIsdZ3cJvSpUBijnIx2wso+8Pv4m
         x3h1emp8JOpe42eOSuylFy6J4yfOd1hFaQOvm2DlW/BWpIf68WB3IuK4paqQhAq5kd6J
         ROuw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772795054; x=1773399854; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4FBAY7Ptj233wihUnQns1LO/raURJqSuY43ghIQW2sU=;
        b=ZwnN+wWAAWFrV84YHShPZsf5L+LInsVkqlHGrOR5UVBNSSf1WKGw9P+6cdgmPGQ/T5
         fG/bmuGIotEW/hujneKmWAorWzgfMdihkpanFtNwA2Fw/YJNzveRvJabIwvLQJ6nik1C
         d45C2xMcfiE+o2uxMMrG2B3UuZt6bSjaQ0pOost1LOz8bC1ymlU/0L4xoz9l9ihDyOJD
         oquRdVKcTv1SPKplrfU/SOfHCZot4tNUL5FF3DzF2kJOw0gXwN94QcdrNbT8X95CF4m0
         RQvmCDGMgayHT6nT/80z8WYJH8Og4PFspXHzC/oGUnfUXNah4pLdAu5g+EVM6dc6wR47
         zqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772795054; x=1773399854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4FBAY7Ptj233wihUnQns1LO/raURJqSuY43ghIQW2sU=;
        b=aus4kNoSz384pX+j5oz0Q0O3ODRJf7p99H3VNZ1S5Lhq7qIY/RYEweYF6s0rY1QtjQ
         DfUv88zUToahyHx3XkhnR02SsCv5F9NNg4p/R5iy4DLK7Y88paBY4XkXQm/1jTIQtyeg
         rrIMZF06FUv2806KJXUPEimojcIOPg9PW6J8OC/7g5Cgjp31009YtMSwMw8pS5PFQkJ8
         NFkt8LK1Q05EVN2sS0uv2stgKxHLLY/PKWyZAMmntZHKyBMZ5j4NrrlQISruOAi5+/xK
         i+mHgjMH9dK+luCFfIoYEQjPWLxTEtl9Fu8w5jCqYSwf3sCOyIhsKttii0tmewdLhtvi
         NrLA==
X-Forwarded-Encrypted: i=1; AJvYcCX3TmODZ6lpldzneIdwJxnLW33gO2hKnilhPgeEm+CdRzOdMnY8u6LSIZcX/jTYijY2Y87ZsMMi5JoyD5U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaUebwwi7vGwDfeCjp1oLCeW8vZCWnWc5+US8R57mnJe0arTvh
	IgX9+OVshBFOuEOYRjmcVaSKSGinIL/C0TZlZD+wR8MRcOcbV2U4U2GwqXIGvYRxXBLAXCSBg23
	owZjwezukzJlahKbjq680KNz31NtWE0w=
X-Gm-Gg: ATEYQzw28NhJN/KEw7lsYnSdvW1RyLjSISyq2gJL7BAM6KhMq3mcHuUbS3x9CdmckaZ
	pxNEay0GZtBihXgcJt6gKQj8RBUpxcmDSbbw10LrfLIn1s9rC+KGNJs7VW1Zj2/yK7tENq4Eb4u
	nwFdFl9qWMmW55ZaivGs3VREnkRQq6l23PHmcVHVybnRVXKEoY4Ee34S7u0GhRQKSHrGuw9m0H9
	sR+7bXD2bQ6kxuPCKjT3+Y/KX0dq76dmvximaXQ9BsF7AdcRAOVRPnPNk6VLuJrbXgLduUniPXf
	LiIpr9C2hi97UgI8z5hRdtfY226PWBBAONZVA0s=
X-Received: by 2002:a05:6808:1522:b0:450:b87b:1ec4 with SMTP id
 5614622812f47-466dd0f715bmr888114b6e.15.1772795053874; Fri, 06 Mar 2026
 03:04:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112192827.25989-4-ethan.w.s.graham@gmail.com>
 <20260306094459.973-1-jiakaiPeanut@gmail.com> <CANgxf6yMNZ3=xm9xVhPZDuxMc__7pQk=mti-CyD1QjUOgTJLEA@mail.gmail.com>
In-Reply-To: <CANgxf6yMNZ3=xm9xVhPZDuxMc__7pQk=mti-CyD1QjUOgTJLEA@mail.gmail.com>
From: Jiakai Xu <jiakaipeanut@gmail.com>
Date: Fri, 6 Mar 2026 19:04:02 +0800
X-Gm-Features: AaiRm50fj2zUudpYSke1Ww9X_50G4gGf4UxVg0WDage5_ANMvrcVMJxjNhrQX6Q
Message-ID: <CAFb8wJvmnPv96o9Kr9VAh=cL9zMr8-5eCEmmkjtgX02_Ypa4nw@mail.gmail.com>
Subject: Re: Question about "stateless or low-state functions" in KFuzzTest doc
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy.shevchenko@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, glider@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, rmoar@google.com, 
	shuah@kernel.org, sj@kernel.org, skhan@linuxfoundation.org, 
	tarasmadan@google.com, wentaoz5@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ethan,

Thanks for the detailed explanation.

Would it be fair to say that KFuzzTest is not well suited for testing
kernel functions that are heavily influenced by or have a significant
impact on kernel state?

I agree with your point that "the goal of the framework is to fuzz real
functions with realistic inputs." One thing I've been thinking about,
though, is how we determine what counts as "realistic" input for a given
function. If the generated inputs that a function would never actually
receive in practice, we'd likely end up chasing false-positive crashes
that don't represent real bugs.

Thanks,
Jiakai


On Fri, Mar 6, 2026 at 6:29=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmail=
.com> wrote:
>
> On Fri, Mar 6, 2026 at 10:45=E2=80=AFAM Jiakai Xu <jiakaipeanut@gmail.com=
> wrote:
> >
> > Hi Ethan and all,
>
> Hi Jiakai
>
> > I've been reading the KFuzzTest documentation patch (v4 3/6) with great
> > interest. I have some questions about the scope and applicability of th=
is
> > framework that I'd like to discuss with the community.
> >
> > The documentation states:
> > > It is intended for testing stateless or low-state functions that are
> > > difficult to reach from the system call interface, such as routines
> > > involved in file format parsing or complex data transformations.
> >
> > I'm trying to better understand what qualifies as a "stateless or
> > low-state function" in the kernel context. How do we define or identify
> > whether a kernel function is stateless or low-state?
> >
> > Also, I'm curious - what proportion of kernel functions would we
> > estimate falls into this category?
>
> I would define it based on "practical heuristics". A function is probably=
 a
> good candidate for KFuzzTest if it fits these loose criteria:
>
> - Minimal setup: KFuzzTest currently supports blob-based fuzzing, so the
>   function should consume raw data (or a thin wrapper struct) and not
>   require a complex web of pre-initialized objects or deep call-chain
>   prerequisites.
> - Manageable teardown: if the function allocates memory or creates
>   objects, the fuzzing harness must be able to cleanly free or revert
>   that state before the next iteration. An example of this can be found
>   in the pkcs7 example in patch 5/6 [1].
> - Non-destructive global impact: it's okay if the function touches global
>   state in minor ways (e.g., writing to the OID registry logs as is done
>   by the crypto/ functions that are fuzzed by the harnesses in patch 5/6)=
,
>   but what matters is that the kernel isn't left in a broken state before=
 the
>   next fuzzing iteration, meaning no leaked global locks, no corrupted
>   shared data structures, and no deadlocks.
>
> These loose criteria are just suggestions, as you can technically fuzz
> anything that you want to - KFuzzTest won't stop you. The danger is
> that the kernel isn't designed to have raw userspace inputs shoved
> into deep stateful functions out of nowhere. If a harness or function
> relies on complex ad-hoc state management or strict preconditions,
> fuzzing it out of context will likely just result in false positives, pan=
ics,
> and ultimately bogus harnesses.
>
> The goal of the framework is to fuzz real functions with realistic inputs
> without accidentally breaking other parts of the kernel that the function
> wasn't meant to touch. Therefore ideal targets (like the PKCS7 example)
> are ones with minimal setup (just passing a blob), have manageable
> teardown (like freeing a returned object on success) and don't
> destructively impact global state (even if they do minor things like
> printing to logs).
>
> That said, I'm curious to see what you come up with! I'm sure there are
> other use cases that I haven't thought of.
>
> [1] PKCS7 message parser fuzzing harness:
> https://lore.kernel.org/all/20260112192827.25989-6-ethan.w.s.graham@gmail=
.com/
