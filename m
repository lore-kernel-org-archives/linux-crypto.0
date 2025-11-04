Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF18257836
	for <linux-crypto@vger.kernel.org>; Tue,  4 Nov 2025 15:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762270361; cv=none; b=IL5+tryqNpCjcuY0IgUN7XEeu8cVzb2ONDuP2RG3u4BfSAlP0X7v6QlikrPDW3H0TlxDggfdcUkmzkrInHaRbt8RtW8spsDEvdUCI+5Ri+qVq64XeBfL53WLtcQXznPDjHQNqwLujjDLRBSv1uvn+hSLkV0No2Wot5nTuYlm+No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762270361; c=relaxed/simple;
	bh=8ucPxln4jCUuHFhw/d6Q11VjxjnmrQRrHkqL4b1Kkeg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y07eIA7iuyKB4xEKuX9gfJNm6pYwLhf2kgwua/Nmtshv17LpT3ZRTJYgoy6rR1ZMsyVhlSarlOUL7eUrkniIfac4UmH2os1HFAYyO/EFzRreArc2rM5MKdn4y4l2rTit9WbR5486yWBnyJWSS9svz4JuhfJ65mLfCA29exUNyrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e2EPE5c/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e2EPE5c/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EADC4CEF7
	for <linux-crypto@vger.kernel.org>; Tue,  4 Nov 2025 15:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762270361;
	bh=8ucPxln4jCUuHFhw/d6Q11VjxjnmrQRrHkqL4b1Kkeg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=e2EPE5c/iiYhzgcYCbz55pMXl2qSKkkMnUVtPulbwAO6u99+Shf3FP95kREg0IXhC
	 B4Wt9Sry1YTldXDY89BrRStt3l2ju/TJCul/a2Bhs2bDoJvKeT+kibcvhSw8fVBEVb
	 drQeiUd0D/EF4/5iOseSGP+kEvBwDuU5dvOB0efMFp5bGe+PT54w5yQrHQBmSC8ThL
	 jvFRlXZpd3lPx8vi5OU8mZAig6qvSw9JZ/i8BRIEvFS/9geR3yP0wvLo7P2Tk1wiYc
	 KC6o9dIYNWuRd7V1V8fLIovimPSfvz2QIoPFn2/0A8QQHHNAvpSJErxScY/Car2A5J
	 jegtfQx7Qvbwg==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-37775ed97daso64476611fa.0
        for <linux-crypto@vger.kernel.org>; Tue, 04 Nov 2025 07:32:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXqAYLodLr6kxP4VX7ee8YN17TKI0T88rRnKfjb9EweT/BambHjoiC3OBkJ1v+jmfjgAmV5Dk9J5D3nDw4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwihV1dLmwZAvI2chOFXihvyOgFNRCcSEOsQJnq88nr76cRK1fT
	6al793jlY/8cXzokQ2IKyckRnkBSUO1ZgaJPM6gaqTgJi8EbLqEdZ5h6fn7IO4NQqcn44aND6Vh
	TVoSQmE1r7Acg1tSN8HD4nK7w2wNgQvE=
X-Google-Smtp-Source: AGHT+IH+CVhvcHFEROY6DI4fTTA1A0rVOvk6V2lH0Qy3bvx0oWjtx6rv8LHLiMplqLO8Ccc4rIiO5m5I7sknLNpZ/eA=
X-Received: by 2002:a2e:a554:0:b0:372:91d2:f659 with SMTP id
 38308e7fff4ca-37a4e6f08demr36141fa.3.1762270359952; Tue, 04 Nov 2025 07:32:39
 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com> <20251031103858.529530-31-ardb+git@google.com>
 <20251031134909.00006bf3@huawei.com> <CAMj1kXHMa_Vj3DsuoAR-rvWW12Bsnz10w+BAze6mtngqpABZPw@mail.gmail.com>
 <CAMj1kXH_YCuBT4CbidTcVDNz2qNvYK9afS+v9eNkNggB3gopBw@mail.gmail.com> <20251103112836.00006966@huawei.com>
