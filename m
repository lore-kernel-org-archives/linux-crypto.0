Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4A334B1B0
	for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 11:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763722917; cv=none; b=SNYLLEfnwoWHBeKyf/ONS3wRgmTVVjD2d6pDTkZLcpIRQLAhSYL93RkdUksKo4bT6nY0++N/IcghDIBiaufggpalHYm7IhmFQf46d42rvIXziymWvO1LusPNCWTrPXOxVMsnzq6UiNDRLFysnmYi7IyALBorFuF+eLf+5MAXqSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763722917; c=relaxed/simple;
	bh=fUR2dZWGeXYdflWi1EJrOGbwibtVMKcjjkkGc0eZf8k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ty+fH7JfhoYNFblUrxiNjlWQNKa22xuQ9LTjC8y2asbwr1g0IaA3dpR88FTRLjFSE1YNJLIri+h0SFX75S4bmRLK+j4XnCMMBqBNUTzRKNYPK+dWLWXSuJeXHc5aFqXyhS9kLwSJY3YbRMv8vrDWwaMEzmBE1QFdYEgo7mbprMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUAn4Nh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUAn4Nh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7ABC19424
	for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 11:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763722917;
	bh=fUR2dZWGeXYdflWi1EJrOGbwibtVMKcjjkkGc0eZf8k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DUAn4Nh4yEEF1B4BhFZlFUjGGAzWQ4R3GjIrYMW9DQLChdAoDT1z80mFkhLTo/Eov
	 15Q8R08f8opZP0YJgrbFUYlqTlaestLa5ONq++5Cyeb51tlLdz9Tx+cW+AHq4yPCnb
	 Zu2ve2JlPT1jHLWGPJQOIgTIda8LsBa7CJD+oEux72RPNvXL8geo6bpWgJHG1bmXRF
	 Mk2dcQoKBw6GnCxUSw2u6C2cMm5NIZcgprVupYi4b2oZchJwJoNsM4M5Et35YNYVIw
	 HZVZBbdSNhQBIFMX/eBvyHOdx2C2F3ijj8n7rrlYhAZVOm/fckyZE5OyA80madbsRL
	 Vq/cgWgTQenRA==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-37902f130e1so15243671fa.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 03:01:57 -0800 (PST)
X-Gm-Message-State: AOJu0YzpxLjgsJ/Ye6KFAfKq9VifTdXhIw29Rpv/ZkwZINBZdosXUN0X
	iZSMQTkVzudxLJiEJlVEW8gwDKiWhY6BjpwznJr1fyyjWx5X8WD15A4bLzzIAWIYX2YGDsH1wQG
	xtW1hdf5TcAcp4VylhUYAe9to6xFUkbQ=
X-Google-Smtp-Source: AGHT+IE8PvZG/EEU0CJJuznEMzImocV3vozaPVDhcwxvj/UZz9E6sY7fViKsVJS1vxTtvLqsx4c9plfAIWS9uXKT3gM=
X-Received: by 2002:a2e:8a96:0:b0:37a:2f61:5f19 with SMTP id
 38308e7fff4ca-37cd915445fmr4797801fa.2.1763722915740; Fri, 21 Nov 2025
 03:01:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121033431.34406-1-ebiggers@kernel.org>
In-Reply-To: <20251121033431.34406-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 21 Nov 2025 12:01:44 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGK8yV7FiddsWdK=UpJAJqUWp9ycyBLGDZp-WAd7=CRyQ@mail.gmail.com>
X-Gm-Features: AWmQ_bllZABLbKu1P9h-FGd-uBqMP8zYfjsbCvHUy1Ydz_VexvmkQuutfNAW470
Message-ID: <CAMj1kXGK8yV7FiddsWdK=UpJAJqUWp9ycyBLGDZp-WAd7=CRyQ@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: tests: Fix KMSAN warning in test_sha256_finup_2x()
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 21 Nov 2025 at 04:36, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Fully initialize *ctx, including the buf field which sha256_init()
> doesn't initialize, to avoid a KMSAN warning when comparing *ctx to
> orig_ctx.  This KMSAN warning slipped in while KMSAN was not working
> reliably due to a stackdepot bug, which has now been fixed.
>
> Fixes: 6733968be7cb ("lib/crypto: tests: Add tests and benchmark for sha256_finup_2x()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  lib/crypto/tests/sha256_kunit.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/lib/crypto/tests/sha256_kunit.c b/lib/crypto/tests/sha256_kunit.c
> index dcedfca06df6..5dccdee79693 100644
> --- a/lib/crypto/tests/sha256_kunit.c
> +++ b/lib/crypto/tests/sha256_kunit.c
> @@ -66,10 +66,11 @@ static void test_sha256_finup_2x(struct kunit *test)
>         ctx = alloc_guarded_buf(test, sizeof(*ctx));
>
>         rand_bytes(data1_buf, max_data_len);
>         rand_bytes(data2_buf, max_data_len);
>         rand_bytes(salt, sizeof(salt));
> +       memset(ctx, 0, sizeof(*ctx));
>
>         for (size_t i = 0; i < 500; i++) {
>                 size_t salt_len = rand_length(sizeof(salt));
>                 size_t data_len = rand_length(max_data_len);
>                 const u8 *data1 = data1_buf + max_data_len - data_len;
>
> base-commit: 10a1140107e0b98bd67d37ae7af72989dd7df00b
> --
> 2.51.2
>
