Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4632206BE
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 07:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740640123; cv=none; b=VaI82paUXVe5/DMGvvLuwItYkX4DaIFEp5yBSTuTlrOUl+huz51o0mi5DySgdT9yvrdDmo74sqlp7mbi6Bqg+uSPpRh9gKOAXEGPLK+xZL6Ohr8z2rXoWnR7tU+DPoA4PQE60aE4EpgiNCR3qIhmTcg98bduHm41MtMEY0OiDxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740640123; c=relaxed/simple;
	bh=rg8B6FDBMz6yz+xYk4oSNWCWQ+8wOLsYZLdg29RHBE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GBg18Y4NeAkA56sIU1foidm7vdbDjcNlHqHZAtrxZx7KNeCOKz6OPgeXOwQRTvKGyaxNb0iTpin+zydoBysrtMW7iXp1mCCm+4/EMG5QxQzXklujvFpY/A+wAtkYV+cZSr7T3T6HKSRwymvrrUQqTgqQMaxoyMs1GQi6yL2Gjdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VVBmMShL; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VVBmMShL"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2feae68f835so117219a91.2
        for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2025 23:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740640121; x=1741244921; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TKhkrI6oIv5W5cLDtWVWvtUq/hOpICpzcugG77LEdi8=;
        b=VVBmMShLmNhsOPeRQux7Fc1DbXQMXzfl1yLjpD/RaT0laLGyXlw+efxM5eRqtfdlqK
         dPdFPfj09Ow8L8PcBLH/K0S8RLmzR27kC33xLejJHGJUokbPJLQHR+t3Isjmr9IJNPWj
         +R4PmiaHu40O2Io6v33ZTHUCxyP8UINjOBNFjl/1nipddrlCqz/1sonx177gyYtp6NLF
         jYn543RGBqBh7wJysHPnzLL7FvJ4pRzukm/dJhkSX8nBIES/bs5gYJiMo/qepWDQmj/9
         IR1qgT/3X7nkX3DZCiiNxHL9pQwn7/B76P24be7XA7Y/Ji96hHCBQYfArVj/QcrnzBKS
         abyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740640121; x=1741244921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TKhkrI6oIv5W5cLDtWVWvtUq/hOpICpzcugG77LEdi8=;
        b=k5df1DHIXjxXNyABUfK3+SntGGU7hzyro5ghj0uz1d206XoU6yp6u36ZxMbfJWQd7p
         AHlc8eCcV5XEZwJwhLJ5+f5LbSxyAYCGNxyCaNxTVLSRyqsOCmpXL8G/qcsDM9Hfcapo
         ehMv2Ojg62sidvyzjvUjqnjj0KmN0t2sE2JC8+gyBGPZrDH9nFYNaQrR0B2gtLXz3XZb
         3K0Zra4WgcIPSSbvYcW7vY8tjoqIggb8fw7zRHY+Aaq/B2PKxi7mSPCzMwnBD7737ToP
         368sATQyWYAkQX9e6tmF/pxZnd9Atar4yBy/cBtz2EAWgoVuSN5ntYGV1ZWCNZnv3YMS
         UFmA==
X-Forwarded-Encrypted: i=1; AJvYcCWgSWw+Mh1KqcCh82pnfUrty95BAH5cE4g1X3M7xIFmuejNC0KrJy0CNHmnhoh7sb/xXLvz85i/LtbwaIY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6dZgs9CE1fC+7Zo+W29GPbjLc7kGp2H4g6BgFUYdkVhaRWdKS
	jcj0mem/16ydfgzYSkwarBD/Gb6u1WBhptVvv8ctrRN9ObcoaMIG5Ht//rk0EjV6YbW1rbChI6y
	JfScKszK5j8jqz1CsmKV1hfKe22hSeezxPOCNMh89GGZE9vi7AG2Dag==
X-Gm-Gg: ASbGncsJdpCdq+xzRhAaIARk24Pu4OqMABcp4zDok9ip7RKxfsmIbn5bgQPWRe/n7rF
	v4Rwf4xjMVyJqnkusNzlqeO8UAVU9Cv7YLU/dtvu+9JCuU16gs1jUS1qVLHA+DJWhzI7sEgp4jm
	ApQCSO
X-Google-Smtp-Source: AGHT+IFvnuTUQDTO+4VmmSR1/1rup47G/HkdLkZFzWMjG5VYtOpMuG8VhVq3CAiDPdsw8oSQMUp+F3Nut4awmQxTzwE=
X-Received: by 2002:a17:90b:570f:b0:2fe:ac01:8016 with SMTP id
 98e67ed59e1d1-2feac01813cmr679744a91.34.1740640120783; Wed, 26 Feb 2025
 23:08:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com>
 <20250227062859.GA2506@sol.localdomain>
