Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213CF3161A4
	for <linux-crypto@vger.kernel.org>; Tue,  2 Jun 2026 02:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780365869; cv=pass; b=FxRDCV7doQcnGayX7ChEuHcT7M24rUT2wNTwWmx9ZK6lTepgSQz851Ccf+P+v/POfWXIzLynLGzFC8sOLHdk2x+F5idVvYaC7Wf7Www6I+zH+N0HOJ4x4bTejqAfQ9AqHla9oLSwqt1T+JKdkFlexiOw/5/bzTrgPq3gJqenJI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780365869; c=relaxed/simple;
	bh=D8nKvS+RV+R8745DEd2/iRZ/c5x5LdOpY38S0WtDztU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RQBKL6BMW4hEiwu1g/54axP1K/8W3xfA7etdpxoQjwjxPnR5bcR9meMsDwta7dkl74bTPXV0HeLjAUhoOUHV9o2D9r4iaXEjV9GB9q5KMe292ZO/u6dhoNJB0urzFeZdnoJtLA7XON+JeI9KScyOT8kal5IbINAQ0ofABItI1ag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i4wUH/uj; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i4wUH/uj"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-68ca6f01079so2942609a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 01 Jun 2026 19:04:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780365866; cv=none;
        d=google.com; s=arc-20240605;
        b=RecjJXBbTjKCehAuWRtEFqpmBwWgm88cU+CJMGzmOEvLm4BTxFJHshZiTWJI0N7u2a
         BmLQL9mheOxR+4QU2xHbuP9ovUkB3wCn+XtH63lvBczN0qca+TCe0MOR9b1ft2tRuG9d
         C9GHbSJs2k3kqvQNTqp56dQmrpawhf9XuCjbTqWrLYS3TcmWe0hvNEj0e2aC/ydTFPYO
         GNb7xNaeZsZLG83n6Q+lC3SYiJtyhb1rWLfZs91JYeVgrnyztVKgVAE891SqxQkW3FXC
         nizN2/8zmvWXQoaC+CHA3u5R6XfZ6hHMEeCQgySFQ95ydfTGH5TQkTi9qUUVchEQVJQc
         6CjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vYg3HI0Jzsg/8U5OZpHehoZL3WY5c02jIZrh5L5mgRQ=;
        fh=cFrSywvrO56GI0X7qV4M9Bi0Spv/g0V39ESd3dkxWuY=;
        b=WHT64zgUwJe2m/oSSfXkLvBB5ttu/f8bqE4ARqGKeKtXnaroMIpGtzfiv3+XmYxfxB
         RE5zY68mIunYouS4wJB+9iyTkAudkjzVB3Irl8BZ4XRP7gPSV9l0rg/p0FH6Z3ITr9SN
         DZPwwOAwNO0e36mUrzmaS9tl7CDWQiv+V2dnMGMnaJzFtz3IoYBI0a1ydrzHLMofiEZM
         P71IbQQPJJm7i3l3DIqF4xNqEjG/J+lAYInbdNZio2SxeCZDA28Z9YYX2oBfmkSEg49l
         HDyqlz7q8PJW5AMulSZ9qPJXeCWDrk+0ScO+P3NWJVcwdqVNIX3j+i60w05VukKZYbJm
         2xKg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780365866; x=1780970666; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vYg3HI0Jzsg/8U5OZpHehoZL3WY5c02jIZrh5L5mgRQ=;
        b=i4wUH/uj0G5owcOGPMC/+BW3dcJa+FQloqLMfnEQ44w3Khaum9Ke9ZouQOZteySEEz
         IQkn5V2vOAkWnpHGoVm0+L/QuhaMmQekIzFH8pVR9GCDEVhgy7kT8Lif9g9JzyvqgUGP
         WH3spk7ZXHPgYw7dqHFtpJePlefdBMAjSAh1/AqESF2XyJpw/Q+/JFWChdPekotmN2IL
         hPl/9B145iNcA5lpGFJ3zdK9sLx6YxxVSeiMl60PA0KGuOOC03uixHWwJi3Ef27YNYW+
         OviRrbnAK0s+u2JaSfwp3lLQu8h+lk7XbyNrPjKGMJz5e9nV52Im+syywu6WjK/hA1QF
         qSFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780365866; x=1780970666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vYg3HI0Jzsg/8U5OZpHehoZL3WY5c02jIZrh5L5mgRQ=;
        b=Dpf9P9bHtn5OI6LUiDhP8vyVo5JFrKFDW0KBI08fUFrEhPHvTAEvkiUfZ5kUTlqug0
         lhL3e2vN7Whx8CEIiKhuMuRkkzm+KYge2Pg/W0IjKugjSgs7se2wb8ehBn3C0nNaEf2S
         wCL9SUf+4zqHIHc1Ve/e/dNqW2lO8tplgcri5G05oSU39QrHzNXiHOTXVaNv3UQpVI/1
         xbbAucZntuaZfyIyN5tNJIFeXllHyN5JsIP/1OTcL1a802IcuwEWlh7PpKvrOxNvjcSs
         86EBqMVtRujYIfsBsdfVgXShVHCHyTt04H3PzY7pe5K54Uo9IemofIAWNL4IhcNEvV9/
         tFtQ==
