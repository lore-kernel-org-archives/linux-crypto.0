Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C55C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 07:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A513E21872
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 07:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbfCOHp3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 03:45:29 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34318 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728465AbfCOHp3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 03:45:29 -0400
Received: by mail-ot1-f68.google.com with SMTP id r19so7595056otn.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 Mar 2019 00:45:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GdmoGJNUMzTaa6dVPkh/diujnWFyAKnv4PW9DHrHtBg=;
        b=opPVgyHMJYdg3qkXwX4lsu9WegLdCZisjAqTkKjsk4wCRNxgd9V0Rq3K6KnFoAMlLj
         hXl5avsgK8yzgN/nhMv+wLYTZBcldLpfyStqVoXuBjs0Q2yTj5LUgB91h59EXt1H3u4h
         zQeHRsDveV6/XX0cjupnjIx24wwRoQAir6NbADyQk2TJLOponDTmTV6TRp3OrebulpMO
         OX3KCvFzAUw7D+f7M4wtGb5CiFCPrI9qu6cD8UanKURFY/SI4vB8bweqH1yauH9j1YTB
         Hk0wLxI0gzbw+Ir91Tl7kvdKDEwLcL6puqqQFUuGDGpS2MhoegpP0beolknZoKaF4gDs
         k+UA==
X-Gm-Message-State: APjAAAVmpdMeLTbw+hQ2ioMQlmrW0JXe1JQnUnDctxLNhJcrDOliSvae
        AEa9dKrXh1e2m77dzBUMklWQ8Jclv9NVYrrOW/TuHhxW9EBtww==
X-Google-Smtp-Source: APXvYqy5JFl0Zkru42MJWna+ue6xd4KiuW1RNuD8ROLjVQHUxfrqlBahwXNTlUnbMBquQ1yC+so5+omzlnC87IqW+SI=
X-Received: by 2002:a9d:6553:: with SMTP id q19mr1324231otl.21.1552635927737;
 Fri, 15 Mar 2019 00:45:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190310190058.4912-1-ebiggers@kernel.org>
In-Reply-To: <20190310190058.4912-1-ebiggers@kernel.org>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Fri, 15 Mar 2019 08:45:16 +0100
Message-ID: <CAFqZXNvJT30Pgv=Uw1OnO5Zt5XEouK-FBVvc8AH2yU2jk_Gf1g@mail.gmail.com>
Subject: Re: [PATCH 0/9] crypto: add SIMD helpers for AEADs
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On Sun, Mar 10, 2019 at 8:02 PM Eric Biggers <ebiggers@kernel.org> wrote:
> This series updates crypto_simd to support wrapping AEADs, then makes
> all AEADs that implement the same functionality use crypto_simd instead.
>
> This simplifies the code, and it also fixes the bug where these
> algorithms modify the user-provided aead_request.  This was a problem
> because users may expect to be able to use the same aead_request for
> another encryption/decryption without reinitializing everything.  The
> last patch removes the test workaround now that this bug is fixed.
>
> Eric Biggers (9):
>   crypto: simd - support wrapping AEAD algorithms
>   crypto: x86/aesni - convert to use skcipher SIMD bulk registration
>   crypto: x86/aesni - convert to use AEAD SIMD helpers
>   crypto: x86/aegis128 - convert to use AEAD SIMD helpers
>   crypto: x86/aegis128l - convert to use AEAD SIMD helpers
>   crypto: x86/aegis256 - convert to use AEAD SIMD helpers
>   crypto: x86/morus640 - convert to use AEAD SIMD helpers
>   crypto: x86/morus1280 - convert to use AEAD SIMD helpers
>   crypto: testmgr - remove workaround for AEADs that modify aead_request
>
>  arch/x86/crypto/aegis128-aesni-glue.c  | 157 +++------------
>  arch/x86/crypto/aegis128l-aesni-glue.c | 157 +++------------
>  arch/x86/crypto/aegis256-aesni-glue.c  | 157 +++------------
>  arch/x86/crypto/aesni-intel_glue.c     | 204 ++-----------------
>  arch/x86/crypto/morus1280-avx2-glue.c  |  12 +-
>  arch/x86/crypto/morus1280-sse2-glue.c  |  12 +-
>  arch/x86/crypto/morus1280_glue.c       |  85 --------
>  arch/x86/crypto/morus640-sse2-glue.c   |  12 +-
>  arch/x86/crypto/morus640_glue.c        |  85 --------
>  crypto/Kconfig                         |  10 +-
>  crypto/simd.c                          | 269 +++++++++++++++++++++++++
>  crypto/testmgr.c                       |   3 -
>  include/crypto/internal/simd.h         |  20 ++
>  include/crypto/morus1280_glue.h        |  79 ++------
>  include/crypto/morus640_glue.h         |  79 ++------
>  15 files changed, 471 insertions(+), 870 deletions(-)
>
> --
> 2.21.0

Nice refactoring, thanks!

I only went quickly through the patches, but I'd say the automated
tests have got us covered quite well here :)

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>

-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Associate Software Engineer, Security Technologies
Red Hat, Inc.
