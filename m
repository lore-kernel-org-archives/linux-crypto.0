Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCF650250
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 16:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwQH2zgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE52C43390
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 16:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704990915;
	bh=pYZFzDQ/TWAhv59QB61LzALmMor3mbcIpv5DzqPls6s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dwQH2zgDTp2iU/C/sQfxuFE8Wl9PsY+/86TzHlbSjtgNHG+x2pe+A/s92EEBfxhaR
	 XuYoVLdCb6PY5YCNnIk5eR7v+A736n2Slmxdy7uynWoWTzSSXkYjlckmjerlXNPXh9
	 ethkCXU311LOB7b+F3iaICYMXQ9bQOFrAWudIsCIHLtYVnCeWdwPoO0mmMeaW31W70
	 arRGx2ab/eZVjnDElb8+cQkpbHoWWRGw15OsbHCQLrSI3R7MxPXs1SLqOljqKKNdif
	 K/wonqm0FJwmEyPynmBF0ZURamnHjF/ISJ7bz0Q/eoXyLY52GBCvPD4yQbEggCfWaT
	 jaDr8ZLeEikbA==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-50eaa8b447bso6084167e87.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 08:35:15 -0800 (PST)
X-Gm-Message-State: AOJu0YwJ0A8X7vr7AFxLqScpkSYwECeeb6p3/c27JuGD1odIToBHKnnY
	fZGowG/aRcSuscLFh2tLuBP/XCPrTyWZZsJFyzE=
X-Google-Smtp-Source: AGHT+IGd0R4a7VgUlGB7OkfS4bXdlkmaUKHgsFZ+H3HqmZqj5ddwPoYBOgdjfcgKwMRY/E/ZB3clD/5JsdwVZMlIimw=
X-Received: by 2002:a05:6512:3e27:b0:50e:7bba:8567 with SMTP id
 i39-20020a0565123e2700b0050e7bba8567mr528644lfv.233.1704990913847; Thu, 11
 Jan 2024 08:35:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240111123302.589910-10-ardb+git@google.com> <20240111123302.589910-14-ardb+git@google.com>
In-Reply-To: <20240111123302.589910-14-ardb+git@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 11 Jan 2024 17:35:02 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHBNe-CaFpWAxeWCw74vG8vwne-VOV6R4O+B=b7pcxiFQ@mail.gmail.com>
Message-ID: <CAMj1kXHBNe-CaFpWAxeWCw74vG8vwne-VOV6R4O+B=b7pcxiFQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] crypto: arm64/aes-ccm - Replace bytewise tail
 handling with NEON permute
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, ebiggers@kernel.org, 
	herbert@gondor.apana.org.au
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Jan 2024 at 13:33, Ard Biesheuvel <ardb+git@google.com> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Implement the CCM tail handling using a single sequence that uses
> permute vectors and overlapping loads and stores, rather than going over
> the tail byte by byte in a loop, and using scalar operations. This is
> more efficient, even though the measured speedup is only around 1-2% on
> the CPUs I have tried.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/aes-ce-ccm-core.S | 59 +++++++++++++-------
>  arch/arm64/crypto/aes-ce-ccm-glue.c | 20 +++----
>  2 files changed, 48 insertions(+), 31 deletions(-)
>
...

The hunks below don't belong here: they were supposed to be squashed
into the previous patch.

I will fix that up for the next revision.


> diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
> index 2f4e6a318fcd..4710e59075f5 100644
> --- a/arch/arm64/crypto/aes-ce-ccm-glue.c
> +++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
> @@ -181,16 +181,16 @@ static int ccm_encrypt(struct aead_request *req)
>                 if (walk.nbytes == walk.total)
>                         tail = 0;
>
> -               if (unlikely(walk.total < AES_BLOCK_SIZE))
> -                       src = dst = memcpy(buf + sizeof(buf) - walk.total,
> -                                          src, walk.total);
> +               if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
> +                       src = dst = memcpy(&buf[sizeof(buf) - walk.nbytes],
> +                                          src, walk.nbytes);
>
>                 ce_aes_ccm_encrypt(dst, src, walk.nbytes - tail,
>                                    ctx->key_enc, num_rounds(ctx),
>                                    mac, walk.iv);
>
> -               if (unlikely(walk.total < AES_BLOCK_SIZE))
> -                       memcpy(walk.dst.virt.addr, dst, walk.total);
> +               if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
> +                       memcpy(walk.dst.virt.addr, dst, walk.nbytes);
>
>                 if (walk.nbytes == walk.total)
>                         ce_aes_ccm_final(mac, orig_iv, ctx->key_enc, num_rounds(ctx));
> @@ -248,16 +248,16 @@ static int ccm_decrypt(struct aead_request *req)
>                 if (walk.nbytes == walk.total)
>                         tail = 0;
>
> -               if (unlikely(walk.total < AES_BLOCK_SIZE))
> -                       src = dst = memcpy(buf + sizeof(buf) - walk.total,
> -                                          src, walk.total);
> +               if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
> +                       src = dst = memcpy(&buf[sizeof(buf) - walk.nbytes],
> +                                          src, walk.nbytes);
>
>                 ce_aes_ccm_decrypt(dst, src, walk.nbytes - tail,
>                                    ctx->key_enc, num_rounds(ctx),
>                                    mac, walk.iv);
>
> -               if (unlikely(walk.total < AES_BLOCK_SIZE))
> -                       memcpy(walk.dst.virt.addr, dst, walk.total);
> +               if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
> +                       memcpy(walk.dst.virt.addr, dst, walk.nbytes);
>
>                 if (walk.nbytes == walk.total)
>                         ce_aes_ccm_final(mac, orig_iv, ctx->key_enc, num_rounds(ctx));
> --
> 2.43.0.275.g3460e3d667-goog
>
