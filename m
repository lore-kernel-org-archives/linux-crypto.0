Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95260C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 17:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6506264F03
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 17:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhBXRLP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 12:11:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231439AbhBXRLO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 12:11:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AD5864F0B;
        Wed, 24 Feb 2021 17:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614186632;
        bh=SJ5Rru5hG1o1K/jlMvVzI1qjCrEGLO45OJ/U+7040fc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HSPR/wWgNMbRQ+S4wYUT05rHBo4pCnm4/8aBrtKFABWfY75ExJsX5cSEMqDXmZkVk
         B3wtKyPJBOp7d2e5rTI2UQBIRgYeSLMvBWeSkumFH7Sqw7b68djTOmIxt+dZc8ApuP
         TdKCWjOtexw6313xPABgbZSohP010+hAp7Im7P3sstnrETat77/nOIu7K6qwGP35cc
         AkH5FFiwidjLOdh4SLs/EOa6oFWqrxlCBCWiGA9f0U5ecLE46Q30Ab3nVY+diRIF+r
         qcWkWYr1vb+xlHekc0exE6bYBNMNBxFD5mfVilO3H87fa7htEyq5BbVC6f637BMJYi
         4lHqKDqQ7NClw==
Received: by mail-ot1-f49.google.com with SMTP id s107so2828668otb.8;
        Wed, 24 Feb 2021 09:10:32 -0800 (PST)
X-Gm-Message-State: AOAM5314sw8vasSt/UKqk2Hl7gEQW2A3R8wzueJUUC4Nie7rX3Xl7eA+
        csIHZ20/vKN6z5iv1vNFTioZl9/k1GHTvxjOUI0=
X-Google-Smtp-Source: ABdhPJz5tsY3F8T09dNXv8JnxGazL++sEU1h6wwPeb3AK0KRDtvuCHcYpTFjaYYOXIdA5S3OKoKOP24SjVd8wbZsicU=
X-Received: by 2002:a05:6830:135a:: with SMTP id r26mr9309607otq.77.1614186631597;
 Wed, 24 Feb 2021 09:10:31 -0800 (PST)
MIME-Version: 1.0
References: <cover.1614182415.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1614182415.git.jpoimboe@redhat.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 24 Feb 2021 18:10:20 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFnfH2OMA=JhzXuM=gT3pGci2=wpmjic-AbxoJLZnEexA@mail.gmail.com>
Message-ID: <CAMj1kXFnfH2OMA=JhzXuM=gT3pGci2=wpmjic-AbxoJLZnEexA@mail.gmail.com>
Subject: Re: [PATCH 00/13] x86/crypto/asm: objtool support
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     X86 ML <x86@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 24 Feb 2021 at 17:29, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> Standardize the crypto asm to make it resemble compiler-generated code,
> so that objtool can understand it.
>
> This magically enables ORC unwinding from crypto code.  It also fixes
> the last known remaining objtool warnings on vmlinux.o, for LTO and
> more.
>
> Josh Poimboeuf (13):
>   objtool: Support asm jump tables
>   x86/crypto/aesni-intel_avx: Remove unused macros
>   x86/crypto/aesni-intel_avx: Fix register usage comments
>   x86/crypto/aesni-intel_avx: Standardize stack alignment prologue
>   x86/crypto/camellia-aesni-avx2: Unconditionally allocate stack buffer
>   x86/crypto/crc32c-pcl-intel: Standardize jump table
>   x86/crypto/sha_ni: Standardize stack alignment prologue
>   x86/crypto/sha1_avx2: Standardize stack alignment prologue
>   x86/crypto/sha256-avx2: Standardize stack alignment prologue
>   x86/crypto/sha512-avx: Standardize stack alignment prologue
>   x86/crypto/sha512-avx2: Standardize stack alignment prologue
>   x86/crypto/sha512-ssse3: Standardize stack alignment prologue
>   x86/crypto: Enable objtool in crypto code
>

I gave this series a spin with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y,
and all the tests still pass.

Tested-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>



>  arch/x86/crypto/Makefile                     |  2 -
>  arch/x86/crypto/aesni-intel_avx-x86_64.S     | 28 +++++--------
>  arch/x86/crypto/camellia-aesni-avx2-asm_64.S |  5 +--
>  arch/x86/crypto/crc32c-pcl-intel-asm_64.S    |  7 +---
>  arch/x86/crypto/sha1_avx2_x86_64_asm.S       |  8 ++--
>  arch/x86/crypto/sha1_ni_asm.S                |  8 ++--
>  arch/x86/crypto/sha256-avx2-asm.S            | 13 +++---
>  arch/x86/crypto/sha512-avx-asm.S             | 41 +++++++++----------
>  arch/x86/crypto/sha512-avx2-asm.S            | 42 ++++++++++----------
>  arch/x86/crypto/sha512-ssse3-asm.S           | 41 +++++++++----------
>  tools/objtool/check.c                        | 14 ++++++-
>  11 files changed, 98 insertions(+), 111 deletions(-)
>
> --
> 2.29.2
>
