Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 676D7C10F14
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 10:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A78C2067B
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 10:33:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TpsPmLAp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730714AbfJOKdj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Oct 2019 06:33:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39723 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730348AbfJOKdj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Oct 2019 06:33:39 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so23200355wrj.6
        for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2019 03:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YSK25mgLP2qGujjcVZMaYH39R8jkExhb9pHpMqbi9GA=;
        b=TpsPmLAphUhP91H2zfTGmqgMFc+tf3x2s40xaEMXb4jarRvDtFZ5Re7Oq97V+ovVBm
         JJba+t1emP9U++I0ssZAbA1j2VgnXDVbnUzdzo75m8UWBXdGcQXSzI1NHBlood8xkfs9
         LDNoJSG14R2jBhOuZwa4ijGXTSdXsAFyDC1ZdEH0/2Q9CSy4OG33qNfW67KQcDIfPemE
         29VJuwe7H83hKYkJpz06O82aT12VYY+/RzuNmAYrqZMFZzB+/yngc9eeGfaZXMeCDQ4J
         Y+zu9ZpcKV9zQODZ1SzuefzABwyShTteUlgYkDBVNjMeSzHywmaiNZ8OcFpWt31pIj5R
         itrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YSK25mgLP2qGujjcVZMaYH39R8jkExhb9pHpMqbi9GA=;
        b=ZRb+q/hh3ErU8dFSm4aprxGFuphwUw6b70MWRXxYf2f38O+S9dVHVkxWNzn+1DPeNj
         kWl08Xw/yZoDU0lH7YjzrJ2DwDdsk5UJs5PG4YZMfvnyMLvDiwPzXAokrz2ec5UT4km7
         uApsjudx+FRD056r+fcWNjLZ9gHfljZxrfHAxtO+MT5eNH492sL0L/WslbDo5ljTrNHK
         y9eenY9P3FA6drpCwFwAbwz8HaRlC/FnyfTUUmI8RSSD2vJTfVi6eTWMmZHZ+fuYSocn
         x0cG1wQToDt9qlVkVdj/0VSRPVsDcS8SXMPsLvcXGk4pGOleXt57c5KwSPCVDRpFseeo
         h7Xg==
X-Gm-Message-State: APjAAAWhPKwsq/u6BpkjvDjmAp90kzXah7MxWd70XYvKsEiSWPILuTyA
        fUFuZylmcXXtGGNDljxRs7cr//PIiuTGkb0uLQxlNd+07jMutAoF
X-Google-Smtp-Source: APXvYqzAzVDkHsjTVyzfvOTUBgHd0YjSgoANEEfLP1CwlPZ8hBLoj9oAW8bPSfn3FKN8hHgs3zbYuM4bXtcIus5kXCg=
X-Received: by 2002:adf:f5c2:: with SMTP id k2mr31748636wrp.0.1571135616941;
 Tue, 15 Oct 2019 03:33:36 -0700 (PDT)
MIME-Version: 1.0
References: <20191015024517.52790-1-ebiggers@kernel.org>
In-Reply-To: <20191015024517.52790-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 15 Oct 2019 12:33:25 +0200
Message-ID: <CAKv+Gu8V50wZyoP8gLAEL8W=w25Ra91E+KyH7-kD18qUyuEOmw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] crypto: powerpc - convert SPE AES algorithms to
 skcipher API
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Markus Stockhausen <stockhausen@collogia.de>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 15 Oct 2019 at 04:45, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series converts the glue code for the PowerPC SPE implementations
> of AES-ECB, AES-CBC, AES-CTR, and AES-XTS from the deprecated
> "blkcipher" API to the "skcipher" API.  This is needed in order for the
> blkcipher API to be removed.
>
> Patch 1-2 are fixes.  Patch 3 is the actual conversion.
>
> Tested with:
>
>         export ARCH=powerpc CROSS_COMPILE=powerpc-linux-gnu-
>         make mpc85xx_defconfig
>         cat >> .config << EOF
>         # CONFIG_MODULES is not set
>         # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
>         CONFIG_DEBUG_KERNEL=y
>         CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
>         CONFIG_CRYPTO_AES=y
>         CONFIG_CRYPTO_CBC=y
>         CONFIG_CRYPTO_CTR=y
>         CONFIG_CRYPTO_ECB=y
>         CONFIG_CRYPTO_XTS=y
>         CONFIG_CRYPTO_AES_PPC_SPE=y
>         EOF
>         make olddefconfig
>         make -j32
>         qemu-system-ppc -M mpc8544ds -cpu e500 -nographic \
>                 -kernel arch/powerpc/boot/zImage \
>                 -append cryptomgr.fuzz_iterations=1000
>
> Note that xts-ppc-spe still fails the comparison tests due to the lack
> of ciphertext stealing support.  This is not addressed by this series.
>
> Changed since v1:
>
> - Split fixes into separate patches.
>
> - Made ppc_aes_setkey_skcipher() call ppc_aes_setkey(), rather than
>   creating a separate expand_key() function.  This keeps the code
>   shorter.
>
> Eric Biggers (3):
>   crypto: powerpc - don't unnecessarily use atomic scatterwalk
>   crypto: powerpc - don't set ivsize for AES-ECB
>   crypto: powerpc - convert SPE AES algorithms to skcipher API
>

For the series

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>


>  arch/powerpc/crypto/aes-spe-glue.c | 389 ++++++++++++-----------------
>  crypto/Kconfig                     |   1 +
>  2 files changed, 166 insertions(+), 224 deletions(-)
>
> --
> 2.23.0
>