X-Gm-Message-State: AOJu0YyMM59CykF9u40HaWZfTs813BuQ2BVwYqwAYCDpuj3vTYwiy0LM
	UeQUvKtyoJEFzSxMrShpC20bs/2SdwMwsjEYGzn1rSAjMSHofd4zghvUsPx5vHoMKfTUrpSWmBN
	SzufEFNUhL1xjaMHf53uOGYYZfPZVYlT47g==
X-Gm-Gg: Acq92OHVOJKBaUOtODowyu2xCw4r+smUwouTiq2AEig6GH6E0UOO5pdlt7d1uiPm1DR
	4sw6nEAXMB/0+o+XwG2ggrHY9gZTIKRPfkcva2IQQ3QooYnyJy6Vu9x0481yffhLAsMzCk5BSsX
	txJcR0jDYwJASYKQ0XeCV29KBtImST24rQgrL+MQJ8z927vMvKBuaanHyrVD8H6lgnHxoNFnoio
	QjmE13yF/j4y54puFgnYNQElG8gLlyAtfNO9tCPAiblT7LhkoP1DwQn1QJ/Qtm1cjQNIy4rsGTx
	qEDwg3mkO98jrSdmMHCW8AaRHCf6Z8zN3/SCzVfFh8RVt2xgXaztrzJaogZMk1mWK3DtGs6aG5n
	Rs0Zzy5G9bDfYASswPCMLMsL9p+YGciO6pCLDsLdQflVXR1NRiOEAPaIimsJkP7vgDyHu
X-Received: by 2002:aa7:ccc3:0:b0:678:7da5:2346 with SMTP id
 4fb4d7f45d1cf-68c8d1f854dmr4849891a12.25.1780365866332; Mon, 01 Jun 2026
 19:04:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260602014553.522044-1-rosenp@gmail.com>
