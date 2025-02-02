Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABB21F9F65;
	Sun,  2 Feb 2025 14:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738506701; cv=none; b=BV42yTcrZdPDtrFZpt17xaUymFzJzfHaH6F2SN01O3+eYErPBfZMqB1OuuW78arb6AfFdMrd01sCASrLfhWbFhE0ofWjLDBUusDuhorml2r4TvySQfflR0Q9uDhbtdV9F/yu+03CY0E7bv0+NEWnSacWKoWq9+DtBcAuABYm36I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738506701; c=relaxed/simple;
	bh=CkmZWRHL7U+9vQ2VN/E7cee2NL7Lwa5MxL18HlBUD7w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b8jbL22VkC844Ppdg1wpNpSJQvIGM8fTV3e7WV9NxTqR43jQ9qXkI5PWA2GxqVXMCVD99eTKOQQ40MFPBtM3F8u46Ji99WlpEeAWnD8I8ZMaI5AM0aIGXsLJ63x5MqCK27EpEAyfkffrRW+SnPBQPscz+Gy8JAzbeggLkNhCS80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=COuIHXFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="COuIHXFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAED5C4CEE4;
	Sun,  2 Feb 2025 14:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738506700;
	bh=CkmZWRHL7U+9vQ2VN/E7cee2NL7Lwa5MxL18HlBUD7w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=COuIHXFvY9Fmz8k14Tt+PaXNqxvnQ2flvDJEc9wjySYd6LKFnHTTB7o/XrYxFJIuh
	 TvIKgc4FmDfRYZRRg9lsoWkCfq44zi6EuEVlthbYHvBoa4kvDCAiNgwaV9wxT2lN1p
	 auSbQfCVCNvhR0gOpJI4bBczNbKSaD7SmywxaqoMkhTI+hqRUz79uTSYvE94XQlL+4
	 e70Bdkt9kYORsa9zc7ykpHehtuSDm5tnP8SaqXyQ0J2iFquuC0K+Lal+lqqJVVzWvD
	 cn+GDzFEv0qFPhJY15l6/tPsLDa3MrYDc24OQ6KzWOf3h7quOKuEhtGLZUDJf3sYzp
	 faYlj0yVRoQfA==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5439a6179a7so3718620e87.1;
        Sun, 02 Feb 2025 06:31:40 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVS8Q5QVhhOyF7QBXUYpgK8zR4VKGmCRpWt5ReXgED0WqeXqFF7wOAK+/SOLZrkKQiAtBjG4KG2qw06/g==@vger.kernel.org, AJvYcCXVc0bXPFgbEteMHG9VdB2vPPQ7ZNIpPEqhGS5v+ZO1qlV2RkGcyMoyZriSZkejiP3w6XQ5KC8QuV8EJf+2@vger.kernel.org
X-Gm-Message-State: AOJu0YwO9aaL6gymuhSu1/QtApANL4g0VcLA1WzZMsUhBKMxS5RPMksL
	/XDcWF71+D1bd4tUY1tZ+oSfxX65LmXXAxS9pmeVHi27X9HPxILbEUb/84bxzrAMjJG5E9+oa7o
	Zh0GNly729wn4ZyEWaL8IhDhlf+c=
X-Google-Smtp-Source: AGHT+IEQeSMyoRHbZbJv5099JI+erk95/GnmFnPSzwQOPTruEfIivETEmL1Rsq2c9JFpXeaImyGgsz4dLL+QhTO6FT4=
X-Received: by 2002:a05:6512:3f27:b0:541:324e:d3ac with SMTP id
 2adb3069b0e04-543f0eddce9mr3314661e87.3.1738506699058; Sun, 02 Feb 2025
 06:31:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250130035130.180676-1-ebiggers@kernel.org> <20250130035130.180676-6-ebiggers@kernel.org>
