Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D900367;
	Wed,  2 Apr 2025 06:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743575685; cv=none; b=BQ5iGFeq54Q07irIJQwnZgb4aHPYDKaj1ry/FmAUZhIKY+QeTyBuPWziV5rPnscBHc4DvAGeQ9OjHnTKB5QeYzu4PY0eJRLCOnKeDn/OdiMt0Q50wWdLL7wvOkiXvX36zudg3tvEAkv9mzvX0y1FS39WTwl5uzcEh49aIljlYII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743575685; c=relaxed/simple;
	bh=QJWKrUTLhpdBk1gTJUAvvDChPHHcCG2u7wUtYBcC138=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LQxL6c6CozTTfpkz8cCvL06j/DFhwJozp7d6y2JeEQ7f/T9mfWB2KR7NmYx1+PSFGHPiaKy8o+112U+zcAgq3ESTZUf+zJwcG2Bdfxw8qJ86lFU5GfFjrOWxUTaQSL6Cfr4Rmqc4zd4ZVqqh7Ov2RI4tgfGFJLLXeNlOh9i09y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Spb4dcG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Spb4dcG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ABFC4CEDD;
	Wed,  2 Apr 2025 06:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743575683;
	bh=QJWKrUTLhpdBk1gTJUAvvDChPHHcCG2u7wUtYBcC138=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Spb4dcG6QHtIDLgY5Q4rz7CDLxj84umylUdOi0Z93YwuqY64zXeVhnTb2fnYR6aJr
	 izyl69jG6aY+SVJJOusYPqT7WwssH4IqF4GcCQQ6FP8M5MQkD11hNnLstT1Fe7xCnU
	 aiyGTQ07vcqV98E1KQk68m/53UsHY0o5/PW0pecrHJzWJrUKdQA4+FJJ6IO9hnTipM
	 46TmaJPcL3XevUa0+gJxNUlk2eagkSFSIdLrbnLb0RknEyemJgBaQxM8Nfc8HLnu3N
	 V2Sws6iqG51JRu9eKALWAi8uA3/2zSxLMzJk3nDx1JIg51M0LsuN7zEamusBIcc/7/
	 gES1k6CgiQF1Q==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-30c44a87b9cso48109681fa.3;
        Tue, 01 Apr 2025 23:34:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV6OGO1RT3LJniwEE/BwaFBxHo15L3Yy2mHj+UlJblFiyLTzQXYAy1amLCnD9jlkS8Hyz7NCk9umL6CU91m@vger.kernel.org, AJvYcCW+FxQGV++tGUkNj1/cmBBVg8OSaXNaqhrGtQmZxgn8JuMlzOeQfNYoFme/cYKFCjYLJ+02DhhJ/1+KdoU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWLdkDCqhxOdNOj9BLraENjlP7fiz16ffeOiTpNrna9GMaF01x
	Ivodc0RpOa2GFvjXQ2v1mu5j0CMuvpslxlXrlFtO3lcmi2e990sMGzvRnmLOJWukWCr/Gpt8IOz
	iaJqc0HWJrTBZg8sTHogY9sfiTTs=
X-Google-Smtp-Source: AGHT+IGeaFkBlwbxppv/Ms1A+TfuX7smxLpSQ5LVPfoCe1K+hSX+PDl+fZ2soQf0baCRYVw5iYe9xXVK1leT7vSJkEs=
X-Received: by 2002:a2e:bea2:0:b0:30c:2e21:9958 with SMTP id
 38308e7fff4ca-30de032f0b1mr50297471fa.32.1743575682261; Tue, 01 Apr 2025
 23:34:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250402002420.89233-1-ebiggers@kernel.org> <Z-yrf_9D2rV1Q136@gondor.apana.org.au>
 <CAMj1kXEx__RLBriW0kVPrKnx6+DCpq8=6F-7Tmj2Us61gvGGaw@mail.gmail.com>
In-Reply-To: <CAMj1kXEx__RLBriW0kVPrKnx6+DCpq8=6F-7Tmj2Us61gvGGaw@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 2 Apr 2025 09:34:30 +0300
X-Gmail-Original-Message-ID: <CAMj1kXE-vo7E1U++4mAqDH2SXfc=sRZs8KganedJk5z0QF49NA@mail.gmail.com>
X-Gm-Features: AQ5f1JqzmAudo-CcmfpasbkkOWp_Bsl3uaQehcYB86N21t-Epvr3g_pGrYpaMDE
Message-ID: <CAMj1kXE-vo7E1U++4mAqDH2SXfc=sRZs8KganedJk5z0QF49NA@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] crypto: x86 - stop using the SIMD helper
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 2 Apr 2025 at 09:31, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Wed, 2 Apr 2025 at 06:14, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > Stop wrapping skcipher and aead algorithms with the crypto simd helper
> > > (crypto/simd.c).  The only purpose of doing so was to work around x86
> > > not always supporting kernel-mode FPU in softirqs.  Specifically, if a
> > > hardirq interrupted a task context kernel-mode FPU section and then a
> > > softirqs were run at the end of that hardirq, those softirqs could not
> > > use kernel-mode FPU.  This has now been fixed.  In combination with the
> > > fact that the skcipher and aead APIs only support task and softirq
> > > contexts, these can now just use kernel-mode FPU unconditionally on x86.
> >
> > Nice work!
> >
>
> Yeah good riddance.
>
> > So which platform still needs the simd wrapper? I believe arm/arm64
> > have both been fixed but we haven't finished removing the legacy
> > simd code yet? Ard, would you be able to spare some cycles and
> > finish the removal of simd on arm?
> >
>
> Removal of what, exactly?

Ah, never mind - I see some calls on 32-bit ARM to
simd_skcipher_create_compat(), which have become redundant now that
SIMD is guaranteed to be available in softirq context.