In-Reply-To: <20260602014553.522044-1-rosenp@gmail.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Mon, 1 Jun 2026 19:04:15 -0700
X-Gm-Features: AVHnY4LLVFveYYkOdaruz-pKM48AD8XVKCn6mOnqNbT7SXNihAyYGkaRQlfdJDU
Message-ID: <CAKxU2N-3R-sug+CjwWw5oMmuip7fp2KRYgrYirvPPuH76KvLOA@mail.gmail.com>
Subject: Re: [PATCH] crypto: amcc - check ppc4xx_trng_probe() return value
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 1, 2026 at 6:46=E2=80=AFPM Rosen Penev <rosenp@gmail.com> wrote=
:
>
> ppc4xx_trng_probe() can fail for several reasons (missing TRNG node,
> iomap failure, allocation failure, hwrng registration failure). Change
> its return type from void to int and propagate error codes back to the
> caller in crypto4xx_probe() so that probe failures are handled properly.
This was prematurely sent. Please ignore.
>
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/amcc/crypto4xx_core.c |  5 ++++-
>  drivers/crypto/amcc/crypto4xx_trng.c | 12 ++++++------
>  drivers/crypto/amcc/crypto4xx_trng.h |  6 +++---
>  3 files changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/c=
rypto4xx_core.c
> index 0f1b2653769c..596a90af2c90 100644
> --- a/drivers/crypto/amcc/crypto4xx_core.c
> +++ b/drivers/crypto/amcc/crypto4xx_core.c
> @@ -1346,7 +1346,10 @@ static int crypto4xx_probe(struct platform_device =
*ofdev)
>         if (rc)
>                 goto err_tasklet;
>
> -       ppc4xx_trng_probe(core_dev);
> +       rc =3D ppc4xx_trng_probe(core_dev);
> +       if (rc)
> +               goto err_tasklet;
> +
>         return 0;
>
>  err_tasklet:
> diff --git a/drivers/crypto/amcc/crypto4xx_trng.c b/drivers/crypto/amcc/c=
rypto4xx_trng.c
> index 031dd2bf8598..f762f92dd03e 100644
> --- a/drivers/crypto/amcc/crypto4xx_trng.c
> +++ b/drivers/crypto/amcc/crypto4xx_trng.c
> @@ -68,7 +68,7 @@ static const struct of_device_id ppc4xx_trng_match[] =
=3D {
>         {},
>  };
>
> -void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
> +int ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
>  {
>         struct crypto4xx_device *dev =3D core_dev->dev;
>         struct device_node *trng =3D NULL;
> @@ -79,17 +79,17 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *=
core_dev)
>         trng =3D of_find_matching_node(NULL, ppc4xx_trng_match);
>         if (!trng || !of_device_is_available(trng)) {
>                 of_node_put(trng);
> -               return;
> +               return -ENODEV;
>         }
>
>         dev->trng_base =3D devm_of_iomap(core_dev->device, trng, 0, NULL)=
;
>         of_node_put(trng);
>         if (IS_ERR(dev->trng_base))
> -               return;
> +               return PTR_ERR(dev->trng_base);
>
>         rng =3D devm_kzalloc(core_dev->device, sizeof(*rng), GFP_KERNEL);
>         if (!rng)
> -               return;
> +               return -ENOMEM;
>
>         rng->name =3D KBUILD_MODNAME;
>         rng->data_present =3D ppc4xx_trng_data_present;
> @@ -103,9 +103,9 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *=
core_dev)
>                 ppc4xx_trng_enable(dev, false);
>                 dev_err(core_dev->device, "failed to register hwrng (%d).=
\n",
>                         err);
> -               return;
> +               return err;
>         }
> -       return;
> +       return 0;
>  }
>
>  void ppc4xx_trng_remove(struct crypto4xx_core_device *core_dev)
> diff --git a/drivers/crypto/amcc/crypto4xx_trng.h b/drivers/crypto/amcc/c=
rypto4xx_trng.h
> index 7356716274cb..7c6f426ab275 100644
> --- a/drivers/crypto/amcc/crypto4xx_trng.h
> +++ b/drivers/crypto/amcc/crypto4xx_trng.h
> @@ -13,11 +13,11 @@
>  #define __CRYPTO4XX_TRNG_H__
>
>  #ifdef CONFIG_HW_RANDOM_PPC4XX
> -void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev);
> +int ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev);
>  void ppc4xx_trng_remove(struct crypto4xx_core_device *core_dev);
>  #else
> -static inline void ppc4xx_trng_probe(
> -       struct crypto4xx_core_device *dev __maybe_unused) { }
> +static inline int ppc4xx_trng_probe(
> +       struct crypto4xx_core_device *dev __maybe_unused) { return -ENODE=
V; }
>  static inline void ppc4xx_trng_remove(
>         struct crypto4xx_core_device *dev __maybe_unused) { }
>  #endif
> --
> 2.54.0
>