In-Reply-To: <20250130035130.180676-6-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 2 Feb 2025 15:31:28 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG1y4GKQLb5nkNKonV8xEKethwMps7R-Pr-9MRgGPpxSw@mail.gmail.com>
X-Gm-Features: AWEUYZk_93hvmJv5xf_ICL9sWSiT0RKTicZH6ANMBpKGURarhX1mYS--Rem7CM4
Message-ID: <CAMj1kXG1y4GKQLb5nkNKonV8xEKethwMps7R-Pr-9MRgGPpxSw@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] lib/crc64: add support for arch-optimized implementations
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 30 Jan 2025 at 04:54, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Add support for architecture-optimized implementations of the CRC64
> library functions, following the approach taken for the CRC32 and
> CRC-T10DIF library functions.
>
> Also take the opportunity to tweak the function prototypes:
> - Use 'const void *' for the lib entry points (since this is easier for
>   users) but 'const u8 *' for the underlying arch and generic functions
>   (since this is easier for the implementations of these functions).
> - Don't bother with __pure.  It's an unusual optimization that doesn't
>   help properly written code.  It's a weird quirk we can do without.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  include/linux/crc64.h | 26 ++++++++++++++++++++++----
>  lib/Kconfig           |  7 +++++++
>  lib/crc64.c           | 36 ++++++++----------------------------
>  3 files changed, 37 insertions(+), 32 deletions(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/include/linux/crc64.h b/include/linux/crc64.h
> index 17cf5af3e78e..41de30b907df 100644
> --- a/include/linux/crc64.h
> +++ b/include/linux/crc64.h
> @@ -5,12 +5,28 @@
>  #ifndef _LINUX_CRC64_H
>  #define _LINUX_CRC64_H
>
>  #include <linux/types.h>
>
> -u64 __pure crc64_be(u64 crc, const void *p, size_t len);
> -u64 __pure crc64_nvme_generic(u64 crc, const void *p, size_t len);
> +u64 crc64_be_arch(u64 crc, const u8 *p, size_t len);
> +u64 crc64_be_generic(u64 crc, const u8 *p, size_t len);
> +u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len);
> +u64 crc64_nvme_generic(u64 crc, const u8 *p, size_t len);
> +
> +/**
> + * crc64_be - Calculate bitwise big-endian ECMA-182 CRC64
> + * @crc: seed value for computation. 0 or (u64)~0 for a new CRC calculation,
> + *       or the previous crc64 value if computing incrementally.
> + * @p: pointer to buffer over which CRC64 is run
> + * @len: length of buffer @p
> + */
> +static inline u64 crc64_be(u64 crc, const void *p, size_t len)
> +{
> +       if (IS_ENABLED(CONFIG_CRC64_ARCH))
> +               return crc64_be_arch(crc, p, len);
> +       return crc64_be_generic(crc, p, len);
> +}
>
>  /**
>   * crc64_nvme - Calculate CRC64-NVME
>   * @crc: seed value for computation. 0 for a new CRC calculation, or the
>   *      previous crc64 value if computing incrementally.
> @@ -18,11 +34,13 @@ u64 __pure crc64_nvme_generic(u64 crc, const void *p, size_t len);
>   * @len: length of buffer @p
>   *
>   * This computes the CRC64 defined in the NVME NVM Command Set Specification,
>   * *including the bitwise inversion at the beginning and end*.
>   */
> -static inline u64 crc64_nvme(u64 crc, const u8 *p, size_t len)
> +static inline u64 crc64_nvme(u64 crc, const void *p, size_t len)
>  {
> -       return crc64_nvme_generic(crc, p, len);
> +       if (IS_ENABLED(CONFIG_CRC64_ARCH))
> +               return ~crc64_nvme_arch(~crc, p, len);
> +       return ~crc64_nvme_generic(~crc, p, len);
>  }
>
>  #endif /* _LINUX_CRC64_H */
> diff --git a/lib/Kconfig b/lib/Kconfig
> index da07fd39cf97..67bbf4f64dd9 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -199,10 +199,17 @@ config CRC64
>           This option is provided for the case where no in-kernel-tree
>           modules require CRC64 functions, but a module built outside
>           the kernel tree does. Such modules that use library CRC64
>           functions require M here.
>
> +config ARCH_HAS_CRC64
> +       bool
> +
> +config CRC64_ARCH
> +       tristate
> +       default CRC64 if ARCH_HAS_CRC64 && CRC_OPTIMIZATIONS
> +
>  config CRC4
>         tristate "CRC4 functions"
>         help
>           This option is provided for the case where no in-kernel-tree
>           modules require CRC4 functions, but a module built outside
> diff --git a/lib/crc64.c b/lib/crc64.c
> index d6f3f245eede..5b1b17057f0a 100644
> --- a/lib/crc64.c
> +++ b/lib/crc64.c
> @@ -39,40 +39,20 @@
>  #include "crc64table.h"
>
>  MODULE_DESCRIPTION("CRC64 calculations");
>  MODULE_LICENSE("GPL v2");
>
> -/**
> - * crc64_be - Calculate bitwise big-endian ECMA-182 CRC64
> - * @crc: seed value for computation. 0 or (u64)~0 for a new CRC calculation,
> - *       or the previous crc64 value if computing incrementally.
> - * @p: pointer to buffer over which CRC64 is run
> - * @len: length of buffer @p
> - */
> -u64 __pure crc64_be(u64 crc, const void *p, size_t len)
> +u64 crc64_be_generic(u64 crc, const u8 *p, size_t len)
>  {
> -       size_t i, t;
> -
> -       const unsigned char *_p = p;
> -
> -       for (i = 0; i < len; i++) {
> -               t = ((crc >> 56) ^ (*_p++)) & 0xFF;
> -               crc = crc64table[t] ^ (crc << 8);
> -       }
> -
> +       while (len--)
> +               crc = (crc << 8) ^ crc64table[(crc >> 56) ^ *p++];
>         return crc;
>  }
> -EXPORT_SYMBOL_GPL(crc64_be);
> +EXPORT_SYMBOL_GPL(crc64_be_generic);
>
> -u64 __pure crc64_nvme_generic(u64 crc, const void *p, size_t len)
> +u64 crc64_nvme_generic(u64 crc, const u8 *p, size_t len)
>  {
> -       const unsigned char *_p = p;
> -       size_t i;
> -
> -       crc = ~crc;
> -
> -       for (i = 0; i < len; i++)
> -               crc = (crc >> 8) ^ crc64nvmetable[(crc & 0xff) ^ *_p++];
> -
> -       return ~crc;
> +       while (len--)
> +               crc = (crc >> 8) ^ crc64nvmetable[(crc & 0xff) ^ *p++];
> +       return crc;
>  }
>  EXPORT_SYMBOL_GPL(crc64_nvme_generic);
> --
> 2.48.1
>