In-Reply-To: <20250227062859.GA2506@sol.localdomain>
From: Bill Wendling <morbo@google.com>
Date: Wed, 26 Feb 2025 23:08:22 -0800
X-Gm-Features: AQ5f1JrEBuahLVZ7GJL1oCz4jbIFAykPYy8gOB3rzQjuGstuIo1gE7lS5pS-AII
Message-ID: <CAGG=3QVitM-AwqtYF0QjxpBV7Q8bqv59Os+jELFRUKMnRS9OGA@mail.gmail.com>
Subject: Re: [PATCH] x86/crc32: use builtins to improve code generation
To: Eric Biggers <ebiggers@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Justin Stitt <justinstitt@google.com>, LKML <linux-kernel@vger.kernel.org>, 
	linux-crypto@vger.kernel.org, clang-built-linux <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2025 at 10:29=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> On Wed, Feb 26, 2025 at 10:12:47PM -0800, Bill Wendling wrote:
> > For both gcc and clang, crc32 builtins generate better code than the
> > inline asm. GCC improves, removing unneeded "mov" instructions. Clang
> > does the same and unrolls the loops. GCC has no changes on i386, but
> > Clang's code generation is vastly improved, due to Clang's "rm"
> > constraint issue.
> >
> > The number of cycles improved by ~0.1% for GCC and ~1% for Clang, which
> > is expected because of the "rm" issue. However, Clang's performance is
> > better than GCC's by ~1.5%, most likely due to loop unrolling.
> >
> > Link: https://github.com/llvm/llvm-project/issues/20571#issuecomment-26=
49330009
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: x86@kernel.org
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Eric Biggers <ebiggers@kernel.org>
> > Cc: Ard Biesheuvel <ardb@kernel.org>
> > Cc: Nathan Chancellor <nathan@kernel.org>
> > Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
> > Cc: Justin Stitt <justinstitt@google.com>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-crypto@vger.kernel.org
> > Cc: llvm@lists.linux.dev
> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> >  arch/x86/Makefile         | 3 +++
> >  arch/x86/lib/crc32-glue.c | 8 ++++----
> >  2 files changed, 7 insertions(+), 4 deletions(-)
>
> Thanks!  A couple concerns, though:
>
> > diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> > index 5b773b34768d..241436da1473 100644
> > --- a/arch/x86/Makefile
> > +++ b/arch/x86/Makefile
> > @@ -114,6 +114,9 @@ else
> >  KBUILD_CFLAGS +=3D $(call cc-option,-fcf-protection=3Dnone)
> >  endif
> >
> > +# Enables the use of CRC32 builtins.
> > +KBUILD_CFLAGS +=3D -mcrc32
>
> Doesn't this technically allow the compiler to insert CRC32 instructions
> anywhere in arch/x86/ without the needed runtime CPU feature check?  Norm=
ally
> when using intrinsics it's necessary to limit the scope of the feature
> enablement to match the runtime CPU feature check that is done, e.g. by u=
sing
> the target function attribute.
>
I'm not sure if CRC32 instructions will automatically be inserted when
not explicitly called, especially since the other vector features are
disabled. I wanted to limit enabling this flag for only crc32-glue.c,
but my Makefile-fu failed me. The file appears to be compiled twice.
But adding __attribute__((target("crc32"))) to the function would be
much better.

> > diff --git a/arch/x86/lib/crc32-glue.c b/arch/x86/lib/crc32-glue.c
> > index 2dd18a886ded..fdb94bff25f4 100644
> > --- a/arch/x86/lib/crc32-glue.c
> > +++ b/arch/x86/lib/crc32-glue.c
> > @@ -48,9 +48,9 @@ u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
> >  EXPORT_SYMBOL(crc32_le_arch);
> >
> >  #ifdef CONFIG_X86_64
> > -#define CRC32_INST "crc32q %1, %q0"
> > +#define CRC32_INST __builtin_ia32_crc32di
> >  #else
> > -#define CRC32_INST "crc32l %1, %0"
> > +#define CRC32_INST __builtin_ia32_crc32si
> >  #endif
>
> Do both gcc and clang consider these builtins to be a stable API, or do t=
hey
> only guarantee the stability of _mm_crc32_*() from immintrin.h?  At least=
 for
> the rest of the SSE and AVX stuff, I thought that only the immintrin.h fu=
nctions
> are actually considered stable.
>
I don't know the answer for this. In general, once we (Clang) create a
__builtin_* function it's not going away, because it will break anyone
who uses them. (I assume the same is true for GCC.) There's a note in
Documentation/arch/x86/x86_64/fsgs.rst in regards to using
_{read,write}fsbase_u64() from immintrin.h (see below). I don't know
if that's analogous to what I'm doing here, but maybe we should do
something similar for crc32intr.h?

FSGSBASE instructions compiler support
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

GCC version 4.6.4 and newer provide intrinsics for the FSGSBASE
instructions. Clang 5 supports them as well.

  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  _readfsbase_u64()   Read the FS base register
  _readfsbase_u64()   Read the GS base register
  _writefsbase_u64()  Write the FS base register
  _writegsbase_u64()  Write the GS base register
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

To utilize these intrinsics <immintrin.h> must be included in the source
code and the compiler option -mfsgsbase has to be added.


-bw