In-Reply-To: <20251103112836.00006966@huawei.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 4 Nov 2025 16:32:28 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGog9bwqc=1qCv+Lh3giK081jf9h4AFCvQ=6Ls6N27LyA@mail.gmail.com>
X-Gm-Features: AWmQ_bmFX2z95LFUqFBLXa1zysHI_LqNQuskPyUwu9Z4a7PNLTWxdw_qHd8vC_4
Message-ID: <CAMj1kXGog9bwqc=1qCv+Lh3giK081jf9h4AFCvQ=6Ls6N27LyA@mail.gmail.com>
Subject: Re: [PATCH v4 08/21] lib/crc: Switch ARM and arm64 to 'ksimd' scoped
 guard API
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 3 Nov 2025 at 12:28, Jonathan Cameron
<jonathan.cameron@huawei.com> wrote:
>
> On Fri, 31 Oct 2025 15:05:19 +0100
> Ard Biesheuvel <ardb@kernel.org> wrote:
>
> > On Fri, 31 Oct 2025 at 14:52, Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > On Fri, 31 Oct 2025 at 14:49, Jonathan Cameron
> > > <jonathan.cameron@huawei.com> wrote:
> > > >
> > > > On Fri, 31 Oct 2025 11:39:07 +0100
> > > > Ard Biesheuvel <ardb+git@google.com> wrote:
> > > >
> > > > > From: Ard Biesheuvel <ardb@kernel.org>
> > > > >
> > > > > Before modifying the prototypes of kernel_neon_begin() and
> > > > > kernel_neon_end() to accommodate kernel mode FP/SIMD state buffers
> > > > > allocated on the stack, move arm64 to the new 'ksimd' scoped guard API,
> > > > > which encapsulates the calls to those functions.
> > > > >
> > > > > For symmetry, do the same for 32-bit ARM too.
> > > > >
> > > > > Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> > > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > > ---
> > > > >  lib/crc/arm/crc-t10dif.h   | 16 +++++-----------
> > > > >  lib/crc/arm/crc32.h        | 11 ++++-------
> > > > >  lib/crc/arm64/crc-t10dif.h | 16 +++++-----------
> > > > >  lib/crc/arm64/crc32.h      | 16 ++++++----------
> > > > >  4 files changed, 20 insertions(+), 39 deletions(-)
> > > > >
> > > > > diff --git a/lib/crc/arm/crc-t10dif.h b/lib/crc/arm/crc-t10dif.h
> > > > > index 63441de5e3f1..aaeeab0defb5 100644
> > > > > --- a/lib/crc/arm/crc-t10dif.h
> > > > > +++ b/lib/crc/arm/crc-t10dif.h
> > > >
> > > > >  static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
> > > > > @@ -20,21 +19,16 @@ asmlinkage void crc_t10dif_pmull8(u16 init_crc, const u8 *buf, size_t len,
> > > > >  static inline u16 crc_t10dif_arch(u16 crc, const u8 *data, size_t length)
> > > > >  {
> > > > >       if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE) {
> > > > > -             if (static_branch_likely(&have_pmull)) {
> > > > > -                     if (likely(may_use_simd())) {
> > > > > -                             kernel_neon_begin();
> > > > > -                             crc = crc_t10dif_pmull64(crc, data, length);
> > > > > -                             kernel_neon_end();
> > > > > -                             return crc;
> > > > > -                     }
> > > > > +             if (static_branch_likely(&have_pmull) && likely(may_use_simd())) {
> > > > > +                     scoped_ksimd()
> > > > > +                             return crc_t10dif_pmull64(crc, data, length);
> > > >
> > > > >               } else if (length > CRC_T10DIF_PMULL_CHUNK_SIZE &&
> > > > >                          static_branch_likely(&have_neon) &&
> > > > >                          likely(may_use_simd())) {
> > > >
> > > > I briefly thought this was a functional change but it's not because
> > > > of may_use_simd() being something that isn't going to change between
> > > > the two evaluations.
> > > >
> > > > Would it hurt at all to pull that up to be
> > > >         if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && likely(may_use_simd())) {
> > > >                 if (static_branch_likely(&have_pmull)) {
> > > >                         scoped_ksimd()
> > > >                                 return crc_t10dif_pmull64(crc, data, length);
> > > >
> > > >                 } else if (length > CRC_T10DIF_PMULL_CHUNK_SIZE &&
> > > >                            static_branch_likely(&have_neon)) {
> > > >                 ...
> > > >
> > > > ?
> > > >
> > >
> > > Yeah that would be a reasonable cleanup, I guess.
> >
> > Actually, looking more closely, that would result in may_use_simd()
> > being evaluated even when the static keys are set to false, given that
> > the compiler is unlikely to be able to figure out by itself that
> > may_use_simd() has no side effects.
> Yeah. That was why it was a question :)
> Given everything is marked as likely I wasn't sure if we cared about when
> the static keys aren't set.
>

Yeah, it is rather doubtful that those annotations (or the use of
static keys, for that matter) make a meaningful difference here.
