Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6ED2FDC28
	for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 08:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763109374; cv=none; b=qX8fbPAcsXYSKyozU5a7QonwOsWMbTNtW/MfayC8afEah1WvlZFvdriEhTV+mlJZgIlZSKWBvYXZcsBeI+I7puebzwlAY14RjB1Rs95BeD5FVQk4ee06vyETVNT06gA4w5/ki0O7qycwATgxOJu9KUnpRyWlACRIq+VNMk40Tl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763109374; c=relaxed/simple;
	bh=QTgEQGJZ3GHZmXCkPNrDf8CvJ8SwxwiLHdjeVMSJS9I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QI5rzVylx2Zgmz47dJrxKIbjd3U7BU4Fweb5aj5coyONNdN6hn8QdpI6wlsyj3D5rIv3mCVxf8C7JT4JzfhdKYrOHNQ+y+LFzxVO9qwAeUVxgsn05bbzqtvyfX0IUHASrXzKrL8Mcec7Hu4vZauODd2fzpi1doSgKQq6KB8AGzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UU2Bp4pA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UU2Bp4pA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394F3C16AAE
	for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 08:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763109373;
	bh=QTgEQGJZ3GHZmXCkPNrDf8CvJ8SwxwiLHdjeVMSJS9I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UU2Bp4pA8noTn5MRb2hXSLTYCftQtK+OYh1SJRDK1rWEPNqeZC3EZNe0pOKC8pBrn
	 s1rPgn2wCfDhPv4emE/FwFm6uTZ+PqwHmonV3DtVALF/gwTKWk1QZ/F4eD7ANwfwE3
	 H9Re9w8LN4lXcDNiqoHAQOjFXi2RrAnr6szeG4g2Of+EXVWNaWfW6/gx+IOiQDwaK2
	 2xcSaGQVofyJOzeXVdZ727b6ytl8bsYW1mg27NdQCtAhM5b3a5BZhEmpQM9oHrZQus
	 EQfLb9NZudDI5s3kXV/g0iMJuqhvuHW6KLdp9X9qPWqxn7lLyBlnw3XlzXk57jNQyj
	 onWFMKUZzMoTQ==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5943d20f352so1887964e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 00:36:13 -0800 (PST)
X-Gm-Message-State: AOJu0Yy5sH/c1FQk2snOdOuAB3c8e0z/3eLanAuQ4m7a47D75KB5eWWz
	H6hzI+DdoxrzZmi+rEA5IqQKMRb6SYx9gLiBDOBL7dpNzLVhUdTu9/fraBJ2kTWKxurzohhio2D
	uoVmkiSSDOlqzHIU6GQF/WgKST2U3Wxs=
X-Google-Smtp-Source: AGHT+IHdWqZkqACKPeCuoyyfoQ2ao+Z2i5UwCLvcCG1YlqNw139A5+yThWPuXkYJs5HZd1c3I2GCh+9K/2GudZ/qZ+s=
X-Received: by 2002:a05:6512:10cc:b0:590:9a11:9c23 with SMTP id
 2adb3069b0e04-5958426ee7bmr688933e87.55.1763109371590; Fri, 14 Nov 2025
 00:36:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251114030344.235748-1-ebiggers@kernel.org>
In-Reply-To: <20251114030344.235748-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 14 Nov 2025 09:35:58 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGGZ_WNp3E0V-gGv8Jf9VVuC2LdwXuG4rQX6QyEsimbHA@mail.gmail.com>
X-Gm-Features: AWmQ_bnyE6LaoCJP4nFzKPZy-sGiG3o3Eddf_TiqXrtbeBnC4JQRF5i59xx5e6k
Message-ID: <CAMj1kXGGZ_WNp3E0V-gGv8Jf9VVuC2LdwXuG4rQX6QyEsimbHA@mail.gmail.com>
Subject: Re: [PATCH] crypto: tcrypt - Remove unused poly1305 support
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"

On Fri, 14 Nov 2025 at 04:05, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Since the crypto_shash support for poly1305 was removed, the tcrypt
> support for it is now unused as well.  Support for benchmarking the
> kernel's Poly1305 code is now provided by the poly1305 kunit test.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>
> This patch is targeting cryptodev/master
>
>  crypto/tcrypt.c |  4 ----
>  crypto/tcrypt.h | 18 ------------------
>  2 files changed, 22 deletions(-)
>
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index d1d88debbd71..3baff6bfb9d1 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -2266,14 +2266,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
>                 fallthrough;
>         case 319:
>                 test_hash_speed("crc32c", sec, generic_hash_speed_template);
>                 if (mode > 300 && mode < 400) break;
>                 fallthrough;
> -       case 321:
> -               test_hash_speed("poly1305", sec, poly1305_speed_template);
> -               if (mode > 300 && mode < 400) break;
> -               fallthrough;
>         case 322:
>                 test_hash_speed("sha3-224", sec, generic_hash_speed_template);
>                 if (mode > 300 && mode < 400) break;
>                 fallthrough;
>         case 323:
> diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
> index 7f938ac93e58..85c3f77bcfb4 100644
> --- a/crypto/tcrypt.h
> +++ b/crypto/tcrypt.h
> @@ -94,24 +94,6 @@ static struct hash_speed generic_hash_speed_template[] = {
>
>         /* End marker */
>         {  .blen = 0,   .plen = 0, }
>  };
>
> -static struct hash_speed poly1305_speed_template[] = {
> -       { .blen = 96,   .plen = 16, },
> -       { .blen = 96,   .plen = 32, },
> -       { .blen = 96,   .plen = 96, },
> -       { .blen = 288,  .plen = 16, },
> -       { .blen = 288,  .plen = 32, },
> -       { .blen = 288,  .plen = 288, },
> -       { .blen = 1056, .plen = 32, },
> -       { .blen = 1056, .plen = 1056, },
> -       { .blen = 2080, .plen = 32, },
> -       { .blen = 2080, .plen = 2080, },
> -       { .blen = 4128, .plen = 4128, },
> -       { .blen = 8224, .plen = 8224, },
> -
> -       /* End marker */
> -       {  .blen = 0,   .plen = 0, }
> -};
> -
>  #endif /* _CRYPTO_TCRYPT_H */
>
> base-commit: d633730bb3873578a00fde4b97f9ac62a1be8d34
> --
> 2.51.2
>
>
