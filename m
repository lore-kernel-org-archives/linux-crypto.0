Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E2833BBC6
	for <linux-crypto@vger.kernel.org>; Fri,  6 Mar 2026 16:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772816030; cv=pass; b=RxdvHtUqk8o0efU36n46flI82fAAUX5S1rT+ZGhrHjboKcjZcvi1xPCxKcs2s1RJ4sDiYfgXhgbDD8A0QSTQBTA23dCNUsP/T8FAqyt8CvjFljLnUohKo8vOy6r0Oc3K6K+YNJCkSbGOn0i5Bh5kQiRe4T9n/Rz14NhJqToZNXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772816030; c=relaxed/simple;
	bh=sOB0uRpn90bNn0KEyo8o/J3jsfZjShZ7dooZWroirh0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YqnYX/E4HxdqtYDBaV4b5dxfX0tO7h4fkzfkv6Z74zdzNlnXH5nEFU5RlIqsa2igtJwNDDTNqZZFFjyXbXiLEvTzLe/JTnnw1JB2m/KoeCk22+VMGBf2AUCfAs9r2hn77Lxq2jsNJZcYQAnHu6mIer/A52sOXbbUz2DrJ1ptXDw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k6fVHpN8; arc=pass smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k6fVHpN8"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1275750cf9cso7866987c88.0
        for <linux-crypto@vger.kernel.org>; Fri, 06 Mar 2026 08:53:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772816028; cv=none;
        d=google.com; s=arc-20240605;
        b=a1J1FuUNrX2ey8w/j3hql/CJnyMImBVBUAR6HhkDCA4tcNwdWroT08k6A5sVloEtJr
         jAzYvBIXoE/Rk2KxDQrHj+oj995fz8kRqLBR4QqCCyJLUKid7xQJ/pTk6pw/M9oE1Ypd
         lzmxH9dwVZr7w4CEdKpAxpD4FDyZmAY+sx3uohsfYrpsbl6L/rgJ8tdT9Wtb9NPimySH
         uFWwIx+aeQyK+w9yo1nsWg9pCiRSMZ0ZkVCV8MN5Mdq96n9npSRDKUGSxo6jEJffV+KP
         mfmsOFPwYnLN6Owg4oBXxwAQNtHEQZYF+3eQonxv+sdFh6hmkMLNtJvcFfhypKnKOoQS
         ZOGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d55lq5uPJ8gGFWTrhAL2DxmhHj1adF25qQQ5iMiqqsE=;
        fh=WTGPYswrAEctXtULa++iLtTlTrlrueHABEseyqsjf68=;
        b=IdU/SrjAUFwFWdWX2eIksQJPuvwH1L8OHIgeeGXF0ifuRhXdA4TcR10cbHAT02a6Xs
         +IesMDvJeLfh5qk03Xbw3NEXtJBsXR4Ln6aGIYsuKI1Raq5vev95nqtdvIDo0v/137F1
         phTdk32rGZY3+Ift4p8TQk+PEk9NDAZ/hFBUJUOumu8o0VsCp/2oC2UoCL6sVQs/c0US
         PUofKRlPJ3UPbNx8s+cMnd3MyVWAv9wag9mot6DKmmbJrOnLng9QehwAMPYNe7wfE/dQ
         iKqWPRpEv5FNmNmtONLdJj+U0ebkiJVe03jGd1oNwbhxp0rcidyljBILX9HwIU4oGWj+
         ZeCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772816028; x=1773420828; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d55lq5uPJ8gGFWTrhAL2DxmhHj1adF25qQQ5iMiqqsE=;
        b=k6fVHpN8iNYGg0+yDVjPTk7jPKVHEFumtiEwNxJJT+Hkp7yU/xg6OLFQLDfH9e8QFW
         kmTngRfaUNQ66eZTSLUdFJwTKBPR43tmrGrKsfp0djYdQ4KozRLOYm3wfKNp1PP/qw6l
         rcomLlAmuECumhFvou30+IvZ7RBmIbTgwOJcKW9g/6+LKnrZ8Th0my0hmLRwAItK/RbO
         0IXbiHVfNGQXOCdY89Bxguz5g3nGrwfzptuIUV9V4BQ9TsUdkuJqWz4oMPb/rDNlHoEx
         QYK9SbZGAIFg9g/ARn07/EHSH1L7PVWxso84bdzYEDyXCw9C4uyQjLl/2RqrQNcybzEB
         aFNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772816028; x=1773420828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d55lq5uPJ8gGFWTrhAL2DxmhHj1adF25qQQ5iMiqqsE=;
        b=YtHuzVJUfjYWFbNbDBo/IHQ8wFNemF+jGgzQalVFvW9l5198L+FzbdiOg/xsCViAgV
         WwND/nEk00RY56B5WujVdh97duqKM2DffeVlRoGN4KiDEaezqjVwOxNjtpFf5OsPyjSv
         RxdLra7RU2vDUD8EDguoxYVM0cFFhz8OBvTRzFmhbKyDRSVLC04KmdAv//mbRT9nDnpg
         AwOSBCbQIafMTfUpjzcawl4NXMqoYd0yKw5w3BVQeUQSx7vqGz6TTDav+Bp9RjhZ4wKF
         dltFI7CIkjN2EVWbr84E18nQH54p/hkMvR1cVOWPtcFtNyvR7k2IQpJ+Am52ZByUkabd
         mobA==
