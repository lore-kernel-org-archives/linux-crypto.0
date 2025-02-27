Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C12922E3F3
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 12:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740658665; cv=none; b=LiH5Lob3hoZQnj6WeQXM8i9kzZRr8jOhiRbyrHX4/5Q3yyPFqLhQQksyDveEwrxG3QhEA3oDq2EnozKveL+kF1l4v8gNjAsHcTG4ZiA+kWC0GuzUrw9LNzbAfV/f4aoMwMptw/ULS0bfUXg0TJ3WXUSnTeobmigI50kHz0BYmso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740658665; c=relaxed/simple;
	bh=t2NEDTueBdrSzpgnFv04f30wmQJOXvi/XawvOOxHn+Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=alhZ21EFpgOqc8t5milTvHtDwd3NfNlBtJ35Ar9/JyAdjoLrjvLD3qLTWGvMttcUK1HtDMOYbahgYu0MFWM1L4pipQewOgWrULw1HmTSmrnsOkPB6amH0pXZCaTE0JCSZEfu5hB7EYnqelTyAN2asC+mKO6i9jFb9tgEU0bfsy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=He49sx0v; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="He49sx0v"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-abec8b750ebso133254366b.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 04:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740658661; x=1741263461; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aRXThQoOhwcNnfMppD5vGBwZ9FKwKkKrXbvSv/+frAI=;
        b=He49sx0vEapmkUt1z3yGaOX1ltKdhey+ncCLb8smPK6USqhJwq6NcK7WeIJY0EjzAI
         4Hu9Q3rF0qfiMuaPLH/y7YtvbLvdBVDkKwfYV+wU+9tAvOihXj+ZlCbG53WdyTDMDdTE
         JYcqCuRlDrlBc0dSdzYgndXDjDEBhN8CsNv+2CbKSC6XcSKSn6FaTjJ/BYJFp3w0TVn3
         XJPH8CM+ADA2Z3LK49fhG9b/R7AYSOEByh68057hRYTG03AWFRRUNhGVtSfvFby8urD0
         pWKKNckHarYVdcEk9upm8CBREaTUccAjm4hYPIkEa/2uavHgbp/Lr6UVIvJFmGJq00BV
         staQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740658661; x=1741263461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aRXThQoOhwcNnfMppD5vGBwZ9FKwKkKrXbvSv/+frAI=;
        b=gmTY6jvwxWSgDG8LRyaGhlIfhTFfP4XVgpR9KdAd0+HjhruoETKMeDkqbTzX0fswER
         07bXxtVZnPVQpwEasAil84HRgd+McVGFPJXqorV8D3w6gVC5zYSDlun3llY5LWCKA++/
         E7XtCHVo91QNBvnF/Nj/ikOD6amQI014vmjrXzds/ZnYLa6omQEn+756F3xj0L+BQdp/
         T2b1G/FeXUpcge0crRjZR1pk/uO9//2QmX6g4XpvcJi1viWoq6eahWg3YCt4TH0AYZC8
         rjV6aZF8yWhbmqBr638vfI0sP6UlMGi+NUnWLeYT0svtWEEODIQtPdnX9BQ7FVTwHj9U
         4wPg==
X-Forwarded-Encrypted: i=1; AJvYcCW4zz4XrUlVm3cCIlrm3muHpKPNUGtuDOEmXeuR0yyoIY+bQ4bvSClTYIMUaNup1qkqsHMKySYSyhmeAg8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1MNEl7XMvvSI6UFHHL3DhsTVp94qKSgZitWkC5zBklNcPl1MU
	ObVYvpS5o9PAUqaO2U1oi0J+NR1bgiIM2Z11BQBVcSGraw8igZK8scAhmda/KQFu8xKUf7uOPWJ
	E6kBa1pz2rZ3R93XfrvIU0VkZoo0GHnQfGhg=
X-Gm-Gg: ASbGncu49BmnVdM6r7kAUssFfIPeI4IR7mvWI9dNhAzUgR24dbpz38X+Vip2qF6D5dz
	fc1VJcAMJMi1IF5ZIYt8Nil+Qhz4mmzRwiXo3rFzPNLujNnSk2rpkMii/T4H3rS+SUo5pDLEw1P
	Ql/PdY
X-Google-Smtp-Source: AGHT+IHRc8urmMJEzZbReC8M5BOsivBbw5OeEiAmZaCJJN/28VM+niwg7HDoTK9wNm4K4ubtXD5ztJ3KeACr16PHRt8=
X-Received: by 2002:a17:906:308e:b0:ab6:511d:8908 with SMTP id
 a640c23a62f3a-abc0de19516mr2303876566b.40.1740658660615; Thu, 27 Feb 2025
 04:17:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com>
 <20250227062859.GA2506@sol.localdomain> <68F134A3-5371-4E74-9942-2BC66984C18A@zytor.com>
