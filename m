Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7EEC352AA
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E54B21783
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:47:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="klrtSd9x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfJBOrS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:47:18 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36238 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbfJBOrK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:47:10 -0400
Received: by mail-wr1-f67.google.com with SMTP id y19so20011724wrd.3
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 07:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V+28Bfx9nZyZNhk5cPbt+tiyzN/EnbhTEEnFK4bFz+g=;
        b=klrtSd9x7EFwa+Ec7wdiT3ZU6NGyfGGOIz4UXMXCRHjDyHEjKJDjiRTa/OiN0h+6fF
         c0z7zCfUDOQ/vG9/HDM6evXq+ROZReXHHyflxjZgIWuDPE1zKFUnY9J9W6yTzm+/QWN7
         jWHNnCm8R4fqdbqhwbCwWYHkje5Yv42o/kK+YxdN+NnkZSXD5O+ZfXiSQ+9gRehhA7jl
         I8eMtomtae3UW0tz+b5pIPYPMN1wTq0x1Ezsxpln+PcSXN14/RgYT5l7NPL/DN5JpI+A
         ilkQ7+xfcRWMZ6aeEeYWC83bAm/9opVbedCjSIPNygFp93eOJUS8WGka+WZRuJCN5/vq
         LICA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V+28Bfx9nZyZNhk5cPbt+tiyzN/EnbhTEEnFK4bFz+g=;
        b=OMDzuGaiaORQIGZLTZNd5n0g32o/I2YgdRoH9X2bhYhypAr+ZsEzqiEi/QmD5GgDsB
         ce1eAnelfEnjxfzxbvQwmAlpGtq9u5ZwJ11v73BQBOVnz0tbP00Yvpr3XUul9Zcylpml
         nbt0v2tSDepKlPoNPYgxLE8gCisomdtNFJBtM+0P3Y5cZHeF9x3vlZaQRTZsV0J3pzTB
         tbf/JDlsdFePBrkzuNQo66JPCppbAFfjZ3F/Nw7Ai6WQrpXKJs8Or28lJms8+hP/m0XD
         MpM0nr0OEXuZ1KosNXWvHyGmt/6RAouWTykkEMqWVY1Kbn2H+LhcUwAyPgTImaE1kCzy
         jwew==
X-Gm-Message-State: APjAAAWBQbhsYg/xqwXyHM18jhjM80D8daRCxQQ0s1I6j8HQMg+hSHXk
        RejAFnIjVAO4g2pvkJPh+fs=
X-Google-Smtp-Source: APXvYqxOApt+Ib7W2aca1ctQvpnldVWnhC4F/Z1Qxm2J5MaxNawfJ1Pmu7x+kGhk2leM176w2wovwg==
X-Received: by 2002:a5d:470e:: with SMTP id y14mr2926417wrq.332.1570027629083;
        Wed, 02 Oct 2019 07:47:09 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id p7sm7324459wma.34.2019.10.02.07.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 07:47:08 -0700 (PDT)
Date:   Wed, 2 Oct 2019 07:47:06 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        arnd@arndb.de, ndesaulniers@google.com
Subject: Re: [PATCH] crypto: aegis128/simd - build 32-bit ARM for v8
 architecture explicitly
Message-ID: <20191002144706.GA957871@archlinux-threadripper>
References: <20191002075448.6453-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002075448.6453-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thank you for fixing this, it is much appreciated!

On Wed, Oct 02, 2019 at 09:54:48AM +0200, Ard Biesheuvel wrote:
> Now that the Clang compiler has taken it upon itself to police the
> compiler command line, and reject combinations for arguments it views
> as incompatible, the AEGIS128 no longer builds correctly, and errors
> out like this:
> 
>   clang-10: warning: ignoring extension 'crypto' because the 'armv7-a'
>   architecture does not support it [-Winvalid-command-line-argument]
> 
> So let's switch to armv8-a instead, which matches the crypto-neon-fp-armv8
> FPU profile we specify. Since neither were actually supported by GCC
> versions before 4.8, let's tighten the Kconfig dependencies as well so
> we won't run into errors when building with an ancient compiler.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Minor nit below but regardless.

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  crypto/Kconfig  | 1 +
>  crypto/Makefile | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index e928f88b6206..b138b68329dc 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -331,6 +331,7 @@ config CRYPTO_AEGIS128
>  config CRYPTO_AEGIS128_SIMD
>  	bool "Support SIMD acceleration for AEGIS-128"
>  	depends on CRYPTO_AEGIS128 && ((ARM || ARM64) && KERNEL_MODE_NEON)
> +	depends on !ARM || CC_IS_CLANG || GCC_VERSION >= 40800

This !ARM is a bit misleading to me given the (ARM || ARM64) requirement
right above it and the fact that crypto/Makefile gates the addition of
the NEON files to aegis128-y to $(ARCH) = arm or arm64.

>  	default y
>  
>  config CRYPTO_AEGIS128_AESNI_SSE2
> diff --git a/crypto/Makefile b/crypto/Makefile
> index fcb1ee679782..aa740c8492b9 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -93,7 +93,7 @@ obj-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
>  aegis128-y := aegis128-core.o
>  
>  ifeq ($(ARCH),arm)
> -CFLAGS_aegis128-neon-inner.o += -ffreestanding -march=armv7-a -mfloat-abi=softfp
> +CFLAGS_aegis128-neon-inner.o += -ffreestanding -march=armv8-a -mfloat-abi=softfp
>  CFLAGS_aegis128-neon-inner.o += -mfpu=crypto-neon-fp-armv8
>  aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
>  endif
> -- 
> 2.20.1
> 