X-Forwarded-Encrypted: i=1; AJvYcCUioIehKc3o3SO2/wf1NduVxsiuca5LiE3IojlSenxNIMOWvbKf+LJMr6mndlvoxk0OMIizPZ7ZVnaXa7w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0T5ygPF1fq0SLPB+wmd8yqOIWXelzXnZDJX2moYvPujDGWHse
	vcsENi5CpIAPIRbT/FzUEVlzOsYKHlT6JalBscIw1w0WasYlSwmv8lIRXw2OwrXrDo8yRvudUay
	Pjse20bMH+3SUOsCtbSHD+BwESD3cMuI=
X-Gm-Gg: ATEYQzzmDrQWXlD6vjV9UztVwvPkz1tS4U7sqvrO4vjh/Nwto5sE+hhDVMiQoay9lih
	4L5eNCsT9nKNxmCXki72DjCrdhrw3y8/+wxvrZWN8I3IXSQNIf6I1hiyvskXgnB0t7k5nnKFeRa
	on5uS0XWVTslrpTaQ1y+qHGDXT0BaNR7dQOEzW7ORimC4Hp9t0UuXlJiLNDp1O3WiFjOX1IEhe3
	9qqzNxHihs942jtrWLru1/vYHfo0A9L3yIvQ49vgLB5B/W7n8b2EJIU0hpTlgb8++5OZABK2mlR
	dkKppI2UK6WyCzhalTqraxNCAfw=
X-Received: by 2002:a05:7022:2381:b0:123:330b:3b5 with SMTP id
 a92af1059eb24-128c2e8cce8mr927019c88.30.1772816027931; Fri, 06 Mar 2026
 08:53:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112192827.25989-4-ethan.w.s.graham@gmail.com>
 <20260306094459.973-1-jiakaiPeanut@gmail.com> <CANgxf6yMNZ3=xm9xVhPZDuxMc__7pQk=mti-CyD1QjUOgTJLEA@mail.gmail.com>
 <CAFb8wJvmnPv96o9Kr9VAh=cL9zMr8-5eCEmmkjtgX02_Ypa4nw@mail.gmail.com>
In-Reply-To: <CAFb8wJvmnPv96o9Kr9VAh=cL9zMr8-5eCEmmkjtgX02_Ypa4nw@mail.gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Fri, 6 Mar 2026 17:53:36 +0100
X-Gm-Features: AaiRm520AP3BKAgH-rViiwWeXF81JB5TY519npbH34QQ3iWXw2jRnyHpyWWp2eg
Message-ID: <CANgxf6wjPOoYemsK9EKrFM-eSpOgSUQvZ6kX5JyDTfC5J62Ufg@mail.gmail.com>
Subject: Re: Question about "stateless or low-state functions" in KFuzzTest doc
To: Jiakai Xu <jiakaipeanut@gmail.com>
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

On Fri, Mar 6, 2026 at 12:04=E2=80=AFPM Jiakai Xu <jiakaipeanut@gmail.com> =
wrote:
>
> Hi Ethan,

Hi Jiakai,

> Thanks for the detailed explanation.
>
> Would it be fair to say that KFuzzTest is not well suited for testing
> kernel functions that are heavily influenced by or have a significant
> impact on kernel state?

With the current fuzzer support (see the PR in the syzkaller repo [1])
this is a fair assessment, but with a caveat.

It really depends on how you are fuzzing. KFuzzTest itself is just the
conduit. Whether or not your fuzzer can meaningfully reproduce
bugs/crashes related to complex state is somewhat out of KFuzzTest's
hands. However as of v4 the framework only supports blob-based
fuzzing, I would advise against targeting heavily stateful functions right
now. You are welcome to experiment to see if there is a way to meaningfully
fuzz more stateful functions, but with just binary buffers as inputs, I don=
't
reckon that there will be too many candidates.

