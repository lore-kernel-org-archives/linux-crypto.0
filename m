Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127ABC4167D
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Oct 2023 13:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344489AbjJaNSc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Oct 2023 09:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344461AbjJaNSb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Oct 2023 09:18:31 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FCFDF
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2023 06:18:29 -0700 (PDT)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 197AF3F1D9
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2023 13:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1698758308;
        bh=uvHqCrq9wXa0TDS7Jj958/xFYGi/3ExdWX51LoPq1wo=;
        h=Message-ID:Date:MIME-Version:Subject:To:References:From:
         In-Reply-To:Content-Type;
        b=p6hSyH9B0oFam85mRnWKGXaLQSJP5YJd/VdlzdWuYoozqVwWlGbyIlL76jlicpqoJ
         S2XpPSse5HRg83qaixk7zC0ergtuqor86IGn2d5SvsnCXD0lzCU8AS2jsDEyWfExzQ
         k0+nXv5FXoUcsyxGMa2kkfrXNUmsdnaaT9IzT0p0iUG2rmjkK7OfjmLss3ApZe25RW
         Vr7CWvQaHgYXeTWwZQvbkaZpya+wPSM9n5o8h4wna/I/IPcD/88xh2UrAOd3ilgZQW
         9OgTa1GPsDwmEazyW0nUkXl//vsG/f3Y77bJ5OEZMtSDMfbIoa+qe3RX7GkF6/IcK7
         Wm8hVAvs39snQ==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9c749c28651so390454566b.0
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2023 06:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698758307; x=1699363107;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uvHqCrq9wXa0TDS7Jj958/xFYGi/3ExdWX51LoPq1wo=;
        b=sVnf0c960ffBTO8juB8z9pt5Zzrk5RInI3Bj/AAAg/b1+1xWX7HoF4IhV0gkjTo0TT
         c/+haIwZ9OHoWn+N8iee3iydrKXJaKY26PPxJ6hgdtN1otGNRYR9OvG0wpz0oPipdbyF
         WPvT7W2CKeZcqVVNR3n633/TvYYPz99J1PkRmO5ZV/8zXB7IJ7SKsDLA3DKW/Ux9bTGf
         3wM3/cE5xSNZs2bTwnPN8UHDtqpsVQmMH1SbznLAyNI0BFXH17bU5kKhfGKxJ0Wn8kTq
         UpaWqCMm8X3ukF4AUlz5aq9gz1Hn2ENyynz+SdWKu4vAMOJol2PH0j7hSrJftVONuXA8
         P2Zg==
X-Gm-Message-State: AOJu0Yz0VsvbP+i7sKjp0HXQHD5EehiuB5gQkgvzVXzO/g2YAA82X6Ed
        Kx+iAjV5sEBMDdnwr2FanNzRCR2d2a5RwnswoZ+1DYDSpt6HZJv9aNcRC+ettU75jFIITnKVkUp
        xHQtgFiib2xXIK6Jr4C01BOcg3aYQMzNtFqQBVvyIwg==
X-Received: by 2002:a17:907:3185:b0:9b2:b95e:3825 with SMTP id xe5-20020a170907318500b009b2b95e3825mr9980124ejb.39.1698758307215;
        Tue, 31 Oct 2023 06:18:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGT1VS9GgAUUWEi5p+w5LhjfUT5qrZ5qhNVLePrSdvHEVQnR5qmG3ZVfyZUj+tRKZfqBpptTA==
X-Received: by 2002:a17:907:3185:b0:9b2:b95e:3825 with SMTP id xe5-20020a170907318500b009b2b95e3825mr9980105ejb.39.1698758306840;
        Tue, 31 Oct 2023 06:18:26 -0700 (PDT)
Received: from [192.168.0.189] (77-169-125-32.fixed.kpn.net. [77.169.125.32])
        by smtp.gmail.com with ESMTPSA id p16-20020a1709060e9000b009786c8249d6sm973306ejf.175.2023.10.31.06.18.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Oct 2023 06:18:26 -0700 (PDT)
Message-ID: <32541ecd-690d-4db6-aa00-6e7bd6389822@canonical.com>
Date:   Tue, 31 Oct 2023 14:18:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: x86/sha1 - autoload if SHA-NI detected
To:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20231029051535.157605-1-ebiggers@kernel.org>
Content-Language: en-US
From:   Roxana Nicolescu <roxana.nicolescu@canonical.com>
Autocrypt: addr=roxana.nicolescu@canonical.com; keydata=
 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 Og==
In-Reply-To: <20231029051535.157605-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 29/10/2023 06:15, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> The x86 SHA-1 module contains four implementations: SSSE3, AVX, AVX2,
> and SHA-NI.  Commit 1c43c0f1f84a ("crypto: x86/sha - load modules based
> on CPU features") made the module be autoloaded when SSSE3, AVX, or AVX2
> is detected.  The omission of SHA-NI appears to be an oversight, perhaps
> because of the outdated file-level comment.  This patch fixes this,
> though in practice this makes no difference because SSSE3 is a subset of
> the other three features anyway.  Indeed, sha1_ni_transform() executes
> SSSE3 instructions such as pshufb.
>
> Cc: Roxana Nicolescu <roxana.nicolescu@canonical.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Indeed, it was an oversight.


Reviewed-by: Roxana Nicolescu <roxana.nicolescu@canonical.com>
> ---
>   arch/x86/crypto/sha1_ssse3_glue.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
> index 959afa705e95..d88991f2cb3a 100644
> --- a/arch/x86/crypto/sha1_ssse3_glue.c
> +++ b/arch/x86/crypto/sha1_ssse3_glue.c
> @@ -1,16 +1,16 @@
>   // SPDX-License-Identifier: GPL-2.0-or-later
>   /*
>    * Cryptographic API.
>    *
> - * Glue code for the SHA1 Secure Hash Algorithm assembler implementation using
> - * Supplemental SSE3 instructions.
> + * Glue code for the SHA1 Secure Hash Algorithm assembler implementations
> + * using SSSE3, AVX, AVX2, and SHA-NI instructions.
>    *
>    * This file is based on sha1_generic.c
>    *
>    * Copyright (c) Alan Smithee.
>    * Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
>    * Copyright (c) Jean-Francois Dive <jef@linuxbe.org>
>    * Copyright (c) Mathias Krause <minipli@googlemail.com>
>    * Copyright (c) Chandramouli Narayanan <mouli@linux.intel.com>
>    */
>   
> @@ -21,20 +21,21 @@
>   #include <linux/init.h>
>   #include <linux/module.h>
>   #include <linux/mm.h>
>   #include <linux/types.h>
>   #include <crypto/sha1.h>
>   #include <crypto/sha1_base.h>
>   #include <asm/cpu_device_id.h>
>   #include <asm/simd.h>
>   
>   static const struct x86_cpu_id module_cpu_ids[] = {
> +	X86_MATCH_FEATURE(X86_FEATURE_SHA_NI, NULL),
>   	X86_MATCH_FEATURE(X86_FEATURE_AVX2, NULL),
>   	X86_MATCH_FEATURE(X86_FEATURE_AVX, NULL),
>   	X86_MATCH_FEATURE(X86_FEATURE_SSSE3, NULL),
>   	{}
>   };
>   MODULE_DEVICE_TABLE(x86cpu, module_cpu_ids);
>   
>   static int sha1_update(struct shash_desc *desc, const u8 *data,
>   			     unsigned int len, sha1_block_fn *sha1_xform)
>   {
>
> base-commit: f2b88bab69c86d4dab2bfd25a0e741d7df411f7a
