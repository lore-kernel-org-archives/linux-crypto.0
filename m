Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D282020B7E1;
	Thu, 23 Jan 2025 08:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737620199; cv=none; b=sbe6Swdy4JfoRnkrDZlmFswFym4ptrU8Wqu4jicdnRHhmYWBPuoIJjZ3ZQZKsniLojxWWp45pJ2KRIC2JgDb3bm5Wi4viPrs+xTr3xXqnOghIdGoVRHUx2lC/clqccCKPLqA2lKsxcRK0xQoy1svIIjnF6hO5m/x91Vc3N1bTaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737620199; c=relaxed/simple;
	bh=0dSxOoXneAIw9b/Rbf23DaScIK+SoWrBXKRsH3S+NX0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=opU/VUxua4xPLLaXYrLuASTmswI8kMrMRmEOagJeELB8PGojh9y90plNUaX3AFLVjFf8mWjcsB7sWtvDIIrmL9eYWzbAhmcLQ358vNc6UwdqvMYa/+UeS6z5mtTbyKQX3t9/d8UXgBh3y/l1kMcImajNW2ULvDdjHhv3evMlHys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-85c5adbca8eso162750241.0;
        Thu, 23 Jan 2025 00:16:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737620196; x=1738224996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IL8JdNbFwxa5Ar2ZXc5SPYsdaaVHbgLLSXVJV/lk+vA=;
        b=d7BDsSeWft9t0sFwlzrSz2SnpFQfh+5fqR43GoD8P6WtuknuIAKvE31nl9Djg3BwFV
         uygP7pTeQuPBhsMWsE8FDtTA6SyM9Pfepj4rmVE9XI7Uu6iZ1TMjcnjj8L1GX2DWpW7P
         JTEz91Dyc/0oBEPl/VsnEKuugnZByAIrCco1GVSSbY688gp4bkBIXR+uZr5aSklADQb5
         jxMo3QMkR9J+u0DixOc8RR6ILgI39kcb0vrR6AVcpVUx+KBRcLGJyPhu/tNTUYjyPTKb
         /vnkD9FE9s7OYLitu7vzpa6FOTZbjTijb+MzYJJ9vqev8sL9ipRTZse0NFx5KTxN0qLZ
         8Q7g==
X-Forwarded-Encrypted: i=1; AJvYcCUWllawgzSgjsbi8vOpUa/K2RNK7kEg8mHZH+n7NYq7rEbwY3LyjSKD6T5x68WxtR+ZF2e7p1bIRhPeV4I=@vger.kernel.org, AJvYcCXX2c53qvY7MmfzLrkJfSW3PWsQIRw+ASFv15/EQrwklCaSxl7hygx1r17JpCNDv0n0om0Mr+oVvhbNKDT+@vger.kernel.org
X-Gm-Message-State: AOJu0YxP9/Pvu6VHNGQ6L06ghF0EiY03UF0nD4oqxiW5yENEd8RmGlQ2
	YYbSOlnpu4yM9xQ7YrqLlPmsNo7LtzMuey+wOvNMqV0Ms6UGNkr1O2jJvi43
X-Gm-Gg: ASbGncvUvVS2CoHHBElwq7G5SO3HVDXSKrdt0l6xs9LAjXDEkF3iet0l8jWJ8gaZ9ZN
	iFTV6dn/aQPInV2EnwM1mc/iAYL2RkGpKOyFK1Iojt+RPcvpMpcpIC2Tp33yNoZJwY1W4a3Defi
	1GDyuL458qb877iAUVifPdUVg/0e6MtCyvGYai4yku6bwzTInZ/fI2dIf79QKgYzCh+RAHWpnR2
	L6AavDW5rxcmnCvk5hRYEHVEZAqyMwigg7nRVJZZqsSWOADvcYyL5ycrWYwOAMjQ4Gg0zoP7QH4
	0RlqECXWMzoncQLjCN+VJl7Ryngwc+8xHLva8d+96EyOH5H0oDa06A==
X-Google-Smtp-Source: AGHT+IH+IB/+K9hdMTNTu4yILs8BBJDoikvfoeDUMkezTJsh7d21HM5SUhYxIzM8eitry+fU7GV07Q==
X-Received: by 2002:a05:6102:2923:b0:4b1:3409:5dcd with SMTP id ada2fe7eead31-4b690cd0f26mr19981189137.20.1737620194245;
        Thu, 23 Jan 2025 00:16:34 -0800 (PST)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-8642cb09232sm3284205241.19.2025.01.23.00.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 00:16:33 -0800 (PST)
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-85c5adbca8eso162745241.0;
        Thu, 23 Jan 2025 00:16:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUeyzMJqXPxlBaOavKRBo001qaTfjKGPL6SbmDb5lkzzk8ndO+sgd3onLPsMs45zwpJcMY86CM6s+hbl2Ik@vger.kernel.org, AJvYcCX4690X8G1HLqA75oSfxvtcYdGivNeCmLVgMILA+EX4ANyCi0+NKbW9MmMXJb0BDunj8KNErDsG3q4Blt8=@vger.kernel.org
X-Received: by 2002:a05:6102:374d:b0:4b6:cf06:f892 with SMTP id
 ada2fe7eead31-4b6cf06fbccmr10613603137.1.1737620193435; Thu, 23 Jan 2025
 00:16:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250119225118.GA15398@sol.localdomain> <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
 <20250123051633.GA183612@sol.localdomain>
