Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5244C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 21:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CC8264F06
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 21:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbhBXVtC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhBXVtC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 16:49:02 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AAAC061574
        for <linux-crypto@vger.kernel.org>; Wed, 24 Feb 2021 13:48:22 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id 62so1220105uar.13
        for <linux-crypto@vger.kernel.org>; Wed, 24 Feb 2021 13:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uABnwLb5clK2j7a0BopxOiOj7Kc33alaae1juQoV1fI=;
        b=c8+3QeqPgwO5SLK89VAdVSzKIFAiW25G85wQVYGv7qE4PGZnQ81amKGPFmsLnc/m7/
         cFO+HTXRODXPX00H2/0NUrh8FEgLBycvUdZCZklSfNvr6KLhjVgTnilSzl+sSkdc4PYC
         QfXPeSKBaMo+SmHdNN+CSzcR1dBoPeynGX6bG3qWbaPrElRBJYeG+5YhYcM08WWx/EZO
         Ate4Lj/6zsNNWyIxeQpyRwFDU3+AP7xDwebN8GYdrY7ELg6z7RB2TraPMjqG5tax8PkL
         dowcXnAwIaRlhzkH6/oe9D7k2Wi0yR3BHC624xA2HLQkw1BwZQ8IkXH5+mOEN4pytNOL
         cD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uABnwLb5clK2j7a0BopxOiOj7Kc33alaae1juQoV1fI=;
        b=fMA0wZj0tdT+gqBFo3X5+pgYlfsua9s3BacvgaYQ+0Fq93p8Jxz3+fop/CPjijPG/m
         GWoBomFWnGhijUzIEb4r+2RbcdXXyLTgPf0JMwkQf6qxC65AEETblSn6GVnNabWn8zIy
         pGhvgfdMsVDNtM9+PWuf6ecY7Oy7jcPd2l8G+sRh+zkOgcLldQ/0g93Crpte3Y33j6b4
         00REIuWvi7bWBi2YHwBiMljSLiu6jIgNPYbHG9cFeF+TeYr4M+Xf0SZS74pWmz4ZNohN
         D9YXe6slInCv08whOGqOTquMdsotcCt5aepIo6Ko65tAx63zaEjelG94RJbAsFGxrj1J
         Jt1w==
X-Gm-Message-State: AOAM533nS4YImf0hZPmNBOhw8K1ejYDqpjE+y+a78nhG0Yt7y2/1kcZZ
        mN7W5M+QIUDmAXAeF7ij/i++kFFNNYIX4f9HFdNzlA==
X-Google-Smtp-Source: ABdhPJzzJpxl0TLF6WUbNu7ui2jAx53JvPmtTPQcyjm8KqLDYQYfcWJcEsZlbSlAvHcLDFZoSTc/fmJza/+PMpU9LLQ=
X-Received: by 2002:ab0:1427:: with SMTP id b36mr74576uae.52.1614203301053;
 Wed, 24 Feb 2021 13:48:21 -0800 (PST)
MIME-Version: 1.0
References: <cover.1614182415.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1614182415.git.jpoimboe@redhat.com>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Wed, 24 Feb 2021 13:48:09 -0800
Message-ID: <CABCJKucRHfCBWwq08rmJr7LDHpuCw_Kweoxmcd-=Houzwy_iLQ@mail.gmail.com>
Subject: Re: [PATCH 00/13] x86/crypto/asm: objtool support
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     X86 ML <x86@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Josh,

On Wed, Feb 24, 2021 at 8:29 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
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

Thank you for working on this! I can confirm that this series fixes
the objtool warnings in crypto code with allyesconfig + Clang LTO.

Tested-by: Sami Tolvanen <samitolvanen@google.com>

Sami
