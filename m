Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0501FC77B6C
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Apr 2023 15:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjDHPdA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Apr 2023 11:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjDHPdA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Apr 2023 11:33:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4733AB0
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 08:32:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B95860D3A
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 15:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81FBC4339E
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 15:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680967977;
        bh=NZoj/OY0+5Ty7CnWda5nWmmNZC+uA/YodJGXvWhs+7U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ERycMkEgEmfkwdJsjvSGnG49syNOkjcZMy7ana5+YQCJPgMe4cCRryczl+rC/bELh
         mBWHigAXonzzxpJyQQULe+MZ8yX4Qip2MDe9eaMwdpZA+VdjgD0I465GtfzGdUGyhy
         +x841qEwlmr3dOV8in3x231ohnxptkV5WE3kujfaQW6XssmYhhFO2dZgnRko5dQGyW
         sKBrem/jbZdQCYNcNmp0v6Z7fnthLPSJb6EUO29XZwKHJdc7GNB8tbv7kmPNPVLq1e
         EBJuHvT4O6MZWOBvNIjj1sgllJ70r412p4PSSjXCJOpEzoPjOjQFXa3YQNCDC3gOZI
         d/nWYTWuivTAw==
Received: by mail-lj1-f174.google.com with SMTP id bd22so3815897ljb.5
        for <linux-crypto@vger.kernel.org>; Sat, 08 Apr 2023 08:32:57 -0700 (PDT)
X-Gm-Message-State: AAQBX9fYr3HcCzmgezhkRhTB286IMI4uy3j+JnKVWIcOkJ8Iij9kpwS/
        /XEOd3qW3apP6v92iRuJmoTeKcYAvIewaEYY1fQ=
X-Google-Smtp-Source: AKy350bMA/0ukZlPAesA2kqRM+yl0OfQ478Ct+RmxeQfpV032AtbBxhn8F/MwDIRrA6ebfm/0FzUZ6/NZbzY811FAwM=
X-Received: by 2002:a2e:959a:0:b0:2a7:5fe2:1c90 with SMTP id
 w26-20020a2e959a000000b002a75fe21c90mr1046152ljh.2.1680967975896; Sat, 08 Apr
 2023 08:32:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230408152722.3975985-1-ardb@kernel.org>
In-Reply-To: <20230408152722.3975985-1-ardb@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 8 Apr 2023 17:32:44 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEtwDyaJASbpRGOf9P1pvoyt02HMN9pawq4QyRD8UzJoA@mail.gmail.com>
Message-ID: <CAMj1kXEtwDyaJASbpRGOf9P1pvoyt02HMN9pawq4QyRD8UzJoA@mail.gmail.com>
Subject: Re: [PATCH 00/10] crypto: x86 - avoid absolute references
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 8 Apr 2023 at 17:27, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> This is preparatory work for allowing the kernel to be built as a PIE
> executable, which relies mostly on RIP-relative symbol references from
> code, which don't need to be updated when a binary is loaded at an
> address different from its link time address.
>
> Most changes are quite straight-forward, i.e., just adding a (%rip)
> suffix is enough in many cases. However, some are slightly trickier, and
> need some minor reshuffling of the asm code to get rid of the absolute
> references in the code.
>
> Tested with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y on a x86 CPU that
> implements AVX, AVX2 and AVX512.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
>
> Ard Biesheuvel (10):

>   crypto: x86/camellia - Use RIP-relative addressing
>   crypto: x86/cast5 - Use RIP-relative addressing
>   crypto: x86/cast6 - Use RIP-relative addressing
>   crypto: x86/des3 - Use RIP-relative addressing

Note: the patches above are

Co-developed-by: Thomas Garnier <thgarnie@chromium.org>
Signed-off-by: Thomas Garnier <thgarnie@chromium.org>

but this got lost inadvertently - apologies.

Herbert: will patchwork pick those up if I put them in a reply to each
of those individual patches?

Thanks,


>   crypto: x86/aegis128 - Use RIP-relative addressing
>   crypto: x86/aesni - Use RIP-relative addressing
>   crypto: x86/aria - Use RIP-relative addressing
>   crypto: x86/crc32c - Use RIP-relative addressing
>   crypto: x86/ghash - Use RIP-relative addressing
>   crypto: x86/sha256 - Use RIP-relative addressing
>
>  arch/x86/crypto/aegis128-aesni-asm.S         |  6 +-
>  arch/x86/crypto/aesni-intel_asm.S            |  2 +-
>  arch/x86/crypto/aesni-intel_avx-x86_64.S     |  6 +-
>  arch/x86/crypto/aria-aesni-avx-asm_64.S      | 28 +++---
>  arch/x86/crypto/aria-aesni-avx2-asm_64.S     | 28 +++---
>  arch/x86/crypto/aria-gfni-avx512-asm_64.S    | 24 ++---
>  arch/x86/crypto/camellia-aesni-avx-asm_64.S  | 30 +++---
>  arch/x86/crypto/camellia-aesni-avx2-asm_64.S | 30 +++---
>  arch/x86/crypto/camellia-x86_64-asm_64.S     |  8 +-
>  arch/x86/crypto/cast5-avx-x86_64-asm_64.S    | 50 +++++-----
>  arch/x86/crypto/cast6-avx-x86_64-asm_64.S    | 44 +++++----
>  arch/x86/crypto/crc32c-pcl-intel-asm_64.S    |  3 +-
>  arch/x86/crypto/des3_ede-asm_64.S            | 96 +++++++++++++-------
>  arch/x86/crypto/ghash-clmulni-intel_asm.S    |  4 +-
>  arch/x86/crypto/sha256-avx2-asm.S            | 18 ++--
>  15 files changed, 213 insertions(+), 164 deletions(-)
>
> --
> 2.39.2
>
