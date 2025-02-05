Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1C516CD1D;
	Wed,  5 Feb 2025 15:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738769760; cv=none; b=d0fT9IbDkgeCJgvgT2P5KAsVeomTdujDZBktvxv6tkhu+gCaDM0mIk3F4Ho92gKqHn2K6H+OFFi1HB1H3tSEBejTzLkNKd6p1hVXrhfBXwt1HJv6LI1dzBCnCQbifXE9xl1xB37YYrDxwX1URjlDoWsnJL9Uz9YX6QMp4PHPFa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738769760; c=relaxed/simple;
	bh=uiJavePqixiqoSrlO3ZE+tW7T+WNC6gXkPrlh5xEtPQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zqx7CZaCsXB6FZYxtqr8NPvnwikY0EA7Ga5jxH5vturRjNPjTk/hophwhEKmWzLNhxJUJcKXpU4BiS06BpOpFL5iend/Vy+ONZl6toQ9hLXLuky/vqdgD68xSKDQSFg8uTNRExpzD2LVf5Qa6epxJMOWTRXnvLPXEdD0JwgSfWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrQsJKLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrQsJKLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9ABC4CED1;
	Wed,  5 Feb 2025 15:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738769760;
	bh=uiJavePqixiqoSrlO3ZE+tW7T+WNC6gXkPrlh5xEtPQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jrQsJKLb6dx81k2DOjDXcb00WzHF4ND6Sq7k8eZcnba/Gb27y5bwnNTC4PKsW9GwW
	 Uk9PR26JPw1kqhFa8pfQrlhcfUNbCv4uwTkQgXRYyhxoBhMyBEaDWi6Fa0AAKpodyj
	 n8I4IKqKAsQ3IDK1F/zehXclKFMds1louCnN63Tw95rXFuzFRR//X/vj5j+QUwgKCM
	 W7gku6X8WxWTdZ0fOFZ6HJNJSKiGYXuFAtu2uyxm6W2QFWVnXMxHfDkuA8d/1/Wf9w
	 o1grXf2E8Gsz/cFqtFXY6vH8OYuHHBQjGyFOPysvuia5/utHV7m6JvurIDqop136CT
	 bK2TxSlAaodwQ==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-543e47e93a3so7411086e87.2;
        Wed, 05 Feb 2025 07:35:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWl2oC4tB72cEOPoJRRrNe0s/5r2rkV/12VY5XPkHQjKSD2M2jBcL4+btupFXty/Ge7VRYjGdI9f8e5QVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxS6ykJiSvKOE5zSCfsWji/u1sLzm8ZQeI6KPj0ZYgXI3AEzkrh
	HcmgG5TIVqJHgJojz/gEg5YPYrAg5I6+dl0o0jSRPRuJmUZHQ8zrtt5E5JHh5SwuqofQe8AMveM
	UmcngWAIu/tbrzNkLolsQFm6tPV0=
X-Google-Smtp-Source: AGHT+IFld6ep/WDbZMsQh+uCUPULr4YtzWoBrgHzHQXjWb03VIpWj6qaj0RjCtZ//GgEa5JnDLEL57z6N2a2R5FQiFw=
X-Received: by 2002:ac2:4c49:0:b0:53e:39c2:f021 with SMTP id
 2adb3069b0e04-54405a22561mr1250907e87.15.1738769758287; Wed, 05 Feb 2025
 07:35:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250205000424.75149-1-ebiggers@kernel.org>
In-Reply-To: <20250205000424.75149-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 5 Feb 2025 16:35:47 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFhLhXFPAeT-81E3Vrcw+0CCcWB0vzCGKZdYNWp5kLbkA@mail.gmail.com>
X-Gm-Features: AWEUYZnsrN0vDOFs7MMTBBYfgsnBZ_aIPrUWzYdXTJKIgcvfYL8h4QppJCfOwkY
Message-ID: <CAMj1kXFhLhXFPAeT-81E3Vrcw+0CCcWB0vzCGKZdYNWp5kLbkA@mail.gmail.com>
Subject: Re: [PATCH] lib/crc32: remove obsolete CRC32 options from defconfig files
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 5 Feb 2025 at 01:05, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Remove all remaining references to CONFIG_CRC32_BIT,
> CONFIG_CRC32_SARWATE, CONFIG_CRC32_SLICEBY4, and CONFIG_CRC32_SLICEBY8.
> These options no longer exist, now that we've standardized on a single
> generic CRC32 implementation.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/arm/configs/moxart_defconfig         | 1 -
>  arch/mips/configs/bcm47xx_defconfig       | 1 -
>  arch/mips/configs/db1xxx_defconfig        | 1 -
>  arch/mips/configs/rt305x_defconfig        | 1 -
>  arch/mips/configs/xway_defconfig          | 1 -
>  arch/powerpc/configs/adder875_defconfig   | 1 -
>  arch/powerpc/configs/ep88xc_defconfig     | 1 -
>  arch/powerpc/configs/mpc866_ads_defconfig | 1 -
>  arch/powerpc/configs/mpc885_ads_defconfig | 1 -
>  arch/powerpc/configs/tqm8xx_defconfig     | 1 -
>  10 files changed, 10 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>