> I agree with your point that "the goal of the framework is to fuzz real
> functions with realistic inputs." One thing I've been thinking about,
> though, is how we determine what counts as "realistic" input for a given
> function. If the generated inputs that a function would never actually
> receive in practice, we'd likely end up chasing false-positive crashes
> that don't represent real bugs.

I would argue that just because an input isn't "realistic" in the current
kernel context (i.e., the current upstream code only calls into the library
after performing sanity checks and/or validation) doesn't mean that a
crash isn't problematic.

Code can and does get reused and refactored over time. If an internal
parser can cause a panic or OOB access when handed certain inputs,
it is inherently fragile. Even if that code path is shielded today, it coul=
d
be exposed by a new caller tomorrow. Our baseline assumption here is
that if a function accepts a blob as input, it should be resilient to all t=
ypes
of blobs.

However your concerns about false positives is justified, and something
that we have thought about. In previous iterations of this work, we relied
on a constraints system for encoding input semantics and performing
validation inside the fuzz harness. While we stepped back from that due
to its inherent complexity, instead favoring a more simple blob-only design=
,
adding constraints to better define "realistic" inputs is a good idea that =
may
need to be revisited in the future.

Hope this helps clarify the design philosphy!

[1] related syzkaller PR for KFuzzTest:
https://github.com/google/syzkaller/pull/6280

> Thanks,
> Jiakai
>
>
> On Fri, Mar 6, 2026 at 6:29=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gma=
il.com> wrote:
> >
> > On Fri, Mar 6, 2026 at 10:45=E2=80=AFAM Jiakai Xu <jiakaipeanut@gmail.c=
om> wrote:
> > >
> > > Hi Ethan and all,
> >
> > Hi Jiakai
> >
> > > I've been reading the KFuzzTest documentation patch (v4 3/6) with gre=
at
> > > interest. I have some questions about the scope and applicability of =
this
> > > framework that I'd like to discuss with the community.
> > >
> > > The documentation states:
> > > > It is intended for testing stateless or low-state functions that ar=
e
> > > > difficult to reach from the system call interface, such as routines
> > > > involved in file format parsing or complex data transformations.
> > >
> > > I'm trying to better understand what qualifies as a "stateless or
> > > low-state function" in the kernel context. How do we define or identi=
fy
> > > whether a kernel function is stateless or low-state?
> > >
> > > Also, I'm curious - what proportion of kernel functions would we
> > > estimate falls into this category?
> >
> > I would define it based on "practical heuristics". A function is probab=
ly a
> > good candidate for KFuzzTest if it fits these loose criteria:
> >
> > - Minimal setup: KFuzzTest currently supports blob-based fuzzing, so th=
e
> >   function should consume raw data (or a thin wrapper struct) and not
> >   require a complex web of pre-initialized objects or deep call-chain
> >   prerequisites.
> > - Manageable teardown: if the function allocates memory or creates
> >   objects, the fuzzing harness must be able to cleanly free or revert
> >   that state before the next iteration. An example of this can be found
> >   in the pkcs7 example in patch 5/6 [1].
> > - Non-destructive global impact: it's okay if the function touches glob=
al
> >   state in minor ways (e.g., writing to the OID registry logs as is don=
e
> >   by the crypto/ functions that are fuzzed by the harnesses in patch 5/=
6),
> >   but what matters is that the kernel isn't left in a broken state befo=
re the
> >   next fuzzing iteration, meaning no leaked global locks, no corrupted
> >   shared data structures, and no deadlocks.
> >
> > These loose criteria are just suggestions, as you can technically fuzz
> > anything that you want to - KFuzzTest won't stop you. The danger is
> > that the kernel isn't designed to have raw userspace inputs shoved
> > into deep stateful functions out of nowhere. If a harness or function
> > relies on complex ad-hoc state management or strict preconditions,
> > fuzzing it out of context will likely just result in false positives, p=
anics,
> > and ultimately bogus harnesses.
> >
> > The goal of the framework is to fuzz real functions with realistic inpu=
ts
> > without accidentally breaking other parts of the kernel that the functi=
on
> > wasn't meant to touch. Therefore ideal targets (like the PKCS7 example)
> > are ones with minimal setup (just passing a blob), have manageable
> > teardown (like freeing a returned object on success) and don't
> > destructively impact global state (even if they do minor things like
> > printing to logs).
> >
> > That said, I'm curious to see what you come up with! I'm sure there are
> > other use cases that I haven't thought of.
> >
> > [1] PKCS7 message parser fuzzing harness:
> > https://lore.kernel.org/all/20260112192827.25989-6-ethan.w.s.graham@gma=
il.com/
