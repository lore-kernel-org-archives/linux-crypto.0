Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DD9230BC0;
	Thu,  3 Apr 2025 07:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743663795; cv=none; b=Wa3GblY2gUWe0JSH5oNAaVNOfVXbPcQf/lnQACaUxS2iL5TXjDu0lS8vM43NuSiYe/NdHb6T3QXCd+GdSWk5GhKKowwak1y6ey8eeJojeCH+6uUDWM9zSI6NyANwBQ1AezLHRDHBhgOifhWTqfxzJ8etddO6MWH8knWygOxjlTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743663795; c=relaxed/simple;
	bh=l0MLC3LjSRdSlGxzQJUnA2o45FMnz5uriKWfGAhpZ1M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gh1vI2CSO+Pzc/r8oLCMJmQyGPQiYNZBmfUms3npJcjlKhcRwxq1SEoTQQx20g77qoJmqd5my8r9zILnsRJ3PZ+cszSjGps/2H2sXdR4CrWkuYdptSh/HY0bSup+XD3Wsb8AL1mQEJIW84XlF8TVeHJZQFHEzwI9Bmp3IhqodKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KLXVwCO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KLXVwCO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBE8C4CEE3;
	Thu,  3 Apr 2025 07:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743663795;
	bh=l0MLC3LjSRdSlGxzQJUnA2o45FMnz5uriKWfGAhpZ1M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KLXVwCO+bVMklE7kYusSUnLK7+vPPkVA2GBEf23bDXUMvGs1jnLEgwEV0v4a1oqCV
	 NxWekVzemIsXpTbwULg9TwbZAhiLw8UaaHRhhzJhB4AyiJ6aPRovCsPc1WHETfIG4N
	 pUKrUHkrJ66ZC2LTD5qd97O+hHjlH2sud0lmHlkl17XR6qlsH/ZJGOxwi0pPDPzaw1
	 ZRWeJ+8Ss7DOKM3AVV71s37gfaivRUDbjUZzOUNvrzKWtwwkJSNofgttbvXzNmphC9
	 P3vIBpEc3rWq+aW5ciJVshEXpUGK3xAQLYvrLK1fsXWrhjF+tcj8RO8ax04EzkjImO
	 drpT3bih3xx+A==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-30db3f3c907so4452041fa.1;
        Thu, 03 Apr 2025 00:03:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWo8hYqzpXajUbk+L94avbyzIttVSSyJpqWQwnNqj/RzPUHr1JEd7FD0nR215ipXu7NP0BMtEPM6rGTwzs=@vger.kernel.org, AJvYcCX9HafK3+paFuESd9b9eqnoDoR75634NVESY7lt4YG0nr8lKmDYBzQ7rDOSJN+ShoN1rChpwVlkHigw8er3@vger.kernel.org
X-Gm-Message-State: AOJu0YygXU4gJdQAP9zNgjMfoa6bH6pUdwCS5bQYdGhP50+D3TCuTtCu
	7q3O7jdxwwvO6hNfa9YYsrjncmWuqJyFYbdR3sDfyeTkRGinv4o+suaf1LJLcQIA8aAoS3UdmnR
	QVJ5NSDdU9g7kMu8yLlGS9WcbRMU=
X-Google-Smtp-Source: AGHT+IGG4ssKCRoG5dC97++m90adCNhEWJun+PLvmZ3Ya1OJJn752p8/HHSPqTqIThDqF5RoLpoT/qHIxeRbwSImqfw=
X-Received: by 2002:a05:651c:997:b0:30b:a20b:eccc with SMTP id
 38308e7fff4ca-30f021163fbmr4141991fa.11.1743663793438; Thu, 03 Apr 2025
 00:03:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z-yrf_9D2rV1Q136@gondor.apana.org.au> <CAMj1kXEx__RLBriW0kVPrKnx6+DCpq8=6F-7Tmj2Us61gvGGaw@mail.gmail.com>
 <CAMj1kXE-vo7E1U++4mAqDH2SXfc=sRZs8KganedJk5z0QF49NA@mail.gmail.com>
 <Z-zzvXbjt3xzquXb@gondor.apana.org.au> <20250402171930.GD1235@sol.localdomain>
 <Z-3jkYNtZpTDtKGf@gondor.apana.org.au> <20250403021453.GA2872965@google.com>
 <Z-344xAsx1uTE9OK@gondor.apana.org.au> <20250403032008.GA129577@sol.localdomain>
 <Z-4DqsRApwQi6Xju@gondor.apana.org.au> <20250403035934.GB129577@sol.localdomain>
