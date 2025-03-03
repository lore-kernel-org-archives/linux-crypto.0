Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A55822E3F9;
	Mon,  3 Mar 2025 22:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741041742; cv=none; b=eEUtDFBeVFohGXMAniVcUs5iTfyPZq8LZm661grC7JAW6EFATJlWkjOL9ikgB6LoAqKYnWl7q7xDmh+TTDNTxQytKdnSSZYsU2orrexa2NoMGmVSmAdDlbEAOAWk7CqcmoIl/srD1KzYaC3uNhYwzk/7j7n8Angg8EK9pxVCNsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741041742; c=relaxed/simple;
	bh=3WcjziBYJ7UhydDwwC1yT484QDKIbhFIegMuTUZDvaY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NgwFewlFVIAMmfGeXcHYgtywl9vl1a8PLznN9HLSmzSxwIE4+PFoOchz61yhAUJQIoAig/7PunSqEWM0MJ2IYKbVDGvMtxUWxFZpYll2ZsQGtVNS0PS/LnNg/0VQ3PByUHqOV9GHBiEVg1nDG8LRDL6RnrIoCwncjbACfxmPRoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jIWKfU0W; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jIWKfU0W"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4398e3dfc66so45041125e9.0;
        Mon, 03 Mar 2025 14:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741041739; x=1741646539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IXvjaZuB8q7nUvxhvluaSegqkirhQmglnHumuP+7VuI=;
        b=jIWKfU0WQSKvKRbP8fMBTXSpDS5CEcbXop3Ocf9j6muO89SpeGIJhzCqOHgaANvgLZ
         2SO6nKJgI/qLQM9oDd843FVPSQlA9GkHTBH3p8Fi4rLeY1Vq45RUf8XK7Qaz//dvd9LD
         tjGzv1aldh6Vvr4jO5vjJa/pwrodurHhOuoSVKUFPk4aInFVrsC+D3IwpVXbhxxPW6Kn
         F0s1pfZaREZlOeYUqZL5+6XeeUHrF6fYtjoxM/cpPtRKJt6lavk4LUV237Ob+Q2dlVd8
         IlHBFcW4Z32VUXVX33pk/L4cOvW2cq4hchr08Z7JT1IN63RwOkjPypUagLO7R/X44AeK
         g2lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741041739; x=1741646539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IXvjaZuB8q7nUvxhvluaSegqkirhQmglnHumuP+7VuI=;
        b=N2TYs+r/dxMb28OmYNJioQNFwX2fwFkWoEimM+tdQ2psZjh2vDy257dH1VBf0ufzA0
         bMVQTl+46FSrbY8mrFvyhchUCB9USog/k5SROV4PylYJ8Ie7rqXL2MKf9RgmJejXWKAm
         LRuMpuUhGCRcouFahFdkjCxEkYC5MvhTeloH8cj/o6hqVUfcdUjMq91AyrLAltF2jaOo
         qHUVg+PG8z+TUF8h2PsNFicCRRtdo+xrXRYzdFR7YC/0Qqn60UmaCwTudeCePM9nnQaf
         m5Yqdl9Lt1zcdKPZCC9eXVoWueujrnoVO5IDhqgKrwNfJWCmzLu9dhrB56FvJRgQp8n9
         Uv8g==
X-Forwarded-Encrypted: i=1; AJvYcCUrfR4EV95mA1iH7uh84jOQZtou1jeB6/WNWI3A2dhqTR+XF4prN7/RmwJPJL2PMkdGX0j/K6r1/e6x7PCw@vger.kernel.org, AJvYcCV2n8OTAeIQ/+HmqJxrnFLN51Vl/UXeR2+C0jn2RrdwUOLZlvWeUbEDjjyF6pDrMX1IPa+sY+Cqe9f9Hxw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0qfXyl0p3hYSMd3QR+jtppy0lwRETERV/FRM+lk90t6tAGRdy
	kfYG8EvR1REsT628BFqGRvkCtzoIdwbpdpP50VjoYUcQRCS1OdV2
