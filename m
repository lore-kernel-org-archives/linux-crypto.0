Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4944C77B6E
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Apr 2023 18:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjDLSjI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Apr 2023 14:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjDLSir (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2023 14:38:47 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C4D8A61
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 11:38:08 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b145b3b03so1190204b3a.1
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 11:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1681324686; x=1683916686;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=uzqaPYFhiYcrhgMVz1koqWzxmdMx5HRlr5KdFg4Jdqo=;
        b=VFJ/EN/rYeRLbq1rSK++4iRY9IK5LsMZ+Au3HBbV2pSoW5Mc+Xd8x/eqHUdGvfKvKG
         c572E73c+TPVORmlbCBtOQBGurSCehn2nvELc74RcCqDj8bs3cYiNok9xv52+gPemd2x
         bGeuVymuViOjQXwcB/UB6YjiRI0xllFAcBRPY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681324686; x=1683916686;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzqaPYFhiYcrhgMVz1koqWzxmdMx5HRlr5KdFg4Jdqo=;
        b=UGmgWt+qeaphftHaZB2PYzl5N7J5oENFMS9JJ7Fxas3F86QREwTNYrVQ9T2OKDgtgW
         QxjSy+dEuAwqniLa4pI/wEhnoNkcaLhpJBjYK7llErVDM4LOknALl6XsygtxSOj4Y3pP
         1f9hiSNzIoR++z9m8331QH5RihxckRUofhQBspR5zy2p7BXMhUwKRaAaOsonwNrs7NS2
         jlZBVZzUd/FH5mu7Ymo8p77OEeCU8MARpaq2bPM34CKd3ZWZGnogLvfIGTCDdv0KWxaz
         0wLlP6Rlm2YZh6iAxOKcfU+7R86KguAZ9TzzFZ3RIJmSx5bF8RHfRfuXlxrUq0ae172B
         WZyA==
X-Gm-Message-State: AAQBX9cE1miwBwLpLKBCXax9SXZwJPzO6CyUG1sp8cIwhLNhhTrsNoXi
        n5ohEW5C2LmbD2qK273zfsT1VA==
X-Google-Smtp-Source: AKy350Y+3emyR9cuvHV2yu5iDaTuuxSNd7DmcVnnxhkZKhaDUWh/AnC/HNLqruA+G8tQgUhXiJYBCw==
X-Received: by 2002:a05:6a00:710:b0:627:e677:bc70 with SMTP id 16-20020a056a00071000b00627e677bc70mr3674794pfl.14.1681324686627;
        Wed, 12 Apr 2023 11:38:06 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id i16-20020aa78d90000000b0062e00158bf4sm12054395pfr.208.2023.04.12.11.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 11:38:06 -0700 (PDT)
Message-ID: <6436fa8e.a70a0220.ee07e.7bff@mx.google.com>
X-Google-Original-Message-ID: <202304121137.@keescook>
Date:   Wed, 12 Apr 2023 11:38:05 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 00/13] crypto: x86 - avoid absolute references
References: <20230412110035.361447-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412110035.361447-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 12, 2023 at 01:00:22PM +0200, Ard Biesheuvel wrote:
> This is preparatory work for allowing the x86 kernel to be built as a
> PIE executable, which relies mostly on RIP-relative symbol references
> from code, as these don't need to be updated when a binary is loaded at
> an address different from its link time address.
> 
> Most changes are quite straight-forward, i.e., just adding a (%rip)
> suffix is enough in many cases. However, some are slightly trickier, and
> need some minor reshuffling of the asm code to get rid of the absolute
> references in the code.
> 
> Tested with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y on a x86 CPU that
> implements AVX, AVX2 and AVX512.
> 
> Changes since v1:
> - add missing tags from Thomas Garnier
> - simplify AES-NI GCM tail handling and drop an entire permute vector
>   table (patch #2)
> - add a couple of patches to switch to local labels, which removes ~1000
>   useless code symbols (e.g., _loop0, _loop1, _done etc etc) from
>   kallsyms
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>

Thanks for continuing this work! In addition to removing the needless
relocations, I like the .L clean-ups as well.

For the series:

Reviewed-by: Kees Cook <keescook@chromium.org>

> 
> Ard Biesheuvel (13):
>   crypto: x86/aegis128 - Use RIP-relative addressing
>   crypto: x86/aesni - Use RIP-relative addressing
>   crypto: x86/aria - Use RIP-relative addressing
>   crypto: x86/camellia - Use RIP-relative addressing
>   crypto: x86/cast5 - Use RIP-relative addressing
>   crypto: x86/cast6 - Use RIP-relative addressing
>   crypto: x86/crc32c - Use RIP-relative addressing
>   crypto: x86/des3 - Use RIP-relative addressing
>   crypto: x86/ghash - Use RIP-relative addressing
>   crypto: x86/sha256 - Use RIP-relative addressing
>   crypto: x86/aesni - Use local .L symbols for code
>   crypto: x86/crc32 - Use local .L symbols for code
>   crypto: x86/sha - Use local .L symbols for code
> 
>  arch/x86/crypto/aegis128-aesni-asm.S         |   6 +-
>  arch/x86/crypto/aesni-intel_asm.S            | 198 +++++++--------
>  arch/x86/crypto/aesni-intel_avx-x86_64.S     | 254 +++++++++-----------
>  arch/x86/crypto/aria-aesni-avx-asm_64.S      |  28 +--
>  arch/x86/crypto/aria-aesni-avx2-asm_64.S     |  28 +--
>  arch/x86/crypto/aria-gfni-avx512-asm_64.S    |  24 +-
>  arch/x86/crypto/camellia-aesni-avx-asm_64.S  |  30 +--
>  arch/x86/crypto/camellia-aesni-avx2-asm_64.S |  30 +--
>  arch/x86/crypto/camellia-x86_64-asm_64.S     |   6 +-
>  arch/x86/crypto/cast5-avx-x86_64-asm_64.S    |  38 +--
>  arch/x86/crypto/cast6-avx-x86_64-asm_64.S    |  32 +--
>  arch/x86/crypto/crc32-pclmul_asm.S           |  16 +-
>  arch/x86/crypto/crc32c-pcl-intel-asm_64.S    |  70 +++---
>  arch/x86/crypto/des3_ede-asm_64.S            |  96 +++++---
>  arch/x86/crypto/ghash-clmulni-intel_asm.S    |   4 +-
>  arch/x86/crypto/sha1_avx2_x86_64_asm.S       |  25 +-
>  arch/x86/crypto/sha256-avx-asm.S             |  16 +-
>  arch/x86/crypto/sha256-avx2-asm.S            |  54 +++--
>  arch/x86/crypto/sha256-ssse3-asm.S           |  16 +-
>  arch/x86/crypto/sha512-avx-asm.S             |   8 +-
>  arch/x86/crypto/sha512-avx2-asm.S            |  16 +-
>  arch/x86/crypto/sha512-ssse3-asm.S           |   8 +-
>  22 files changed, 509 insertions(+), 494 deletions(-)
> 
> -- 
> 2.39.2
> 

-- 
Kees Cook
