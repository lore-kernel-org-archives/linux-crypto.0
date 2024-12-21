Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846F884A35
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 15:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734795955; cv=none; b=ScMEpAVi6DrdCTriGaVlIslXMn2vR4rz36x8G2DaUHbXY3WADtEJd6IvHDi29uUjIBuwpDOuvjx/ant1GEVJZVF9Gh2RdYqd3oxoM6hT5xFB9lJky4Uq8kyOv8RVAxHWY4zm5wxl2ymmWdrKrJGjEpE8YWzVwrC8S8OEe5o1PqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734795955; c=relaxed/simple;
	bh=LWtaK4qwpS4fOdvZaEMaXsWW7BOcb8fhebKHOXQQ8As=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l8+qlMlkrrifjOv70PZAbKhiHADT8V5sy7oZrmvWc3q32+rEojpo2Ok5UPgTrCGkvXT2/1ZOarTvL3pttQfTPXeJkCeRFpDfYB9gafRE8l9se4u7cN5P8/4rlLyX2l7DOyvdoeN3AkVAk9q/EzVZkESnigsP/3K31F7QBuK2jys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vdw04p2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vdw04p2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE22EC4CECE
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 15:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734795955;
	bh=LWtaK4qwpS4fOdvZaEMaXsWW7BOcb8fhebKHOXQQ8As=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Vdw04p2ynUuHZQka4A5kDIWbLGGzeEZckEJ58oNdtkicPN3OcrX6wPbVOZefLBfkK
	 F/AS+V2VutMpPwuHONAXVROiV59SbRdV9v6J6aOzeXcNgS6KYKzgwRWZ+MGyXfAdpG
	 huYy4o+PHjxNmvxxKS9SLL+TWCxqnzU/0aPvIrScBPPZeCj8j+2nH2Fa+nkhdc1/8O
	 YoqP++oWaVL9a/7qUppGQY3EUElYnVitMS/hbUiQqLwgbMp/OzKpfP/S/U0N+GUSHz
	 QD4fJ9nb263X9mvFAU5UK09rsBQ/2jiUdl/rjvI8WRYnAAFtGMCcd4QE4+zN4RjovH
	 9QPD4DV5tn90g==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-30039432861so29611281fa.2
        for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 07:45:54 -0800 (PST)
X-Gm-Message-State: AOJu0Yy/GxjmwiYIR9fvYSy+b3x+DwIUzIeif431yyqqpdJ3RItePQwP
	WSXl2lDy3yTPQJJMsA2ixi2v+qj/gX2IFHZm/WPqrLs192ndV/PaSy1Yo5RMGZKIuKUK8hHVbG0
	TiMA6dCkpjkoZ0cPtzxkZun7yBI8=
X-Google-Smtp-Source: AGHT+IHBigSMOffzM0tS+oKPMi0M8MwcxNSEHuXVEXHiU9kUsge5sG8tWfGFRs1myMtw+sIFt7P1SBfOkDxjKucxzCI=
X-Received: by 2002:a05:6512:334d:b0:542:2999:2e54 with SMTP id
 2adb3069b0e04-54229992e56mr1616424e87.12.1734795953310; Sat, 21 Dec 2024
 07:45:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z2bWK_JKxKvwOpTM@gondor.apana.org.au>
In-Reply-To: <Z2bWK_JKxKvwOpTM@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sat, 21 Dec 2024 16:45:42 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFJ1Wj8ca-XNcxaWnoeu=ujVbBM-E1f+XhPFfoJRYc4vw@mail.gmail.com>
Message-ID: <CAMj1kXFJ1Wj8ca-XNcxaWnoeu=ujVbBM-E1f+XhPFfoJRYc4vw@mail.gmail.com>
Subject: Re: [PATCH] crypto: lib/aesgcm - Reduce stack usage in libaesgcm_init
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 21 Dec 2024 at 15:52, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> The stack frame in libaesgcm_init triggers a size warning on x86-64.
> Reduce it by making buf static.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/lib/crypto/aesgcm.c b/lib/crypto/aesgcm.c
> index 6bba6473fdf3..902e49410aaf 100644
> --- a/lib/crypto/aesgcm.c
> +++ b/lib/crypto/aesgcm.c
> @@ -697,7 +697,7 @@ static int __init libaesgcm_init(void)
>                 u8 tagbuf[AES_BLOCK_SIZE];
>                 int plen = aesgcm_tv[i].plen;
>                 struct aesgcm_ctx ctx;
> -               u8 buf[sizeof(ptext12)];
> +               static u8 buf[sizeof(ptext12)];
>
>                 if (aesgcm_expandkey(&ctx, aesgcm_tv[i].key, aesgcm_tv[i].klen,
>                                      aesgcm_tv[i].clen - plen)) {
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
