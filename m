Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024B5C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 12:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE88A23D9B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 12:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgLJMEt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Dec 2020 07:04:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727306AbgLJMEt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Dec 2020 07:04:49 -0500
X-Gm-Message-State: AOAM530jcpYuafYXjanv+TX4O6o3/jOvAZ9R1PGzlby8t7FjtpeWJB5c
        SHdR1yxlQQscykTc6JFWobyivqKla6hpXkGDsHk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607601848;
        bh=FKNf/u7hXc6q7bKc/g6iam7gZhP94GH2F7Y352Lgcj8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GRMQiLK1TL+Mhj52cg0oFB/+zelnc67EiCC6EbZrzUzD0MTRf/jIscDTu7cRJhJ48
         H9OIOKG6jtlmbqGrAW2tEWqbar9LYV3kp09mOJzCMCm87/pzLCcwkecuMvsPiB/Jl9
         V7/TjWMdMAJ5KG9HOe79AOl2hu6VNA2GmPQSRhwuREbHdWnhr2q+AL/6upCO0f0q5Z
         530eD3rMgk22GJ4C/uj3zJ82MrBH7m+yOh4YmJXPrPeIlH9JL0gjG0esh3Q8f7U9bK
         BaLq8kw3+le7JN+MSDkORaOGAVtM+5w4NBYob0Wa8W6gb/cpVIA3Yq1QWJDeDpfVaH
         owiXF9yX0XMUw==
X-Google-Smtp-Source: ABdhPJxeLlvY7UJARp6i/USCu3UjCFUBZRo5NG3E2M3teVzMngDQ7DUaEFHtZoxsikDvsfiwlpBu7pZqiYX4URpNz7Y=
X-Received: by 2002:aca:dd0b:: with SMTP id u11mr5124358oig.47.1607601847436;
 Thu, 10 Dec 2020 04:04:07 -0800 (PST)
MIME-Version: 1.0
References: <CAMj1kXHb27ugTWuQZhPD0DvjtgYC8t_pj+igqK7dNfh+WsUS4w@mail.gmail.com>
 <20201201220431.GA32072@gondor.apana.org.au> <CAMj1kXGO+kbZ+2VmUQKxLYos2nR5vqZKjengxPxPjSXudG-zLw@mail.gmail.com>
 <20201201221628.GA32130@gondor.apana.org.au> <CAMj1kXFrLiHfv1S1AM=5pc1J9gWwZVuoGvmFoTT0-+oREoojTA@mail.gmail.com>
 <20201201231158.GA32274@gondor.apana.org.au> <CAMj1kXHwD5ktJTUrh8sndMY7P0kSFhgkGT66YJN1-ONUaU05-g@mail.gmail.com>
 <20201210024342.GA26428@gondor.apana.org.au> <e02fe07e-8cb6-f889-3228-60e4fabf4e40@candelatech.com>
 <CAMj1kXF05XZtyakdpLixpP9Lroy0D3_gEcY2SFbSshD8ERUU7w@mail.gmail.com> <20201210111427.GA28014@gondor.apana.org.au>
In-Reply-To: <20201210111427.GA28014@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 10 Dec 2020 13:03:56 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG39GgsTeNBbX7_oaK+f-awPyL8NxJ7R+fyOBjL4c5xMw@mail.gmail.com>
Message-ID: <CAMj1kXG39GgsTeNBbX7_oaK+f-awPyL8NxJ7R+fyOBjL4c5xMw@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ben Greear <greearb@candelatech.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steve deRosier <derosier@cal-sierra.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 10 Dec 2020 at 12:14, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Dec 10, 2020 at 08:30:47AM +0100, Ard Biesheuvel wrote:
> >
> > I would argue that these are orthogonal. My patch improves both the
> > accelerated and the fallback path, given that the latter does not have
> > to walk the input data twice anymore, and go through 3 layers of
> > templates and the associated indirect calls for each 16 bytes of
> > input.
>
> As I told your before, your patch introduces a new model into aesni
> that is different to every other algorithm there for the sole purpose
> of catering for legacy hardware in a subsystem that refuses to do
> the right thing.
>
> That is not acceptable.
>

OK, I will stop whining about CCM, apologies if this is getting tedious.

But we should probably start policing this a bit more. For instance, we now have

drivers/net/macsec.c:

/* Pick a sync gcm(aes) cipher to ensure order is preserved. */
tfm = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);

(btw the comment is bogus, right?)

TLS_SW does the same thing in net/tls/tls_device_fallback.c.

So it is not only CCM in the 802.11 layer, there are now other places
where we end up using a sub-optimal algorithm (and less secure if
table based AES or GHASH end up being used) just to avoid a potential
fallback which is not even as bad as the fallback we will actually end
up with when the crypto API synthesizes it from the GCM, CTR and GHASH
templates/drivers.

Async is obviously needed for h/w accelerators, but could we perhaps
do better for s/w SIMD algorithms? Those are by far the most widely
used ones.
