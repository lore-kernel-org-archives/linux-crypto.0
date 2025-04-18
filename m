Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECEE219ED;
	Fri, 18 Apr 2025 02:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744944569; cv=none; b=TIbjsJrHWGElnC8wuzmMmszWukfScx4ZFUwYFDzrSM7N1Y7vcLRpMM/d5YvLHTm11H4/Wuau6Jrq4KuiodIDL+oRgdI7syd/sl3hddxcUCgGryec99Wd4RbMzrfdTWEQY9XyhVZVlW6Wv10cONAv5Cni0dOw6RlsvRXFqGcR+WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744944569; c=relaxed/simple;
	bh=lEbPmZPHeuEvxspsAVAjSCIqu9XEP/Q8eqr+/w0V9tA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WnOCkHN+8veTexgYlqfqVK0CqrqF0e4mZjzzCGI3W34AMyQdg+AM/SEuQ2RZzW19fVoFoEos4Oo6xgQVELcRBAwq1u30e6tEjg8JiKxPF4eTVLbe9qcY375ujBctin4sJaGJtLvsZZcpCb6dA5fsfILmt3/6fNUh8BL4H9BztfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X7N+edrb; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X7N+edrb"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e6df1419f94so1193186276.0;
        Thu, 17 Apr 2025 19:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744944566; x=1745549366; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Dj8GhW50UrAUMkoalDHqFuyFbqo3nnRECKX4Bf5Ge4=;
        b=X7N+edrb/Nans/aDQP6+qe1YhJHext92N/wqZV5SzUW8fUcrdNgjbjZmKTlDS33oXj
         TZglZ7dPilBSRwziouZgIbGkpxOnTYaAydD0svLBMpxC6BfD+eOklqX0QtdycTKPvBcg
         TW69PZOtLbP1hTNZ3yxRQBxLDkpBS+nMGsTSWnJ9s4m3q9DEyARsujm7bA18ylUnevqC
         FvSA7EcczDdFO9xAZGX7261Wb4DLeZxJz7D+zjJ5M7o08O4IbVdGd2sDSUsRiwhQd5WD
         aQPEQ7iAPJLY/i6VelCrFsKhf3EABv5m9Zxdif+6HY4h8/+1Wa75v8wPRVzaqR0g3K+i
         DEfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744944566; x=1745549366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Dj8GhW50UrAUMkoalDHqFuyFbqo3nnRECKX4Bf5Ge4=;
        b=TTFNte7F+Xc+CisHddROh3TGKJiVftk3eUn/2daRZvqX+UEobbQDssvdoLvys8KAfZ
         WuQA6Ojl6U2v0mqUZDR+fsvI+7U7XVPCr0vJjANVY6326bvnc5mQ6KYQVGsSzfXKB82G
         YAgCi/Fp3XgG7JKFTkHFDgqFpLdFPA5oevd3t6DfeGYD+WO9QYOoAd4tjywj2IR8qgHY
         BEZj42tEX15GlPAQb+SZ8ZVoVi1vsYOlyOlUsOX/C8wgtRz9zVHVNcFBHpVn4umfOPJ2
         1wHBJcAAHnkLHiOEBjvLZl9l4wCuvv7NJdRX2PE1TeUYgrMsGWy1YcV0PKMnWa8pVHnD
         UIZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTkimbm/XAHIaljon4AtVMuwccOwRhJA2Gev9aw5/l5B+Oeuq7jma+dDit8sEVFNrYvzLM7BrKzicglXA=@vger.kernel.org, AJvYcCV/yai+te26pknfh95hQFPtukmSDMatE6jnHc01lKmZW2NJNMkz8ZI4y8tGbynwP3jig5kNMqJ0dztwYRTU@vger.kernel.org
X-Gm-Message-State: AOJu0YwsFRkTnGevZcBBqcFjRJdOB4LaEpXXuLqCkfOblCFYfUhPsK6Y
	CaY56PD2j3GSHQSB0bZZy+g/rHiIxN3rW63JtSDTEntf8rsNgu1by8VkG6hxfJHUQ8NADMZfjKj
	Yz0RDxIoK+rbzzNg04O4k0huLylA=
