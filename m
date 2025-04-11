Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DE8205502
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 19:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744401304; cv=none; b=fst9fKfNT2Le0BfGN+Hsu1zPuSPnm7FiBCAPzFqqkJ0z870o/KSrZp4Vc1y5GfOoZR74PkOzKet44HEmP3hfUwG+sIni29yiphRWyVUTHI+Z48nl2kBDXRkqO2ycrjvmRau/3WFFZnfmcpHSDUnH5TGXLZrAWA4UvErCdKpzjgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744401304; c=relaxed/simple;
	bh=fMl/cO4Mc+3rRQGsUDrG2q1xGapHt7w8Pi2Ez0VeIfQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K3rDPOrG+qfc8oHkvZRTj/Ukdt7zxa+szkB7ejqmYCP/eyvLgjdUQgVzNd6tT6S+vlrvS9CeyOaUjW6+jK2UDHo70aSHDAxM620QwVbdc0UUk5H3i6y6jbBsEdJW45PQnE2VG5bqtLFdGX068c156OPfxXehKJYVOrOz6LTu+XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=Fnm/b9x9; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="Fnm/b9x9"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3035858c687so1890144a91.2
        for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 12:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1744401301; x=1745006101; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qmuXF4G8oAveu1kU1QwyLEPu0VP5pJHFUetOkYKYD+E=;
        b=Fnm/b9x93jbCvqaWNHQGL0hLLgms6dNKtSFON45I3XtYE6PrARTl3Sx1I+pIQ5Ks1e
         mNxxZ+r2cb4jmjfMUgLgELjqqf/+Xehx4VNZ/2UTGp4b6ufWCoP9+Wrh6iSr9VoThaAI
         J03YSE9NYJXfAzNoh2kcvDr5Aa+zJOT/JYnSpM6hFA/rK1uv6SPfv2VApsFCmre3uV3i
         hqUIQRnYRVBQJZl2eNgpNpsj47U+l7WVWSbWvCtmvnqbTE8hDN3S7SDkhgSWoGTGQkJB
         uswQP0Xqk0XPmM/5jTcZ2ie366rhTDX6bFJuR3WmEvr7X0XTbaZtv3/phUHEleMO6FE5
         /72Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744401301; x=1745006101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qmuXF4G8oAveu1kU1QwyLEPu0VP5pJHFUetOkYKYD+E=;
        b=XWjrCoppCuUrnkhfSk5G1NDH3PNqvB2OI/mZ0cjYpisPaOPT5p0+hiLKwdaTrujdz+
         lszdTnyNtW+Iiu6QocMfF7JmPXgceGQeHmzLjd4Z18MO3jv1rHJmMs25M3oSCNOA5HX2
         0JENMAhKfapcC083/18I3J2zMnxSYFovrHhke4hbQFc2FMxij0TKPqeu5eXgjs/nFexV
         0nHBNXN4ODqointB8wpyxgwaxX8iOiWZo5XdmDVdOMbluopaIqALVGh76i9nFWKnEqYf
         D9QaZhOR+tt+hmMHSVcIftRALRaQ6MRNm4n1qFKb7J5PJ/hb+cDJOaY40xRgu7taSUN/
         SgNw==
X-Forwarded-Encrypted: i=1; AJvYcCWD6tcBd+E8gE3fI74A9Dm4pjCAy/+IaZj3TbQjySFixQdV9YEfESj3aI90NKR7FI0JIbI/ztaBqBjq6aU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrBIoQgzslEExFXByMUAlApdMPDCZPSBRZTqFF2lCYlq0i5PIz
	iSGRD/SKMvzBMxr8xm6HEzEGiY7aWKr7QKJdiMBwDB2nHjEzjKWQmj3oG+rzBYYvCmwyHiPd07e
	3b59tNCAb6Yh8kKnAycFaIXD3PM3lxi4+5RqFZA==
X-Gm-Gg: ASbGnct3nwhAaDm99xMh5cCihhiVOaDDCIT2XfrWIgAeMTI8NYhg8nW+tqavAJAAdA/
	IRk/b2Ypvra713qKwiE4hZ/Qr7jC6u4FGNHZkvOiYzsu7XnFd8jkrbUu9Ed4utgBrc1V6UcuBsF
	FJprLm5a6TJfyecTMfWzEY7oIZ95UWzP5Erg1BMm6z
