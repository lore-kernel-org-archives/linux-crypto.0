Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D70847C;
	Tue,  4 Mar 2025 00:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741049046; cv=none; b=un+8biQ0hVrEhtn1Y2dBHbybeXTzXCOlFgnDHUdIpavKVtHLKjEtZjho0th4onpbmL63ZCN6vTLSOOiN9Yq7w4fNrPhAwqLYpAF+9jZplgkW8HT49yMSk9j1uENfhXmF/3Ych8c931Jz8JmhMmNmm2HcMp/g8wBg1IlnYfqZI0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741049046; c=relaxed/simple;
	bh=xWRDIGEJAaSKJN5L6v+Gz8Kp0GE3AOC8Pmimy78MwWY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=QNkignFupASCfpbi5mkDtsWdsmXVUgqK/JILJrSsyvaemOEbkSKeAm3vE4WUBRHznymEZNYr1TdBOozOkWMN0O6JHWyA3E6UFl8TVAuX6KO1WbHkg6uKDlxzRjhJHmn80IpCTI+zAEqP82pzIxCEUvLYOWgX1nZvBSFrDSsjkJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=b4cihuk+; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="b4cihuk+"
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5240hUXv1830362
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 3 Mar 2025 16:43:30 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5240hUXv1830362
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025021701; t=1741049011;
	bh=OSryckLw96E62f0iZRN2OBpC8ktnL4UPuvxIYyXqeks=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=b4cihuk+D1XE7MW3dGc9AT4cwhrm/tIzlFws9HV4KGf2UcgI7nzMNOpyRud6Vg/20
	 IMT6Qh/xt3xgDT5tXTBF12LAqdGZqAXXDhR85BDaWhX2NvadNSsGNtk3FKps2rvNfi
	 inPJNAWItdgmU++oeoHZZ4ii5D3dqZhQZ3aFZaT0+Awn9IecuNc1qRdEu76ln/VmaH
	 1xlE54eyrQ036iCypwGvrc462lkdKYU2wdyFxDUQecEvc/tTVRxfHRvbmPXZnjdtTK
	 4/muF4i98pGw6Gp2VQJYQs0SBGS/q+n8mKVttCU6lYr/Pg4LZJeA+1ZB/F5Vjs/zkS
	 EZpFvBozoYAqQ==
Date: Mon, 03 Mar 2025 16:43:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Bill Wendling <morbo@google.com>
CC: David Laight <david.laight.linux@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Justin Stitt <justinstitt@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        clang-built-linux <llvm@lists.linux.dev>
Subject: Re: [PATCH v2] x86/crc32: use builtins to improve code generation
User-Agent: K-9 Mail for Android
In-Reply-To: <CAGG=3QUnUQL2=YxN2ozwSba2A_x-S7sAEUP5oGhCWOzu4Q9SQA@mail.gmail.com>
References: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com> <CAGG=3QVkd9Vb9a=pQ=KwhKzGJXaS+6Mk5K+JtBqamj15MzT9mQ@mail.gmail.com> <20250303201509.32f6f062@pumpkin> <CAGG=3QV1iDn2r39v5eroO+kCvpbmJNtSeqJS+fpwb4vBG67z=w@mail.gmail.com> <20250303224216.30431b1d@pumpkin> <7BC89461-A060-462A-9B42-7C0138AA0307@zytor.com> <CAGG=3QUnUQL2=YxN2ozwSba2A_x-S7sAEUP5oGhCWOzu4Q9SQA@mail.gmail.com>
Message-ID: <D989BBB5-8DA9-424B-A22D-CC4405747083@zytor.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On March 3, 2025 4:16:43 PM PST, Bill Wendling <morbo@google=2Ecom> wrote:
>On Mon, Mar 3, 2025 at 3:58=E2=80=AFPM H=2E Peter Anvin <hpa@zytor=2Ecom>=
 wrote:
>> On March 3, 2025 2:42:16 PM PST, David Laight <david=2Elaight=2Elinux@g=
mail=2Ecom> wrote:
>> >On Mon, 3 Mar 2025 12:27:21 -0800
>> >Bill Wendling <morbo@google=2Ecom> wrote:
>> >
>> >> On Mon, Mar 3, 2025 at 12:15=E2=80=AFPM David Laight
>> >> <david=2Elaight=2Elinux@gmail=2Ecom> wrote:
>> >> > On Thu, 27 Feb 2025 15:47:03 -0800
>> >> > Bill Wendling <morbo@google=2Ecom> wrote:
>> >> >
>> >> > > For both gcc and clang, crc32 builtins generate better code than=
 the
