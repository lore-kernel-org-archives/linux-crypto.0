Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81705280A5A;
	Wed, 12 Nov 2025 21:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762981214; cv=none; b=em1LlZo2QxyKVtek/xlJyzkVurMsrVrvcs2wGcGdiH6LeepuT1MX/oEkiKvikVKA+8L3CuPqMyNipb1xfAPASekem1emDvUIEL0OCN+bQL6neRMJU4bWKr4vd26cfA+fxiVFyCSTV4jZYTp4WFipuzYUWM1oHaoO+cOaR2Z3D8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762981214; c=relaxed/simple;
	bh=y4Ld6BCnq7KX+vDSRVwSUYQvdimBcRrIcm5ooyZboEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ztot586rs/YeYgHpfY6L+xyCHw/iogxBy6IallQxdI/U5B65BwJnuuzIt6smwcmvLhwQYtVSCmLu33A6I5HtvpnOVi+m2KlITR0WuD4FoMvom9iR1TWXmhMuCMD5F0TPf68ftxTsymnUq2TUS/odj1u9Etk/SnlqjCAN1IIJ47U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s9KNBCdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s9KNBCdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07FAC4CEF7;
	Wed, 12 Nov 2025 21:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762981213;
	bh=y4Ld6BCnq7KX+vDSRVwSUYQvdimBcRrIcm5ooyZboEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s9KNBCdIQnX4NqogZP5t9fr/bVLmOpAcYpydtyT11eaAXfRe32MGmyfP5gaQnnRhR
	 o+9E5tSgi/SjmlpWTbxOuCyJKjMh8iu/ma+NnD2czJ9USvlo/1FIARwRNNJPQuEcRZ
	 /4g8rMzdFJRGYzgPaU+OzpK68OoVqpft4p5G3p4J7J83YxYi3026N9ncSGU6UY00KB
	 H5WQJ+8AuoptYS9SGk0WTrzT0LAq59zhNyFP5NdM0wliZ0bEPaYpsaVDwfj44z3cXW
	 tPzbx8wfs1tCxUPsWgd8wKiDDPIUMvO69WBRCmocsFTY2PUNsJhNs6nJeuQQ+/jcz4
	 LxJUKHmbuav0g==
Date: Wed, 12 Nov 2025 12:58:32 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>,
	Ard Biesheuvel <ardb+git@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH v4 08/21] lib/crc: Switch ARM and arm64 to 'ksimd' scoped
 guard API
Message-ID: <20251112205832.GC1760@sol>
References: <20251031103858.529530-23-ardb+git@google.com>
 <20251031103858.529530-31-ardb+git@google.com>
 <20251031134909.00006bf3@huawei.com>
 <CAMj1kXHMa_Vj3DsuoAR-rvWW12Bsnz10w+BAze6mtngqpABZPw@mail.gmail.com>
 <CAMj1kXH_YCuBT4CbidTcVDNz2qNvYK9afS+v9eNkNggB3gopBw@mail.gmail.com>
 <20251103112836.00006966@huawei.com>
 <CAMj1kXGog9bwqc=1qCv+Lh3giK081jf9h4AFCvQ=6Ls6N27LyA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGog9bwqc=1qCv+Lh3giK081jf9h4AFCvQ=6Ls6N27LyA@mail.gmail.com>