> diff --git a/arch/arm/configs/moxart_defconfig b/arch/arm/configs/moxart_defconfig
> index 34d079e03b3c5..fa06d98e43fcd 100644
> --- a/arch/arm/configs/moxart_defconfig
> +++ b/arch/arm/configs/moxart_defconfig
> @@ -116,11 +116,10 @@ CONFIG_MOXART_DMA=y
>  CONFIG_EXT3_FS=y
>  CONFIG_TMPFS=y
>  CONFIG_CONFIGFS_FS=y
>  CONFIG_JFFS2_FS=y
>  CONFIG_KEYS=y
> -CONFIG_CRC32_BIT=y
>  CONFIG_DMA_API_DEBUG=y
>  CONFIG_PRINTK_TIME=y
>  CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
>  # CONFIG_ENABLE_MUST_CHECK is not set
>  CONFIG_KGDB=y
> diff --git a/arch/mips/configs/bcm47xx_defconfig b/arch/mips/configs/bcm47xx_defconfig
> index 6a68a96d13f80..f56e8db5da951 100644
> --- a/arch/mips/configs/bcm47xx_defconfig
> +++ b/arch/mips/configs/bcm47xx_defconfig
> @@ -67,11 +67,10 @@ CONFIG_BCMA_DRIVER_GMAC_CMN=y
>  CONFIG_USB=y
>  CONFIG_USB_HCD_BCMA=y
>  CONFIG_USB_HCD_SSB=y
>  CONFIG_LEDS_TRIGGER_TIMER=y
>  CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
> -CONFIG_CRC32_SARWATE=y
>  CONFIG_PRINTK_TIME=y
>  CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
>  CONFIG_DEBUG_INFO_REDUCED=y
>  CONFIG_STRIP_ASM_SYMS=y
>  CONFIG_DEBUG_FS=y
> diff --git a/arch/mips/configs/db1xxx_defconfig b/arch/mips/configs/db1xxx_defconfig
> index 6eff21ff15d54..281dd7d0f8059 100644
> --- a/arch/mips/configs/db1xxx_defconfig
> +++ b/arch/mips/configs/db1xxx_defconfig
> @@ -214,9 +214,8 @@ CONFIG_NLS_UTF8=y
>  CONFIG_SECURITYFS=y
>  CONFIG_CRYPTO_USER=y
>  CONFIG_CRYPTO_CRYPTD=y
>  CONFIG_CRYPTO_USER_API_HASH=y
>  CONFIG_CRYPTO_USER_API_SKCIPHER=y
> -CONFIG_CRC32_SLICEBY4=y
>  CONFIG_FONTS=y
>  CONFIG_FONT_8x8=y
>  CONFIG_MAGIC_SYSRQ=y
> diff --git a/arch/mips/configs/rt305x_defconfig b/arch/mips/configs/rt305x_defconfig
> index 332f9094e8479..8404e0a9d8b22 100644
> --- a/arch/mips/configs/rt305x_defconfig
> +++ b/arch/mips/configs/rt305x_defconfig
> @@ -127,11 +127,10 @@ CONFIG_JFFS2_COMPRESSION_OPTIONS=y
>  CONFIG_SQUASHFS=y
>  # CONFIG_SQUASHFS_ZLIB is not set
>  CONFIG_SQUASHFS_XZ=y
>  CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRC_ITU_T=m
> -CONFIG_CRC32_SARWATE=y
>  # CONFIG_XZ_DEC_X86 is not set
>  # CONFIG_XZ_DEC_POWERPC is not set
>  # CONFIG_XZ_DEC_IA64 is not set
>  # CONFIG_XZ_DEC_ARM is not set
>  # CONFIG_XZ_DEC_ARMTHUMB is not set
> diff --git a/arch/mips/configs/xway_defconfig b/arch/mips/configs/xway_defconfig
> index 08c0aa03fd564..7b91edfe3e075 100644
> --- a/arch/mips/configs/xway_defconfig
> +++ b/arch/mips/configs/xway_defconfig
> @@ -139,11 +139,10 @@ CONFIG_JFFS2_COMPRESSION_OPTIONS=y
>  CONFIG_SQUASHFS=y
>  # CONFIG_SQUASHFS_ZLIB is not set
>  CONFIG_SQUASHFS_XZ=y
>  CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRC_ITU_T=m
> -CONFIG_CRC32_SARWATE=y
>  CONFIG_PRINTK_TIME=y
>  CONFIG_STRIP_ASM_SYMS=y
>  CONFIG_DEBUG_FS=y
>  CONFIG_MAGIC_SYSRQ=y
>  # CONFIG_SCHED_DEBUG is not set
> diff --git a/arch/powerpc/configs/adder875_defconfig b/arch/powerpc/configs/adder875_defconfig
> index 97f4d48517356..3c6445c98a85f 100644
> --- a/arch/powerpc/configs/adder875_defconfig
> +++ b/arch/powerpc/configs/adder875_defconfig
> @@ -42,10 +42,9 @@ CONFIG_THERMAL=y
>  # CONFIG_DNOTIFY is not set
>  CONFIG_TMPFS=y
>  CONFIG_CRAMFS=y
>  CONFIG_NFS_FS=y
>  CONFIG_ROOT_NFS=y
> -CONFIG_CRC32_SLICEBY4=y
>  CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
>  CONFIG_DEBUG_FS=y
>  CONFIG_MAGIC_SYSRQ=y
>  CONFIG_DETECT_HUNG_TASK=y
> diff --git a/arch/powerpc/configs/ep88xc_defconfig b/arch/powerpc/configs/ep88xc_defconfig
> index 50cc59eb36cf1..354180ab94bcc 100644
> --- a/arch/powerpc/configs/ep88xc_defconfig
> +++ b/arch/powerpc/configs/ep88xc_defconfig
> @@ -45,9 +45,8 @@ CONFIG_SERIAL_CPM_CONSOLE=y
>  # CONFIG_DNOTIFY is not set
>  CONFIG_TMPFS=y
>  CONFIG_CRAMFS=y
>  CONFIG_NFS_FS=y
>  CONFIG_ROOT_NFS=y
> -CONFIG_CRC32_SLICEBY4=y
>  CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
>  CONFIG_MAGIC_SYSRQ=y
>  CONFIG_DETECT_HUNG_TASK=y
> diff --git a/arch/powerpc/configs/mpc866_ads_defconfig b/arch/powerpc/configs/mpc866_ads_defconfig
> index 6f449411abf7b..a0d27c59ea788 100644
> --- a/arch/powerpc/configs/mpc866_ads_defconfig
> +++ b/arch/powerpc/configs/mpc866_ads_defconfig
> @@ -37,6 +37,5 @@ CONFIG_EXT4_FS=y
>  CONFIG_TMPFS=y
>  CONFIG_CRAMFS=y
>  CONFIG_NFS_FS=y
>  CONFIG_ROOT_NFS=y
>  CONFIG_CRC_CCITT=y
> -CONFIG_CRC32_SLICEBY4=y
> diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
> index 77306be62e9ee..89da51d724fb1 100644
> --- a/arch/powerpc/configs/mpc885_ads_defconfig
> +++ b/arch/powerpc/configs/mpc885_ads_defconfig
> @@ -68,11 +68,10 @@ CONFIG_TMPFS=y
>  CONFIG_CRAMFS=y
>  CONFIG_NFS_FS=y
>  CONFIG_ROOT_NFS=y
>  CONFIG_CRYPTO=y
>  CONFIG_CRYPTO_DEV_TALITOS=y
> -CONFIG_CRC32_SLICEBY4=y
>  CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
>  CONFIG_MAGIC_SYSRQ=y
>  CONFIG_DEBUG_FS=y
>  CONFIG_DEBUG_VM_PGTABLE=y
>  CONFIG_DETECT_HUNG_TASK=y
> diff --git a/arch/powerpc/configs/tqm8xx_defconfig b/arch/powerpc/configs/tqm8xx_defconfig
> index 383c0966e92fd..425f10837a185 100644
> --- a/arch/powerpc/configs/tqm8xx_defconfig
> +++ b/arch/powerpc/configs/tqm8xx_defconfig
> @@ -52,9 +52,8 @@ CONFIG_HW_RANDOM=y
>  # CONFIG_DNOTIFY is not set
>  CONFIG_TMPFS=y
>  CONFIG_CRAMFS=y
>  CONFIG_NFS_FS=y
>  CONFIG_ROOT_NFS=y
> -CONFIG_CRC32_SLICEBY4=y
>  CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
>  CONFIG_MAGIC_SYSRQ=y
>  CONFIG_DETECT_HUNG_TASK=y
>
> base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
> --
> 2.48.1
>
