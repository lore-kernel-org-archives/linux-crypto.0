Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA292228CA9;
	Thu,  6 Feb 2025 11:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738840176; cv=none; b=Zf7Mw0FuQUmnvxPq+Jeo4eIP5ee4yer18ucJ/T9TnG5srdAxvOaRf4o3zODwj4VaQzq5FfLaGXh7no0GDE4u0hlVqyBT+wA4Vsyw+ua6CX/AVquPWJ0/gWJpYRYn8jeaDk5uk3K03zCsNU6vOBU/yjKQcfwPDUd01BNiGD+elXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738840176; c=relaxed/simple;
	bh=znQlYFszf8Qj5PTYLib001RCt1Ha/9Q/gHiPmcVioug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GP6lGocL3U19JSh3SKL9my5gBVFEhUJY5grrgDbntVYw5Gk361UsbP0UvCrLqbRfZI3ODV7tGatvFAShmPcgpQ0YETH+pVno4nncogLI2IqcNBTcrvERNtuDV/H3u2n7MHnyvQcv3XhDPH1YEnJr5wsCZ8LKIqUWTp5ldFjsotw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HW3kDufw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HW3kDufw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58537C4CEDD;
	Thu,  6 Feb 2025 11:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738840175;
	bh=znQlYFszf8Qj5PTYLib001RCt1Ha/9Q/gHiPmcVioug=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HW3kDufwwjLhY/DrMwrinaOavwn9bOg4oKHmyJN5ggUvVYZ39zGcd3RWND/X1SaRJ
	 9Up88iRP8/4xYaqpgtPQvilPFI3+fxC+81B0sWcQde8Hd8lHrOAzE59LX3f7ADbRth
	 T8RE3U62hw0+TP0vuwCstfCUK4GNGkrf4qtDtTD96wUcZfIt2/6K0TunRF0v/OIIiL
	 oGSiExquhgoniWVOodtTsaGY7VPUr7FtqhUOZY6B3364slOgYskRdR8HgZkcxyd2k3
	 OGvn1pU723IDnaMaSzySZ4BnVVz+f0X/RMbbnksji4pmYulcRjIloXLN/5LuO4VhiI
	 tvxTTPJHjdZLg==
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3078fb1fa28so7618151fa.3;
        Thu, 06 Feb 2025 03:09:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV+vt1DiYPcbHK6u5l4a1+/hw5sSXm5dyqHPOgxOGdA2KRzYrAWs/lX63SLEM8TMb4sPSXtIbFZZxtygSs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxR9bISwTwtDFwfZ83hCbLxpHCYnb26HelYk7kLxlwqvquXpMy7
	nWm/Mg1LpuUCKdExlEsDYfa3LRrxOcmYXI9H2zDXEnhuhhnEZs9RR23NJdbzPBKRQCAurW/qn8R
	z9iBosNLxa0lWG9L+SfQZQOI7HvU=
X-Google-Smtp-Source: AGHT+IH4SvwTTCCYMvTw+8VtCLEUUV8WHLnIaRBN27lccumU1crnkMIshBPMvuBoMpQK+q9Gnj3Zs9PIrW19SZBTeuM=
X-Received: by 2002:a05:651c:1614:b0:302:264e:29dd with SMTP id
 38308e7fff4ca-307cf370987mr24341671fa.24.1738840173682; Thu, 06 Feb 2025
 03:09:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250204201108.48039-1-ebiggers@kernel.org>
In-Reply-To: <20250204201108.48039-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 6 Feb 2025 12:09:22 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGjc6Abm1eHANt7w=D5eVpJXHHNo_7ZcyRMNMNwirZoHg@mail.gmail.com>
X-Gm-Features: AWEUYZmv38e6P2rPDqLxwC4kAv-lSurp3G1nxsusgfuuaCkkii4IkfyRLTLXoro
Message-ID: <CAMj1kXGjc6Abm1eHANt7w=D5eVpJXHHNo_7ZcyRMNMNwirZoHg@mail.gmail.com>
Subject: Re: [PATCH] lib/crc-t10dif: remove digest and block size constants
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 4 Feb 2025 at 21:11, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> These constants are only used in crypto/crct10dif_generic.c, and they
> are better off just hardcoded there.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>
> I'm planning to take this via the crc tree.
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

Could you remind me why we are keeping this driver?


>  crypto/crct10dif_generic.c | 8 ++++----
>  include/linux/crc-t10dif.h | 3 ---
>  2 files changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/crypto/crct10dif_generic.c b/crypto/crct10dif_generic.c
> index 259cb01932cb5..fdfe78aba3ae0 100644
> --- a/crypto/crct10dif_generic.c
> +++ b/crypto/crct10dif_generic.c
> @@ -114,34 +114,34 @@ static int chksum_digest_arch(struct shash_desc *desc, const u8 *data,
>  {
>         return __chksum_finup_arch(0, data, length, out);
>  }
>
>  static struct shash_alg algs[] = {{
> -       .digestsize             = CRC_T10DIF_DIGEST_SIZE,
> +       .digestsize             = sizeof(u16),
>         .init                   = chksum_init,
>         .update                 = chksum_update,
>         .final                  = chksum_final,
>         .finup                  = chksum_finup,
>         .digest                 = chksum_digest,
>         .descsize               = sizeof(struct chksum_desc_ctx),
>         .base.cra_name          = "crct10dif",
>         .base.cra_driver_name   = "crct10dif-generic",
>         .base.cra_priority      = 100,
> -       .base.cra_blocksize     = CRC_T10DIF_BLOCK_SIZE,
> +       .base.cra_blocksize     = 1,
>         .base.cra_module        = THIS_MODULE,
>  }, {
> -       .digestsize             = CRC_T10DIF_DIGEST_SIZE,
> +       .digestsize             = sizeof(u16),
>         .init                   = chksum_init,
>         .update                 = chksum_update_arch,
>         .final                  = chksum_final,
>         .finup                  = chksum_finup_arch,
>         .digest                 = chksum_digest_arch,
>         .descsize               = sizeof(struct chksum_desc_ctx),
>         .base.cra_name          = "crct10dif",
>         .base.cra_driver_name   = "crct10dif-" __stringify(ARCH),
>         .base.cra_priority      = 150,
> -       .base.cra_blocksize     = CRC_T10DIF_BLOCK_SIZE,
> +       .base.cra_blocksize     = 1,
>         .base.cra_module        = THIS_MODULE,
>  }};
>
>  static int num_algs;
>
> diff --git a/include/linux/crc-t10dif.h b/include/linux/crc-t10dif.h
> index 16787c1cee21c..d0706544fc11f 100644
> --- a/include/linux/crc-t10dif.h
> +++ b/include/linux/crc-t10dif.h
> @@ -2,13 +2,10 @@
>  #ifndef _LINUX_CRC_T10DIF_H
>  #define _LINUX_CRC_T10DIF_H
>
>  #include <linux/types.h>
>
> -#define CRC_T10DIF_DIGEST_SIZE 2
> -#define CRC_T10DIF_BLOCK_SIZE 1
> -
>  u16 crc_t10dif_arch(u16 crc, const u8 *p, size_t len);
>  u16 crc_t10dif_generic(u16 crc, const u8 *p, size_t len);
>
>  static inline u16 crc_t10dif_update(u16 crc, const u8 *p, size_t len)
>  {
>
> base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
> --
> 2.48.1
>
