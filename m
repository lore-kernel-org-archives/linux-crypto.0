Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B5539E194
	for <linux-crypto@vger.kernel.org>; Wed,  7 Jan 2026 16:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767803929; cv=none; b=eQBa1YElBy2jlsjzdIdtogd+dWR+YZ/6EPcFhJ0Z3+ItMqoqbcPVa+ytxJJVKYxMrVKihMPuKITSsvQnkr/AP6GwZ7ujA1ioAzWPTvTjGPzr+BGTLYtV4aKJtueB6lWrT3zgHrt8p8M5nAOpO4iVriGZNMF/DxtCYT8R1yGdUDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767803929; c=relaxed/simple;
	bh=fRsEUwtHorbtdkW1jrhWLB7v+CG3d0JqqtIPkpcXTO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XNF1oc7ZOu6c1eTCDRYjmfA2Qwu+5AoanMovixgpxEyELriwDWxglpYRttnUmZYh2GdUHc2PTWvJX3WKTXXYzYqGEnIquUY6Zw+iY/kmGb+ScoAV7wnmtAEvyVhLvVKytSobziG/pmicJ4iIMNxN8ZHjQFVGjFosh08OaxftLuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=GWYT5nx1; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="GWYT5nx1"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-598f81d090cso2347601e87.2
        for <linux-crypto@vger.kernel.org>; Wed, 07 Jan 2026 08:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1767803918; x=1768408718; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kW846dKKsvB937IYHg57MK2wxwUFHhgVJ3+JvFFPElU=;
        b=GWYT5nx1llV/EqfT4RHaicIR7DWQtgQWlM4MD41cV13TQzyXKOY6iIvNneHhNIz0l/
         XtRYEgEXhABOna1O1qkZuGF1YOHz+Fmaagzeo1ZrJOMnbYoYXi3YsKKw7FVFVY7K6Exv
         ya67yUf6xx5g5L5fr9Qma8xViIoVKFCIvSSOfnoZhbj/nuBcXXxCxF9bDSxk6ma0ePp/
         tcBjKgDX9xPe+Duydnu2ogF0FdFvwtmuDu0a8KsXevk/v3dvnA2QZSJgw3U4QbJuZXjm
         Kl1qRNEx6KjFI3kZxnFev8+lunxJCJH5jnYTxNvPuABEA/R0OV0slKHFYK0h+lPvIcrs
         uY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767803918; x=1768408718;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kW846dKKsvB937IYHg57MK2wxwUFHhgVJ3+JvFFPElU=;
        b=BDRUZgrj5cBc+q4t6KxaOggIqDNqcUSRK6QerD/zwnOPyvzrXRjjCk+jN1ApCcmTNq
         jKq1HUAmiW83FZoIaYlq4z964fxWWjxtb6/P0aJJaVozJubOl7a5LgFqM0kStVz3VstL
         1M88vG1BPKZaZHlMY4GAhqQdv6AvS8cXJtkSh4iiJ0Ap6zSWQhuSahGCdJczYluSYBIw
         WltGG79aUMMIsYgvuLrCb2QLbnaVBLUvMRYLB64LTiTJFfGN95rQNnshwlyWFqkeh3Tw
         yYWiJPVP6Aj4ELCdMRQGbEXhheuryFslyt2Uz1794/qwL1kM3GzgKcWM3Vqnm6M9YU6G
         zVIA==
X-Forwarded-Encrypted: i=1; AJvYcCU6Nj9sd44sEx9AjM7yvI0AIUo1dcW8sXb0v7c6LHjfhbDDQGZAVAltsaugGPhTUZf3rU3EZNXsgBEAn7k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt8eRlEWO0o6sK3RyrEnOUrPmrbPh+GSXJlhYlijt0SXgji75d
	vobM0up+eY2yddfOgijkirBxXdAC1g2LzTKurIjxn8S83HCMUG5w4LWj8LOJwa4SPXeMrMK+VWl
	318SdGpTaRTocGNzytkh94Vf/llkffpzokm1bBv+gkg==