X-Google-Smtp-Source: AGHT+IEnWF6ApvR+x3IIHITC/uWVzWWJi+T0SFmfe017j/rzp6CXgf5avrrjDB4yDV9iv2tl/vmLn2sZEZi79yCWRvY=
X-Received: by 2002:a17:90b:4c04:b0:2ff:62b7:dcc0 with SMTP id
 98e67ed59e1d1-3082367dd5emr6478582a91.15.1744401300804; Fri, 11 Apr 2025
 12:55:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1744052920.git.lukas@wunner.de> <831608e465078cdcd3a8e74d6dfd85e77b2083a8.1744052920.git.lukas@wunner.de>
In-Reply-To: <831608e465078cdcd3a8e74d6dfd85e77b2083a8.1744052920.git.lukas@wunner.de>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Fri, 11 Apr 2025 20:54:48 +0100
X-Gm-Features: ATxdqUE9FTCjpKwEwPpUJicmrT9B0LP527CN1MU-wtw7jKidDcOWVFOYixBPDLU
Message-ID: <CALrw=nFr_R6As6UhHwJR+awaRwFQhEg3d-q4fwDoZbX=av40AQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 1/2] crypto: ecdsa - Fix enc/dec size reported
 by KEYCTL_PKEY_QUERY
To: Lukas Wunner <lukas@wunner.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	David Howells <dhowells@redhat.com>, Stefan Berger <stefanb@linux.ibm.com>, 
	Vitaly Chikunov <vt@altlinux.org>, linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 7, 2025 at 8:42=E2=80=AFPM Lukas Wunner <lukas@wunner.de> wrote=
:
>
> KEYCTL_PKEY_QUERY system calls for ecdsa keys return the key size as
> max_enc_size and max_dec_size, even though such keys cannot be used for
> encryption/decryption.  They're exclusively for signature generation or
> verification.
>
> Only rsa keys with pkcs1 encoding can also be used for encryption or
> decryption.
>
> Return 0 instead for ecdsa keys (as well as ecrdsa keys).
>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>

Reviewed-by: Ignat Korchagin <ignat@cloudflare.com>

> ---
>  crypto/asymmetric_keys/public_key.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys=
/public_key.c
> index bf165d3..dd44a96 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -188,6 +188,8 @@ static int software_key_query(const struct kernel_pke=
y_params *params,
>         ptr =3D pkey_pack_u32(ptr, pkey->paramlen);
>         memcpy(ptr, pkey->params, pkey->paramlen);
>
> +       memset(info, 0, sizeof(*info));
> +
>         if (issig) {
>                 sig =3D crypto_alloc_sig(alg_name, 0, 0);
>                 if (IS_ERR(sig)) {
> @@ -211,6 +213,9 @@ static int software_key_query(const struct kernel_pke=
y_params *params,
>                         info->supported_ops |=3D KEYCTL_SUPPORTS_SIGN;
>
>                 if (strcmp(params->encoding, "pkcs1") =3D=3D 0) {
> +                       info->max_enc_size =3D len;
> +                       info->max_dec_size =3D len;
> +
>                         info->supported_ops |=3D KEYCTL_SUPPORTS_ENCRYPT;
>                         if (pkey->key_is_private)
>                                 info->supported_ops |=3D KEYCTL_SUPPORTS_=
DECRYPT;
> @@ -232,6 +237,8 @@ static int software_key_query(const struct kernel_pke=
y_params *params,
>                 len =3D crypto_akcipher_maxsize(tfm);
>                 info->max_sig_size =3D len;
>                 info->max_data_size =3D len;
> +               info->max_enc_size =3D len;
> +               info->max_dec_size =3D len;
>
>                 info->supported_ops =3D KEYCTL_SUPPORTS_ENCRYPT;
>                 if (pkey->key_is_private)
> @@ -239,8 +246,6 @@ static int software_key_query(const struct kernel_pke=
y_params *params,
>         }
>
>         info->key_size =3D len * 8;
> -       info->max_enc_size =3D len;
> -       info->max_dec_size =3D len;
>
>         ret =3D 0;
>
> --
> 2.43.0
>
