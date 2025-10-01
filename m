Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AC23128D0
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 22:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759359586; cv=none; b=oza0mUq2eWrJf6JdWcF5d2v9x0/3wmOzITgQVeigdA5CIlo2CVTTM+bmf7If89iu76XOPbBiKQC8tVQOayezCDvP2VImcOi2t3EzGpoa9b0ll7Dolh3l8HU0KQtv6pJ87QAQLNQPMGg1UCZTukLzy84mrKA4Rcd56+SdZAyEjGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759359586; c=relaxed/simple;
	bh=/jEZePi63ifb7LawHxT3yfaud/22p+YbYH+kfCQsEVI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e/h+53ihYzA02UnCtnZ+TplnHJGHicWiinKLELTHCODJZoBZE6sFHsXmSTQqkMnlgfW6ZJtjELf3kzjHVw2YwHmij8ZUnYPzFMHVdyZsZ+Kh+yRsO1m1inlB/z4S9uG9BCDvYELvJfVywmOJZ9prD5cOGVp2ATt8sy6n6qaHjwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ekLhcHnG; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ekLhcHnG"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3ee15505cdeso270328f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 15:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759359583; x=1759964383; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2LJjpzKHNhkNbLIhRR6OhIR28zGFHZ3AsWw8V3scZQ=;
        b=ekLhcHnGgRaFHZPl+8I7CNhiukr6E77fHqYw6yBYvktrkZjIp6Eo7+zMaNHy+nDuUh
         1mocxv7sRgM+nZshpSXYbQgZ/HsTjAfJHrsDSN2yq8e81U8jyIdVSkXvmJsKL7h1S3MV
         zdT7BCmG+hAsa2HbXnJtcX0a9HCoxlz0mXh6STsOY79IahfWfSIv4oofaPUmCbdYeHir
         K+GO3vJ5w5Jrx1Py7Br0wAN/pHTPp4csiBO9PfQNsXXJ+M9h1RB3RppYBZdHkamuxQ1r
         G7bsW3OR+/VqWoaBvkb3vPjWGCCiFP1+I7/GLj125sOHmKMyvOr8KYU9/rGqjogWSJ5z
         CWFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759359583; x=1759964383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I2LJjpzKHNhkNbLIhRR6OhIR28zGFHZ3AsWw8V3scZQ=;
        b=iocsBchcGUS8uo86dOoKz7KlGHQdbRc0zz9QPJN+DjABY+U34xBapJWhyChMic3Cbp
         rLsJW6YrUb3sUm1HRldkLEC+ah3WlXBMihvbJa+iu3TxlLp2ZibzrDAwuA5fh81pCQHE
         AB5Kuf9gqguEXjKRZxLMhydFXEDwcYRxysCTrfP4TWwQNq6H31UV2TuNKQQPldn2Ntnm
         1Geoe71S1BPZQZJl2VW7t6COA7kLD4N9Uq3FUCunMNgbiqZSGt3geIvAne7Razg0Lzyy
         pbVTaUgeE1uXSF7vsiVhE2KZlkMJhc0olzTh7zhKUOXX4xHGRalkGbH4er/SjaMAzxPL
         6HFw==
X-Forwarded-Encrypted: i=1; AJvYcCUtoFdOGNKykYzp5BlC32ecDjwyF85vJhpojrQCaL6Rxw80ZViPRPOyTydS8JuZ68n0XF1Ml85FrWkL9X0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXajYrYvnfgKoahwnB125gMpgUIlttV06g+iXASt1WmWiQInCs
	PTkiOF2TIWlgQK3GS6i3ebziDy1AjGjiqlwLpjyU8Vpi0bsCV7YacsscuzjI0MhLgXJ1ANJQVOJ
	ElmtFggmUVpXuKkXd1NdbYBq9A1vIbJy4+4P7
X-Gm-Gg: ASbGncs45ttmpvK+yJL0Z9mZc5Ba5UoIMNCurzl/Bpb+BQA7wyU2xNQXOfNcEGkn8uG
	agVx/hKlZOcWfF6bVsKs0HhDYZD3FDY1TGiSBqmWe9R2LdAAJFrlR9T0iO2IQILvwcyWo3HWaTZ
	RthvnJDDIUPLPcOxBZk+t9IK5o31+a+XTwbb7hYl/rEZPo8Cx94Q2LHvZWc6pz2Er2kCIdqN7ih
	1f8DEzUdX6zoPoW60opW3+d1xYhoArRqP6GHpMCo3keQDYF9M02HeZrcSsO
X-Google-Smtp-Source: AGHT+IFIthqNLIzsiiVqfIC/794k1c4r4WbSgF7mi39Ywx1WhaF8XPcDvawxyxt3Hv5pgCvoq9HKGrKtaTz9avnQwoo=
X-Received: by 2002:a05:6000:26c8:b0:3ec:dd27:dfa3 with SMTP id
 ffacd0b85a97d-4255d2b70c7mr906497f8f.25.1759359582571; Wed, 01 Oct 2025
 15:59:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250929194648.145585-1-ebiggers@kernel.org>
In-Reply-To: <20250929194648.145585-1-ebiggers@kernel.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 1 Oct 2025 15:59:31 -0700
X-Gm-Features: AS18NWDraC0eOVPTbkYt3tRMCpa8HC5n2XCxn7eFZFOdN6cdM4zLD1NKkPUHBCk
Message-ID: <CAADnVQKKQEjZjz21e_639XkttoT4NvXYxUb8oTQ4X7hZKYLduQ@mail.gmail.com>
Subject: Re: [PATCH iproute2-next v2] lib/bpf_legacy: Use userspace SHA-1 code
 instead of AF_ALG
To: Eric Biggers <ebiggers@kernel.org>
Cc: Network Development <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, 
	bpf <bpf@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2025 at 12:48=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> Add a basic SHA-1 implementation to lib/, and make lib/bpf_legacy.c use
> it to calculate SHA-1 digests instead of the previous AF_ALG-based code.
>
> This eliminates the dependency on AF_ALG, specifically the kernel config
> options CONFIG_CRYPTO_USER_API_HASH and CONFIG_CRYPTO_SHA1.
>
> Over the years AF_ALG has been very problematic, and it is also not
> supported on all kernels.  Escalating to the kernel's privileged
> execution context merely to calculate software algorithms, which can be
> done in userspace instead, is not something that should have ever been
> supported.  Even on kernels that support it, the syscall overhead of
> AF_ALG means that it is often slower than userspace code.

Help me understand the crusade against AF_ALG.
Do you want to deprecate AF_ALG altogether or when it's used for
sha-s like sha1 and sha256 ?

I thought the main advantage of going through the kernel is that
the kernel might have an optimized implementation for a specific
architecture, while the open coded C version is generic.
The cost of syscall and copies in/out is small compared
to actual math, especially since compilers might not be smart enough
to use single asm insn for rol32() C function.

sha1/256 are simple enough in plain C, but other crypto/hash
could be complex and the kernel may have HW acceleration for them.
CONFIG_CRYPTO_USER_API_HASH has been there forever and plenty
of projects have code to use that. Like qemu, stress-ng, ruby.
python and rust have standard binding for af_alg too.
If the kernel has optimized and/or hw accelerated crypto, I see an appeal
to alway use AF_ALG when it's available.