X-Gm-Gg: AY/fxX6bFkTRHvqItaeiJM6h1tkpcMEScU3nEQEdLw43t824lm6IhAvPCf6y6yUYSSx
	UW7r0XKmUxeIGzs1+6iR6etnq0pK7f6gC1Ynms99CkhUUpEDDyTKVp6dyUAkYJeEUTKAJDECkJg
	YHZBukPqX1qLNxf8kzK4pvMf7YLGZLgAT3tYowmGLik4NGxr6n20jsyRaubrWEygg+I64quloST
	N1cI9pjRP4mtWN4WyDzT0N3X1Yo8Ww6Sw7i95tvV+HVMCip/gACjDzeY++hkJWquF3BJDrJl3u+
	YE9Y2ONhwy1wCQ==
X-Google-Smtp-Source: AGHT+IGLoWHGzRMHY6PpbgP44tMsQvOWECFXE6pLJTWOIJxsRLSDUETFtqlqqwHRUPWy9MfLR1uDc+QiEDzeOSFRbv4=
X-Received: by 2002:ac2:4e12:0:b0:594:2e7b:6f9 with SMTP id
 2adb3069b0e04-59b6f047f08mr1233343e87.27.1767803918457; Wed, 07 Jan 2026
 08:38:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260105152145.1801972-1-dhowells@redhat.com> <20260105152145.1801972-9-dhowells@redhat.com>
