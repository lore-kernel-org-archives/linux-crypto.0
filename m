Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B471EDE99E
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 09:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbjINJSS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 05:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjINJSR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 05:18:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6412D9E
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:18:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067C1C433C8
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 09:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694683093;
        bh=vEkCdkTgriwJjDyyvjt+W9IgitpS32SWKcTtoyv/NC8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VvtSjmX3Xs+rXl0jien8983nDAfpfg//3UhDz1X85WcPAm1jvH1J6S9h9p3Ai8/ML
         R2oKbVq9G+cAlXLyll2ZaFUy+rESxqr/tq3ukwJBFuqW5OhqzEvKlscOiEMyCplxhr
         Ldz+MBt5/gkD78y4tav2RzKvct5uuFIx3VNRXicpRgsKUgS+9OdcmWpwkakKzM6/e6
         ogdyDz5W3qXZmqKIZTiI2Md7lNoLl3dJXOF/nR0RDW8SvhsOI+sb/5u2+OTah1EX/I
         Vd9CZNNZqxeDkRfBN0QaaabzlS+MlSP2FyQmFm9mavgIB4U2KnCnNl8qWPuGJT5CBa
         jI89Q348lt8HA==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2b962c226ceso10572931fa.3
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:18:12 -0700 (PDT)
X-Gm-Message-State: AOJu0YyzDGMMESRWn2pVg0klM+/ZgdoqIEDAA3KbUh35SDm/OoREPkDA
        UUdI5u9Fg+BwFN0M+INBLdKATKEAxKjqzXDCkv0=
X-Google-Smtp-Source: AGHT+IHPLGyb6YtBaqIP8eJRmk6Fqk7Cb6RW3qMAY2eCUoGQYusu7HJoSZbdXl+ThqwMF6eZLTXxXm71yCH084SneO8=
X-Received: by 2002:a2e:910d:0:b0:2bc:bc70:263f with SMTP id
 m13-20020a2e910d000000b002bcbc70263fmr4339963ljg.0.1694683091129; Thu, 14 Sep
 2023 02:18:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <CAMj1kXHLZ8kZWL3npQRavdzjRtv_uiRKmKDeXaQhhy3m4LvK+w@mail.gmail.com> <ZQLK0injXi7K3X1b@gondor.apana.org.au>
In-Reply-To: <ZQLK0injXi7K3X1b@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 14 Sep 2023 11:18:00 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHvhrUyShdSNCJeOh8WVXFqPPu+KLh16V6fJJdQKhPv1A@mail.gmail.com>
Message-ID: <CAMj1kXHvhrUyShdSNCJeOh8WVXFqPPu+KLh16V6fJJdQKhPv1A@mail.gmail.com>
Subject: Re: [PATCH 0/8] crypto: Add lskcipher API type
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 14 Sept 2023 at 10:56, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Sep 14, 2023 at 10:51:21AM +0200, Ard Biesheuvel wrote:
> >
> > So the intent is for lskcipher to ultimately supplant the current
> > cipher entirely, right? And lskcipher can be used directly by clients
> > of the crypto API, in which case kernel VAs may be used directly, but
> > no async support is available, while skcipher API clients will gain
> > access to lskciphers via a generic wrapper (if needed?)
> >
> > That makes sense but it would help to spell this out.
>
> Yes that's the idea.  It is pretty much exactly the same as how
> shash and ahash are handled and used.
>
> Because of the way I structured the ecb transition code (it will
> take an old cipher and repackage it as an lskcipher), we need to
> convert the templates first and then do the cipher => lskcipher
> conversion.
>
> > I'd be happy to help out here but I'll be off on vacation for ~3 weeks
> > after this week so i won't get around to it before mid October. What I
> > will do (if it helps) is rebase my recent RISC-V scalar AES cipher
> > patches onto this, and implement ecb(aes) instead (which is the idea
> > IIUC?)
>
> That sounds good.  In fact let me attach the aes-generic proof-
> of-concept conversion (it can only be applied after all templates
> have been converted, so if you test it now everything but ecb/cbc
> will be broken).
>

That helps, thanks.

...
> +static struct lskcipher_alg aes_alg = {
> +       .co = {
> +               .base.cra_name          =       "aes",

So this means that the base name will be aes, not ecb(aes), right?
What about cbc and ctr? It makes sense for a single lskcipher to
implement all three of those at least, so that algorithms like XTS and
GCM can be implemented cheaply using generic templates, without the
need to call into the lskcipher for each block of input.
