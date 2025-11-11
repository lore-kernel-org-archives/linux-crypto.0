Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2416636B06F
	for <linux-crypto@vger.kernel.org>; Tue, 11 Nov 2025 16:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762877341; cv=none; b=GhrvXUk+0GWEPO0O/HPrq2k939XDQMQuAq6nETt+eB1IVc2KrJ1UiyUAq82ksQuiMWmAyweLIr1oIwKiyb1CqqhNJxfGNN34Yb7MkGNHS9cLB8D/T8JbcYyky0XpOlzP1M9ZQwP8oh2I6yLSFNrnsvu4Ws/dO0aV6IoTD8jo3lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762877341; c=relaxed/simple;
	bh=aysh5UWarQ7L8UM6wmzXLNddrubxWUn3U+QaaL3x7+s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q9u2GdAWgC/dsiAv6p7QlPMqBE1tMzBQqRukzeFwudEphDYP0uvUWv72/+T5Pp63i2+zYAKdM6SYNmy8IFp67poMAk8gNfz55wftDuc2uWqscc9aYfUk2C+ohAYVxoUoA7uV8Ty+KjFUhKwnhvNJO4PADzKEq0bz7ps/jSm7zRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=T9NakLss; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="T9NakLss"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-378d6fa5aebso38200781fa.2
        for <linux-crypto@vger.kernel.org>; Tue, 11 Nov 2025 08:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1762877337; x=1763482137; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iLmijrLc4WS3nSB0g1tes3gmjZB4xp4JotsNrP4RgbI=;
        b=T9NakLssrxRZu4Y1431XbGWnyx7s417lj3ApaCz0BRZUZjEedWsHiTYNEmZ4ef0gK7
         RjehRBafD7u+FIeiqgxiRBLOFTyMBhn6hzZDPPFAb8ng7++LFIbsKKYaOTutOK0t9geo
         4Qvqh0yNnroKgO9HPWtIMZyL+HYY+4SQVNdIzx06hs3XX2R3MeWeItQCXCObm66eMLi2
         fiI9HbC7MOzxJh58B1txJW+IUYJn6shk82Hd+JTNpmNzduI72JhGOArvkbvRYhOxyUeM
         s6GzEDgoJJtaqBiZfXwHnVpCyVbLBpLYYEbAMvsA2n6CClkqSo+2Y6FMcbgTe0/EfONg
         /VpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762877337; x=1763482137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iLmijrLc4WS3nSB0g1tes3gmjZB4xp4JotsNrP4RgbI=;
        b=p/UYWdK7+uHqA/oxDQZJaYWG/v0pNa1AD3wcIJTvxwe+xCQ6e+gVWcC/tinagfN99O
         6U3ksZ6R7wzmmSpB80oDpDBuKtEHnNuuNrjqbfzADoGowHTyzovpdOB32LsgRD5wLcET
         ShUkKdMEBExjfz2XMiH1BjB1omk5Jcnzi2NfMZMQXxsvQffm9pCyplB+AKj4g4Rt6W97
         EodeiOl3DqC8MMuzVOxXI7Oyw9jGHSyfmqFSyWpITRUlbrNDfEOndtoldOzj62st+UGd
         DzxUS41F9Mj3VJHFNZdLv8MPqUPl5K6oorQO1fCQFQGw0jkP6OojmcUhYnfDthmc2P9l
         UlLg==
X-Forwarded-Encrypted: i=1; AJvYcCXdTgkHiE+EvDuBOWaIzhhGeI779KAXi8CrRWugKukrmuY6mqBdYiNFZ7LTJnud8CYY+fFfa7IVjLEzN6w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+ZPu9aOyWVyRi3KQ20n9R5mKyidV3DJoFHgTZHXjPs9WlFpsf
	C0UvsRk6Aiuv/dPNZ9QbZbbgEV3L2wzS1fwExonfw4heVXpuoRl7ySDwgxD5HQaE7PaH5rqat7x
	CIVjEYEWWGJO/dV/N/SYnpvmOHtQn3E97FTMhvp7Ckg==
X-Gm-Gg: ASbGncvapUW17wl1E7WTy5bA30oE9nlGlSmme4/o/MQN5M3WxEouq/1vW5UXI9KU99T
	ugSwzJVafhuictDjYrXqhRdP8UWhhPDyjuojh0euuv1WEJmbgUVAToBZgHRlPM5xRAVP+OKVQEx
	H2jiRpts0zWLZR5SF4LOaMVeVky5zcE670zE8s462oIqoJX2Y1yXHiG+DA60bSEFlFLyu8LyRqO
	4ndYS9mRRUfJOzzfd9uXLuujDXal4r8cqyrFEaEayYMekrjGxXKk9jUOXi8K5a1YV6HepNFY4CR
	cCsDTQQKZ6vb4w==
