Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5469821C167
	for <linux-crypto@vger.kernel.org>; Sun, 23 Nov 2025 08:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763886692; cv=none; b=HY09DF8j1EnRw9x7Myd0vt3jNOHN76FxpoYQoYHcxv8tvhG8+f7Y6jwD7WXihlbP1+LepakKtWSu5voyqYKf4r6TNFbZRfpvN53Oi/owA6131jFf4YVmGKO1Zr/FGQbzEfi69b2jw4/Cj6tCCps/Ba79+0k29Xwgiuu4LJk9RTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763886692; c=relaxed/simple;
	bh=WDd4mnT/mfusSNDmVC85VbsfUdt8ta0On2QPDJmZMao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AiQsmLsqQI04TPn3re4rkg23uHl/vgFvbZeRNhSBJtlZXKL8yydeY3y0g8oH+98td+A+37GZTaFuiQEEM/LzCAk9R11jeWwl88O39UHr4IMr3nDAQ/5NQgrnry2/Y6kENdKhp1738240Se9x+3JytmzRGgdSsOTnUsU9BAHZnmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XAffUSQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XAffUSQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA442C4AF09
	for <linux-crypto@vger.kernel.org>; Sun, 23 Nov 2025 08:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763886691;
	bh=WDd4mnT/mfusSNDmVC85VbsfUdt8ta0On2QPDJmZMao=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XAffUSQvhtwAfPz2NooiS1PtwVIIdQ/DrI3Dqv7n5N5I8VHI5yFsQeFznhgihATtq
	 saAHCaxE+dhYGYT7vaGIa7xP57XEXGG8q1aTqsQcJ+EsBHh360IoYXRdY9DaJ6o1BX
	 HsBIq6/8VFY5tz3295nvpf8yWSLgkGojv4u42BisZiJj5oNU48so9RoD9gM3hVMtp0
	 Tx6BQ6+tPDzpKO49VOm45HXmU+DD9QQkLuD1eO7e7XxiH7CmF1y0KkdiTGn8VueAm4
	 l7tVM5lUi6G0q/N4ow7Mo3DSfCE3Q7F1THdY3lN+iT3h+B8Jh5ZmxHpu4orZQgNkZ9
	 9W4YOYAwJBKZw==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5942b58ac81so2366672e87.2
        for <linux-crypto@vger.kernel.org>; Sun, 23 Nov 2025 00:31:31 -0800 (PST)
X-Gm-Message-State: AOJu0Yw9JtgD6LAssVh5oo1JWgs18oAw1StR3Xp0Bf0Qepji1fu+2xm5
	6sUyaqz+vEHxosJzWPCqXneQPyM3gsPp3//AYfQ4ne0LNBWjRE4nIqJiWaramu8mSr9Uhv+6HO4
	Os7owzleJP23xAbII1suFnkDbcYrMslY=
X-Google-Smtp-Source: AGHT+IEgrVLozqpqe8xl39FIoM2yksgsu0OWvLog5nO6RU9u03/UaGvlNPgvrpenmimekZmhUETgtp5lS1Yn9sjb83w=
X-Received: by 2002:a05:6512:b1a:b0:594:2639:d0fe with SMTP id
 2adb3069b0e04-596a3e98394mr2342577e87.8.1763886690268; Sun, 23 Nov 2025
 00:31:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251122194206.31822-1-ebiggers@kernel.org>
In-Reply-To: <20251122194206.31822-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 23 Nov 2025 09:31:19 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFSL9=TWzv35mSwVMVaKAQ=3n=w93=1+VSfKyDe+0A+Ow@mail.gmail.com>
X-Gm-Features: AWmQ_bkZFlS1YpPoKvELIeMcBpgHR7-QOmEumch6Y7C43Xtev5VqTahg4G7dLMU
Message-ID: <CAMj1kXFSL9=TWzv35mSwVMVaKAQ=3n=w93=1+VSfKyDe+0A+Ow@mail.gmail.com>
Subject: Re: [PATCH 0/6] lib/crypto: More at_least decorations
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 22 Nov 2025 at 20:42, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series depends on the 'at_least' macro added by
> https://lore.kernel.org/r/20251122025510.1625066-4-Jason@zx2c4.com
> It can also be retrieved from
>
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git more-at-least-decorations-v1
>
> Add the at_least (i.e. 'static') decoration to the fixed-size array
> parameters of more of the crypto library functions.  This causes clang
> to generate a warning if a too-small array of known size is passed.
>

FTR GCC does so too.

> Eric Biggers (6):
>   lib/crypto: chacha: Add at_least decoration to fixed-size array params
>   lib/crypto: curve25519: Add at_least decoration to fixed-size array
>     params
>   lib/crypto: md5: Add at_least decoration to fixed-size array params
>   lib/crypto: poly1305: Add at_least decoration to fixed-size array
>     params
>   lib/crypto: sha1: Add at_least decoration to fixed-size array params
>   lib/crypto: sha2: Add at_least decoration to fixed-size array params
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

>  include/crypto/chacha.h     | 12 ++++-----
>  include/crypto/curve25519.h | 24 ++++++++++-------
>  include/crypto/md5.h        | 11 ++++----
>  include/crypto/poly1305.h   |  2 +-
>  include/crypto/sha1.h       | 12 +++++----
>  include/crypto/sha2.h       | 53 ++++++++++++++++++++++---------------
>  6 files changed, 65 insertions(+), 49 deletions(-)
>
>
> base-commit: 86d930bb1c19ec798fd432c5b8f25912373c98b2
> --
> 2.51.2
>
