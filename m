Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579142DC772
	for <linux-crypto@vger.kernel.org>; Sat,  7 Mar 2026 01:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772847573; cv=pass; b=V6DxXmSr/mhz8jlnbbW+PSK3ABCopqVA0ZlBPsY93+JA2HCWKiAxTChGlmzM5ValLMUqp9aorcPD+FmRGyXyUq7kYrTYfS3U3J3Fx7cKqTGHqxRe3+8kM6g0hQbKBMi5Ntd3xe8liNJPmACcZll6ah6lHRf/4BXJFYdPmq8mnU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772847573; c=relaxed/simple;
	bh=NXQEz8pfyhdL2DxRvemrpO+1eJpbig3ch1akrMKNRHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QPN0vHGN7AxUW8IWpSX04j6T0bksvfy/Cyjk2gZ4Ry/fbeE69SZmj+FErlofE7MMuCMZ6mDMeZgw3PKy/d1NVEWFUeCPuF3wQP58WfJt7Ftl9URyB1BN+6yYYnCkM+MTDf6jJBPko1ESsA6beSGBzi5wvW9gk0oaWp8Gsp4uQH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KsdWWLta; arc=pass smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KsdWWLta"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-679f6f0855bso5824676eaf.0
        for <linux-crypto@vger.kernel.org>; Fri, 06 Mar 2026 17:39:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772847571; cv=none;
        d=google.com; s=arc-20240605;
        b=QnoDojh11NH3Lb5hT0CDJhDkunCYU1XtUkO9TM4Mo+oZXeR0oWcw1Kss+x2Yzulwlx
         M3FONr7gyHTEzzdvbd1tFijODf0HozXiobHEXSHEIDKC1r4/0cmoAdG606Pi4OtsQkSu
         Z0D9jYUTNS1vdQbXTDtlBrGKaMHqUosWLSHCBqr23mk6jtgtztJCwdAmwjCoxwIfldZh
         cDtewW7OSX9Yb8SSdJCGQDuF/4d2qpnV3J3U7Ed5hF8g6zClbwccI98zBxf8eV13Cj8p
         jzYJC4nvZhPbEI0XgUctfcY75xtdVYCQsCubHIx7DO/+k5I0kMyGpnWTSGv5qwmb015v
         ZXeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WUt9V96pGWBeEnbjx1PAHPx8YoZ8MwGfywkRHa4eCJ8=;
        fh=L+WnbUr84cpNN6+RdNIOEZSzyYRjv/MkQ9E4Y8X7Qlw=;
        b=EkMS7Wvq8DQJrfhqu4vx5QGvtVN5TLx4/nsB/+uRnHG4NKrZGbDC+gSeta1GbLK37E
         GAPS0a+NEPSzw3zuTx9ZgXpnd4PbQXZpWofn4ghv4BrqxFtG6fjlz3UuU+x1r5seBSy+
         AAOMRF9UnGpqxqtso766X8vrtV4CEN06+mJZ7H5q0zGZrGrBEFE5YGOCUn+NGc4PqM6J
         4n98/uENEuZnb+yC5zl69Y/eXXUMixMA2a6y0ONxfE1vJnVulD7dm/si8dvpGz7I8/Nk
         B4p1wZ4zcwwCVv72rK76DBfP+8Q0tlDh+OvaLcts/4ZalVRfQ3g1LmMqi0EuagRHCV5k
         lzEw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772847571; x=1773452371; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WUt9V96pGWBeEnbjx1PAHPx8YoZ8MwGfywkRHa4eCJ8=;
        b=KsdWWLta0EwkQwARnl2Dv23gnVimwuGlAu2FusOHa4vEnWCyfN/OPp0jQNt5kGFUFX
         qRcJY0CxqQoIL44oO0oQfDA8hjcgoQPi0FXchjru2eyqv+KlK7OU/g0IvOc60Cd61H+i
         CdMX6jovrrfP6/oISLzzotMOQwSr2pXtWrdLk+MOk+PnjiVgLSUaXZy08tFcit2L/TZT
         sU3aNBZm1ukJQia49WIbhIVp/0o83UJVPcL40y3rl1A4cCXZd6k+krc9DZWZ6sX4Qy4M
         Lb2ZVS1D4t7cLW5Cazl1DG/K4bxySZz63BG8Qea2sQwwj2CCgdcJplyX105ll/wyxy8Q
         EMyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772847571; x=1773452371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WUt9V96pGWBeEnbjx1PAHPx8YoZ8MwGfywkRHa4eCJ8=;
        b=WTPPYYXL2rrcQ89ECCo4c+5AxcoPy62RkJ/1ED9T7Oy0K2OCVsEJbAvsq3Pa3UbnMM
         R8qBnA//0/WFp6SZJ5GAexbhzeOvj4z95PTNwp7V/QR5gfaUU8p79I9vnSZlpeGR9kXu
         zLDGfwyE+kZiSSCXmALBMHEpazIndWPEGdyed/6c1I9Dv4gUarUiREzsdhXl00IMx0if
         QoNhtUys3MXqevG26YwL3NhC6IS3hTmV4hTk5ZBu78DgbJSbJHFESuTM9z3B+ccGNYGa
         23EQrtJDhV8VyVHCaes7Fj0vthwZ5mSn9MWigT0JvcVZKuVsYMpxhb8K8i9AhamZnDgr
         qHPw==