In-Reply-To: <20250403035934.GB129577@sol.localdomain>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 3 Apr 2025 10:03:02 +0300
X-Gmail-Original-Message-ID: <CAMj1kXHB5-ZFbi5TfuU_pfNJRdxH5-ZUY+k4azpvYgv1Py_Ocw@mail.gmail.com>
X-Gm-Features: AQ5f1JooGG0PId6nG39bmLVotgubW1omncONlNucYGzQmxvf8Fro6Z3QmYKqbPk
Message-ID: <CAMj1kXHB5-ZFbi5TfuU_pfNJRdxH5-ZUY+k4azpvYgv1Py_Ocw@mail.gmail.com>
Subject: Re: Banning crypto in hardirq context (was: [PATCH v2 0/9] crypto:
 x86 - stop using the SIMD helper)
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, 
	"Jason A. Donenfeld" <Jason@zx2c4.com>, Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 3 Apr 2025 at 06:59, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Apr 03, 2025 at 11:42:34AM +0800, Herbert Xu wrote:
> > On Wed, Apr 02, 2025 at 08:20:08PM -0700, Eric Biggers wrote:
> > >
> > > Also, riscv has scalar AES instructions.  (They aren't used by the kernel yet,
> > > but they could be.  The CRC code already uses scalar carryless multiplication.)
> >
> > It still doesn't mean that it's a good idea to use AES in a
> > hard IRQ handler, especially if the code is meant to be portable.
> >
> > > Also, as I said already, x86 does support SIMD instructions in hardirq context
> > > in some cases.  Whether anyone actually uses that, I don't know, but it is
> > > explicitly supported.  Check out irq_fpu_usable().
> >
> > This is more of an accident than some deliberate strategy of
> > supporting FPU usage in hard IRQs.  This test was initially
> > added for aesni:
> >
> > commit 54b6a1bd5364aca95cd6ffae00f2b64c6511122c
> > Author: Ying Huang <huang.ying.caritas@gmail.com>
> > Date:   Sun Jan 18 16:28:34 2009 +1100
> >
> >     crypto: aes-ni - Add support to Intel AES-NI instructions for x86_64 platform
> >
> > It was then improved by:
> >
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Mon Feb 13 13:56:14 2012 -0800
> >
> >     i387: make irq_fpu_usable() tests more robust
> >
> >     Some code - especially the crypto layer - wants to use the x86
> >     FP/MMX/AVX register set in what may be interrupt (typically softirq)
> >     context.
> >
> > At no point was there any intention of using this in a hardirq
> > context.
> >
> > Until such a time when you have a valid application for using
> > lib/crypto code in a hardirq context, I don't think we should
> > be supporting that at the expense of real users who are in
> > process/softirq context only.
>
> Whatever.  We agree that "crypto in hardirq" is not a good idea in general.  I'm
> just pointing out that there are certain cases, like SipHash used in a hash
> table, where it easily could happen and would be fine.  And all the shash and
> crypto library functions currently work in any context, unlike e.g. skcipher and
> aead which do not.  You seem to be trying to claim that it was never supported,
> but that is incorrect.  Making it unsupported would be a change that needs to be
> properly documented (the functions would no longer be simply "Any context")
> *and* have proper debug assertions added to enforce it and prevent usage errors.
> But in a lot of cases there is also no reason to even add that restriction.  I'm
> not sure why you're so eager to make the library functions harder to use.
>

Agree with Eric.

There may be cases where some error condition (machine check etc) is
hit while running in hard IRQ context or with IRQs disabled, and the
code that produces the diagnostic, writes to pstore, generates the QR
code for  etc etc may actually be where the library calls to crc32 etc
originate from. So pedantically disallowing that rather than falling
back to a non-SIMD code path make things worse, because now, the
original diagnostic may get lost while the only information left to
debug the issue is an OOPS complaining about a library call in hard
IRQ context.

So while I agree that knowingly invoking library interfaces with IRQs
disabled should be avoided, that is just a variation on the general
adage that IRQs should only be disabled when absolutely necessary. But
that necessity may derive from a condition that exists one or several
layers up.