On Tue, Nov 04, 2025 at 04:32:28PM +0100, Ard Biesheuvel wrote:
> On Mon, 3 Nov 2025 at 12:28, Jonathan Cameron
> <jonathan.cameron@huawei.com> wrote:
> >
> > On Fri, 31 Oct 2025 15:05:19 +0100
> > Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > > On Fri, 31 Oct 2025 at 14:52, Ard Biesheuvel <ardb@kernel.org> wrote:
> > > >
> > > > On Fri, 31 Oct 2025 at 14:49, Jonathan Cameron
> > > > <jonathan.cameron@huawei.com> wrote:
> > > > >
> > > > > On Fri, 31 Oct 2025 11:39:07 +0100
> > > > > Ard Biesheuvel <ardb+git@google.com> wrote:
> > > > >
> > > > > > From: Ard Biesheuvel <ardb@kernel.org>
> > > > > >
> > > > > > Before modifying the prototypes of kernel_neon_begin() and
> > > > > > kernel_neon_end() to accommodate kernel mode FP/SIMD state buffers
> > > > > > allocated on the stack, move arm64 to the new 'ksimd' scoped guard API,
> > > > > > which encapsulates the calls to those functions.
> > > > > >
> > > > > > For symmetry, do the same for 32-bit ARM too.
> > > > > >
> > > > > > Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> > > > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > > > ---
> > > > > >  lib/crc/arm/crc-t10dif.h   | 16 +++++-----------
> > > > > >  lib/crc/arm/crc32.h        | 11 ++++-------
> > > > > >  lib/crc/arm64/crc-t10dif.h | 16 +++++-----------
> > > > > >  lib/crc/arm64/crc32.h      | 16 ++++++----------
> > > > > >  4 files changed, 20 insertions(+), 39 deletions(-)
> > > > > >
> > > > > > diff --git a/lib/crc/arm/crc-t10dif.h b/lib/crc/arm/crc-t10dif.h
> > > > > > index 63441de5e3f1..aaeeab0defb5 100644
> > > > > > --- a/lib/crc/arm/crc-t10dif.h
> > > > > > +++ b/lib/crc/arm/crc-t10dif.h
> > > > >
> > > > > >  static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
> > > > > > @@ -20,21 +19,16 @@ asmlinkage void crc_t10dif_pmull8(u16 init_crc, const u8 *buf, size_t len,
> > > > > >  static inline u16 crc_t10dif_arch(u16 crc, const u8 *data, size_t length)
> > > > > >  {
> > > > > >       if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE) {
> > > > > > -             if (static_branch_likely(&have_pmull)) {
> > > > > > -                     if (likely(may_use_simd())) {
> > > > > > -                             kernel_neon_begin();
> > > > > > -                             crc = crc_t10dif_pmull64(crc, data, length);
> > > > > > -                             kernel_neon_end();
> > > > > > -                             return crc;
> > > > > > -                     }
> > > > > > +             if (static_branch_likely(&have_pmull) && likely(may_use_simd())) {
> > > > > > +                     scoped_ksimd()
> > > > > > +                             return crc_t10dif_pmull64(crc, data, length);
> > > > >
> > > > > >               } else if (length > CRC_T10DIF_PMULL_CHUNK_SIZE &&
> > > > > >                          static_branch_likely(&have_neon) &&
> > > > > >                          likely(may_use_simd())) {
> > > > >
> > > > > I briefly thought this was a functional change but it's not because
> > > > > of may_use_simd() being something that isn't going to change between
> > > > > the two evaluations.
> > > > >
> > > > > Would it hurt at all to pull that up to be
> > > > >         if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && likely(may_use_simd())) {
> > > > >                 if (static_branch_likely(&have_pmull)) {
> > > > >                         scoped_ksimd()
> > > > >                                 return crc_t10dif_pmull64(crc, data, length);
> > > > >
> > > > >                 } else if (length > CRC_T10DIF_PMULL_CHUNK_SIZE &&
> > > > >                            static_branch_likely(&have_neon)) {
> > > > >                 ...
> > > > >
> > > > > ?
> > > > >
> > > >
> > > > Yeah that would be a reasonable cleanup, I guess.
> > >
> > > Actually, looking more closely, that would result in may_use_simd()
> > > being evaluated even when the static keys are set to false, given that
> > > the compiler is unlikely to be able to figure out by itself that
> > > may_use_simd() has no side effects.
> > Yeah. That was why it was a question :)
> > Given everything is marked as likely I wasn't sure if we cared about when
> > the static keys aren't set.
> >
> 
> Yeah, it is rather doubtful that those annotations (or the use of
> static keys, for that matter) make a meaningful difference here.

Well, this change makes crc_t10dif_update() not usable during early boot
on arm64, as it will start hitting the
WARN_ON(!system_capabilities_finalized() in may_use_simd().

I doubt there are any current callers where that matters, but I've been
trying to avoid this sort of unnecessary pitfall in the CRC functions.

Checking the static key first eliminates this pitfall and is also more
efficient on CPUs that don't support the relevant CPU feature.

- Eric
