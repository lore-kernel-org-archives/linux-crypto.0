Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62908200120
	for <linux-crypto@vger.kernel.org>; Tue,  3 Dec 2024 20:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733257648; cv=none; b=IdeWYPWKeEuT03mMUKVP0ZTtV6YJVnTyS+jNDmn4D8FXHGcTlHjOfzOZv+SXvxfQfX3JaXKqIjUpkNYDROni56MI4IT8PsIbSUXOQCHDPKOdQndWRpl1AoXQm+rFQYTQ302sf4j84ZT4lHJX/ZREij/DBZZoMYGoXirIPJZTRfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733257648; c=relaxed/simple;
	bh=0nDNLU0QqS5naP5m8r89FpLO0RTYBNZNYYgROoCW2E4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RyJufET/gAUGVinLp5N145OOK9vusRoplAzcelgZjIizKpWVKwuDBzXfjFD4oGdDgR+MghryFBqpP0ORxpd2ZZLOLjqf+9pPTimotMfYvO3631XcGDnjVcJEJpu2O7zEWzeBzN8LfTzXHslAtdK4LlJLxHt+g5CQ0cX4k947p9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=nNiAQJL4; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="nNiAQJL4"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-53e152731d0so167276e87.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2024 12:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733257644; x=1733862444; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7mYLgWRx19EhLntfJHR6XQME2VsuqQ9Oja4sZu+CCPU=;
        b=nNiAQJL4p+XXcPHhKsKcXMuphD045MyRDvwWnS9DrTSuLUN6ICTydZFDjwW0NnAqEY
         cipiFgIXuYy7LiQ1auwrxAsLmFFBEEyCnRfEd/ekA8+Dkx7lrYm+YEllUxFjQZWRk9hk
         0CRZ253H0zxmBFOHVYiYWY9rFiQi6MP4q+Bnqkx15UzhhxKvioKMAQq+1qVKfPuPReGT
         qfcpBsPRxLcchlb6btpNMU68bNfOU4wOUdYMUi1MCxkB70sMY6fmH1xdoTTzfGqrKoMT
         y332dbJc3Dj5IBsH3tsbTCJcOctC5Uj0649Q5P28ju3R2mQCIsWs4jfC/NYJuzInzMjI
         WaUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733257644; x=1733862444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7mYLgWRx19EhLntfJHR6XQME2VsuqQ9Oja4sZu+CCPU=;
        b=gzrcGcCiZzavq6jRhc7fEtWu+/ZXHA7Go/PZfOlO/mqIfMJ9uTIS0Ip26ggNotANAP
         mniPL83saPmV933s3QfO/yRqHfJAJMgiwT5pScmMOLJzNocL6OJcXDqIvbaDyUXy5RDn
         Zu+LLhfhsFijDBwm95JotIF1vqcO4BBvJ8qYYCsprDjZ4qs5SxtTVB1lnH8esL+tCaC+
         oAfGiFaMRxdnfJIu6FybiTUbOnm6vYX2Wro/L/9NfD/lc5qtZIq4NnO2Y3ZPziRgKeS6
         ZFRLyl+1hgbqpkWPF03fbmD4sqwPSTDNYRPJyf+mGymrBc+VdsU4IpJCBUr9m9qWJ61Y
         oOLg==
X-Gm-Message-State: AOJu0YxkrOsT8QZFIWoShvYC8ctfFKyld3K3dF4RiG4La+99rAqsxpCZ
	7X6ZD/+WfWh5DrmJZvQ/ivc/cfGGs9FRRc5xlTYn3/0ws1xsxle3zHesW+EQ8VklPOimKa67Lsh
	lFdxiVap9YLZKOiqDsoLcVTPQq88Y0uALY/3oQA==
X-Gm-Gg: ASbGncumL91eh+3upE4Yb3HBSVjnpMxLzavCno7Je+tnQjuhAQEMiba5g/lCNoSPET6
	O+QVVvra04fAW6SSaOIF83D+DsxKFk10=
X-Google-Smtp-Source: AGHT+IHTJDxVt4kVp1R1qLjhVx/yNmiNeG07rAAd6X/haudry/By7fRJmRzYReE4NmWiWYuDtOH6tXvmTboOfqMnWHw=
X-Received: by 2002:a05:6512:3f06:b0:53d:dfbd:3e68 with SMTP id
 2adb3069b0e04-53e12db7668mr1445334e87.7.1733257644249; Tue, 03 Dec 2024
 12:27:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241203180553.16893-1-ebiggers@kernel.org>
