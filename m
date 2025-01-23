Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105B01C3C0A;
	Thu, 23 Jan 2025 08:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737620412; cv=none; b=ZMf2eo4BWAXbK9RySrHmHYRqW6+HTiZruW3QqImms/b85hHQ0fOnWFC7KZqLAe3fSFZ/iP6aYWqRC5QfPZc9US7cy0UrHJ6hCiStjdsOpQS6qxiE2m5JtYB6C6H4BM31sj+qyMrAYlYhoqGhj2uiQ6El4FaHhBjqYuOKuCr9fks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737620412; c=relaxed/simple;
	bh=FzmjOqJWmFDGHHPt5IKJ5j9R8KEq60Qw3ENw4DMpZDA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dAXpH9HLdibQ0ORvjYBRybmyw1aS9m9dT4o+V0S/Xorm2lUida+98Hl++We6qSe+q07lO7OZWAr4fWZgcNKzY7ExtHpfXFuaHfZ+m8Hc44t/9b0j/yIpe2kBFqj4AKYt+8IAItD+oRlXv1MmjXAnqwArLT47j4uxDj0xQV154E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-85c4557fce0so135778241.3;
        Thu, 23 Jan 2025 00:20:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737620406; x=1738225206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jSUoP0e7+g0LOR1t5wHYu3Yx1JDrfkcDqUBETzP0cZs=;
        b=IOmhvwBS0Pn3ZGLr8gdOtKzFpFttg3UZLKXWdvERmdsnKWvBcSs8WqjKVVBDqXdMgt
         w2ebstzqCLkxOg0mxHBytV5m6oRYld2YxBNIo/+/W489722t4wLE7HYujGzsH86Ltcxf
         GF97EuyxxhpKXF64ovVkMh+gDBsZksXHicIXkyLlfHAusKnCCoQPOzgs3tUwv36F5ujE
         irx7YVdTm/OTlyinQFu1E37O5pzEuXl+/my8ftytUqqLeC/J22tBFjmIUpXOoQA1WXWZ
         s1fdrifgAG2CtHupMQoIXH5yh9nHItb7Xn9+kD76HlsIEBjE6bp7pE1Lh2IEjgvRSxYo
         MUwg==
X-Forwarded-Encrypted: i=1; AJvYcCV9zZsUt6stSDycmnMy5lECj8qoLTFUWpG7utenw5Jjh4pTz1F7Jhfot9OIsa2XYqb+G9aa5BeFki84npw=@vger.kernel.org, AJvYcCW5VSv7KsHRbm4PWFEL+kd+iunGs7vISMEcaZJwQgNyRvmD50YnEZaxMlnkGaefL3bS8+nrFcc6Gl0rsQEs@vger.kernel.org
X-Gm-Message-State: AOJu0Yzcl0d1SqYMbdpVIrPNzixsAJF5LK0SDkCXpO5PwfD5S6aSdqj+
	FGnK5A1/pbQsu2YSO2L3M7KjcV4q0gOQRxjqHx4+/0JOR1IEV6DG5CEL+D45
X-Gm-Gg: ASbGncsmM7z5HUf1jNEATW67d5vEcmRwI6mS+bPsGW0ecDwADam3Pk0Phs7Cc+XrYCk
	nTdsEjJ/4OKQ3xTT9kVcRBEpBh3YiJEpbOn3bTYf8SWwShfLIrwn9uPP//PKJ6Loy/smO1Dwopu
	5ghvJYwT4AF7S0t2XD9L8oIhIfswY7xKSpIuBaDqvDE+0D4ORBECtTikWOAfgrFL3iyozpBLPkr
	l3EoQT7zpi5e4How+J19eQgs1aJIV2roc6JqSDnfQXAsI/+hggsY+d3MYu+Ov+IkxcgyOVuoCg1
	p6gBpyTrZemQs2YpaP3R+RSxGCmI61VPtNFCHDV4X1U=
