Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92854A4154
	for <linux-crypto@vger.kernel.org>; Thu,  8 Jan 2026 11:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767871161; cv=none; b=DhMY2xui4xhr6X1efxmyqPT/aiGuB5hz3h8nDpGYGNued9CDc/hR1aqjRGbv881916tet2itiGU7SFqhX8NtW0UldMUreG28DqBDkUBbB1n5ft0UhbXIY1GAI3z9CPIJlTK5M7Tb04sGvqGe8Nh/EA5lJxvauYfxkggvR3phRwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767871161; c=relaxed/simple;
	bh=HcZkxh8oUR6R4IPWY9mg6EQFirGkv4mv4d16ug+zMMo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=As8dPpP/7zW/FVO1cN/ObDsTTdkMnif9RwoTyVSi1+SfU5qAdkCQ1X4YCaEgDUIBd9zW6z+j6RXHUQ1v+Ap3ctL0HCs5pwIp62f0bGRn1cFx917JX2/mPc1Z4WTwrUhHXkjAOiFnEJsfDyZjjTvbSZMidFQLOJfXvVF5llOynd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXz4tjEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXz4tjEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAC8C19424
	for <linux-crypto@vger.kernel.org>; Thu,  8 Jan 2026 11:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767871161;
	bh=HcZkxh8oUR6R4IPWY9mg6EQFirGkv4mv4d16ug+zMMo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pXz4tjELQ2b0XE7huzKy1IjXEqMQUy8H4nnivl+CeBJtvo0U11HH1zRFSlX0wT4MM
	 iWzX793GM4zVI3dcJzAiAAysgXJbW2KR5QyGs+TaON4UCSjPU6Tv8QJkO4UkxoVfnx
	 pvXE6YE0d58j5dFHchTk+fCBs2BgJ7OsWv0lZHBtcckXaDFfsj4oQrvlTydCWDlsIh
	 /w0raeKh1opeIg7ug3F4Ke6vIle25fN4SjZ8JFc26DDoyopGnAgIHvvS1FPTGjqrrU
	 9vFjJZ41+uKxcUhCvwvTzKcP6wNfbeOYiSED8ystJxsoExh7SCrJkFLkLq6cNodE3d
	 5htcY05Y6p1fA==
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-34c708702dfso2032029a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 08 Jan 2026 03:19:21 -0800 (PST)
X-Gm-Message-State: AOJu0Yzjo1Ffg9EO0AKIDUZib/SNGzdEgmXJmX406AaFw4KWb9mPJyoN
	YUKcHzfimiVqBpqSxEjpj3DM7P1KnRB86zc5QSU/3t6pj7CPmq3YTHGlHYsB5ubVBVyfUaYA/pq
	v3IAooYpvgKc/t5lV9iJg4X7Nxh4CaTw=
X-Google-Smtp-Source: AGHT+IHejcWTbI1yANyDoNP1uKqjrifLJ5oaExqhHccCohbl7Zxq+NgqaLjAx6/EO65SPs3XIUmUgYV54HbTD83grv0=
X-Received: by 2002:a17:90a:fc48:b0:340:5c27:a096 with SMTP id
 98e67ed59e1d1-34f68c023d4mr6012737a91.6.1767871160604; Thu, 08 Jan 2026
 03:19:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107033948.29368-1-ebiggers@kernel.org>
In-Reply-To: <20260107033948.29368-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 8 Jan 2026 12:19:09 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEZ36WjQ7Pcc7H+DCdQU6Nrx-jvFKq-72WmEPtzJRMGkQ@mail.gmail.com>
X-Gm-Features: AQt7F2oSsFQLuM6ESwWtoJF4MFRXOesXonNNQzR7GVU-wX8XjLvK1nMwabauCK4
Message-ID: <CAMj1kXEZ36WjQ7Pcc7H+DCdQU6Nrx-jvFKq-72WmEPtzJRMGkQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add test vector generation scripts to
 "CRYPTO LIBRARY"
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Jan 2026 at 04:40, Eric Biggers <ebiggers@kernel.org> wrote:
>
> The scripts in scripts/crypto/ are used to generate files in
> lib/crypto/, so they should be included in "CRYPTO LIBRARY".
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is targeting libcrypto-fixes
>
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 765ad2daa218..87d97df65959 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6703,10 +6703,11 @@ M:      Ard Biesheuvel <ardb@kernel.org>
>  L:     linux-crypto@vger.kernel.org
>  S:     Maintained
>  T:     git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-next
>  T:     git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-fixes
>  F:     lib/crypto/
> +F:     scripts/crypto/
>
>  CRYPTO SPEED TEST COMPARE
>  M:     Wang Jinchao <wangjinchao@xfusion.com>
>  L:     linux-crypto@vger.kernel.org
>  S:     Maintained
>
> base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
> --
> 2.52.0
>
