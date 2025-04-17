Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B926C2512E6;
	Thu, 17 Apr 2025 14:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744899328; cv=none; b=SXnBCJuVFpRM8ajpJtQ4Sy2WP4Sho0Gq1hqFwPpL4VHiBmgbDUHX/GpfDnPDKwXmC6VftR9p+jxY1ugtCAXCHdQPHlvfDoPPh6SHuGj2I6u4Dq6v43deZbiiLAJWu+Kf1YFaSMys4lYE4/9x1T1xpMRHM+AcJJi3BtNTj5Q3A8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744899328; c=relaxed/simple;
	bh=OwOkjFVgfqnhtYMoB2n+/2LjSN54EJEx3cnulauDKdo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IO/aWFJaZbuVcPAEPDjd3yRL+0tJoG5tiWhPfYgJxeRFj3jaoHHQt0HlhwWNpAy9E76ktfWCuqp0sZ5bLnQ0kRhpUWqQdfCIEhuE/3JrpUBAoQicRcDSxyqiixXM3sRfpFsILnndOGwfFRZC1lEc+cK1EDh03goo9TQersfjsLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rkPcu2I9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rkPcu2I9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32058C4CEED;
	Thu, 17 Apr 2025 14:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744899328;
	bh=OwOkjFVgfqnhtYMoB2n+/2LjSN54EJEx3cnulauDKdo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rkPcu2I9/wcJSEB9hys4gh2n7O1us0r2kkmLcoI3BHSWby4kg6PpnZiNYwA8xAsv2
	 qdNxNE5+pvCPVLL/Yg4eQ8v6PWOO7yFGCwLrbZz0PQm7FhrlLXMRnF8JDr5pFbJ3tz
	 Gtig0ZzIYazvHpcs5VKrktD54KbjXccWV1YGXKUgCwvwbg35BpxskWyoYVAyJ+3LO4
	 Jn0LnkZsTT853+vAqZw+33d6WLX7Hle9MMmSYhTQ5hZkcTX98WjS7l/DY6o4uUZc94
	 gWsgAil/6uekgh3x3aB/eH0R7cxBYKhkVRJ04JMRNnrJFbwO2GRxatlx88fZs6PrHs
	 bJm8ag2D0nnBQ==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-30bfe0d2b6dso7927651fa.3;
        Thu, 17 Apr 2025 07:15:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUu6qk5bPczgY3Bqgbiff7Wzym3yH9DQVA40CkBQ6jXfmqL5ejhaUbraB4xTg5ND+eGpM7K5+nkOT3j8QHA@vger.kernel.org, AJvYcCXiBLMqY0RfR3iSS6N1pBPoDlZlWGUEbVd7kVlM+INdCbdaa3ibCfPtSyyBmTTbvivBbO2oLLnJRSbHYfA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu9mvhnU+y63UFMJ/a8EGxsk5r6AgOchR1p4rKnAqTwKZDPJXM
	2m72ciHeHdYTJJGP9vRILbVzS2M/gEKs1RuPOmI3vRHhZkcbeHiXymZqCBHvIQw/bwjEo9rjxCx
	9QFtJjiwR/7qnQfOK5sUAdxuQ8/Y=
X-Google-Smtp-Source: AGHT+IGKDLvGQdTgpdJ7/j9wkID94NCC8FnydWqifd12MlpxWqVVofyUjcJtA/8XvkknzSU9uf03za/MH7AVddjqFIU=
X-Received: by 2002:a2e:ad93:0:b0:30b:b204:6b80 with SMTP id
 38308e7fff4ca-3107f695046mr25939941fa.8.1744899326442; Thu, 17 Apr 2025
 07:15:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417064940.68469-1-dqfext@gmail.com> <CAMj1kXFPAVXOtPoETKvHB49kjZUPYrsAqsJwdL7p5Cu4xk75Rg@mail.gmail.com>
 <CALW65jY=LnVBYoKPOQnSKgGSA0brKzmo0vqoRDcqF_=jofLAng@mail.gmail.com>
 <CAMj1kXH-u7hiKGQfgYHj_16V4ATN_aHmA_wkvMSyLh+E3+QaAA@mail.gmail.com> <CALW65jZVYUZoka7Gbjcoh43qbkD7rGpw8gTZjjOYpZD-BhLyBQ@mail.gmail.com>
