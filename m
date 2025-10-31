Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A033223DDA
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 13:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761918770; cv=none; b=CFIMOIZN7JJPow2NGwSlQLm/gq8kaZ7ShtU4AomlGgPTMc7bzZIYWn4rXV0nys9M3zMQB2p2/LcZSWDOohUy1pKe5aktgnoykmajk1mjhz6RUUersoCamHSxV4B9gp5RdZG6qu+R339fDwJ9sfUcwj2k13O5mIarQry+YSmotqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761918770; c=relaxed/simple;
	bh=OZOJGVFPVvgoICzb96sWJOAxC8zQUwZgmSqC+4PRa40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ew9fOJjwnKTUnSJBVE2FcrcZrg5z5fSwNrKr+zLd3iFmJJAaRGLKylQBa+qKtzn4SB1PA+xAnPSXvkLa+QwMUbZJiftKvwAyRef/SRg02X+XpTgBCfdqcFMm/XHEPwGdX3F4o5y1QNOyl1QGmEuF0XKAhI7RRhVK5RUkzkjqCAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ofeRqvX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ofeRqvX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60D5C4CEE7
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 13:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761918769;
	bh=OZOJGVFPVvgoICzb96sWJOAxC8zQUwZgmSqC+4PRa40=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ofeRqvX2L7Pn9ovcq2lQufq0kGpAqAZnOXo3GjIcfAWaclc6jOoG/Q0SnsnttZzOC
	 P+ahLVgGodiule3lfdJ3mBC1BNy3n62cqGnTGRmvuAC3KCwxsymgEql/pq6lxQjDg1
	 wX0yoySYtu/vY/dwi514HL/x+WDf7f3rOyd/CfeZ6D2TVAOSDCcVXR03hAz0jN7czB
	 luk4ImAlSi78rqa89syl6a9Tz5f3zsGX9lLiE2O4Coy1LElMj4bSGomz5zZbyh1WwE
	 hOW+hVO5g5CHecNA0GHm98HVumj1CD32DmSUqv0Eb+wXwbrIdoaoGnVGkkUUpV4zuu
	 btlfQgSNknlDw==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5930e30857bso3093977e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 06:52:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVUnYoDtlqEYMCPR5VxKJEIC8lJh3IFk4GFJUKpTryZerGSto5kZLM1ICDDTUYyyT0ZnQpwwHk6VK1p/WA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrQsDCvwImLYhu1FGoG53VHItvGhuhdX6yjTugRCVmzSzU/CUh
	PHSZeWoWvkbV8OHJU73ZZb4XzC60L3OpqknZMXLFdkwtcVC5f0+pKmCp9lByJ3X6k4MzulcIlli
	8LFrhDiyTZZGDgRSeVdRqjBLOP7CWoxs=
X-Google-Smtp-Source: AGHT+IGKmCnEm7EzivIgJyR5JKOYXoySZ6tvgvet9bi10ExWbl/TVPMYWyirNSz29x5TQUoCZJBcqca3iDbFf1g6fWQ=
X-Received: by 2002:a05:6512:224c:b0:592:ef1b:da72 with SMTP id
 2adb3069b0e04-5941d505da1mr1434407e87.14.1761918768160; Fri, 31 Oct 2025
 06:52:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com> <20251031103858.529530-31-ardb+git@google.com>
 <20251031134909.00006bf3@huawei.com>
In-Reply-To: <20251031134909.00006bf3@huawei.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 31 Oct 2025 14:52:36 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHMa_Vj3DsuoAR-rvWW12Bsnz10w+BAze6mtngqpABZPw@mail.gmail.com>
X-Gm-Features: AWmQ_bnUHTmFTpf6_wwhZYvTf56YiWzMFCCLq2ZM6tGMZqDdBbz5PGKileyFjes
Message-ID: <CAMj1kXHMa_Vj3DsuoAR-rvWW12Bsnz10w+BAze6mtngqpABZPw@mail.gmail.com>
Subject: Re: [PATCH v4 08/21] lib/crc: Switch ARM and arm64 to 'ksimd' scoped
 guard API
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 31 Oct 2025 at 14:49, Jonathan Cameron
<jonathan.cameron@huawei.com> wrote:
>
> On Fri, 31 Oct 2025 11:39:07 +0100
> Ard Biesheuvel <ardb+git@google.com> wrote:
>
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > Before modifying the prototypes of kernel_neon_begin() and
> > kernel_neon_end() to accommodate kernel mode FP/SIMD state buffers
> > allocated on the stack, move arm64 to the new 'ksimd' scoped guard API,
> > which encapsulates the calls to those functions.
> >
> > For symmetry, do the same for 32-bit ARM too.
> >
> > Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  lib/crc/arm/crc-t10dif.h   | 16 +++++-----------
> >  lib/crc/arm/crc32.h        | 11 ++++-------
> >  lib/crc/arm64/crc-t10dif.h | 16 +++++-----------
> >  lib/crc/arm64/crc32.h      | 16 ++++++----------
> >  4 files changed, 20 insertions(+), 39 deletions(-)
> >
> > diff --git a/lib/crc/arm/crc-t10dif.h b/lib/crc/arm/crc-t10dif.h
> > index 63441de5e3f1..aaeeab0defb5 100644
> > --- a/lib/crc/arm/crc-t10dif.h
> > +++ b/lib/crc/arm/crc-t10dif.h
>
> >  static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
> > @@ -20,21 +19,16 @@ asmlinkage void crc_t10dif_pmull8(u16 init_crc, const u8 *buf, size_t len,
> >  static inline u16 crc_t10dif_arch(u16 crc, const u8 *data, size_t length)
> >  {
> >       if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE) {
> > -             if (static_branch_likely(&have_pmull)) {
> > -                     if (likely(may_use_simd())) {
> > -                             kernel_neon_begin();
> > -                             crc = crc_t10dif_pmull64(crc, data, length);
> > -                             kernel_neon_end();
> > -                             return crc;
> > -                     }
> > +             if (static_branch_likely(&have_pmull) && likely(may_use_simd())) {
> > +                     scoped_ksimd()
> > +                             return crc_t10dif_pmull64(crc, data, length);
>
> >               } else if (length > CRC_T10DIF_PMULL_CHUNK_SIZE &&
> >                          static_branch_likely(&have_neon) &&
> >                          likely(may_use_simd())) {
>
> I briefly thought this was a functional change but it's not because
> of may_use_simd() being something that isn't going to change between
> the two evaluations.
>
> Would it hurt at all to pull that up to be
>         if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && likely(may_use_simd())) {
>                 if (static_branch_likely(&have_pmull)) {
>                         scoped_ksimd()
>                                 return crc_t10dif_pmull64(crc, data, length);
>
>                 } else if (length > CRC_T10DIF_PMULL_CHUNK_SIZE &&
>                            static_branch_likely(&have_neon)) {
>                 ...
>
> ?
>

Yeah that would be a reasonable cleanup, I guess.
