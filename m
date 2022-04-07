Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A74BC433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 08:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbiDGIfi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 04:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234459AbiDGIfh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 04:35:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9B11B9884
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 01:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13E546187F
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 08:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3105AC385A0
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 08:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649320417;
        bh=+Goi38y8epY8BN4u8isck26NnJ+QBzQRnMhu5NnKrVE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=o1fvYK4+asGnNwfzVoQpYeIuICeXy1yy1LOno1snx5tza58sjBx8jDYsD7iHZvS+E
         pi8/eU6OUdwm224F8c3GFy6Z40m7ZUrXYh4Vu6nhgcY34Yt+wI6hZEKkogXbQ8AjpB
         kljpPy1yUlk7hCe6i/k5g3nVpVmWF6PUaDn2slf0vEMMtbm/AQZysa33RrVDMKXxnH
         7YlWQplpExR8u2eFwQLRFi7/a+suLMrFbH7cZC6W5Axf1ldFA3q1RvurcmZ+uwI5/y
         snm216BpwxmedRDw+hJe/ejd/ZVF+K6U3+c/BAJPBVkERuUlRTXE9e9JulBy4rf4V/
         S1mFJsCudUFNg==
Received: by mail-oi1-f180.google.com with SMTP id q129so4955412oif.4
        for <linux-crypto@vger.kernel.org>; Thu, 07 Apr 2022 01:33:37 -0700 (PDT)
X-Gm-Message-State: AOAM532tkSVQrKcBZ6qdaTWoEYl/5fqr/ID0tZ/kPTd04UTCZomghT1y
        Me+UiSwUOYo2Xt4l4zKAAQN2irE6XVqNSQqMxCI=
X-Google-Smtp-Source: ABdhPJzR8ppNmIzkdJeuorLFH/uZLhX8zpW/IfrL2Rwidi1EyUXoZPSp9CJ5n5o3ahIl+ATjTLu4ZAp7Q2C8FDQ4jZA=
X-Received: by 2002:a05:6808:1596:b0:2f7:5d89:eec7 with SMTP id
 t22-20020a056808159600b002f75d89eec7mr5411000oiw.228.1649320416369; Thu, 07
 Apr 2022 01:33:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220406142715.2270256-1-ardb@kernel.org> <20220406142715.2270256-3-ardb@kernel.org>
 <Yk5pa7rdMuCGPVG5@gondor.apana.org.au> <CAMj1kXGZingf+_KHR8PyrqQ=L-SR97-ozWjx_1UvJXT4AhfwdA@mail.gmail.com>
In-Reply-To: <CAMj1kXGZingf+_KHR8PyrqQ=L-SR97-ozWjx_1UvJXT4AhfwdA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 7 Apr 2022 10:33:25 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFR26xst=vLFTJRZy9hN6bV9G_mOKwyia=kQ=WGJ9mfnA@mail.gmail.com>
Message-ID: <CAMj1kXFR26xst=vLFTJRZy9hN6bV9G_mOKwyia=kQ=WGJ9mfnA@mail.gmail.com>
Subject: Re: [PATCH 2/8] crypto: safexcel - take request size after setting TFM
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, keescook@chromium.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 7 Apr 2022 at 10:32, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Thu, 7 Apr 2022 at 06:32, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Wed, Apr 06, 2022 at 04:27:09PM +0200, Ard Biesheuvel wrote:
> > >
> > > +#define EIP197_SKCIPHER_REQ_SIZE     (ALIGN(sizeof(struct skcipher_request), \
> > > +                                            CRYPTO_MINALIGN) +               \
> >
> > The whole point of CRYPTO_MINALIGN is that it comes for free
> > via kmalloc.
> >
>

BTW the definition above is only used for request allocations on the stack.
