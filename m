Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD55215F4C;
	Thu, 17 Apr 2025 08:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744879378; cv=none; b=Hki/Wn8FcoIp7kl8cGgw60RjjEXqEUxslSggyhAhRwpTJLxBZNKwSQWMjFAOAeV3h52bApqRAHQ2zrlXwZJ7E009dSRrMf1MkWgkbzFCLVauGfUtM8m5iYkCfgK1FkJ+KX8sKdKHrYfmNLGdgMhR4qIRue8nkl5fhy3MvzXFArQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744879378; c=relaxed/simple;
	bh=0vW4NcGEDGioTo3EBjeBzi8jLHnCF7eXadZ47IZhMsw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=thQAfPv+gidOyGGYJLenRO9bZFCFdq5Qr8tDnACfP0OMKwXqCfeSGEXNvPr5pb3xUu3joc7BotbypAhlapJZu2fJV7xmQBilAp5zYhtbNoB+XJ231np3/qI33SpoM68HsY0xqnGGe1Y/z/JQ4WplHsnfZPLLRNsGxxf0fSJfMkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fj9FQ6iz; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fj9FQ6iz"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e5372a2fbddso480117276.3;
        Thu, 17 Apr 2025 01:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744879376; x=1745484176; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gyDG2C1fOJ7sS+KyT/XBqXKFbi/J2aTw+uyXNBnFAdg=;
        b=fj9FQ6izjNo30HiRGY0H6If2j6COoCZ8WtTg2c09FFNipw9DRQVl7UkHwwaukHw+xO
         2SgjZ5Sh7lyoukM4XxZTPTvyEgCP4l3l1hsNyT4YpBjOyaYFEow6HwW7/V3fQ17HBzHk
         SAZlAQ4jLGbm3tAO23yBlPqKOAOf7vUgCXfzK6I4vCuBO3rt27rGiIeRGuhcfc1KKNb6
         eRKDQAXWa5EmUjzRcvBwPTXIoJ6gki6Z7KsqztsyyJ1N2De51KpW/nmRwtMLOT89SuW8
         MeWgeaPE6hhG302udfondHiljlMiVW6pvD06fMzdngTlA9szJLzhnYjQ5TKDfog5RuwG
         uPEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744879376; x=1745484176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gyDG2C1fOJ7sS+KyT/XBqXKFbi/J2aTw+uyXNBnFAdg=;
        b=rLDcu8N61KAwimKpOVBF7n7zza/M4RtSVF565jYpoZmU0gyw1Swy0NFD3xAokJZ/Db
         qjhhVIMXMGHnsg5kXzyAeXPNG/oGk1CR9YbKOglhDG+7JWgzkHKof5ZoBcKaVBatlv3A
         JFYWkks5THB7OVVO9F1tPdu3MwyVzYkUdFOKDylCnJaqVf5IeJjXX3muCv7+fVsSYHl7
         79MvaotxhMBxDVMprEfSSUGhai1QfMPB5Tzu/0JvQSt0R5XvjmzJfDb9yLCQo99cZY7z
         2nlNkHlHGSFiCfSK5zgF1yPEbDn4sVUzzR5NDnWEqsRGx0+U2meHeaTCEWrUspn2ktsH
         w96w==
X-Forwarded-Encrypted: i=1; AJvYcCV641zOAUF/GoohpXLh9L4girQV6HorlgcToEN4aS7C0enJbl3HvGuJZZyDyKk2nptPQyulucxwrAgViLQQ@vger.kernel.org, AJvYcCVHW0LkVn5Raxi9fp21p0dnKFv9b0AvSvwbgCdY9z7sV9IvSVodDEdXF1fTRWaDxg+7itoLpdUkIRBmBaQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxih5m7AbylUMwsBuMy4KhpwVbpRBfSgqEAPRquveot/AbagWT
	+9+z1noTjOe0fyb4prFb6gaU+EljEFQp/bFVTl5u2uB6P7ZG9bPnwLSawKypuPhV+rCfHwrLM5L
	xy5k99xFX7Brts7eL6cVPjCbgbK4=
X-Gm-Gg: ASbGnct5IoP9b8f2Eq/TQNF/2YnW0nHwsIRSCvnh7kHKhsT2TLbUb1Gwv9Hzzcqnq/G
	vkkGhdN/aeLRePQr6dXN8DKOdlWFAw+mfEJZpo3JYTt0FNj7UmpJFEZRDBaYM9umvH/WNLMi/FT
	k/ss/bW4cZ7CuSb6NEa/BcocFhMwulAHNgDZSCLw==