In-Reply-To: <20260105152145.1801972-9-dhowells@redhat.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Wed, 7 Jan 2026 16:38:27 +0000
X-Gm-Features: AQt7F2p43GDavepwZCl172aMay7N5leyGJ_l1NOUP-m5QhxfdGJ64MkgnawivDo
Message-ID: <CALrw=nEkbXMLfTR9tHLZchz-UsdzCQK_27QJYv=LuEOX2=6TBQ@mail.gmail.com>
Subject: Re: [PATCH v11 8/8] modsign: Enable RSASSA-PSS module signing
To: David Howells <dhowells@redhat.com>
Cc: Lukas Wunner <lukas@wunner.de>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>, Stephan Mueller <smueller@chronox.de>, 
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 3:22=E2=80=AFPM David Howells <dhowells@redhat.com> =
wrote:
>
> Add support for RSASSA-PSS signatures (RFC8017) for use with module signi=
ng
> and other public key cryptography done by the kernel.
>
> Note that only signature verification is supported by the kernel.
>
> Note further that this alters some of the same code as the MLDSA support,
> so that needs to be applied first to avoid conflicts.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Lukas Wunner <lukas@wunner.de>
> cc: Ignat Korchagin <ignat@cloudflare.com>
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: keyrings@vger.kernel.org
> cc: linux-crypto@vger.kernel.org
> ---
>  certs/Kconfig       |  6 ++++++
>  certs/Makefile      |  1 +
>  scripts/sign-file.c | 39 +++++++++++++++++++++++++++++++++++++--
>  3 files changed, 44 insertions(+), 2 deletions(-)
>
> diff --git a/certs/Kconfig b/certs/Kconfig
> index 94b086684d07..beb8991ad761 100644
> --- a/certs/Kconfig
> +++ b/certs/Kconfig
> @@ -27,6 +27,12 @@ config MODULE_SIG_KEY_TYPE_RSA
>         help
>          Use an RSA key for module signing.
>
> +config MODULE_SIG_KEY_TYPE_RSASSA_PSS
> +       bool "RSASSA-PSS"
> +       select CRYPTO_RSA
> +       help
> +        Use an RSASSA-PSS key for module signing.
> +
>  config MODULE_SIG_KEY_TYPE_ECDSA
>         bool "ECDSA"
>         select CRYPTO_ECDSA
> diff --git a/certs/Makefile b/certs/Makefile
> index 3ee1960f9f4a..3b5a3a303f4c 100644
> --- a/certs/Makefile
> +++ b/certs/Makefile
> @@ -42,6 +42,7 @@ targets +=3D x509_certificate_list
>  # boolean option and we unfortunately can't make it depend on !RANDCONFI=
G.
>  ifeq ($(CONFIG_MODULE_SIG_KEY),certs/signing_key.pem)
>
> +keytype-$(CONFIG_MODULE_SIG_KEY_TYPE_RSASSA_PSS) :=3D -newkey rsassa-pss
>  keytype-$(CONFIG_MODULE_SIG_KEY_TYPE_ECDSA) :=3D -newkey ec -pkeyopt ec_=
paramgen_curve:secp384r1
>  keytype-$(CONFIG_MODULE_SIG_KEY_TYPE_MLDSA_44) :=3D -newkey ml-dsa-44
>  keytype-$(CONFIG_MODULE_SIG_KEY_TYPE_MLDSA_65) :=3D -newkey ml-dsa-65
> diff --git a/scripts/sign-file.c b/scripts/sign-file.c
> index b726581075f9..ca605095194e 100644
> --- a/scripts/sign-file.c
> +++ b/scripts/sign-file.c
> @@ -233,6 +233,7 @@ int main(int argc, char **argv)
>         EVP_PKEY *private_key;
>  #ifndef USE_PKCS7
>         CMS_ContentInfo *cms =3D NULL;
> +       CMS_SignerInfo *signer;
>         unsigned int use_keyid =3D 0;
>  #else
>         PKCS7 *pkcs7 =3D NULL;
> @@ -329,13 +330,47 @@ int main(int argc, char **argv)
>                     !EVP_PKEY_is_a(private_key, "ML-DSA-65") &&
>                     !EVP_PKEY_is_a(private_key, "ML-DSA-87"))
>                         flags |=3D use_signed_attrs;
> +               if (EVP_PKEY_is_a(private_key, "RSASSA-PSS"))
> +                       flags |=3D CMS_KEY_PARAM;
> +       if (EVP_PKEY_is_a(private_key, "RSASSA-PSS")) {
> +                       EVP_PKEY_CTX *pkctx;
> +                       char mdname[1024] =3D {};
> +
> +                       pkctx =3D EVP_PKEY_CTX_new(private_key, NULL);
> +
> +                       ERR(!EVP_PKEY_sign_init(pkctx), "EVP_PKEY_sign_in=
it");
> +                       ERR(!EVP_PKEY_CTX_set_rsa_padding(pkctx, RSA_PKCS=
1_PSS_PADDING),
> +                           "EVP_PKEY_CTX_set_rsa_padding");
> +                       ERR(!EVP_PKEY_CTX_set_rsa_mgf1_md_name(pkctx, has=
h_algo, NULL),
> +                           "EVP_PKEY_CTX_set_rsa_mgf1_md_name");
> +
> +                       ERR(!EVP_PKEY_CTX_get_rsa_mgf1_md_name(pkctx, mdn=
ame, sizeof(mdname)),
> +                           "EVP_PKEY_CTX_get_rsa_mgf1_md_name");
> +                       printf("RSASSA-PSS %s\n", mdname);
> +               }
>
>                 /* Load the signature message from the digest buffer. */
>                 cms =3D CMS_sign(NULL, NULL, NULL, NULL, flags);
>                 ERR(!cms, "CMS_sign");
>
> -               ERR(!CMS_add1_signer(cms, x509, private_key, digest_algo,=
 flags),
> -                   "CMS_add1_signer");
> +               signer =3D CMS_add1_signer(cms, x509, private_key, digest=
_algo, flags);
> +               ERR(!signer, "CMS_add1_signer");
> +
> +               if (EVP_PKEY_is_a(private_key, "RSASSA-PSS")) {
> +                       EVP_PKEY_CTX *pkctx;
> +                       char mdname[1024] =3D {};
> +
> +                       pkctx =3D CMS_SignerInfo_get0_pkey_ctx(signer);
> +                       ERR(!EVP_PKEY_CTX_set_rsa_padding(pkctx, RSA_PKCS=
1_PSS_PADDING),
> +                           "EVP_PKEY_CTX_set_rsa_padding");
> +                       ERR(!EVP_PKEY_CTX_set_rsa_mgf1_md_name(pkctx, has=
h_algo, NULL),
> +                           "EVP_PKEY_CTX_set_rsa_mgf1_md_name");
> +
> +                       ERR(!EVP_PKEY_CTX_get_rsa_mgf1_md_name(pkctx, mdn=
ame, sizeof(mdname)),
> +                           "EVP_PKEY_CTX_get_rsa_mgf1_md_name");
> +                       printf("RSASSA-PSS %s\n", mdname);
> +               }
> +
>                 ERR(CMS_final(cms, bm, NULL, flags) !=3D 1,
>                     "CMS_final");
>
>

Reviewed-by: Ignat Korchagin <ignat@cloudflare.com>