X-Gm-Gg: ASbGncujA4uh5qYRsuWHNvEUa4qHG0dlMTYXsAX0OV5BnTDOq6owrbE3PQELfWdgdSt
	0/DB860wNci+QxIg+59JUenZrvpmhBfnLvaj/9+NCwsKShcUF78nKPOl91rPctmJF20L+YK2Bcj
	WGrgbFIrtEbUvAPTZk8UHaxRNgKKtn6TC073JD98MALSsYZYjiUDYqj0eYXSMo9W1vGJBS5haO8
	sdJDWw4s8AalrHWBEpLQ9BNYYtu3IVjCqJNDO/G2rb5yVJtlLxf03f0vAXBLsgDodc8FgxM48H7
	DAiQaRGeIQI4QPd6z1zFY598GE4PKVedeyYf8ptbtZ94KE98PfgM2fh41vHfVF11aU6jNZVyEUi
	wAjgvsaI=
X-Google-Smtp-Source: AGHT+IGz/4MMeNxI6FkfVAP1gBhWfV0TLINClFzpnGmKzbqTXvswWzt9UC98eYl7tiFXTNCznFca4g==
X-Received: by 2002:a05:600c:4f51:b0:439:95b9:91fc with SMTP id 5b1f17b1804b1-43ba83f922cmr125458295e9.12.1741041738353;
        Mon, 03 Mar 2025 14:42:18 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e479609asm15518627f8f.2.2025.03.03.14.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 14:42:17 -0800 (PST)
Date: Mon, 3 Mar 2025 22:42:16 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Bill Wendling <morbo@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H.
 Peter Anvin" <hpa@zytor.com>, Eric Biggers <ebiggers@kernel.org>, Ard
 Biesheuvel <ardb@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nick
 Desaulniers <nick.desaulniers+lkml@gmail.com>, Justin Stitt
 <justinstitt@google.com>, LKML <linux-kernel@vger.kernel.org>,
 linux-crypto@vger.kernel.org, clang-built-linux <llvm@lists.linux.dev>
Subject: Re: [PATCH v2] x86/crc32: use builtins to improve code generation
Message-ID: <20250303224216.30431b1d@pumpkin>
In-Reply-To: <CAGG=3QV1iDn2r39v5eroO+kCvpbmJNtSeqJS+fpwb4vBG67z=w@mail.gmail.com>
References: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com>
	<CAGG=3QVkd9Vb9a=pQ=KwhKzGJXaS+6Mk5K+JtBqamj15MzT9mQ@mail.gmail.com>
	<20250303201509.32f6f062@pumpkin>
	<CAGG=3QV1iDn2r39v5eroO+kCvpbmJNtSeqJS+fpwb4vBG67z=w@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Mar 2025 12:27:21 -0800
Bill Wendling <morbo@google.com> wrote:

> On Mon, Mar 3, 2025 at 12:15=E2=80=AFPM David Laight
> <david.laight.linux@gmail.com> wrote:
> > On Thu, 27 Feb 2025 15:47:03 -0800
> > Bill Wendling <morbo@google.com> wrote:
> > =20
> > > For both gcc and clang, crc32 builtins generate better code than the
> > > inline asm. GCC improves, removing unneeded "mov" instructions. Clang
> > > does the same and unrolls the loops. GCC has no changes on i386, but
> > > Clang's code generation is vastly improved, due to Clang's "rm"
> > > constraint issue.
> > >
> > > The number of cycles improved by ~0.1% for GCC and ~1% for Clang, whi=
ch
> > > is expected because of the "rm" issue. However, Clang's performance is
> > > better than GCC's by ~1.5%, most likely due to loop unrolling. =20
> >
> > How much does it unroll?
> > How much you need depends on the latency of the crc32 instruction.
> > The copy of Agner's tables I have gives it a latency of 3 on
> > pretty much everything.
> > If you can only do one chained crc instruction every three clocks
> > it is hard to see how unrolling the loop will help.
> > Intel cpu (since sandy bridge) will run a two clock loop.
> > With three clocks to play with it should be easy (even for a compiler)
> > to generate a loop with no extra clock stalls.
> >
> > Clearly if Clang decides to copy arguments to the stack an extra time
> > that will kill things. But in this case you want the "m" constraint
> > to directly read from the buffer (with a (reg,reg,8) addressing mode).
> > =20
> Below is what Clang generates with the builtins. From what Eric said,
> this code is only run for sizes <=3D 512 bytes? So maybe it's not super
> important to micro-optimize this. I apologize, but my ability to
> measure clock loops for x86 code isn't great. (I'm sure I lack the
> requisite benchmarks, etc.)

Jeepers - that is trashing the I-cache.
Not to mention all the conditional branches at the bottom.
Consider the basic loop:
1:	crc32q	(%rcx), %rbx
	addq	$8, %rcx
	cmp	%rcx, %rdx
	jne	1b