In-Reply-To: <68F134A3-5371-4E74-9942-2BC66984C18A@zytor.com>
From: Bill Wendling <morbo@google.com>
Date: Thu, 27 Feb 2025 04:17:24 -0800
X-Gm-Features: AQ5f1JqSG0FexJpU0L8y0F9hIyeax1Uhs_LQEGtbtQBFiT71P2KI1fCoyo9pC64
Message-ID: <CAGG=3QX2WX5U-uNp3VWSbQCN9fPVAirOBn5KcaWn8m-87RhWfg@mail.gmail.com>
Subject: Re: [PATCH] x86/crc32: use builtins to improve code generation
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Justin Stitt <justinstitt@google.com>, 
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, 
	clang-built-linux <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2025 at 2:53=E2=80=AFAM H. Peter Anvin <hpa@zytor.com> wrot=
e:
> On February 26, 2025 10:28:59 PM PST, Eric Biggers <ebiggers@kernel.org> =
wrote:
> >On Wed, Feb 26, 2025 at 10:12:47PM -0800, Bill Wendling wrote:
> >> For both gcc and clang, crc32 builtins generate better code than the
> >> inline asm. GCC improves, removing unneeded "mov" instructions. Clang
> >> does the same and unrolls the loops. GCC has no changes on i386, but
> >> Clang's code generation is vastly improved, due to Clang's "rm"
> >> constraint issue.
> >>
> >> The number of cycles improved by ~0.1% for GCC and ~1% for Clang, whic=
h
> >> is expected because of the "rm" issue. However, Clang's performance is
> >> better than GCC's by ~1.5%, most likely due to loop unrolling.
> >>
> >> Link: https://github.com/llvm/llvm-project/issues/20571#issuecomment-2=
649330009
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> >> Cc: Ingo Molnar <mingo@redhat.com>
> >> Cc: Borislav Petkov <bp@alien8.de>
> >> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> >> Cc: x86@kernel.org
> >> Cc: "H. Peter Anvin" <hpa@zytor.com>
> >> Cc: Eric Biggers <ebiggers@kernel.org>
> >> Cc: Ard Biesheuvel <ardb@kernel.org>
> >> Cc: Nathan Chancellor <nathan@kernel.org>
> >> Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
> >> Cc: Justin Stitt <justinstitt@google.com>
> >> Cc: linux-kernel@vger.kernel.org
> >> Cc: linux-crypto@vger.kernel.org
> >> Cc: llvm@lists.linux.dev
> >> Signed-off-by: Bill Wendling <morbo@google.com>
> >> ---
> >>  arch/x86/Makefile         | 3 +++
> >>  arch/x86/lib/crc32-glue.c | 8 ++++----
> >>  2 files changed, 7 insertions(+), 4 deletions(-)
> >
> >Thanks!  A couple concerns, though:
> >
> >> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> >> index 5b773b34768d..241436da1473 100644
> >> --- a/arch/x86/Makefile
> >> +++ b/arch/x86/Makefile
> >> @@ -114,6 +114,9 @@ else
> >>  KBUILD_CFLAGS +=3D $(call cc-option,-fcf-protection=3Dnone)
> >>  endif
> >>
> >> +# Enables the use of CRC32 builtins.
> >> +KBUILD_CFLAGS +=3D -mcrc32
> >
> >Doesn't this technically allow the compiler to insert CRC32 instructions
> >anywhere in arch/x86/ without the needed runtime CPU feature check?  Nor=
mally
> >when using intrinsics it's necessary to limit the scope of the feature
> >enablement to match the runtime CPU feature check that is done, e.g. by =
using
> >the target function attribute.
> >
> >> diff --git a/arch/x86/lib/crc32-glue.c b/arch/x86/lib/crc32-glue.c
> >> index 2dd18a886ded..fdb94bff25f4 100644
> >> --- a/arch/x86/lib/crc32-glue.c
> >> +++ b/arch/x86/lib/crc32-glue.c
> >> @@ -48,9 +48,9 @@ u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
> >>  EXPORT_SYMBOL(crc32_le_arch);
> >>
> >>  #ifdef CONFIG_X86_64
> >> -#define CRC32_INST "crc32q %1, %q0"
> >> +#define CRC32_INST __builtin_ia32_crc32di
> >>  #else
> >> -#define CRC32_INST "crc32l %1, %0"
> >> +#define CRC32_INST __builtin_ia32_crc32si
> >>  #endif
> >
> >Do both gcc and clang consider these builtins to be a stable API, or do =
they
> >only guarantee the stability of _mm_crc32_*() from immintrin.h?  At leas=
t for
> >the rest of the SSE and AVX stuff, I thought that only the immintrin.h f=
unctions
> >are actually considered stable.
> >
> >- Eric
>
> There is that... also are there compiler versions that we support that do=
 not have -mcrc32 support?
>
Checking GCC 5.1.0 and Clang 13.0.1, it seems that both support '-mcrc32'.

-bw
