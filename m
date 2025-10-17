Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51BA2BCF6A
	for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 08:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760690691; cv=none; b=H/smLnc1N2V8vIz5PL+2COFG8bRFkTkL7DRJFPLfh8oLorvM8xDHvksB6mRqi9scD9931AInuoXT1KXc1wRxZ2vK4lbNx/fuRUGDhgvNHzwEp3pG33S3qP9Xeo6RwEsLrgZzZnh3feISups8HYLfzQfTSkBk9d+TVfFDIE2EWy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760690691; c=relaxed/simple;
	bh=M3KqIVskwF3grHmlGKXoHw7sNTetWvhv39yaKZa9PgU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MhwDwMqrsdLsMOKgZtONjZ/sqlJZPJrXQ22lE6O0lqxnzCATnnBQElvN6AVSzI6Fl+D0A7d/ISIHcqIpDxLM76qtUW5Ih8UM0ngS+zNsFwAkD3PoeOathMHHYA+vum/Z9e+2sBJSlz38i8FEQRoAtSAaGyvHh2XCqkz1VlFG2u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HSvQGyYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HSvQGyYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E53DC4AF09
	for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 08:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760690691;
	bh=M3KqIVskwF3grHmlGKXoHw7sNTetWvhv39yaKZa9PgU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HSvQGyYShps59OsNWCUofFffWzSuaviV1nBEixs2Xpm+4/6Kv3xZos4tVee+NdaVy
	 0s8CBddZNOxP5JP9tv+NaJuDCOJR/7r2DYQpDFRtg6HVjoXgy5oXzCRnw9bd3aHUSE
	 cgeqJRgWnJlgE/x77TpPJ4lnhHw4w6Qp9eOX3bIqvbFXF+qMsGLwEGKSQRyI0C3s1M
	 NqPs+yiZ9kRM3Q6bpAFMfjEKUd1DGm8peQY6MwOrc26S6hQigMYKnPBhHZiKKS9yky
	 +uTP+uWu94KVH11MQjK4ukz2RCb44PasAmG0fJjQEVzfeypUmTJL+X6/afmEgekpWt
	 87jA3dEkyo5KQ==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-57e03279bfeso1916486e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 01:44:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV6w9tpE0Yg9ROn2JiZtbOFru3IQiGAFHwKAxwrQHf77N3aO2DybX80jjXGB2omIMC+QfUiVpBfqBiXjN0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwT6Xc9ZFBWtyOpfqDlGi6Ivt4njEW7AhVJGaR1IP3fkxRYHBLI
	nmxSc+LUQIvAe660T1CymtWk3znQJI+MinLLTqo9MQxZtqRKCIYU1oBxK7s/TquRkgduFh/ayfK
	TGMrmVG+I/PehLyaigqHFdr8Kyx4xOZ8=
X-Google-Smtp-Source: AGHT+IG8m+8L4Gxn++Cn2QlcMckIaT6zBogPZazCDfExESimOjZMlCC5sWcVPJIIyV8q2DOeGIJDhBIsPWJJbi/mXEg=
X-Received: by 2002:a05:6512:224c:b0:591:c8b0:ee63 with SMTP id
 2adb3069b0e04-591d8384262mr1076101e87.2.1760690689957; Fri, 17 Oct 2025
 01:44:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014003123.GA2763@sol> <aPH9ZQP0m8Pq5Iy-@gondor.apana.org.au>
In-Reply-To: <aPH9ZQP0m8Pq5Iy-@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 17 Oct 2025 10:44:37 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGE6-xiUSyKa92=HWeywt=5-F2_G2H7V-UnVhKG65zwCA@mail.gmail.com>
X-Gm-Features: AS18NWCFgWRqDkr026prMo1PlVx4VvNYuzvuaDS2yBki6cEMxGz_HEvQCwa6Ozc
Message-ID: <CAMj1kXGE6-xiUSyKa92=HWeywt=5-F2_G2H7V-UnVhKG65zwCA@mail.gmail.com>
Subject: Re: [PATCH 0/8] VAES+AVX2 optimized implementation of AES-GCM
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, Jason@zx2c4.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 17 Oct 2025 at 10:25, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Eric Biggers <ebiggers@kernel.org> wrote:
> > On Wed, Oct 01, 2025 at 07:31:09PM -0700, Eric Biggers wrote:
> >> This patchset replaces the 256-bit vector implementation of AES-GCM for
> >> x86_64 with one that requires AVX2 rather than AVX512.  This greatly
> >> improves AES-GCM performance on CPUs that have VAES but not AVX512, for
> >> example by up to 74% on AMD Zen 3.  For more details, see patch 1.
> >>
> >> This patchset also renames the 512-bit vector implementation of AES-GCM
> >> for x86_64 to be named after AVX512 rather than AVX10/512, then adds
> >> some additional optimizations to it.
> >>
> >> This patchset applies to next-20250929 and is targeting 6.19.  Herbert,
> >> I'd prefer to just apply this myself.  But let me know if you'd prefer
> >> to take it instead (considering that AES-GCM hasn't been librarified
> >> yet).  Either way, there's no hurry, since this is targeting 6.19.
> >>
> >> Eric Biggers (8):
> >>   crypto: x86/aes-gcm - add VAES+AVX2 optimized code
> >>   crypto: x86/aes-gcm - remove VAES+AVX10/256 optimized code
> >>   crypto: x86/aes-gcm - rename avx10 and avx10_512 to avx512
> >>   crypto: x86/aes-gcm - clean up AVX512 code to assume 512-bit vectors
> >>   crypto: x86/aes-gcm - reorder AVX512 precompute and aad_update
> >>     functions
> >>   crypto: x86/aes-gcm - revise some comments in AVX512 code
> >>   crypto: x86/aes-gcm - optimize AVX512 precomputation of H^2 from H^1
> >>   crypto: x86/aes-gcm - optimize long AAD processing with AVX512
> >>
> >>  arch/x86/crypto/Makefile                      |    5 +-
> >>  arch/x86/crypto/aes-gcm-aesni-x86_64.S        |   12 +-
> >>  arch/x86/crypto/aes-gcm-vaes-avx2.S           | 1150 +++++++++++++++++
> >>  ...m-avx10-x86_64.S => aes-gcm-vaes-avx512.S} |  722 +++++------
> >>  arch/x86/crypto/aesni-intel_glue.c            |  264 ++--
> >>  5 files changed, 1667 insertions(+), 486 deletions(-)
> >>  create mode 100644 arch/x86/crypto/aes-gcm-vaes-avx2.S
> >>  rename arch/x86/crypto/{aes-gcm-avx10-x86_64.S => aes-gcm-vaes-avx512.S} (69%)
> >>
> >> base-commit: 3b9b1f8df454caa453c7fb07689064edb2eda90a
> >
> > Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next
>
> Oops, I didn't see this email until it was too late.  Since the
> patches should be identical I don't think it matters.
>

You also failed to apply my acked-by/tested-by so perhaps you should
just drop the patches from your tree again.