The crc32 has latency 3 so it must take at least 3 clocks.
Even naively the addq can be issued in the same clock as the crc32
and the cmp and jne in the following ones.
Since the jne is predicted taken, the addq can be assumed to execute
in the same clock as the jne.
(The cmp+jne might also get merged into a single u-op)
(I've done this with adc (for IP checksum), with two adc the loop takes
two clocks even with the extra memory reads.)

So that loop is likely to run limited by the three clock latency of crc32.
Even the memory reads will happen with all the crc32 just waiting for the
previous crc32 to finish.
You can take an instruction out of the loop:
1:	crc32q	(%rcx,%rdx), %rbx
	addq	$8, %rdx
	jne	1b
but that may not be necessary, and (IIRC) gcc doesn't like letting you
generate it.

For buffers that aren't multiples of 8 bytes 'remember' that the crc of
a byte depends on how far it is from the end of the buffer, and that initial
zero bytes have no effect.
So (provided the buffer is 8+ bytes long) read the first 8 bytes, shift
right by the number of bytes needed to make the rest of the buffer a multip=
le
or 8 bytes (the same as reading from across the start of the buffer and mas=
king
the low bytes) then treat exactly the same as a buffer that is a multiple
of 8 bytes long.
Don't worry about misaligned reads, you lose less than one clock per cache
line (that is with adc doing a read every clock).

Actually measuring the performance is hard.
You can use rdtsc because the clock speed will change when the cpu gets bus=
y.
There is a 'performance counter' that is actual clocks.
While you can use the library functions to set it up, you need to just read=
 the
register - the library overhead it too big.
You also need the odd lfence.
Having done that, and provided the buffer is in the L1 d-cache you can meas=
ure
the loop time in clocks and compare against the expected value.
Once you've got 3 clocks per crc32 instruction it won't get any better,
which is why the 'fast' code for big buffers does crc of 3+ buffers sections
in parallel.

	David

>=20
> -bw
>=20
> .LBB1_9:                                # =3D>This Inner Loop Header: Dep=
th=3D1
>         movl    %ebx, %ebx
>         crc32q  (%rcx), %rbx
>         addq    $8, %rcx
>         incq    %rdi
>         cmpq    %rdi, %rsi
>         jne     .LBB1_9
> # %bb.10:
>         subq    %rdi, %rax
>         jmp     .LBB1_11
> .LBB1_7:
>         movq    %r14, %rcx
> .LBB1_11:
>         movq    %r15, %rsi
>         andq    $-8, %rsi
>         cmpq    $7, %rdx
>         jb      .LBB1_14
> # %bb.12:
>         xorl    %edx, %edx
> .LBB1_13:                               # =3D>This Inner Loop Header: Dep=
th=3D1
>         movl    %ebx, %ebx
>         crc32q  (%rcx,%rdx,8), %rbx
>         crc32q  8(%rcx,%rdx,8), %rbx
>         crc32q  16(%rcx,%rdx,8), %rbx
>         crc32q  24(%rcx,%rdx,8), %rbx
>         crc32q  32(%rcx,%rdx,8), %rbx
>         crc32q  40(%rcx,%rdx,8), %rbx
>         crc32q  48(%rcx,%rdx,8), %rbx
>         crc32q  56(%rcx,%rdx,8), %rbx
>         addq    $8, %rdx
>         cmpq    %rdx, %rax
>         jne     .LBB1_13
> .LBB1_14:
>         addq    %rsi, %r14
> .LBB1_15:
>         andq    $7, %r15
>         je      .LBB1_23
> # %bb.16:
>         crc32b  (%r14), %ebx
>         cmpl    $1, %r15d
>         je      .LBB1_23
> # %bb.17:
>         crc32b  1(%r14), %ebx
>         cmpl    $2, %r15d
>         je      .LBB1_23
> # %bb.18:
>         crc32b  2(%r14), %ebx
>         cmpl    $3, %r15d
>         je      .LBB1_23
> # %bb.19:
>         crc32b  3(%r14), %ebx
>         cmpl    $4, %r15d
>         je      .LBB1_23
> # %bb.20:
>         crc32b  4(%r14), %ebx
>         cmpl    $5, %r15d
>         je      .LBB1_23
> # %bb.21:
>         crc32b  5(%r14), %ebx
>         cmpl    $6, %r15d
>         je      .LBB1_23
> # %bb.22:
>         crc32b  6(%r14), %ebx
> .LBB1_23:
>         movl    %ebx, %eax
> .LBB1_24:

