Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA902C433ED
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 11:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFFE3601FC
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 11:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240529AbhESLiK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 07:38:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhESLiI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 07:38:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57E4F6135B
        for <linux-crypto@vger.kernel.org>; Wed, 19 May 2021 11:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621424209;
        bh=xpCSnOj5OqOTmpmQNj3CEeVzOjrSk2CT158iiJBHiR0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KEygD9R9ovcTam+Y63Rmw4J37/nbYMaZsLqafTkftg3S1nKsSBtN7drQc3GDAwnyr
         w9tC0leLTL1QS9F+tLN1Vhl33v/cN1nBS8vLM54oTf5eNwt/mQATXSXfKh/fjSzHHV
         BWkWsdU/tEQRVMaGI9HGmXK9xDHSq4DI95Gj6tSwatWjuiC04vEXqCzXPMbGssz6Vh
         IiUVRz9Um4VT+9+AD1x0c+pf6dXbVsGj9x2+5o0B95hyox9XuzXDj0mIwveQlT223O
         I2mkZLj56za7F5ywxRmdlmO41Faz5j62qX4sbTaTWyAmpoLdDRZ2xorBSBlLSfVp0k
         zP5J6/OXuE+2Q==
Received: by mail-oi1-f170.google.com with SMTP id h9so12847154oih.4
        for <linux-crypto@vger.kernel.org>; Wed, 19 May 2021 04:36:49 -0700 (PDT)
X-Gm-Message-State: AOAM5307YiIgCNGXISG/MGFHX56XWl02FSY7DqWt1cHre/gGErYg4B+x
        GpPV1+kFK/liDzKy3hElvnJVSsXCi8eKojSmaI8=
X-Google-Smtp-Source: ABdhPJzArHzgYW/AkKjt1EdaXfWP8cJ7cXF6rEsjLDCrEtHMnCaluO92NB1eDam+896uwsZGnYwZZJ2baGKOHt+tCuQ=
X-Received: by 2002:a05:6808:a96:: with SMTP id q22mr7394508oij.47.1621424208675;
 Wed, 19 May 2021 04:36:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210519112239.33664-1-ardb@kernel.org> <20210519112239.33664-3-ardb@kernel.org>
 <20210519112930.sgy3trqczyfok7mn@gondor.apana.org.au>
In-Reply-To: <20210519112930.sgy3trqczyfok7mn@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 19 May 2021 13:36:37 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGsxFzx8XTwhBRma_eSmnAHDZHox9X+SYDn0JYfPBVbYg@mail.gmail.com>
Message-ID: <CAMj1kXGsxFzx8XTwhBRma_eSmnAHDZHox9X+SYDn0JYfPBVbYg@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] crypto: aead - disallow en/decrypt for non-task or
 non-softirq context
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Will Deacon <will@kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 19 May 2021 at 13:29, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, May 19, 2021 at 01:22:34PM +0200, Ard Biesheuvel wrote:
> >
> >       crypto_stats_get(alg);
> > -     if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
> > +     if (!(alg->cra_flags & CRYPTO_ALG_ASYNC) &&
> > +         WARN_ONCE(!in_task() && !in_serving_softirq(),
> > +                   "synchronous call from invalid context\n"))
> > +             ret = -EBUSY;
>
> I don't think we've ever supported crypto in hard IRQ contexts.
> So this should be done regardless of ASYNC.
>

OK.

> Then again, do we really need this since the assumption has
> always been that the crypto API can only be invoked in user or
> softirq context?
>

With this series applied, some of the arm64 accelerated s/w
implementations will no longer work correctly when this rule is
violated, and so it would be nice to have a sanity check somewhere.
And policing rules like these is best done in generic code, right?

So if we do need to check this, we should check it here. If we don't,
then we can drop these patches.
