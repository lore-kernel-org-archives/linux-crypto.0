Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2931D192D9D
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 08:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742113257; cv=none; b=qas5Etsx0oG8uWCf+1puoHVyrRKmUuYVq4W4NcdEmTvyzfHWEMUagzud+EeYcZKCUkieWoiwVJRUiqAaOnsOvIQJoHwv1vNCQ/TFDPGPek4LxCe0eY7x9X2CNMFGKUa3KkRmoZPzyjvdfDDggbBFCJfp8oyaSldTEGLGWo2zMrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742113257; c=relaxed/simple;
	bh=Jm+Ix2B6MpLBrSpXwr6f+vw+gn8DZoeKcO8/7Y6UNs4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c0J74fI1/JQIsUdWHsA1P09n8ABe6cn8yHc1BkN0x/rIOg6wfnhgLp63UEd/+6brIfbZg1mJa53B0MIrd90ZoqdX7wriz7bzwud2+kzpxJqAwPHvvSkDVADUxNCfYAzCa9u5yGZP42FogWefeNXxYYfhzFEAR9NjE8xZAPQ4Rtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jab5uOZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jab5uOZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C77C4CEE9
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 08:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742113256;
	bh=Jm+Ix2B6MpLBrSpXwr6f+vw+gn8DZoeKcO8/7Y6UNs4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Jab5uOZJU6pB29WjwHO9EzWBYe8X6JdLQl4LMrBvyL83MXOrBlmuNOce0okZVcBrj
	 GDiWFYxs0sYQ6TIsTZYfHEolggGIEQFyZ/JD8KiZx+FTTcbNve7yovaWWoBjgCTlWe
	 R8K1WGb9Hv4Y4PlzUkosNWZD8EeZfbsfPrPyinM7s33qD5m9jRfvB0+q5TgS31/9u1
	 wdENInjBFf0ZX7vV0cfjmcm1xCXscyWoKbBlMl4iPnsx22kqCdP7y0l6ahVYfjKMoe
	 XIjipdFCVs/bV3tUg8ansY22ceed5WGxzpl8mVy8JMzRCAA6B3/lYTgCTBjJR8XgpQ
	 OUjDYw6RsFHog==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-30c416cdcc0so32392371fa.2
        for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 01:20:56 -0700 (PDT)
X-Gm-Message-State: AOJu0YwqeHBSQg/PbsDjxA6wr5bfhHXynFyjj8fr0k6P5NG8gVdJrsqm
	V56xqvF9vfHEXwyGrdrOTthw7JFUCUW/MD5K7HyYWXPsWMb+GG8tbTIpohkosswJ6QOJZFK2SBq
	csVyyMdKyCOTu7k5mWZ+YbpkrJbQ=
X-Google-Smtp-Source: AGHT+IELca3t8iur2hJNI1Yq0PpkH+NJF9Qf8KId2MJWPqxgmrddw82q6WbLJkMsCZPaGe28MHkYBM3whvoueEo9mxQ=
X-Received: by 2002:a05:6512:4029:b0:545:5a5:b69d with SMTP id
 2adb3069b0e04-549c3908614mr3464393e87.31.1742113254942; Sun, 16 Mar 2025
 01:20:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z9V0kBchZ8N8JG9n@gondor.apana.org.au>
In-Reply-To: <Z9V0kBchZ8N8JG9n@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 16 Mar 2025 09:20:42 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFtCoZSHmDJpwtJJqhkORHLyiVTiB-Q+u9_txwPoPfrLg@mail.gmail.com>
X-Gm-Features: AQ5f1JrEAeYAnKsLN2tpFTowCOuYAvIK3q9a1pyGbvl3Bd8I6c3BICzbdaIPrDk
Message-ID: <CAMj1kXFtCoZSHmDJpwtJJqhkORHLyiVTiB-Q+u9_txwPoPfrLg@mail.gmail.com>
Subject: Re: [PATCH] crypto: scompress - Fix scratch allocation failure handling
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 15 Mar 2025 at 13:37, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> If the scratch allocation fails, all subsequent allocations will
> silently succeed without actually allocating anything.  Fix this
> by only incrementing users when the allocation succeeds.
>
> Fixes: 6a8487a1f29f ("crypto: scompress - defer allocation of scratch buffer to first use")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  crypto/scompress.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/crypto/scompress.c b/crypto/scompress.c
> index dc239ea8a46c..57bb7353d767 100644
> --- a/crypto/scompress.c
> +++ b/crypto/scompress.c
> @@ -159,8 +159,12 @@ static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
>                 if (ret)
>                         goto unlock;
>         }
> -       if (!scomp_scratch_users++)
> +       if (!scomp_scratch_users) {
>                 ret = crypto_scomp_alloc_scratches();
> +               if (ret)
> +                       goto unlock;
> +               scomp_scratch_users++;
> +       }
>  unlock:
>         mutex_unlock(&scomp_lock);
>
> --
> 2.39.5
>
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