X-Forwarded-Encrypted: i=1; AJvYcCUBtiV2hMA81R7yAR02tKV1/Je2vBnpBn60dkWPQ9ZVDjOLd9MWqED4a7vKF75fZGGAidmSWpJ5BJsmRBE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqWRVZadMyZ26c7IUEhud3GGKVXv18G0M1gaIGxl0zfYnGXePN
	IHF378QcWe/Q3++fafb99lQfQNqvxn0u5Rrb6jx7iuA3J2KBJIA6fy+prANFewIBeHlQl5JGZbR
	ATqRm7w0Ce2EtIxdECtBsFPIjruQaYf4=
X-Gm-Gg: ATEYQzxfzB2dxa3mPPJ3d9j+P5CbG+i40jwEY4m53uKzJBk73ikMQ/lTREIii3ohIzE
	lzTBmH6/ufEArigGHUc3pL+7Cia6svIywxNkee10cOuUKGuZPRaVo7PjWkhqtjEQErG6EasmpEn
	6Z8imGnzHS6Ka7PejCOu7qSFM2rHxVct/E2JpXdYjeDTJaZiDH1orgiIQZ8Vx7klEi5PdDH/yi6
	cR7bcyQxNkUNhKoMPaZ7jGjqFCna6JV3I7CVMeSNEYYTaGOKyy7m5wg+F7rWs+XKw7oUHqMJgVN
	yF91lvUtnaNHL+wyK0e28BIBEjET50iSYi3fbZoijtTADmU+Xg==
X-Received: by 2002:a05:6820:98e:b0:67a:381:d0bc with SMTP id
 006d021491bc7-67b9bd7fbd0mr2495746eaf.72.1772847571210; Fri, 06 Mar 2026
 17:39:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112192827.25989-4-ethan.w.s.graham@gmail.com>
 <20260306094459.973-1-jiakaiPeanut@gmail.com> <CANgxf6yMNZ3=xm9xVhPZDuxMc__7pQk=mti-CyD1QjUOgTJLEA@mail.gmail.com>
 <CAFb8wJvmnPv96o9Kr9VAh=cL9zMr8-5eCEmmkjtgX02_Ypa4nw@mail.gmail.com> <CANgxf6wjPOoYemsK9EKrFM-eSpOgSUQvZ6kX5JyDTfC5J62Ufg@mail.gmail.com>
In-Reply-To: <CANgxf6wjPOoYemsK9EKrFM-eSpOgSUQvZ6kX5JyDTfC5J62Ufg@mail.gmail.com>
From: Jiakai Xu <jiakaipeanut@gmail.com>
Date: Sat, 7 Mar 2026 09:39:20 +0800
X-Gm-Features: AaiRm50KpdlvXzopHVFRmT8nMLKcn3vW_ZNiGHxd8-Gph5tiqofDNvJc5-PXCCs
Message-ID: <CAFb8wJsyKF3m=WQDkjFSLPeCL1peUA-G1__aByz8vQ-kw3wZ8A@mail.gmail.com>
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

Thanks so much for the patient and detailed explanation. Your clarification
has resolved the questions I had, and I now have a much better understandin=
g
of KFuzzTest's design philosophy and approach.

I'm very interested in the design and implementation of KFuzzTest. Thanks
again for the explanation and for proposing KFuzzTest.

Best regards,
Jiakai

On Sat, Mar 7, 2026 at 12:53=E2=80=AFAM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> On Fri, Mar 6, 2026 at 12:04=E2=80=AFPM Jiakai Xu <jiakaipeanut@gmail.com=
> wrote:
> >
> > Hi Ethan,
>
> Hi Jiakai,
>
> > Thanks for the detailed explanation.
> >
> > Would it be fair to say that KFuzzTest is not well suited for testing
> > kernel functions that are heavily influenced by or have a significant
> > impact on kernel state?
>
> With the current fuzzer support (see the PR in the syzkaller repo [1])
> this is a fair assessment, but with a caveat.
>
> It really depends on how you are fuzzing. KFuzzTest itself is just the
> conduit. Whether or not your fuzzer can meaningfully reproduce
> bugs/crashes related to complex state is somewhat out of KFuzzTest's
> hands. However as of v4 the framework only supports blob-based
> fuzzing, I would advise against targeting heavily stateful functions righ=
t
> now. You are welcome to experiment to see if there is a way to meaningful=
ly
> fuzz more stateful functions, but with just binary buffers as inputs, I d=
on't
> reckon that there will be too many candidates.
>
> > I agree with your point that "the goal of the framework is to fuzz real
> > functions with realistic inputs." One thing I've been thinking about,
> > though, is how we determine what counts as "realistic" input for a give=
n
> > function. If the generated inputs that a function would never actually
> > receive in practice, we'd likely end up chasing false-positive crashes
> > that don't represent real bugs.
>
> I would argue that just because an input isn't "realistic" in the current
> kernel context (i.e., the current upstream code only calls into the libra=
ry
> after performing sanity checks and/or validation) doesn't mean that a
> crash isn't problematic.
>
> Code can and does get reused and refactored over time. If an internal
> parser can cause a panic or OOB access when handed certain inputs,
> it is inherently fragile. Even if that code path is shielded today, it co=
uld
> be exposed by a new caller tomorrow. Our baseline assumption here is
> that if a function accepts a blob as input, it should be resilient to all=
 types