>> >> > > inline asm=2E GCC improves, removing unneeded "mov" instructions=
=2E Clang
>> >> > > does the same and unrolls the loops=2E GCC has no changes on i38=
6, but
>> >> > > Clang's code generation is vastly improved, due to Clang's "rm"
>> >> > > constraint issue=2E
>> >> > >
>> >> > > The number of cycles improved by ~0=2E1% for GCC and ~1% for Cla=
ng, which
>> >> > > is expected because of the "rm" issue=2E However, Clang's perfor=
mance is
>> >> > > better than GCC's by ~1=2E5%, most likely due to loop unrolling=
=2E
>> >> >
>> >> > How much does it unroll?
>> >> > How much you need depends on the latency of the crc32 instruction=
=2E
>> >> > The copy of Agner's tables I have gives it a latency of 3 on
>> >> > pretty much everything=2E
>> >> > If you can only do one chained crc instruction every three clocks
>> >> > it is hard to see how unrolling the loop will help=2E
>> >> > Intel cpu (since sandy bridge) will run a two clock loop=2E
>> >> > With three clocks to play with it should be easy (even for a compi=
ler)
>> >> > to generate a loop with no extra clock stalls=2E
>> >> >
>> >> > Clearly if Clang decides to copy arguments to the stack an extra t=
ime
>> >> > that will kill things=2E But in this case you want the "m" constra=
int
>> >> > to directly read from the buffer (with a (reg,reg,8) addressing mo=
de)=2E
>> >> >
>> >> Below is what Clang generates with the builtins=2E From what Eric sa=
id,
>> >> this code is only run for sizes <=3D 512 bytes? So maybe it's not su=
per
>> >> important to micro-optimize this=2E I apologize, but my ability to
>> >> measure clock loops for x86 code isn't great=2E (I'm sure I lack the
>> >> requisite benchmarks, etc=2E)
>> >
>> >Jeepers - that is trashing the I-cache=2E
>> >Not to mention all the conditional branches at the bottom=2E
>> >Consider the basic loop:
>> >1:     crc32q  (%rcx), %rbx
>> >       addq    $8, %rcx
>> >       cmp     %rcx, %rdx
>> >       jne     1b
>> >The crc32 has latency 3 so it must take at least 3 clocks=2E
>> >Even naively the addq can be issued in the same clock as the crc32
>> >and the cmp and jne in the following ones=2E
>> >Since the jne is predicted taken, the addq can be assumed to execute
>> >in the same clock as the jne=2E
>> >(The cmp+jne might also get merged into a single u-op)
>> >(I've done this with adc (for IP checksum), with two adc the loop take=
s
>> >two clocks even with the extra memory reads=2E)
>> >
>> >So that loop is likely to run limited by the three clock latency of cr=
c32=2E
>> >Even the memory reads will happen with all the crc32 just waiting for =
the
>> >previous crc32 to finish=2E
>> >You can take an instruction out of the loop:
>> >1:     crc32q  (%rcx,%rdx), %rbx
>> >       addq    $8, %rdx
>> >       jne     1b
>> >but that may not be necessary, and (IIRC) gcc doesn't like letting you
>> >generate it=2E
>> >
>> >For buffers that aren't multiples of 8 bytes 'remember' that the crc o=
f
>> >a byte depends on how far it is from the end of the buffer, and that i=
nitial
>> >zero bytes have no effect=2E
>> >So (provided the buffer is 8+ bytes long) read the first 8 bytes, shif=
t
>> >right by the number of bytes needed to make the rest of the buffer a m=
ultiple
>> >or 8 bytes (the same as reading from across the start of the buffer an=
d masking
>> >the low bytes) then treat exactly the same as a buffer that is a multi=
ple
>> >of 8 bytes long=2E
>> >Don't worry about misaligned reads, you lose less than one clock per c=
ache
>> >line (that is with adc doing a read every clock)=2E
>> >
>For reference, GCC does much better with code gen, but only with the buil=
tin:
>
>=2EL39:
>        crc32q  (%rax), %rbx    # MEM[(long unsigned int *)p_40], tmp120
>        addq    $8, %rax        #, p
>        cmpq    %rcx, %rax      # _37, p
>        jne     =2EL39    #,
>        leaq    (%rsi,%rdi,8), %rsi     #, p
>=2EL38:
>        andl    $7, %edx        #, len
>        je      =2EL41    #,
>        addq    %rsi, %rdx      # p, _11
>        movl    %ebx, %eax      # crc, <retval>
>        =2Ep2align 4
>=2EL40:
>        crc32b  (%rsi), %eax    # MEM[(const u8 *)p_45], <retval>
>        addq    $1, %rsi        #, p
>        cmpq    %rsi, %rdx      # p, _11
>        jne     =2EL40    #,
>
>> >Actually measuring the performance is hard=2E
>> >You can use rdtsc because the clock speed will change when the cpu get=
s busy=2E
>> >There is a 'performance counter' that is actual clocks=2E
>> >While you can use the library functions to set it up, you need to just=
 read the