In-Reply-To: <CALW65jZVYUZoka7Gbjcoh43qbkD7rGpw8gTZjjOYpZD-BhLyBQ@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 17 Apr 2025 16:15:15 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE8nY0rasb04qbZGtkuL5_b8so7L7NH61zLv9G3nm5vcg@mail.gmail.com>
X-Gm-Features: ATxdqUGHOdKzra412vt6IXHNye7okVyhB80J7RfKjih5eOcYv_TSJ39O50e8lAk
Message-ID: <CAMj1kXE8nY0rasb04qbZGtkuL5_b8so7L7NH61zLv9G3nm5vcg@mail.gmail.com>
Subject: Re: [RFC PATCH] crypto: riscv: scalar accelerated GHASH
To: Qingfang Deng <dqfext@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, linux-crypto@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	=?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>, 
	Heiko Stuebner <heiko.stuebner@vrull.eu>, Qingfang Deng <qingfang.deng@siflower.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Apr 2025 at 10:42, Qingfang Deng <dqfext@gmail.com> wrote:
>
> On Thu, Apr 17, 2025 at 3:58=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> =
wrote:
> > > >
> > > > What is the use case for this? AIUI, the scalar AES instructions we=
re
> > > > never implemented by anyone, so how do you expect this to be used i=
n
> > > > practice?
> > >
> > > The use case _is_ AES-GCM, as you mentioned. Without this, computing
> > > GHASH can take a considerable amount of CPU time (monitored by perf).
> > >
> >
> > I see. But do you have a particular configuration in mind? Does it
> > have scalar AES too? I looked into that a while ago but I was told
> > that nobody actually incorporates that. So what about these
> > extensions? Are they commonly implemented?
>
> It's aes-generic.c (LUT-based) with accelerated GHASH.
>
> >
> > [0] https://web.git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/=
log/?h=3Driscv-scalar-aes
> >
> > > > ...
> > > > > +static __always_inline __uint128_t get_unaligned_be128(const u8 =
*p)
> > > > > +{
> > > > > +       __uint128_t val;
> > > > > +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> > > >
> > > > CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS means that get_unaligned_xxx=
()
> > > > helpers are cheap. Casting a void* to an aligned type is still UB a=
s
> > > > per the C standard.
> > >
> > > Technically an unaligned access is UB but this pattern is widely used
> > > in networking code.
> > >
> >
> > Of course. But that is no reason to keep doing it.
> >
> > > >
> > > > So better to drop the #ifdef entirely, and just use the
> > > > get_unaligned_be64() helpers for both cases.
> > >
> > > Currently those helpers won't generate rev8 instructions, even if
> > > HAVE_EFFICIENT_UNALIGNED_ACCESS and RISCV_ISA_ZBB is set, so I have t=
o
> > > implement my own version of this to reduce the number of instructions=
,
> > > and to align with the original OpenSSL implementation.
> > >
> >
> > So fix the helpers.
>
> The issue is that RISC-V GCC doesn=E2=80=99t emit efficient unaligned loa=
ds by default:
> - Not all RISC-V CPUs support unaligned access efficiently, so GCC
> falls back to conservative byte-wise code.

That makes sense.

> - There=E2=80=99s no clean way to force the optimized path - GCC only emi=
ts
> fast unaligned loads if tuned for a specific CPU (e.g., -mtune=3Dsize or
> -mtune=3Dthead-c906), which the kernel doesn't typically do, even with
> HAVE_EFFICIENT_UNALIGNED_ACCESS.
>
> Maybe we should raise this with the GCC maintainers. An explicit
> option to enable optimized unaligned access could help.
>

HAVE_EFFICIENT_UNALIGNED_ACCESS is a build time setting, so the
resulting kernel only runs correctly on hardware that implements
unaligned accesses in hardware.

So that means you could pass this -mtune=3D option too in that case, no?
Then, you can just use a packed struct or an __aligned(1) annotation
and the compiler will emit the correct code for you, depending on
whether unaligned accesses are permitted.