X-Google-Smtp-Source: AGHT+IGs856DaTb2Ms3N4tIlRX6croZLMiZ2d2EL2HAF7RmUK8pHfSyqhAxJ705OM0q9t/bCRyylXw==
X-Received: by 2002:a05:6102:5129:b0:4b2:5c0a:9aff with SMTP id ada2fe7eead31-4b690bb53c0mr21502566137.3.1737620405966;
        Thu, 23 Jan 2025 00:20:05 -0800 (PST)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com. [209.85.217.41])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-4b68a20b58dsm3018556137.11.2025.01.23.00.20.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 00:20:05 -0800 (PST)
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-4afdf096fc5so144195137.2;
        Thu, 23 Jan 2025 00:20:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWY/++B+0eiJOELISgb5nn89VltW1RlR1PRPopYI9RgewfVgJWvYCRDepIQybONO1wFun5QoS9OBgRJU18=@vger.kernel.org, AJvYcCWyr8I91Ei5UGc5aajAcCmGVgzeQALShZ5KTiL0we7CegvKpiTIUJ0Az1a5lOV7t8ApNiPAUYHHuEqdIgjZ@vger.kernel.org
X-Received: by 2002:a05:6102:5492:b0:4af:adb2:5133 with SMTP id
 ada2fe7eead31-4b690d16908mr20698259137.23.1737620405048; Thu, 23 Jan 2025
 00:20:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250119225118.GA15398@sol.localdomain> <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
 <20250123051633.GA183612@sol.localdomain> <CAMuHMdXM=iEOiJBZcaRAt1f_BtHBvpU=bg79DoAgUZ161WRz4Q@mail.gmail.com>
In-Reply-To: <CAMuHMdXM=iEOiJBZcaRAt1f_BtHBvpU=bg79DoAgUZ161WRz4Q@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 23 Jan 2025 09:19:53 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWieXCtW76PhWL8FWj5vyLOs01NiMKtBbLNLK=Lugbu1g@mail.gmail.com>
X-Gm-Features: AbW1kvZlXvg2XTTG-gqILrxoIwpgCTKSDdzZu13TyjhwDM3dav56Na6ycxDk5Mo
Message-ID: <CAMuHMdWieXCtW76PhWL8FWj5vyLOs01NiMKtBbLNLK=Lugbu1g@mail.gmail.com>
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

On Thu, Jan 23, 2025 at 9:16=E2=80=AFAM Geert Uytterhoeven <geert@linux-m68=
k.org> wrote:
> On Thu, Jan 23, 2025 at 6:16=E2=80=AFAM Eric Biggers <ebiggers@kernel.org=
> wrote:
> > On Wed, Jan 22, 2025 at 08:13:07PM -0800, Linus Torvalds wrote:
> > > On Sun, 19 Jan 2025 at 14:51, Eric Biggers <ebiggers@kernel.org> wrot=
e:
> > > > - Reorganize the architecture-optimized CRC32 and CRC-T10DIF code t=
o be
> > > >   directly accessible via the library API, instead of requiring the
> > > >   crypto API.  This is much simpler and more efficient.
> > >
> > > I'm not a fan of the crazy crypto interfaces for simple hashes that
> > > only complicate and slow things down, so I'm all in favor of this and
> > > have pulled it.
> > >
> > > HOWEVER.
> > >
> > > I'm also very much not a fan of asking users pointless questions.
> > >
> > > What does this patch-set ask users idiotic questions like
> > >
> > >   CRC-T10DIF implementation
> > >   > 1. Architecture-optimized (CRC_T10DIF_IMPL_ARCH) (NEW)
> > >     2. Generic implementation (CRC_T10DIF_IMPL_GENERIC) (NEW)
> > >
> > > and
> > >
> > >   CRC32 implementation
> > >   > 1. Arch-optimized, with fallback to slice-by-8
> > > (CRC32_IMPL_ARCH_PLUS_SLICEBY8) (NEW)
> > >     2. Arch-optimized, with fallback to slice-by-1
> > > (CRC32_IMPL_ARCH_PLUS_SLICEBY1) (NEW)
> > >     3. Slice by 8 bytes (CRC32_IMPL_SLICEBY8) (NEW)
> > >     4. Slice by 4 bytes (CRC32_IMPL_SLICEBY4) (NEW)
> > >     5. Slice by 1 byte (Sarwate's algorithm) (CRC32_IMPL_SLICEBY1) (N=
EW)
> > >     6. Classic Algorithm (one bit at a time) (CRC32_IMPL_BIT) (NEW)
> > >
> > > because *nobody* wants to see that completely pointless noise.
> > >
> > > Pick the best one. Don't ask the user to pick the best one.
> > >
> > > If you have some really strong argument for why users need to be able
> > > to override the sane choice, make the question it at *least* depend o=
n
> > > EXPERT.
> > >
> > > And honestly, I don't see how there could possibly ever be any point.
> > > If there is an arch-optimized version, just use it.
> > >
> > > And if the "optimized" version is crap and worse than some generic
> > > one, it just needs to be removed.
> > >
> > > None of this "make the user make the choice because kernel developers
> > > can't deal with the responsibility of just saying what is best".
> >
> > Yes, I agree, and the kconfig options are already on my list of things =
to clean
> > up.  Thanks for giving your thoughts on how to do it.  To be clarify, t=
his
> > initial set of changes removed the existing arch-specific CRC32 and CRC=
-T10DIF
> > options (on x86 that was CRYPTO_CRC32C_INTEL, CRYPTO_CRC32_PCLMUL, and
> > CRYPTO_CRCT10DIF_PCLMUL) and added the equivalent functionality to two =
choices
> > in lib, one of which already existed.  So for now the changes to the op=
tions
> > were just meant to consolidate them, not add to or remove from them per=
 se.
