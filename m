Return-Path: <SRS0=MfKA=CE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD38BC433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 10:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F8E520838
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 10:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598439318;
	bh=N1XHrxvXS+Rc2guGmwKsq80ilQ9HeONFSwS58Q0lZq8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=TW1AKfMH1WP5TrkYGNoM1ABTxSyQr0a5FGF1gzlQL83CMwLw9sIXZoHNDnNUhWINC
	 PkneBWnFSTS7o4Rdq6QllfnepzI8OxQ7PAz9P5mBfKeVYGLTg8gewcddAbN6UV2PrP
	 bjP0Brc9dDhHGvOM/w0p8XFOYpf89nM4j25vgmaA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgHZKzS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Aug 2020 06:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgHZKzQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Aug 2020 06:55:16 -0400
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5834F20838
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2020 10:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598439316;
        bh=N1XHrxvXS+Rc2guGmwKsq80ilQ9HeONFSwS58Q0lZq8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dkzEev4kNfR3Aj8xssQF3OJql0AfFKtgF7E3V3/bcWJxO6SgYugHKyeWehIxSIiM9
         iWqrd886mOKIgDac99fQ9gbgwZte2Mx9H0vVRIp2PrJWEwoQp9MNRiiPhbcQ5hHCFD
         BVtSqMHxEAuBSC5CAsYdIF+nkEJ/H8ykktN72aKo=
Received: by mail-ot1-f41.google.com with SMTP id k20so1142138otr.1
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2020 03:55:16 -0700 (PDT)
X-Gm-Message-State: AOAM531Tey3NPQjwdFWWgkCFh1uKYFr8ObKe0Ij2UBBvJ8F4krTlXPYp
        ImL+8Mwjon/2zhWkrZCJYh+AbOCzNxn7D017nm0=
X-Google-Smtp-Source: ABdhPJxcS2HBkmpo3hqe3hhp6IXxj9Sg9gZpQlNKiVbVYuMrYffpiqz2xRg296jlyib9LEKm5T1ONpAQHJtsHdV/68I=
X-Received: by 2002:a05:6830:11da:: with SMTP id v26mr3685739otq.90.1598439315715;
 Wed, 26 Aug 2020 03:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200818082410.GA24497@gondor.apana.org.au> <E1k7ww6-0000eO-LC@fornost.hmeau.com>
In-Reply-To: <E1k7ww6-0000eO-LC@fornost.hmeau.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 26 Aug 2020 12:55:04 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFNxh=1AOED0OZ4D=ZrAJLd3KPx7KiD84qno_DYf-2qwA@mail.gmail.com>
Message-ID: <CAMj1kXFNxh=1AOED0OZ4D=ZrAJLd3KPx7KiD84qno_DYf-2qwA@mail.gmail.com>
Subject: Re: [PATCH 5/6] crypto: ahash - Remove AHASH_REQUEST_ON_STACK
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 18 Aug 2020 at 10:25, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This patch removes AHASH_REQUEST_ON_STACK which is unused.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

and given that any new uses that creep in will trigger -Wvla warnings,
I suggest this is broken out from the series and merged as a fix
instead.


> ---
>
>  include/crypto/hash.h |    5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/include/crypto/hash.h b/include/crypto/hash.h
> index c9d3fd3efa1b0..f16f5d4afc102 100644
> --- a/include/crypto/hash.h
> +++ b/include/crypto/hash.h
> @@ -59,11 +59,6 @@ struct ahash_request {
>         void *__ctx[] CRYPTO_MINALIGN_ATTR;
>  };
>
> -#define AHASH_REQUEST_ON_STACK(name, ahash) \
> -       char __##name##_desc[sizeof(struct ahash_request) + \
> -               crypto_ahash_reqsize(ahash)] CRYPTO_MINALIGN_ATTR; \
> -       struct ahash_request *name = (void *)__##name##_desc
> -
>  /**
>   * struct ahash_alg - asynchronous message digest definition
>   * @init: **[mandatory]** Initialize the transformation context. Intended only to initialize the
