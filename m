Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B07BC433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 08:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243127AbiDGIee (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 04:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243063AbiDGIea (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 04:34:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BE622BD5B
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 01:32:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5E5ABCE26C6
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 08:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38DAC385A4
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 08:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649320347;
        bh=UMGmo7XIYPYxpcneSgCZbK8w6IKxq/N9sRRSMlxHrck=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SZz4iQzzBVlHaVudcP76VcTNSuZdoidizKkOjRM63vv/i838bQJotztQQSwqtf1aC
         0mvAVaxESdCCEVV5oclw1YWpAoo2lmJZgAPMFGNLCk/q0QgYL1Dw9X+yQbPUtDuQSV
         9T53DRBv0wDC2l+FcAzIPWYSzcAmmEek+5fIdAjN1QtymqfIH4K8/h7AHdt0wYrk/w
         JfDudGQnoWxjNqUdh809MXaUYC8APTCiB9QEiKYtNpOiZFjxFvPcJyGPLli1/y+jke
         ZZUvfJTt6HmasjMKnA4S9pzITtaL9onlF3v/DHPdJ8kViR08aCxSGBEHKdquufI+5I
         Xh4oZ3L83yLAQ==
Received: by mail-oi1-f182.google.com with SMTP id w127so4911399oig.10
        for <linux-crypto@vger.kernel.org>; Thu, 07 Apr 2022 01:32:27 -0700 (PDT)
X-Gm-Message-State: AOAM533v/Y1jQUJPpcBLHzllbh9wSOnxFQAmIqykD4Zf+d56elbSVyM6
        6fiFCjCw66dIHG4DMQuWRTiDkYYSFaQSWtG1z5Y=
X-Google-Smtp-Source: ABdhPJz8VxPZ1zZ7Rx/T+3GL2h+0UDjfKntPDOfbHUbvkuAStVYbejB2r0QeAQdx+DSfUFHrprqELq6v4dxe6kKhUR4=
X-Received: by 2002:aca:674c:0:b0:2d9:c460:707c with SMTP id
 b12-20020aca674c000000b002d9c460707cmr5312562oiy.126.1649320346789; Thu, 07
 Apr 2022 01:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220406142715.2270256-1-ardb@kernel.org> <20220406142715.2270256-3-ardb@kernel.org>
 <Yk5pa7rdMuCGPVG5@gondor.apana.org.au>
In-Reply-To: <Yk5pa7rdMuCGPVG5@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 7 Apr 2022 10:32:15 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGZingf+_KHR8PyrqQ=L-SR97-ozWjx_1UvJXT4AhfwdA@mail.gmail.com>
Message-ID: <CAMj1kXGZingf+_KHR8PyrqQ=L-SR97-ozWjx_1UvJXT4AhfwdA@mail.gmail.com>
Subject: Re: [PATCH 2/8] crypto: safexcel - take request size after setting TFM
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, keescook@chromium.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 7 Apr 2022 at 06:32, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Apr 06, 2022 at 04:27:09PM +0200, Ard Biesheuvel wrote:
> >
> > +#define EIP197_SKCIPHER_REQ_SIZE     (ALIGN(sizeof(struct skcipher_request), \
> > +                                            CRYPTO_MINALIGN) +               \
>
> The whole point of CRYPTO_MINALIGN is that it comes for free
> via kmalloc.
>

Yes, but kmalloc allocates the entire block at once, and so all the
concatenated structures need to use the same alignment, which results
in substantial padding overhead.

> If you need alignment over and above that of kmalloc, you need
> to do it explicitly in the driver.
>

But none of the drivers currently do so, and rely on the API to
produce ctx struct pointers that are suitably aligned for DMA.

Note that the main issue is not the alignment, but the rounding up of
the size due to that. For instance, looking at crypto/adiantum.c:

struct adiantum_request_ctx {

       ... other fields ...

        /* Sub-requests, must be last */
        union {
                struct shash_desc hash_desc;
                struct skcipher_request streamcipher_req;
        } u;
};

So on arm64, every skcipher_request that gets allocated will be:
128 bytes for the outer skcipher_request + padding
128 bytes for the adiantum request context + padding
128 bytes for the inner skcipher_request + padding
n bytes for the inner context

Given that the skcipher_request only needs 72 bytes on 64-bit
architectures, and Adiantum's reqctx size of ~50 bytes, this results
in an overhead of ~200 bytes for every allocation, which is rather
wasteful.

I think permitting DMA directly into these buffers was a mistake, but
it is the situation we are in today. I am only trying to reduce the
memory overhead for cases where it is not needed.