X-Gm-Gg: ASbGncvOVtSzGg+vEVmZ1/L6Y2ezKqBtGr716G3npc/IQYno71+kEzCLmAUG3SKNPBX
	rBtV2dH4PGxMV6869DQPnajVSJoOhs6LBi2IztHuqNekpdgrNsfbZqw4fs7aEDsYzA0N1rZKeIA
	ygD+x7+LeOIby9pxyHmwBOam5lBJag/OiegRLUmg==
X-Google-Smtp-Source: AGHT+IFOw2jiDXl3bt6tyk3aoTpA5w5vhRYg4GCxEMlUgP7Q+jQU34k6Rpv4Sr8sgqmg+aVZeAJ5xQLgahHc75hZMLE=
X-Received: by 2002:a05:6902:2290:b0:e72:871e:fc3e with SMTP id
 3f1490d57ef6-e7297db6e4emr1580309276.12.1744944566311; Thu, 17 Apr 2025
 19:49:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417064940.68469-1-dqfext@gmail.com> <20250417170902.GC800@quark.localdomain>
In-Reply-To: <20250417170902.GC800@quark.localdomain>
From: Qingfang Deng <dqfext@gmail.com>
Date: Fri, 18 Apr 2025 10:49:11 +0800
X-Gm-Features: ATxdqUHy7zDRa-eA71VWFff5HhwdMV8ZyAjRDc9UL_LnWdHSkCoRmm8Tv5GBb9Y
Message-ID: <CALW65jZmLx+dh+cYpsynXnZnzmNwA9QFA-q77zHWT=fNKEbW5g@mail.gmail.com>
Subject: Re: [RFC PATCH] crypto: riscv: scalar accelerated GHASH
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, linux-crypto@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	=?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>, 
	Qingfang Deng <qingfang.deng@siflower.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Fri, Apr 18, 2025 at 1:09=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> Please help properly optimize swab*() and {get,put}_unaligned_* for RISC-=
V
> first, before considering random hacks like this.
>
> https://lore.kernel.org/r/20250403-riscv-swab-v3-0-3bf705d80e33@iencinas.=
com
> is working on swab*().

Indeed =E2=80=94 in fact, our downstream NONPORTABLE version currently uses
{get,put}_unaligned_be64, as we've modified the Makefile to ensure the
compiler optimizes for both unaligned access and efficient swab*()
handling.

>
> > +             /* Multiplication (without Karatsuba) */
> > +             t0 =3D clmul128(p_lo, k_lo);
> > +             t1 =3D clmul128(p_lo, k_hi);
> > +             t2 =3D clmul128(p_hi, k_lo);
> > +             t3 =3D clmul128(p_hi, k_hi);
> > +             mid =3D t1 ^ t2;
> > +             lo =3D t0 ^ (mid << 64);
> > +             hi =3D t3 ^ (mid >> 64);
>
> There is no need to explicitly XOR 'mid << 64' into lo and 'mid >> 64' in=
to hi.
> Take a look at how arch/x86/crypto/aes-gcm-*.S do it.

Thanks, I saw your comments in aes-gcm-avx10-x86_64.S and now
understand what you meant.

However, since we're working with 64-bit scalar registers on RISC-V
(as opposed to 128-bit SIMD registers on x86), there's no reduction in
the number of XOR instructions. Regardless of whether we explicitly
compute mid and shift it, or directly XOR the intermediate results, we
still end up with 8 individual 64-bit XORs to combine t0, t1, t2, and
t3.

So while the optimization helps on x86 due to wider registers and
vector instructions, it doesn't offer a benefit in our scalar RISC-V
implementation.

>
> Also, since this is only doing one block at a time and does not use Karat=
suba
> multiplication, the single-step reduction would work well here.  See
> aes-gcm-aesni-x86_64.S.

I saw the pre-compute key step. Is it the same as the step mentioned
on page 12 of this PDF?

[1] https://builders.intel.com/docs/networkbuilders/advanced-encryption-sta=
ndard-galois-counter-mode-optimized-ghash-function-technology-guide-1693300=
747.pdf

>
> - Eric
