Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9C32F2605
	for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 16:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763571457; cv=none; b=k8l5SC9O9m7GsfDp7AWhgHTdrF7v05wwPb6Gh7F0I3LaQzb9QLGpWUZm1KZEQa6AA+Swg2iaI94C6a4iwv0AKMoq1bCgmeOralGFfKZXB3ZOjeh61ksdEzPN9JL9kebHZVN1N+uLp8L68BdUfaS1RrWqRZoXkjzBhZdpY786lcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763571457; c=relaxed/simple;
	bh=3qbmBlDOhBqpexe2KgI2APMs04wdSfYxDR78bi2WaDA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f6XIGL9XELPuFwaATCcdDkTZRp5Bvw76WvMjmzLOrZ7HvYkjQ/w4NNQqHPFwH5vozofOu4Cbu9EBRi2cHYsDw+bYNKaIyqUoC+U+5p6DZ1GG52fBIMsLcNWEGi4Bx0AoB4r073H3/m+M8YBVMu/PXNo7md0+cj3gQw4FUHil3os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dt5aThlU; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dt5aThlU"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b73669bdcd2so984937466b.2
        for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 08:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763571452; x=1764176252; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e5xr7znsz2E58DjiH4TrOVRBZvkxR+ArNemRIj4DQcU=;
        b=dt5aThlUB1SdUlSVs4p4U9O4+oElcY4IPjL2QTdHvYINeLQom/g0+68m81D6k6UuOg
         KmfvBsP/zoxvlulkkOCqe0W+vPdWXVOGvXzy9BZHZENNLAfkq/75NZ5sAD9l5n++M5yM
         xBUPZAZiJJSZwQ/L1bRsfTEOR+YaUbDQU4raA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763571452; x=1764176252;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5xr7znsz2E58DjiH4TrOVRBZvkxR+ArNemRIj4DQcU=;
        b=boqP9axvdFNwQn2xcTm10VfZt6AGUOiqq0nvr4fJ9BFPBjThVLf5nxmNUDGg4QOkgc
         HM4bQ2W0OgM56nYCdByTr7UOxeO3/AU3o5XTg5NGoUyKWka8D9NxAfkgA9NubFdPJXl4
         LsQVYAEn/RQ8JGqyAhov3tim8hi4X2aldRk+ljjHGBDj8FhrmKB6B6FbWDjxAZKrHDsi
         NS7rxXHOU7edSDB5DrBWKaQeSF8xB6Zv7GpjjDbWHTUNBGQaYPgu0Qe7DBns9t/KmELv
         wtiirOMArItjgNGbPqF63eqNuPv0Uvne/HvW5gQYIOMXRFChYkF+wzvpIZQw/JA/qOcN
         XNUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXS03d+B67riHd8GZUVJuiDbxb8w1BgUCOShkswvcscY3G6lObhfWBotwzkfX/bvN2E2NTWHei1tEyAWNg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrcujczzZZ9L6p0II18vA6v6h2z3OaVF2BKOsL07llevklhiYD
	oxkz5rPWda6bEKQ4oZFZ3XR5NRoEaynbSg+9TT9I90H37a5pS847Yy220b/0h7qnF4b+zUyBLEr
	aKTCDzxHqHA==
X-Gm-Gg: ASbGncuEbKMy4TGJpHO32vnkiCQ1C//xzVZpa7zjtJnp3bY+/6eGn0zE5CONVrheUsk
	sASAdpKSxnyfESAH8XbT4CoZFFgeQJFSzWJNI6Xxe278mKPKnZyxmSquxBlICF4ah4Y4Do1pMN/
	CznYpJYMK+pLrC06eHMi7704loGsIfKUI5s8JONMjQMiVgIVui/oEWluxsXuXWgCmFsJtzxiQW0
	Le6gPSOYyTZcC9AtWNl9jbGxqO/E7kaajtxlp018bICJYG+bXukFNo4CMtRVbfHWPP9/t7s7600
	V33ePkMZpYEjCaEQpsOrHCO7k8qM30E1T1uZC3EqiHD8jmMvzesBSE2CeDiza8zkR1RdBuHkfiL
	mH0lV3tbEESwaMtD392p8qDtEFgwFOJX+eaV8WCfB6/EtsOWCG+An9txZYQXsZ5GDF+hOGjFDJ8
	1LQVMlPY+P8diATiJopjwZtqDT/1zY+687mGrtED6vNh6kkX0A5nO97vlqV54aUtRreTLwWEA=
X-Google-Smtp-Source: AGHT+IGKLmody5wHROImLx4cFczsLdNw3Qu4+HMKEt+SybuNKCNh3gYd+fllTJUKKAfYhQR9cOIFjA==
X-Received: by 2002:a17:907:728d:b0:b73:8903:f4b9 with SMTP id a640c23a62f3a-b738903fc0bmr1686431666b.24.1763571451851;
        Wed, 19 Nov 2025 08:57:31 -0800 (PST)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fed9d38sm1692878566b.67.2025.11.19.08.57.30
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Nov 2025 08:57:31 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b73669bdcd2so984933066b.2
        for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 08:57:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVa/1780U+A5emhlxofI57wLXmpzfr/Sq0ty0HThk1akSI4lGLK/ZubSre81/tZqWl6TzD2t6I+e9/9OUY=@vger.kernel.org
X-Received: by 2002:a17:906:478d:b0:b71:9c99:7b8a with SMTP id
 a640c23a62f3a-b7367bc6b95mr1993595766b.49.1763571449725; Wed, 19 Nov 2025
 08:57:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118170240.689299-2-Jason@zx2c4.com> <202511192000.TLYrcg0Z-lkp@intel.com>
 <CAHk-=wj9+OtEku8u9vfEUzMe5LMN-j5VjkDoo-KyKrcjN0oxrA@mail.gmail.com> <CAHmME9pvgyot-PJDbWu1saYagEYutddc_B9qNHf-MZ-vkw4zoQ@mail.gmail.com>
In-Reply-To: <CAHmME9pvgyot-PJDbWu1saYagEYutddc_B9qNHf-MZ-vkw4zoQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Nov 2025 08:57:13 -0800
X-Gmail-Original-Message-ID: <CAHk-=whjG-B517DxHm5rSE0S76n+fHMdnJdqFg9VTvx6-HgGRA@mail.gmail.com>
X-Gm-Features: AWmQ_bkxxp7Yy44j171fiA9Z2Xle-tZAZS12NBySFcI47avzcJvVuC9gPT3eA3A
Message-ID: <CAHk-=whjG-B517DxHm5rSE0S76n+fHMdnJdqFg9VTvx6-HgGRA@mail.gmail.com>
Subject: Re: [PATCH libcrypto 2/2] crypto: chacha20poly1305: statically check
 fixed array lengths
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: kernel test robot <lkp@intel.com>, Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Kees Cook <kees@kernel.org>, linux-crypto@vger.kernel.org, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 19 Nov 2025 at 08:47, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> > Hmm. Is this a compiler bug?
>
> It's not. It's a 0day test bot bug! My original patch had in it some
> commentary about what a bug would look like when it's caught by the
> compiler. In order to provoke that compiler output, I mentioned in the
> commit message that this diff will produce such and such result:

Lol, ok.

I sometimes actively just whitespace-damage my "what about this"
patches to make sure people don't just blindly apply them without
thinking about them and actually look at them.

Maybe that's a good policy in general, so that the bots don't do the same ;)

            Linus
