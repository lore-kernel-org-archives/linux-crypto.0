Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B071723B0
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 00:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741047423; cv=none; b=sNTsEkipaIfkE5Ifauv+PMtZX22XPnbTvO0K+BfPc1ZxpWIthoU7LJctxA1cz93TIdt/n8+lVp+Aa2tOyzm6AjWXC83aJ3QKdpdASCaFPy7SH7Ba3TC35gzkuuVXCgMTo1i+eodGF5afZ3TotMn3wChZv9woJ8PvjqHtO3Dmsqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741047423; c=relaxed/simple;
	bh=rrW1qjeJ/QQIr7ggV8xAw6BBomUUhv0egDm20B+8KU4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JnRuH9/3CIIQbBgvXPvErVycurpmrNgHuIcSiclQlAI1rXDSyJeCKHma8C4wHl7E34jEg94euBPsCpia3dXslvZmGKER37KspSEQwx56h5YPg8Sv721mhkhl003BnVCBXSlXLCyEXMcOzGVX1FFyAzERsKajr3+n+smChMspKnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m737CHbG; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m737CHbG"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e535d16180so2628884a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 03 Mar 2025 16:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741047420; x=1741652220; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jMKIyNsG0NtyjtxG4pWMI2QT+uTV771bs3P2Kh65/aI=;
        b=m737CHbGCeHrSGZKySkEASP0KI3c9eD5Cy6O+VYkk3Yh7T17+aZs+1lAE1CYFEzwve
         EoPfGJcZ4c2QvMfCrx27kW0m+g0AW5+p699s+u2+ZlGgJGFCUXCAaiOllGpqAcDkVJ8B
         5iljnx9EdBN1UbS93m7KkTvAfYyXvE4+Vqn/E6ccHA515gwnHDJ3gxMZw0UUloHl25zR
         TpO02zXvR8Yk4KhDnLCSJpEFuGZLnZibrcmJbBAa/T/jQTYMBvLeKee7/K1bDVOOl4ve
         9pb3J5S25XjFcLMoJS3r8UFUswD9kGccJEfHrcvXuJM22XiUl0mu59Ax6FohcoOL9PbL
         dljQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741047420; x=1741652220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jMKIyNsG0NtyjtxG4pWMI2QT+uTV771bs3P2Kh65/aI=;
        b=o/3pn4tassjyFrzEdMNkf7otxENb34ppT0JxeQPy4ys3suaDSEJ3retJQBZlwZbwQi
         HFBdoZRRTsLWjvX2gfSY5Zwwua3xCmidrEZ4KSnXCIsNG+8QDJU2fyR6j4svoPbewVOq
         6nopFPTLUbb5TYoRuDJVQ063jtpVz2XJhmPO85a5ycljtbQu9WnQhtosfSbtFnyds+pp
         BTtAq9L0g/80MUtYWO2/UMKiMYqzOtEriW8MrX6+Ej8TcRPaZgmb1H+wCTeeHm6zJbSe
         vh+RXdso+w1LP86U73Tk1YrUxDQ+ivM5AO6uaOE/pEZqs/jaDuiRk/VPIPKmL6b5WSpP
         wd8w==
X-Forwarded-Encrypted: i=1; AJvYcCWrJzuie6s5N3CVcnmP4lDWhXQ/5HprXiLc4N08qSJewUU9XA+oJwqxx6X7cLuHIjsgrIhGqjjfMrnWBIk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7Wmd012uVAtJVrHxtLKo4YicBRzz2yozQ8fCJJ+RCoebsFdst
	lC6dpYOC/w/oM+wmlLPyFKyLy+ZunCwTDn+GdDD/LT515S3UokHCoJ4LDK8SHRkqcw3vidaLpyb
	T82fbn+cPPgDaGzMapyFMiMvDQDSSTmUC2No=
X-Gm-Gg: ASbGncsIRsTdtLGr/gCHhb9vk0ENz5agUcuI/4523fFX+hwaYRZ7VowhRlPMDU2AiLc
	3g30CaY89P3mqbNaBFrYJSm3dYZ6kOXmJphqGEVIHhwrQbzILdPaKL43R077y0ALnPNNfyaF4nU
	pvWuQjfSQKD5Me9JsFiuZF9IE=
X-Google-Smtp-Source: AGHT+IExrkPe2uEtMergGwL+KBk495Fd4lod8M4gAWfLy3ShXLjKMJZ8PsT9Bi/Phnh7dpEn1JARrX6tpxQCmjgQieg=
X-Received: by 2002:a05:6402:51d4:b0:5dc:a44e:7644 with SMTP id
 4fb4d7f45d1cf-5e4d6ac58e5mr35957412a12.2.1741047419844; Mon, 03 Mar 2025
 16:16:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com>
 <CAGG=3QVkd9Vb9a=pQ=KwhKzGJXaS+6Mk5K+JtBqamj15MzT9mQ@mail.gmail.com>
 <20250303201509.32f6f062@pumpkin> <CAGG=3QV1iDn2r39v5eroO+kCvpbmJNtSeqJS+fpwb4vBG67z=w@mail.gmail.com>
 <20250303224216.30431b1d@pumpkin> <7BC89461-A060-462A-9B42-7C0138AA0307@zytor.com>