In-Reply-To: <20241203180553.16893-1-ebiggers@kernel.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 3 Dec 2024 21:27:13 +0100
Message-ID: <CAMRc=MfMoZHW5qea4AkftGt=nZJGgBDF_Ws+ESVXmyA=cV_ECw@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce - fix priority to be less than ARMv8 CE
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org, 
	Neil Armstrong <neil.armstrong@linaro.org>, Thara Gopinath <thara.gopinath@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 3, 2024 at 7:06=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> As QCE is an order of magnitude slower than the ARMv8 Crypto Extensions
> on the CPU, and is also less well tested, give it a lower priority.
> Previously the QCE SHA algorithms had higher priority than the ARMv8 CE
> equivalents, and the ciphers such as AES-XTS had the same priority which
> meant the QCE versions were chosen if they happened to be loaded later.
>
> Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
> Cc: stable@vger.kernel.org
> Cc: Bartosz Golaszewski <brgl@bgdev.pl>
> Cc: Neil Armstrong <neil.armstrong@linaro.org>
> Cc: Thara Gopinath <thara.gopinath@gmail.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/crypto/qce/aead.c     | 2 +-
>  drivers/crypto/qce/sha.c      | 2 +-
>  drivers/crypto/qce/skcipher.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
> index 7d811728f047..97b56e92ea33 100644
> --- a/drivers/crypto/qce/aead.c
> +++ b/drivers/crypto/qce/aead.c
> @@ -784,11 +784,11 @@ static int qce_aead_register_one(const struct qce_a=
ead_def *def, struct qce_devi
>         alg->encrypt                    =3D qce_aead_encrypt;
>         alg->decrypt                    =3D qce_aead_decrypt;
>         alg->init                       =3D qce_aead_init;
>         alg->exit                       =3D qce_aead_exit;
>
> -       alg->base.cra_priority          =3D 300;
> +       alg->base.cra_priority          =3D 275;
>         alg->base.cra_flags             =3D CRYPTO_ALG_ASYNC |
>                                           CRYPTO_ALG_ALLOCATES_MEMORY |
>                                           CRYPTO_ALG_KERN_DRIVER_ONLY |
>                                           CRYPTO_ALG_NEED_FALLBACK;
>         alg->base.cra_ctxsize           =3D sizeof(struct qce_aead_ctx);
> diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
> index fc72af8aa9a7..71b748183cfa 100644
> --- a/drivers/crypto/qce/sha.c
> +++ b/drivers/crypto/qce/sha.c
> @@ -480,11 +480,11 @@ static int qce_ahash_register_one(const struct qce_=
ahash_def *def,
>         else if (IS_SHA256(def->flags))
>                 tmpl->hash_zero =3D sha256_zero_message_hash;
>
>         base =3D &alg->halg.base;
>         base->cra_blocksize =3D def->blocksize;
> -       base->cra_priority =3D 300;
> +       base->cra_priority =3D 175;
>         base->cra_flags =3D CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONL=
Y;
>         base->cra_ctxsize =3D sizeof(struct qce_sha_ctx);
>         base->cra_alignmask =3D 0;
>         base->cra_module =3D THIS_MODULE;
>         base->cra_init =3D qce_ahash_cra_init;
> diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.=
c
> index 5b493fdc1e74..ffb334eb5b34 100644
> --- a/drivers/crypto/qce/skcipher.c
> +++ b/drivers/crypto/qce/skcipher.c
> @@ -459,11 +459,11 @@ static int qce_skcipher_register_one(const struct q=
ce_skcipher_def *def,
>                                           IS_DES(def->flags) ? qce_des_se=
tkey :
>                                           qce_skcipher_setkey;
>         alg->encrypt                    =3D qce_skcipher_encrypt;
>         alg->decrypt                    =3D qce_skcipher_decrypt;
>
> -       alg->base.cra_priority          =3D 300;
> +       alg->base.cra_priority          =3D 275;
>         alg->base.cra_flags             =3D CRYPTO_ALG_ASYNC |
>                                           CRYPTO_ALG_ALLOCATES_MEMORY |
>                                           CRYPTO_ALG_KERN_DRIVER_ONLY;
>         alg->base.cra_ctxsize           =3D sizeof(struct qce_cipher_ctx)=
;
>         alg->base.cra_alignmask         =3D 0;
>
> base-commit: ceb8bf2ceaa77fe222fe8fe32cb7789c9099ddf1
> --
> 2.47.1
>

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

But the QCE driver will still be worked on due to features that we
want to support that the CE don't have.

Bart