> >
> > I do think that to support kernel size minimization efforts we should c=
ontinue
> > to allow omitting the arch-specific CRC code.  One of the CRC options, =
usually
> > CONFIG_CRC32, gets built into almost every kernel.  Some options alread=
y group
> > together multiple CRC variants (e.g. there are three different CRC32's)=
, and
> > each can need multiple implementations targeting different instruction =
set
> > extensions (e.g. both PCLMULQDQ and VPCLMULQDQ on x86).  So it does add=
 up.
> >
> > But it makes sense to make the code be included by default, and make th=
e choice
> > to omit it be conditional on CONFIG_EXPERT.
> >
> > I'm also thinking of just doing a single option that affects all enable=
d CRC
> > variants, e.g. CRC_OPTIMIZATIONS instead of both CRC32_OPTIMIZATIONS an=
d
> > CRC_T10DIF_OPTIMIZATIONS.  Let me know if you think that would be reaso=
nable.
> >
> > As you probably noticed, the other problem is that CRC32 has 4 generic
> > implementations: bit-by-bit, and slice by 1, 4, or 8 bytes.
> >
> > Bit-by-bit is useless.  Slice by 4 and slice by 8 are too similar to ha=
ve both.
> >
> > It's not straightforward to choose between slice by 1 and slice by 4/8,=
 though.
> > When benchmarking slice-by-n, a higher n will always be faster in
> > microbenchmarks (up to about n=3D16), but the required table size also =
increases
> > accordingly.  E.g., a slice-by-1 CRC32 uses a 1024-byte table, while sl=
ice-by-8
> > uses a 8192-byte table.  This table is accessed randomly, which is real=
ly bad on
> > the dcache, and can be really bad for performance in real world scenari=
os where
> > the system is bottlenecked on memory.
> >
> > I'm tentatively planning to just say that slice-by-4 is a good enough c=
ompromise
> > and have that be the only generic CRC32 implementation.
>
> So I guess I want slice-by-1 on m68k. Or
>
>     default CRC32_IMPL_SLICEBY1 if CONFIG_CC_OPTIMIZE_FOR_SIZE
>
> so I don't have to touch all defconfigs? ;-)
>
> BTW, shouldn't all existing defconfigs that enable
> CONFIG_CRC32_SLICEBY[48], CONFIG_CRC32_SARWATE, or CRC32_BIT be updated,
> as the logic has changed (these symbols are now enabled based on
> CRC32_IMPL*)?

Oh, I just realized m68k used CONFIG_CRC32_SLICEBY8=3Dy before, as that
was the default. So all these questions are not new, just churn because
of the changed logic?

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