X-Google-Smtp-Source: AGHT+IEcmZOwLvG+h7fUXsvJcnFNIhiV+MryGzOffXJ6dYV5aA7YnFbnyG0YTd/n2a6NhgLGBZaHssoFT3rWJmo9VQY=
X-Received: by 2002:a05:6512:3a86:b0:57c:2474:371f with SMTP id
 2adb3069b0e04-5945f1e5562mr4251059e87.45.1762877337250; Tue, 11 Nov 2025
 08:08:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251111-aheev-uninitialized-free-attr-crypto-v2-1-33699a37a3ed@gmail.com>
In-Reply-To: <20251111-aheev-uninitialized-free-attr-crypto-v2-1-33699a37a3ed@gmail.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Tue, 11 Nov 2025 16:08:45 +0000
X-Gm-Features: AWmQ_bmEt7CJwei-GA566n9pELQVcfSa-BAXmZkdFeUOGoDXbcYtgD_qygu4668
Message-ID: <CALrw=nF1ms+s9gbY-aLfGkTcTWGBoKjJXBsUpQ5v07d+8_M_gg@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: asymmetric_keys: fix uninitialized pointers
 with free attribute
To: Ally Heev <allyheev@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 1:36=E2=80=AFPM Ally Heev <allyheev@gmail.com> wrot=
e:
>
> Uninitialized pointers with `__free` attribute can cause undefined
> behavior as the memory assigned randomly to the pointer is freed
> automatically when the pointer goes out of scope.
>
> crypto/asymmetric_keys doesn't have any bugs related to this as of now,
> but, it is better to initialize and assign pointers with `__free`
> attribute in one statement to ensure proper scope-based cleanup
>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/all/aPiG_F5EBQUjZqsl@stanley.mountain/
> Signed-off-by: Ally Heev <allyheev@gmail.com>

Reviewed-by: Ignat Korchagin <ignat@cloudflare.com>

> ---
> Changes in v2:
> - moved declarations to the top and initialized them with NULL
> - Link to v1: https://lore.kernel.org/r/20251105-aheev-uninitialized-free=
-attr-crypto-v1-1-83da1e10e8c4@gmail.com
> ---
>  crypto/asymmetric_keys/x509_cert_parser.c | 2 +-
>  crypto/asymmetric_keys/x509_public_key.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetri=
c_keys/x509_cert_parser.c
> index 8df3fa60a44f80fbd71af17faeca2e92b6cc03ce..b37cae914987b69c996d65590=
58c00f13c92b5b9 100644
> --- a/crypto/asymmetric_keys/x509_cert_parser.c
> +++ b/crypto/asymmetric_keys/x509_cert_parser.c
> @@ -60,7 +60,7 @@ EXPORT_SYMBOL_GPL(x509_free_certificate);
>   */
>  struct x509_certificate *x509_cert_parse(const void *data, size_t datale=
n)
>  {
> -       struct x509_certificate *cert __free(x509_free_certificate);
> +       struct x509_certificate *cert __free(x509_free_certificate) =3D N=
ULL;
>         struct x509_parse_context *ctx __free(kfree) =3D NULL;
>         struct asymmetric_key_id *kid;
>         long ret;
> diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric=
_keys/x509_public_key.c
> index 8409d7d36cb4f3582e15f9ee4d25f302b3b29358..12e3341e806b8db93803325a9=
6a3821fd5d0a9f0 100644
> --- a/crypto/asymmetric_keys/x509_public_key.c
> +++ b/crypto/asymmetric_keys/x509_public_key.c
> @@ -148,7 +148,7 @@ int x509_check_for_self_signed(struct x509_certificat=
e *cert)
>   */
>  static int x509_key_preparse(struct key_preparsed_payload *prep)
>  {
> -       struct x509_certificate *cert __free(x509_free_certificate);
> +       struct x509_certificate *cert __free(x509_free_certificate) =3D N=
ULL;
>         struct asymmetric_key_ids *kids __free(kfree) =3D NULL;
>         char *p, *desc __free(kfree) =3D NULL;
>         const char *q;
>
> ---
> base-commit: c9cfc122f03711a5124b4aafab3211cf4d35a2ac
> change-id: 20251105-aheev-uninitialized-free-attr-crypto-bc94ec1b2253
>
> Best regards,
> --
> Ally Heev <allyheev@gmail.com>
>
