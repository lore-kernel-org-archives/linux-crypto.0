Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718FB126F00;
	Wed, 21 Feb 2024 23:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708558681; cv=none; b=n3TP5VtTZ6LN/cdGeXXIIhHA3q69R4bRc/7uKSub9S0DyA218S+E6ZySW3/ZXf3r4YcdXX5getksYs4XI7NQ6wonNbf/NBBzUBqnlWHhqKxQSDPEEkBacMasBC3yV7zLtjjI1br963H4nEfmOaZZVnm7Ep7M6mnhyS3mgl9O35I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708558681; c=relaxed/simple;
	bh=WAXaGEI2juxPFHl35+ioThue0wtLioF1NPhr5VM0UkQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V1tZ+v/80EnoR4EOsNcQhTf4Z1Cuco6zRbfgZc8GHb7ZxSuidZjkFYov2DgnIx/w0MhcnGxAiqx26UjrCGhn42kcSIZkLwsUSYXnU9U4i54606zXGxu8kklGeTintN/RylRERqojEJ5ocWQ2Ix5dvfkPhiZx3iXtjgEhvzvy9oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UaKnizN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UaKnizN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD99C433C7;
	Wed, 21 Feb 2024 23:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708558680;
	bh=WAXaGEI2juxPFHl35+ioThue0wtLioF1NPhr5VM0UkQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UaKnizN0x8enyIettGm+0P9IFjEgQle8zT06jCvWpkm0F+ga7+XKvPsmE4mZiHQS0
	 BtxooqOJbBXO+orTooSB2dk79aZLlvx55IOj7iMoQ9tC+gsYfVrezizdGqzykHDM65
	 0LpbaMrtIPBHN9vTlzpMdStwUdJ2V4OR2UfX1Ac/x/on6gneACcmSeU3wtNoGE0mrs
	 VPnn8nOwxumtIm+12Av4cOyLGvpx/2j2iEPpNXKDNgj5wjwxJ6vCXxb61c0IQUrpye
	 qbXyG8P5/wJymdr3qpppBsIvqcv00sWt0t9VowKXp7K+bJlG8Vb6SLL40fRKNJwAJF
	 WK4CLvUEnGkCA==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-511ac32fe38so11071978e87.1;
        Wed, 21 Feb 2024 15:38:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUcV2BLMgAGEuaU81K8xVwOmrrFx2ZSjxRqVw/Sl38dghL5Qp0rQICtHRLl75pGwnqyVh4JaADGLWAW9dgvGjMEHXJTg64H
X-Gm-Message-State: AOJu0YzmTdmtreZ98JyH1G8WYfXAkxwvc6Jf1Mvrv8jFj/q1CyQy5v9S
	oncY+kMn6QUUtiPxIWM5miQvlSxt7mH+ix32DHN9+GXJ3pBKL+tLez4VvGr02rf7/cTUTWI3vvH
	FGl/XIjYjfkE9jJ9Y6YGYHz0sG4M=
X-Google-Smtp-Source: AGHT+IGenZZOFkRMP6+eKElpXmWoSrGK5FHYxUOF69aa2bLEa/DwqCxn3XiWHJ1Xw5V1AaranzDq5lrQhp2GSIIM9hY=
X-Received: by 2002:a05:6512:3a83:b0:512:b04a:aa56 with SMTP id
 q3-20020a0565123a8300b00512b04aaa56mr10911020lfu.24.1708558679072; Wed, 21
 Feb 2024 15:37:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240217161151.3987164-2-ardb+git@google.com>
In-Reply-To: <20240217161151.3987164-2-ardb+git@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 22 Feb 2024 00:37:45 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH+k4Z_iowxp+t=yU4tQFwLYjQxAQ92bga-xeZxE734BA@mail.gmail.com>
Message-ID: <CAMj1kXH+k4Z_iowxp+t=yU4tQFwLYjQxAQ92bga-xeZxE734BA@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/neonbs - fix out-of-bounds access on short input
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	stable@vger.kernel.org, syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

On Sat, 17 Feb 2024 at 17:12, Ard Biesheuvel <ardb+git@google.com> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> The bit-sliced implementation of AES-CTR operates on blocks of 128
> bytes, and will fall back to the plain NEON version for tail blocks or
> inputs that are shorter than 128 bytes to begin with.
>
> It will call straight into the plain NEON asm helper, which performs all
> memory accesses in granules of 16 bytes (the size of a NEON register).
> For this reason, the associated plain NEON glue code will copy inputs
> shorter than 16 bytes into a temporary buffer, given that this is a rare
> occurrence and it is not worth the effort to work around this in the asm
> code.
>
> The fallback from the bit-sliced NEON version fails to take this into
> account, potentially resulting in out-of-bounds accesses. So clone the
> same workaround, and use a temp buffer for short in/outputs.
>
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com
> Tested-by: syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Ping?

> ---
>  arch/arm64/crypto/aes-neonbs-glue.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
> index bac4cabef607..849dc41320db 100644
> --- a/arch/arm64/crypto/aes-neonbs-glue.c
> +++ b/arch/arm64/crypto/aes-neonbs-glue.c
> @@ -227,8 +227,19 @@ static int ctr_encrypt(struct skcipher_request *req)
>                         src += blocks * AES_BLOCK_SIZE;
>                 }
>                 if (nbytes && walk.nbytes == walk.total) {
> +                       u8 buf[AES_BLOCK_SIZE];
> +                       u8 *d = dst;
> +
> +                       if (unlikely(nbytes < AES_BLOCK_SIZE))
> +                               src = dst = memcpy(buf + sizeof(buf) - nbytes,
> +                                                  src, nbytes);
> +
>                         neon_aes_ctr_encrypt(dst, src, ctx->enc, ctx->key.rounds,
>                                              nbytes, walk.iv);
> +
> +                       if (unlikely(nbytes < AES_BLOCK_SIZE))
> +                               memcpy(d, buf + sizeof(buf) - nbytes, nbytes);
> +
>                         nbytes = 0;
>                 }
>                 kernel_neon_end();
> --
> 2.44.0.rc0.258.g7320e95886-goog
>