In-Reply-To: <20250123051633.GA183612@sol.localdomain>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 23 Jan 2025 09:16:21 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXM=iEOiJBZcaRAt1f_BtHBvpU=bg79DoAgUZ161WRz4Q@mail.gmail.com>
X-Gm-Features: AbW1kvZtlEAnDdackuE2VNI1XNXqnr8nGKHN34L0bYSQdpSyRjo_Pa2e6gGzBt0
Message-ID: <CAMuHMdXM=iEOiJBZcaRAt1f_BtHBvpU=bg79DoAgUZ161WRz4Q@mail.gmail.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Theodore Ts'o" <tytso@mit.edu>, Vinicius Peixoto <vpeixoto@lkcamp.dev>, WangYuli <wangyuli@uniontech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Thu, Jan 23, 2025 at 6:16=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
> On Wed, Jan 22, 2025 at 08:13:07PM -0800, Linus Torvalds wrote:
> > On Sun, 19 Jan 2025 at 14:51, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > - Reorganize the architecture-optimized CRC32 and CRC-T10DIF code to =
be
> > >   directly accessible via the library API, instead of requiring the
> > >   crypto API.  This is much simpler and more efficient.
> >
> > I'm not a fan of the crazy crypto interfaces for simple hashes that
> > only complicate and slow things down, so I'm all in favor of this and
> > have pulled it.
> >
> > HOWEVER.
> >
> > I'm also very much not a fan of asking users pointless questions.
> >
> > What does this patch-set ask users idiotic questions like
> >
> >   CRC-T10DIF implementation
> >   > 1. Architecture-optimized (CRC_T10DIF_IMPL_ARCH) (NEW)
> >     2. Generic implementation (CRC_T10DIF_IMPL_GENERIC) (NEW)
> >
> > and
> >
> >   CRC32 implementation
> >   > 1. Arch-optimized, with fallback to slice-by-8
> > (CRC32_IMPL_ARCH_PLUS_SLICEBY8) (NEW)
> >     2. Arch-optimized, with fallback to slice-by-1
> > (CRC32_IMPL_ARCH_PLUS_SLICEBY1) (NEW)
> >     3. Slice by 8 bytes (CRC32_IMPL_SLICEBY8) (NEW)
> >     4. Slice by 4 bytes (CRC32_IMPL_SLICEBY4) (NEW)
> >     5. Slice by 1 byte (Sarwate's algorithm) (CRC32_IMPL_SLICEBY1) (NEW=
)
> >     6. Classic Algorithm (one bit at a time) (CRC32_IMPL_BIT) (NEW)
> >
> > because *nobody* wants to see that completely pointless noise.
> >
> > Pick the best one. Don't ask the user to pick the best one.
> >
> > If you have some really strong argument for why users need to be able
> > to override the sane choice, make the question it at *least* depend on
> > EXPERT.
> >
> > And honestly, I don't see how there could possibly ever be any point.
> > If there is an arch-optimized version, just use it.
> >
> > And if the "optimized" version is crap and worse than some generic
> > one, it just needs to be removed.
> >
> > None of this "make the user make the choice because kernel developers
> > can't deal with the responsibility of just saying what is best".
>
> Yes, I agree, and the kconfig options are already on my list of things to=
 clean
> up.  Thanks for giving your thoughts on how to do it.  To be clarify, thi=
s
> initial set of changes removed the existing arch-specific CRC32 and CRC-T=
10DIF
> options (on x86 that was CRYPTO_CRC32C_INTEL, CRYPTO_CRC32_PCLMUL, and
> CRYPTO_CRCT10DIF_PCLMUL) and added the equivalent functionality to two ch=
oices
> in lib, one of which already existed.  So for now the changes to the opti=
ons
> were just meant to consolidate them, not add to or remove from them per s=
e.
>
> I do think that to support kernel size minimization efforts we should con=
tinue
> to allow omitting the arch-specific CRC code.  One of the CRC options, us=
ually
> CONFIG_CRC32, gets built into almost every kernel.  Some options already =
group
> together multiple CRC variants (e.g. there are three different CRC32's), =
and
> each can need multiple implementations targeting different instruction se=
t
> extensions (e.g. both PCLMULQDQ and VPCLMULQDQ on x86).  So it does add u=
p.
>
> But it makes sense to make the code be included by default, and make the =
choice
> to omit it be conditional on CONFIG_EXPERT.
>
> I'm also thinking of just doing a single option that affects all enabled =
CRC
> variants, e.g. CRC_OPTIMIZATIONS instead of both CRC32_OPTIMIZATIONS and
> CRC_T10DIF_OPTIMIZATIONS.  Let me know if you think that would be reasona=
ble.
>
> As you probably noticed, the other problem is that CRC32 has 4 generic
> implementations: bit-by-bit, and slice by 1, 4, or 8 bytes.
>
> Bit-by-bit is useless.  Slice by 4 and slice by 8 are too similar to have=
 both.
>
> It's not straightforward to choose between slice by 1 and slice by 4/8, t=
hough.
> When benchmarking slice-by-n, a higher n will always be faster in
> microbenchmarks (up to about n=3D16), but the required table size also in=
creases
> accordingly.  E.g., a slice-by-1 CRC32 uses a 1024-byte table, while slic=
e-by-8
> uses a 8192-byte table.  This table is accessed randomly, which is really=
 bad on
> the dcache, and can be really bad for performance in real world scenarios=
 where
> the system is bottlenecked on memory.
>
> I'm tentatively planning to just say that slice-by-4 is a good enough com=
promise
> and have that be the only generic CRC32 implementation.

So I guess I want slice-by-1 on m68k. Or

    default CRC32_IMPL_SLICEBY1 if CONFIG_CC_OPTIMIZE_FOR_SIZE

so I don't have to touch all defconfigs? ;-)

BTW, shouldn't all existing defconfigs that enable
CONFIG_CRC32_SLICEBY[48], CONFIG_CRC32_SARWATE, or CRC32_BIT be updated,
as the logic has changed (these symbols are now enabled based on
CRC32_IMPL*)?

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