In-Reply-To: <7BC89461-A060-462A-9B42-7C0138AA0307@zytor.com>
From: Bill Wendling <morbo@google.com>
Date: Mon, 3 Mar 2025 16:16:43 -0800
X-Gm-Features: AQ5f1Jp1rCZue6IqDgtc6XQUmsfbb7iZovfig0pjAWT2AtVPQ_9tNDnWhAAaCuk
Message-ID: <CAGG=3QUnUQL2=YxN2ozwSba2A_x-S7sAEUP5oGhCWOzu4Q9SQA@mail.gmail.com>
Subject: Re: [PATCH v2] x86/crc32: use builtins to improve code generation
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Laight <david.laight.linux@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Justin Stitt <justinstitt@google.com>, LKML <linux-kernel@vger.kernel.org>, 
	linux-crypto@vger.kernel.org, clang-built-linux <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 3:58=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wrote=
:
> On March 3, 2025 2:42:16 PM PST, David Laight <david.laight.linux@gmail.c=
om> wrote:
> >On Mon, 3 Mar 2025 12:27:21 -0800
> >Bill Wendling <morbo@google.com> wrote:
> >
> >> On Mon, Mar 3, 2025 at 12:15=E2=80=AFPM David Laight
> >> <david.laight.linux@gmail.com> wrote:
> >> > On Thu, 27 Feb 2025 15:47:03 -0800
> >> > Bill Wendling <morbo@google.com> wrote:
> >> >
> >> > > For both gcc and clang, crc32 builtins generate better code than t=
he
> >> > > inline asm. GCC improves, removing unneeded "mov" instructions. Cl=
ang
> >> > > does the same and unrolls the loops. GCC has no changes on i386, b=
ut
> >> > > Clang's code generation is vastly improved, due to Clang's "rm"
> >> > > constraint issue.
> >> > >
> >> > > The number of cycles improved by ~0.1% for GCC and ~1% for Clang, =
which
> >> > > is expected because of the "rm" issue. However, Clang's performanc=
e is
> >> > > better than GCC's by ~1.5%, most likely due to loop unrolling.
> >> >
> >> > How much does it unroll?
> >> > How much you need depends on the latency of the crc32 instruction.
> >> > The copy of Agner's tables I have gives it a latency of 3 on
> >> > pretty much everything.
> >> > If you can only do one chained crc instruction every three clocks
> >> > it is hard to see how unrolling the loop will help.
> >> > Intel cpu (since sandy bridge) will run a two clock loop.
> >> > With three clocks to play with it should be easy (even for a compile=
r)
> >> > to generate a loop with no extra clock stalls.
> >> >
> >> > Clearly if Clang decides to copy arguments to the stack an extra tim=
e
> >> > that will kill things. But in this case you want the "m" constraint
> >> > to directly read from the buffer (with a (reg,reg,8) addressing mode=
).
> >> >
> >> Below is what Clang generates with the builtins. From what Eric said,
> >> this code is only run for sizes <=3D 512 bytes? So maybe it's not supe=
r
> >> important to micro-optimize this. I apologize, but my ability to
> >> measure clock loops for x86 code isn't great. (I'm sure I lack the
> >> requisite benchmarks, etc.)
> >
> >Jeepers - that is trashing the I-cache.
> >Not to mention all the conditional branches at the bottom.
> >Consider the basic loop:
> >1:     crc32q  (%rcx), %rbx
> >       addq    $8, %rcx
> >       cmp     %rcx, %rdx
> >       jne     1b
> >The crc32 has latency 3 so it must take at least 3 clocks.
> >Even naively the addq can be issued in the same clock as the crc32
> >and the cmp and jne in the following ones.
> >Since the jne is predicted taken, the addq can be assumed to execute
> >in the same clock as the jne.
> >(The cmp+jne might also get merged into a single u-op)
> >(I've done this with adc (for IP checksum), with two adc the loop takes
> >two clocks even with the extra memory reads.)
> >
> >So that loop is likely to run limited by the three clock latency of crc3=
2.
> >Even the memory reads will happen with all the crc32 just waiting for th=
e
> >previous crc32 to finish.
> >You can take an instruction out of the loop:
> >1:     crc32q  (%rcx,%rdx), %rbx
> >       addq    $8, %rdx
> >       jne     1b
> >but that may not be necessary, and (IIRC) gcc doesn't like letting you
> >generate it.
> >
> >For buffers that aren't multiples of 8 bytes 'remember' that the crc of
> >a byte depends on how far it is from the end of the buffer, and that ini=
tial
> >zero bytes have no effect.
> >So (provided the buffer is 8+ bytes long) read the first 8 bytes, shift
> >right by the number of bytes needed to make the rest of the buffer a mul=
tiple
> >or 8 bytes (the same as reading from across the start of the buffer and =
masking
> >the low bytes) then treat exactly the same as a buffer that is a multipl=
e
> >of 8 bytes long.
> >Don't worry about misaligned reads, you lose less than one clock per cac=
he
> >line (that is with adc doing a read every clock).
> >
For reference, GCC does much better with code gen, but only with the builti=
n:

.L39:
        crc32q  (%rax), %rbx    # MEM[(long unsigned int *)p_40], tmp120
        addq    $8, %rax        #, p
        cmpq    %rcx, %rax      # _37, p
        jne     .L39    #,
        leaq    (%rsi,%rdi,8), %rsi     #, p
.L38:
        andl    $7, %edx        #, len
        je      .L41    #,
        addq    %rsi, %rdx      # p, _11
        movl    %ebx, %eax      # crc, <retval>
        .p2align 4
.L40:
        crc32b  (%rsi), %eax    # MEM[(const u8 *)p_45], <retval>
        addq    $1, %rsi        #, p
        cmpq    %rsi, %rdx      # p, _11
        jne     .L40    #,

> >Actually measuring the performance is hard.
> >You can use rdtsc because the clock speed will change when the cpu gets =
busy.
> >There is a 'performance counter' that is actual clocks.
> >While you can use the library functions to set it up, you need to just r=
ead the
> >register - the library overhead it too big.
> >You also need the odd lfence.
> >Having done that, and provided the buffer is in the L1 d-cache you can m=
easure
> >the loop time in clocks and compare against the expected value.
> >Once you've got 3 clocks per crc32 instruction it won't get any better,
> >which is why the 'fast' code for big buffers does crc of 3+ buffers sect=
ions
> >in parallel.
> >
Thanks for the info! It'll help a lot the next time I need to delve
deeply into performance.

I tried using rdtsc and another programmatic way of measuring timing.
Also tried making the task have high priority, restricting to one CPU,
etc. But the numbers weren't as consistent as I wanted them to be. The
times I reported were the based on the fastest times / clocks /
whatever from several runs for each build.

> >       David
> >
> >>
> >> -bw
> >>
> >> .LBB1_9:                                # =3D>This Inner Loop Header: =
Depth=3D1
> >>         movl    %ebx, %ebx
> >>         crc32q  (%rcx), %rbx
> >>         addq    $8, %rcx
> >>         incq    %rdi
> >>         cmpq    %rdi, %rsi
> >>         jne     .LBB1_9
> >> # %bb.10:
> >>         subq    %rdi, %rax
> >>         jmp     .LBB1_11
> >> .LBB1_7:
> >>         movq    %r14, %rcx
> >> .LBB1_11:
> >>         movq    %r15, %rsi
> >>         andq    $-8, %rsi
> >>         cmpq    $7, %rdx
> >>         jb      .LBB1_14
> >> # %bb.12:
> >>         xorl    %edx, %edx
> >> .LBB1_13:                               # =3D>This Inner Loop Header: =
Depth=3D1
> >>         movl    %ebx, %ebx
> >>         crc32q  (%rcx,%rdx,8), %rbx
> >>         crc32q  8(%rcx,%rdx,8), %rbx
> >>         crc32q  16(%rcx,%rdx,8), %rbx
> >>         crc32q  24(%rcx,%rdx,8), %rbx
> >>         crc32q  32(%rcx,%rdx,8), %rbx
> >>         crc32q  40(%rcx,%rdx,8), %rbx
> >>         crc32q  48(%rcx,%rdx,8), %rbx
> >>         crc32q  56(%rcx,%rdx,8), %rbx
> >>         addq    $8, %rdx
> >>         cmpq    %rdx, %rax
> >>         jne     .LBB1_13
> >> .LBB1_14:
> >>         addq    %rsi, %r14
> >> .LBB1_15:
> >>         andq    $7, %r15
> >>         je      .LBB1_23
> >> # %bb.16:
> >>         crc32b  (%r14), %ebx
> >>         cmpl    $1, %r15d
> >>         je      .LBB1_23
> >> # %bb.17:
> >>         crc32b  1(%r14), %ebx
> >>         cmpl    $2, %r15d
> >>         je      .LBB1_23
> >> # %bb.18:
> >>         crc32b  2(%r14), %ebx
> >>         cmpl    $3, %r15d
> >>         je      .LBB1_23
> >> # %bb.19:
> >>         crc32b  3(%r14), %ebx
> >>         cmpl    $4, %r15d
> >>         je      .LBB1_23
> >> # %bb.20:
> >>         crc32b  4(%r14), %ebx
> >>         cmpl    $5, %r15d
> >>         je      .LBB1_23
> >> # %bb.21:
> >>         crc32b  5(%r14), %ebx
> >>         cmpl    $6, %r15d
> >>         je      .LBB1_23
> >> # %bb.22:
> >>         crc32b  6(%r14), %ebx
> >> .LBB1_23:
> >>         movl    %ebx, %eax
> >> .LBB1_24:
> >
> >
>
> The tail is *weird*. Wouldn't it be better to do a 4-2-1 stepdown?

Definitely on the weird side! I considered hard-coding something like
that, but thought it might be a bit convoluted, though certainly less
convoluted than what we generate now. A simple loop is probably all
that's needed, because it should only need to be done at most seven
times.

-bw