X-Google-Smtp-Source: AGHT+IEMDK/SY2xCkPcdfnpadxE5dUl1bSX3/cSEvi6KsT9DeYcFnhL4p/6HqW2SE4cLabXs0QINa9JISpmITtGKnHg=
X-Received: by 2002:a05:6902:2b8a:b0:e58:3209:bdb6 with SMTP id
 3f1490d57ef6-e7275967363mr6403514276.16.1744879376263; Thu, 17 Apr 2025
 01:42:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417064940.68469-1-dqfext@gmail.com> <CAMj1kXFPAVXOtPoETKvHB49kjZUPYrsAqsJwdL7p5Cu4xk75Rg@mail.gmail.com>
 <CALW65jY=LnVBYoKPOQnSKgGSA0brKzmo0vqoRDcqF_=jofLAng@mail.gmail.com> <CAMj1kXH-u7hiKGQfgYHj_16V4ATN_aHmA_wkvMSyLh+E3+QaAA@mail.gmail.com>
In-Reply-To: <CAMj1kXH-u7hiKGQfgYHj_16V4ATN_aHmA_wkvMSyLh+E3+QaAA@mail.gmail.com>
From: Qingfang Deng <dqfext@gmail.com>
Date: Thu, 17 Apr 2025 16:42:46 +0800
X-Gm-Features: ATxdqUGF5I5enMnn55N96efB0kMcC0Ath0bpVVj7yzS5lSH1IQrB6kbXGiv0Iic
Message-ID: <CALW65jZVYUZoka7Gbjcoh43qbkD7rGpw8gTZjjOYpZD-BhLyBQ@mail.gmail.com>
Subject: Re: [RFC PATCH] crypto: riscv: scalar accelerated GHASH
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, linux-crypto@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	=?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>, 
	Heiko Stuebner <heiko.stuebner@vrull.eu>, Qingfang Deng <qingfang.deng@siflower.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 17, 2025 at 3:58=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> wr=
ote:
> > >
> > > What is the use case for this? AIUI, the scalar AES instructions were
> > > never implemented by anyone, so how do you expect this to be used in
> > > practice?
> >
> > The use case _is_ AES-GCM, as you mentioned. Without this, computing
> > GHASH can take a considerable amount of CPU time (monitored by perf).
> >
>
> I see. But do you have a particular configuration in mind? Does it
> have scalar AES too? I looked into that a while ago but I was told
> that nobody actually incorporates that. So what about these
> extensions? Are they commonly implemented?

It's aes-generic.c (LUT-based) with accelerated GHASH.

>
> [0] https://web.git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/lo=
g/?h=3Driscv-scalar-aes
>
> > > ...
> > > > +static __always_inline __uint128_t get_unaligned_be128(const u8 *p=
)
> > > > +{
> > > > +       __uint128_t val;
> > > > +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> > >
> > > CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS means that get_unaligned_xxx()
> > > helpers are cheap. Casting a void* to an aligned type is still UB as
> > > per the C standard.
> >
> > Technically an unaligned access is UB but this pattern is widely used
> > in networking code.
> >
>
> Of course. But that is no reason to keep doing it.
>
> > >
> > > So better to drop the #ifdef entirely, and just use the
> > > get_unaligned_be64() helpers for both cases.
> >
> > Currently those helpers won't generate rev8 instructions, even if
> > HAVE_EFFICIENT_UNALIGNED_ACCESS and RISCV_ISA_ZBB is set, so I have to
> > implement my own version of this to reduce the number of instructions,
> > and to align with the original OpenSSL implementation.
> >
>
> So fix the helpers.

The issue is that RISC-V GCC doesn=E2=80=99t emit efficient unaligned loads=
 by default:
- Not all RISC-V CPUs support unaligned access efficiently, so GCC
falls back to conservative byte-wise code.
- There=E2=80=99s no clean way to force the optimized path - GCC only emits
fast unaligned loads if tuned for a specific CPU (e.g., -mtune=3Dsize or
-mtune=3Dthead-c906), which the kernel doesn't typically do, even with
HAVE_EFFICIENT_UNALIGNED_ACCESS.

Maybe we should raise this with the GCC maintainers. An explicit
option to enable optimized unaligned access could help.

As for rev8, there's a patch pending to implement the swab macros.

-- Qingfang