>> >register - the library overhead it too big=2E
>> >You also need the odd lfence=2E
>> >Having done that, and provided the buffer is in the L1 d-cache you can=
 measure
>> >the loop time in clocks and compare against the expected value=2E
>> >Once you've got 3 clocks per crc32 instruction it won't get any better=
,
>> >which is why the 'fast' code for big buffers does crc of 3+ buffers se=
ctions
>> >in parallel=2E
>> >
>Thanks for the info! It'll help a lot the next time I need to delve
>deeply into performance=2E
>
>I tried using rdtsc and another programmatic way of measuring timing=2E
>Also tried making the task have high priority, restricting to one CPU,
>etc=2E But the numbers weren't as consistent as I wanted them to be=2E Th=
e
>times I reported were the based on the fastest times / clocks /
>whatever from several runs for each build=2E
>
>> >       David
>> >
>> >>
>> >> -bw
>> >>
>> >> =2ELBB1_9:                                # =3D>This Inner Loop Head=
er: Depth=3D1
>> >>         movl    %ebx, %ebx
>> >>         crc32q  (%rcx), %rbx
>> >>         addq    $8, %rcx
>> >>         incq    %rdi
>> >>         cmpq    %rdi, %rsi
>> >>         jne     =2ELBB1_9
>> >> # %bb=2E10:
>> >>         subq    %rdi, %rax
>> >>         jmp     =2ELBB1_11
>> >> =2ELBB1_7:
>> >>         movq    %r14, %rcx
>> >> =2ELBB1_11:
>> >>         movq    %r15, %rsi
>> >>         andq    $-8, %rsi
>> >>         cmpq    $7, %rdx
>> >>         jb      =2ELBB1_14
>> >> # %bb=2E12:
>> >>         xorl    %edx, %edx
>> >> =2ELBB1_13:                               # =3D>This Inner Loop Head=
er: Depth=3D1
>> >>         movl    %ebx, %ebx
>> >>         crc32q  (%rcx,%rdx,8), %rbx
>> >>         crc32q  8(%rcx,%rdx,8), %rbx
>> >>         crc32q  16(%rcx,%rdx,8), %rbx
>> >>         crc32q  24(%rcx,%rdx,8), %rbx
>> >>         crc32q  32(%rcx,%rdx,8), %rbx
>> >>         crc32q  40(%rcx,%rdx,8), %rbx
>> >>         crc32q  48(%rcx,%rdx,8), %rbx
>> >>         crc32q  56(%rcx,%rdx,8), %rbx
>> >>         addq    $8, %rdx
>> >>         cmpq    %rdx, %rax
>> >>         jne     =2ELBB1_13
>> >> =2ELBB1_14:
>> >>         addq    %rsi, %r14
>> >> =2ELBB1_15:
>> >>         andq    $7, %r15
>> >>         je      =2ELBB1_23
>> >> # %bb=2E16:
>> >>         crc32b  (%r14), %ebx
>> >>         cmpl    $1, %r15d
>> >>         je      =2ELBB1_23
>> >> # %bb=2E17:
>> >>         crc32b  1(%r14), %ebx
>> >>         cmpl    $2, %r15d
>> >>         je      =2ELBB1_23
>> >> # %bb=2E18:
>> >>         crc32b  2(%r14), %ebx
>> >>         cmpl    $3, %r15d
>> >>         je      =2ELBB1_23
>> >> # %bb=2E19:
>> >>         crc32b  3(%r14), %ebx
>> >>         cmpl    $4, %r15d
>> >>         je      =2ELBB1_23
>> >> # %bb=2E20:
>> >>         crc32b  4(%r14), %ebx
>> >>         cmpl    $5, %r15d
>> >>         je      =2ELBB1_23
>> >> # %bb=2E21:
>> >>         crc32b  5(%r14), %ebx
>> >>         cmpl    $6, %r15d
>> >>         je      =2ELBB1_23
>> >> # %bb=2E22:
>> >>         crc32b  6(%r14), %ebx
>> >> =2ELBB1_23:
>> >>         movl    %ebx, %eax
>> >> =2ELBB1_24:
>> >
>> >
>>
>> The tail is *weird*=2E Wouldn't it be better to do a 4-2-1 stepdown?
>
>Definitely on the weird side! I considered hard-coding something like
>that, but thought it might be a bit convoluted, though certainly less
>convoluted than what we generate now=2E A simple loop is probably all
>that's needed, because it should only need to be done at most seven
>times=2E
>
>-bw
>

4-2-1 makes more sense probably (4 bytes, then 2 bytes, then 1 byte depend=
ing on which bits are set=2E)
