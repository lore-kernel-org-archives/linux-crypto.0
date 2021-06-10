Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CACC48BD1
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 20:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61FC16141D
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 20:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhFJUmU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Jun 2021 16:42:20 -0400
Received: from mail-yb1-f179.google.com ([209.85.219.179]:37441 "EHLO
        mail-yb1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbhFJUmU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jun 2021 16:42:20 -0400
Received: by mail-yb1-f179.google.com with SMTP id b13so1179130ybk.4
        for <linux-crypto@vger.kernel.org>; Thu, 10 Jun 2021 13:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GSEpM/8U8+9Wh8OlIRV8yoDCL+pXbR9afyZOId+gd8s=;
        b=RLUha37mtxfmon728WpMQRtqTcPQ5mzrrSHudUN10PwR6PGxgi5WQHAU+MRFfT70SZ
         wBSAhKFe8Yv50oNXs0qVpEQxajAWu9KUrQpryAFUZ7oeqPGgEhofYl3Pbh3MBK2Mm2Em
         MU7OX0Hn74YxL1EbpH119urOXbSq/tZf2O227W7mqWwu+hrHdvt7twKj+QqYVzkNem85
         gFGOKNJEvj5dswvFZsgj4k18HlJ1VKWmHBF6DjLXeT/mqrCO5Vhob0nZkwMwBl/rn1tf
         0WqVugygy5GjbCss6DjXQPtsthUyGGOJApxwm6LdDDd1gkx212TDx0eHNdFkzagYEU+v
         qFLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GSEpM/8U8+9Wh8OlIRV8yoDCL+pXbR9afyZOId+gd8s=;
        b=motgL1vpKyQg2co6qVmVSw549Jz6I4rgQKRCtLKnbcHxCamkgPYn5VrWN1tCrtF2FV
         TSjsxtiy1/w3FQeAyhgBxepPfVLxZiy0d/knYCjSng2nVDK+ml0w1eQP68eF5URxhtMF
         KYNvUQedXcnACd/0k3FdsAUNrVlqoEgQR6IWgVuz96GhmD2FjUkz8l5SYOy4TdQr6tiy
         NWiAaV7Y9IvkhdZDHSZukIZLaX86wT/9UXH/aHb4j4M+klxwGkhSIR+TUMQpI2fJBTb+
         a851QMy0w9bN+clgbyMINAQxDGgYbpqSDmRLZCVgk9y/uBv3ZxKOSBWxgB4hTL6jkImW
         rSdA==
X-Gm-Message-State: AOAM531fvTVDTFc9a79i1vrb48YgT7uf0anrR46+KWhAXzh0X908F7mh
        /k3aJDcEBPdKqPk8mqLrsy4xO0wLj6jEem+tIuyQ8WAxwLJIOg==
X-Google-Smtp-Source: ABdhPJyH5iDHUJKLV2OBCVrzNd0HojOxCLw2voonlTaZTYGfKSopbGXDUjA3vjT+EthVdRUAQbwMoqgD41rNYfjOzYg=
X-Received: by 2002:a25:26c3:: with SMTP id m186mr880274ybm.47.1623357551424;
 Thu, 10 Jun 2021 13:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210610062150.212779-1-ardb@kernel.org> <YMJeZMiRW7Xjo/sZ@gmail.com>
In-Reply-To: <YMJeZMiRW7Xjo/sZ@gmail.com>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Thu, 10 Jun 2021 13:39:00 -0700
Message-ID: <CABCJKufOnMPPvsNFh1s3f=3DL24Dh8ShdEMNXx2OJjoGDiBpNQ@mail.gmail.com>
Subject: Re: [PATCH v3] crypto: shash - avoid comparing pointers to exported
 functions under CFI
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 10, 2021 at 11:48 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Jun 10, 2021 at 08:21:50AM +0200, Ard Biesheuvel wrote:
> > crypto_shash_alg_has_setkey() is implemented by testing whether the
> > .setkey() member of a struct shash_alg points to the default version,
> > called shash_no_setkey(). As crypto_shash_alg_has_setkey() is a static
> > inline, this requires shash_no_setkey() to be exported to modules.
> >
> > Unfortunately, when building with CFI, function pointers are routed
> > via CFI stubs which are private to each module (or to the kernel proper)
> > and so this function pointer comparison may fail spuriously.
> >
> > Let's fix this by turning crypto_shash_alg_has_setkey() into an out of
> > line function.
> >
> > Cc: Sami Tolvanen <samitolvanen@google.com>
> > Cc: Eric Biggers <ebiggers@kernel.org>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> > v3: improve comment as per Eric's suggestion
> > v2: add code comment to explain why the function needs to remain out of
> > line
> >
> >  crypto/shash.c                 | 18 +++++++++++++++---
> >  include/crypto/internal/hash.h |  8 +-------
> >  2 files changed, 16 insertions(+), 10 deletions(-)
> >
>
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Looks good to me as well. Thank you for fixing this!

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
