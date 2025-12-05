Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F02430170F
	for <linux-crypto@vger.kernel.org>; Fri,  5 Dec 2025 10:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764931901; cv=none; b=ri67cqFKU6yczZTcae2rxeJj+E6Oxlg2LkFe5gXHeyZZBkG8a/iIxownDqLp06OJhC8RqqPAiZqrJmLGVy3l8p8ARdhESxmaLM/5Ze1xg/Tpusjp/s99dNayWaZR/4G+OV9/yxqbKAaVmj5qMvyzC25LxuuMwMHzQ02bvYvZKpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764931901; c=relaxed/simple;
	bh=TeTh/DGtE8wt6e7+QS1xYcwiuRkgQqDik3m2yeeTOwk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W7INtqXCk1qd/KhozKG0/cnpfZylTmdAh4iKO3E/q5GkBKRL7BT/xB5GTwUBfYefiFQVQnNYStL+SRa9jZBCzdBX7CjzTRsPTitb6hMtQX62ofamfzjfiT6q4eKbDZhGVdARuAaagmKDG6ViUc6INznAEtsB83SzdIN34o/v0/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kHr2FyMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHr2FyMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52422C4CEF1
	for <linux-crypto@vger.kernel.org>; Fri,  5 Dec 2025 10:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764931900;
	bh=TeTh/DGtE8wt6e7+QS1xYcwiuRkgQqDik3m2yeeTOwk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kHr2FyMnT8jsTtyDw7gLbbU4rpISzrpemIjY4t+hn7vgLCbN0pGzjnqPvheHo8tgx
	 2ShWkg5mgv+YVLZADKN6XEU27I2DjCzcEZy1/OO/6qUzPlbBPIX3cs1b8Q3wSqxi7g
	 BBNjMeMbKSb5T8Mm4wnYFqZT6nOYWhYzlPxWjCoEG9ezMdbkGpBwCSqU29/OKpwKxy
	 TMxZGBUxTQPUINM/EfCivquVNerzvOfRVVLTA2fzTeNGWqEUCY41774MR+REf8sP4G
	 HZ9z8JDIZpyNUzrJg9sVe/7WCv8dtlzpt9wonpfk0hTfwLgMsJk6L5CYE90C4fjzTm
	 VmrOMfs+tLoNQ==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5958232f806so2118592e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 05 Dec 2025 02:51:40 -0800 (PST)
X-Gm-Message-State: AOJu0YyoknnFGT3wS8xAH+o/iK5ddFFuKuo95ZT7ijJHJ8XmUxcGIz7Q
	ICOsmFLdS3DhPm0ty3pjf84gIFK7LD5EDX0shnMIRpkO3JJqUz7IXwUvSAl5SPBzPTqv8lQDh7V
	r62hvvqqGZiJl/WjCZUf9LT9yW4DjIfw=
X-Google-Smtp-Source: AGHT+IHugUh2Ue4jiaGwd84QsUTuDKQmkvPCnOdPs/IvzYLsK8r+jBLME+aAjUNl97yzsdV+X+9n6Aqf0fDQa5bAFPE=
X-Received: by 2002:a05:6512:10c1:b0:594:2f1a:6ff0 with SMTP id
 2adb3069b0e04-597d3f010ffmr3779903e87.9.1764931898633; Fri, 05 Dec 2025
 02:51:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205051155.25274-1-ebiggers@kernel.org>
In-Reply-To: <20251205051155.25274-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 5 Dec 2025 11:51:26 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEKvMC4pbDiMexs9TST5oo+5ujsgRnLEHSz==9GfSmRDw@mail.gmail.com>
X-Gm-Features: AWmQ_bnIV6duVhP8mgR7RVTcYgAevcWISs_pAcDLmSAWRJUy94NeDLZnPZOm9Ro
Message-ID: <CAMj1kXEKvMC4pbDiMexs9TST5oo+5ujsgRnLEHSz==9GfSmRDw@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: blake2s: Replace manual unrolling with unrolled_full
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Dec 2025 at 06:15, Eric Biggers <ebiggers@kernel.org> wrote:
>
> As we're doing in the BLAKE2b code, use unrolled_full to make the
> compiler handle the loop unrolling.  This simplifies the code slightly.
> The generated object code is nearly the same with both gcc and clang.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/blake2s.c | 38 ++++++++++++++++----------------------
>  1 file changed, 16 insertions(+), 22 deletions(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
> index 6182c21ed943..71578a084742 100644
> --- a/lib/crypto/blake2s.c
> +++ b/lib/crypto/blake2s.c
> @@ -12,10 +12,11 @@
>  #include <linux/bug.h>
>  #include <linux/export.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/string.h>
> +#include <linux/unroll.h>
>  #include <linux/types.h>
>
>  static const u8 blake2s_sigma[10][16] = {
>         { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
>         { 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 },
> @@ -69,33 +70,26 @@ blake2s_compress_generic(struct blake2s_ctx *ctx,
>         d = ror32(d ^ a, 8); \
>         c += d; \
>         b = ror32(b ^ c, 7); \
>  } while (0)
>
> -#define ROUND(r) do { \
> -       G(r, 0, v[0], v[ 4], v[ 8], v[12]); \
> -       G(r, 1, v[1], v[ 5], v[ 9], v[13]); \
> -       G(r, 2, v[2], v[ 6], v[10], v[14]); \
> -       G(r, 3, v[3], v[ 7], v[11], v[15]); \
> -       G(r, 4, v[0], v[ 5], v[10], v[15]); \
> -       G(r, 5, v[1], v[ 6], v[11], v[12]); \
> -       G(r, 6, v[2], v[ 7], v[ 8], v[13]); \
> -       G(r, 7, v[3], v[ 4], v[ 9], v[14]); \
> -} while (0)
> -               ROUND(0);
> -               ROUND(1);
> -               ROUND(2);
> -               ROUND(3);
> -               ROUND(4);
> -               ROUND(5);
> -               ROUND(6);
> -               ROUND(7);
> -               ROUND(8);
> -               ROUND(9);
> -
> +               /*
> +                * Unroll the rounds loop to enable constant-folding of the
> +                * blake2s_sigma values.
> +                */
> +               unrolled_full
> +               for (int r = 0; r < 10; r++) {
> +                       G(r, 0, v[0], v[4], v[8], v[12]);
> +                       G(r, 1, v[1], v[5], v[9], v[13]);
> +                       G(r, 2, v[2], v[6], v[10], v[14]);
> +                       G(r, 3, v[3], v[7], v[11], v[15]);
> +                       G(r, 4, v[0], v[5], v[10], v[15]);
> +                       G(r, 5, v[1], v[6], v[11], v[12]);
> +                       G(r, 6, v[2], v[7], v[8], v[13]);
> +                       G(r, 7, v[3], v[4], v[9], v[14]);
> +               }
>  #undef G
> -#undef ROUND
>
>                 for (i = 0; i < 8; ++i)
>                         ctx->h[i] ^= v[i] ^ v[i + 8];
>
>                 data += BLAKE2S_BLOCK_SIZE;
>
> base-commit: 43dfc13ca972988e620a6edb72956981b75ab6b0
> --
> 2.52.0
>
