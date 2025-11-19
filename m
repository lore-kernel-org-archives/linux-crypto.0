Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AA730ACEA
	for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 19:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763579426; cv=none; b=PRVeUSpn8+EwTX5dSZNX0gToPq1GXatK1x++N4RWyjMxTAKom0fTZjjUq8/xZZJMm1fTcBBCYmpGLXzjEhm0EkQ1LeHALf7fXfhUuj6rVsTLq2klgJGv6s+YtL4O/+X+/ExvqocC1pWhUQ8wHGoBWNGhva9Uj1Six2Bv52H6THM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763579426; c=relaxed/simple;
	bh=r8AioyiEzgLoMj1rUwQD3nyimHbMiw6+wR+NJylFwi4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nj5gLxMlUt++5Nciwqa6FXvz5CqocYwlu+Yxv9QNT3gQJaaK9+7XhiB4X9JoUBeWw6icG86FzovNBgRfsPsiz45DE8glS2PvFl35LKrtNfXpBSI1WWDjviIIJFB7x0wsEpwNlm7w9mcnNR0/EfNTyYcGd25PkGvCGFoDxQwsYUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hiNn55wH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hiNn55wH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDD6C4AF09
	for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 19:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763579425;
	bh=r8AioyiEzgLoMj1rUwQD3nyimHbMiw6+wR+NJylFwi4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hiNn55wHO8VwP2/37jouPwz0p6Hd4BzHXDvx4UppVbw3eYekkJqrgRuMeqKhHZ1Zw
	 lTXdGfuVJc/nBbLjmBySMGvACwoLnU2aMXlYukzykrJ4vks0kxecuYUHDyWE4vNYGV
	 EDzvwpRWh5uRDKtNHkBUaQxAu5hGlD6hPz9lHvAqK3Ii1BvFVrj+H0jLhBhgEGD376
	 NJVf3M1JcPT89VfiNmHteQl5BV+WPDyZirv7Xme2UVp0kSTYEvTbSE9yDWk//oIx/n
	 FQnn7FcSx0w4g4X/XpBUB+W/FEoQ6N/D5rDYXxD7xirEmfdDDDDMHWhm7izu/aJLdC
	 158chclwMnkAw==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-595910c9178so4395e87.1
        for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 11:10:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUiAwdbh6mWgh/zUzSINDlJGjH85n5PSOKwK1LmIJ3pZPzsMheybX4ytn6svGPyrFbV7+RwpilFC/+ka/c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0y7tP0J9amKxc/cqTjW7HP2hJBbYuNByc5qIvSs5PDMkxpecU
	V06YXuxQLaqB6wv0akIxnGcOW8GoJsl32Y60PgVPVRnLLQojKRYmRPKQgJUXsO6ARJLZsomzU1E
	80Bl7TwVZ8cOsDu8xHzsG2/La27UgmcU=
X-Google-Smtp-Source: AGHT+IE0qvqcttMW0U586sYwjlkNWPppgfwBdUQBUPS1JPYzNRxY85RWaOft/PamwKm+nBHogM8oceyIEaulg9YwAkI=
X-Received: by 2002:a05:6512:e97:b0:595:8311:dc80 with SMTP id
 2adb3069b0e04-5969e2d9271mr4328e87.20.1763579423788; Wed, 19 Nov 2025
 11:10:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118170240.689299-1-Jason@zx2c4.com> <20251118232435.GA6346@quark>
 <aR0Bv-MJShwCZBYL@zx2c4.com> <aR4UvNzdLLofbRpW@zx2c4.com>
In-Reply-To: <aR4UvNzdLLofbRpW@zx2c4.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 19 Nov 2025 20:10:12 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE63pP9EwQgAUUDEeK3CDkwscuVKPdbQ9o5607ue3U_pA@mail.gmail.com>
X-Gm-Features: AWmQ_bkzY6P8NgMWw02eM01xMsLM-m4lzq-47wfA5yoKwi0MAHlAVcWMIt6sEio
Message-ID: <CAMj1kXE63pP9EwQgAUUDEeK3CDkwscuVKPdbQ9o5607ue3U_pA@mail.gmail.com>
Subject: Re: [PATCH libcrypto 1/2] array_size: introduce min_array_size()
 function decoration
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Kees Cook <kees@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 19 Nov 2025 at 20:04, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Wed, Nov 19, 2025 at 12:31:11AM +0100, Jason A. Donenfeld wrote:
> > There's also this other approach from 2001 that the C committee I guess
> > shot down: https://www.open-std.org/jtc1/sc22/wg14/www/docs/dr_205.htm
> > It is basically:
> >
> >     #define __at_least static
> >
> > We could attempt to do the same with `at_least`...
> >
> > It kind of feels like we're just inventing a language at that point
> > though.
>
> Actually, you know, the more this apparently terrible idea sits in my
> head, the more I like it.
>
> Which of these is most readable to you?
>
> bool __must_check xchacha20poly1305_decrypt(
>         u8 *dst, const u8 *src, const size_t src_len, const u8 *ad,
>         const size_t ad_len, const u8 nonce[min_array_size(XCHACHA20POLY1305_NONCE_SIZE)],
>         const u8 key[min_array_size(CHACHA20POLY1305_KEY_SIZE)]);
>
> bool __must_check xchacha20poly1305_decrypt(
>         u8 *dst, const u8 *src, const size_t src_len, const u8 *ad,
>         const size_t ad_len, const u8 nonce[static XCHACHA20POLY1305_NONCE_SIZE],
>         const u8 key[static CHACHA20POLY1305_KEY_SIZE]);
>
> bool __must_check xchacha20poly1305_decrypt(
>         u8 *dst, const u8 *src, const size_t src_len, const u8 *ad,
>         const size_t ad_len, const u8 nonce[at_least XCHACHA20POLY1305_NONCE_SIZE],
>         const u8 key[at_least CHACHA20POLY1305_KEY_SIZE]);
>
> The macro function syntax of the first one means nested bracket brain
> parsing. The second one means more `static` usage that might be
> unfamiliar. The third one actually makes it kind of clear what's up.
> It's got that weird-but-nice Objective-C-style sentence programming
> thing.
>
> Would somebody jump in here to tell me to stop sniffing glue? I feel
> silly actually considering this, but here I am. Maybe this is actually
> an okay idea?
>

I quite like it, actually.
