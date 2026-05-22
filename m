Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B57229B18
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 02:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779418344; cv=none; b=OgLtnjDFcJ9zgCbdjS+ngm7rdZS35AUsP5tacuOPeg19vestsUz8kS8abBTLqb0jWMBhPTnOxo6FsOXQ6iLa6rv8pQnbkQ3SV9T4L5mxwkXvHdgogWagdimVKGfkY34SVSx7AuzyauVcy1FpQRZsNzKE0vWBfkpZ0L1oqoc1DeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779418344; c=relaxed/simple;
	bh=ox6bxPIZcQ9pA2poXV11dQdhfB6hdnT42WTbPpl769k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nGAeiqWDJ7aXxH746sCrL8zlLGH2ZLiuWkWwfP9AV0zQBehnnv9xRnDBlkRYPa0ihR0u+xvFOtMK52JzV7WHO62yCYcq0dBMjSDG8q/fxJ8lX1y9TYDf1HkIVdFsFRrInhT3+5j64MVPaXWxmjv28RmUGiw54kBgboZKxs02Z4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ii4G48o2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ii4G48o2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E831F00A3D
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 02:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779418343;
	bh=add7O784fB7u3KgFvBd8EhJRw2Ch/7z+5srxbj+5fbU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ii4G48o2zZI0d+oJlEwHvSxRmvlU88HXjsXH6k5Z8BAkXNvanS+hWZTiP0FmlqNnd
	 0GMLQaQQcqxbMvo6e9tqFjBPe6bb17QES5OzuI/nJxp6yDfeou9tEfmiYWOoJmctWm
	 XWV7zMWD2ZJ6HJE/LaqVDv4HN34aYzyZlLescXqFd4aJIh4SggNK5gl2JQ9tY6k4gn
	 T6ha1XiYcQDBRm5XF6vxK5oRB/0BoVpfTSyAt1wklhmA0NTPOfSORvKmr2ACzTuVxL
	 25j95+UXnrHGI5jioLLVtli9pHDrazqSmjYcaZBIwttUIt/nw9Tlt1BdE/9QH5vruh
	 kwXmnM9kRX+nA==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bd6460b0d11so1214407066b.1
        for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 19:52:22 -0700 (PDT)
X-Gm-Message-State: AOJu0YwXfkNWoiUIZ4RVK85r/06nvGmdi9g+DCM2Q6Ot04aMtne1NGea
	wMpGqIIJEJjYaAmHoEiOFpqM0rdSHVusj2PwH0nwfFdM+td+AyMJ1aeFHeDrZ1FhVc643WqlWmD
	E+mZXCsZ3aphM81mTP2buPSnHU2oHuV4=
X-Received: by 2002:a17:906:fe02:b0:bd3:1a18:cc64 with SMTP id
 a640c23a62f3a-bdd2580c51cmr104098866b.31.1779418341722; Thu, 21 May 2026
 19:52:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260522022525.12976-1-ebiggers@kernel.org>
In-Reply-To: <20260522022525.12976-1-ebiggers@kernel.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 22 May 2026 10:52:42 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5cDnWKxBobwRErRyvG8671e6VXsBe6w1RkX9rfn7CVFA@mail.gmail.com>
X-Gm-Features: AVHnY4LY-TOi84C9U6iPkvfzojtdl72PfdB391W9bREXD-FyusIkwq7iXYp_NFY
Message-ID: <CAAhV-H5cDnWKxBobwRErRyvG8671e6VXsBe6w1RkX9rfn7CVFA@mail.gmail.com>
Subject: Re: [PATCH] crypto: loongson - Select CRYPTO_RNG
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	Qunqin Zhao <zhaoqunqin@loongson.cn>, Yinggang Gu <guyinggang@loongson.cn>, 
	Lee Jones <lee@kernel.org>, kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 22, 2026 at 10:26=E2=80=AFAM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> This driver registers a rng_alg, so it requires CRYPTO_RNG.
>
> Fixes: 766b2d724c8d ("crypto: loongson - add Loongson RNG driver support"=
)
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202605201622.qWOiiZTV-lkp@i=
ntel.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>  drivers/crypto/loongson/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/loongson/Kconfig b/drivers/crypto/loongson/Kc=
onfig
> index 15475da8fc11..f4e1544ffbb4 100644
> --- a/drivers/crypto/loongson/Kconfig
> +++ b/drivers/crypto/loongson/Kconfig
> @@ -1,5 +1,6 @@
>  config CRYPTO_DEV_LOONGSON_RNG
>         tristate "Support for Loongson RNG Driver"
>         depends on MFD_LOONGSON_SE
> +       select CRYPTO_RNG
>         help
>           Support for Loongson RNG Driver.
>
> base-commit: 6c9dddeb582fde005360f4fe02c760d45ca05fb5
> --
> 2.54.0
>