> of blobs.
>
> However your concerns about false positives is justified, and something
> that we have thought about. In previous iterations of this work, we relie=
d
> on a constraints system for encoding input semantics and performing
> validation inside the fuzz harness. While we stepped back from that due
> to its inherent complexity, instead favoring a more simple blob-only desi=
gn,
> adding constraints to better define "realistic" inputs is a good idea tha=
t may
> need to be revisited in the future.
>
> Hope this helps clarify the design philosphy!
>
> [1] related syzkaller PR for KFuzzTest:
> https://github.com/google/syzkaller/pull/6280
>
> > Thanks,
> > Jiakai
> >
> >
> > On Fri, Mar 6, 2026 at 6:29=E2=80=AFPM Ethan Graham <ethan.w.s.graham@g=
mail.com> wrote:
> > >
> > > On Fri, Mar 6, 2026 at 10:45=E2=80=AFAM Jiakai Xu <jiakaipeanut@gmail=
.com> wrote:
> > > >
> > > > Hi Ethan and all,
> > >
> > > Hi Jiakai
> > >
> > > > I've been reading the KFuzzTest documentation patch (v4 3/6) with g=
reat
> > > > interest. I have some questions about the scope and applicability o=
f this
> > > > framework that I'd like to discuss with the community.
> > > >
> > > > The documentation states:
> > > > > It is intended for testing stateless or low-state functions that =
are
> > > > > difficult to reach from the system call interface, such as routin=
es
> > > > > involved in file format parsing or complex data transformations.
> > > >
> > > > I'm trying to better understand what qualifies as a "stateless or
> > > > low-state function" in the kernel context. How do we define or iden=
tify
> > > > whether a kernel function is stateless or low-state?
> > > >
> > > > Also, I'm curious - what proportion of kernel functions would we
> > > > estimate falls into this category?
> > >
> > > I would define it based on "practical heuristics". A function is prob=
ably a
> > > good candidate for KFuzzTest if it fits these loose criteria:
> > >
> > > - Minimal setup: KFuzzTest currently supports blob-based fuzzing, so =
the
> > >   function should consume raw data (or a thin wrapper struct) and not
> > >   require a complex web of pre-initialized objects or deep call-chain
> > >   prerequisites.
> > > - Manageable teardown: if the function allocates memory or creates
> > >   objects, the fuzzing harness must be able to cleanly free or revert
> > >   that state before the next iteration. An example of this can be fou=
nd
> > >   in the pkcs7 example in patch 5/6 [1].
> > > - Non-destructive global impact: it's okay if the function touches gl=
obal
> > >   state in minor ways (e.g., writing to the OID registry logs as is d=
one
> > >   by the crypto/ functions that are fuzzed by the harnesses in patch =
5/6),
> > >   but what matters is that the kernel isn't left in a broken state be=
fore the
> > >   next fuzzing iteration, meaning no leaked global locks, no corrupte=
d
> > >   shared data structures, and no deadlocks.
> > >
> > > These loose criteria are just suggestions, as you can technically fuz=
z
> > > anything that you want to - KFuzzTest won't stop you. The danger is
> > > that the kernel isn't designed to have raw userspace inputs shoved
> > > into deep stateful functions out of nowhere. If a harness or function
> > > relies on complex ad-hoc state management or strict preconditions,
> > > fuzzing it out of context will likely just result in false positives,=
 panics,
> > > and ultimately bogus harnesses.
> > >
> > > The goal of the framework is to fuzz real functions with realistic in=
puts
> > > without accidentally breaking other parts of the kernel that the func=
tion
> > > wasn't meant to touch. Therefore ideal targets (like the PKCS7 exampl=
e)
> > > are ones with minimal setup (just passing a blob), have manageable
> > > teardown (like freeing a returned object on success) and don't
> > > destructively impact global state (even if they do minor things like
> > > printing to logs).
> > >
> > > That said, I'm curious to see what you come up with! I'm sure there a=
re
> > > other use cases that I haven't thought of.
> > >
> > > [1] PKCS7 message parser fuzzing harness:
> > > https://lore.kernel.org/all/20260112192827.25989-6-ethan.w.s.graham@g=
mail.com/
