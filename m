Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C83C4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 00:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D88C23770
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 00:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbgLJATL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Dec 2020 19:19:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729913AbgLJATF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Dec 2020 19:19:05 -0500
X-Gm-Message-State: AOAM533K5jk3t7Ja7WQiEid6xWny6yojuS3+Lmk7dejjiH6oHlHOSQml
        bjVXmbTtsdYc/c/K91FIIbEKcQHL0oqnZRh0ZKI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607559504;
        bh=BK5SfdtLhZjItk74wSKluKT9bgtdmjKwSgCjATsKNsE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=USdjOkKVsFFJkErWOy+le8vuWBmTWQBZXlARNoERngWpj6Fug0vkTF5EkeqwtKvGw
         KhuSL4o81QrfmJuY1SKADf9RguDASdtxKgrocutRSUL6H8ACWDqCeYT4n4AwtmhULQ
         s4jjCJZYptTK6PK8zEoHlHcHhbD8k7u5ajGwGYCUD7QLfH3BPBPC1SEyQb9Lg//k0S
         mwCB60arcNg7APBpWxgLzkFNgXz/DbZxbpLEJeaDpEoUq6+cYs2N4aa7CUZk2QLRW1
         Z2m9LEVFNZ4e45oVU5te+YnQif5cWLKbIIpXgtxOWhDvwYOWasHerfPBn4SbPQdtCU
         Ea3qADnBymmTA==
X-Google-Smtp-Source: ABdhPJzPKabjWEViiZEDz5gkzm3NkO1Ik4jvp0bAklJ1rmDObGsGaC6vs6jEUZNfsQ6MV4n/0tFovtcz1gmjnzXaMhI=
X-Received: by 2002:aca:b809:: with SMTP id i9mr3717448oif.174.1607559503969;
 Wed, 09 Dec 2020 16:18:23 -0800 (PST)
MIME-Version: 1.0
References: <20201201194556.5220-1-ardb@kernel.org> <20201201215722.GA31941@gondor.apana.org.au>
 <CAMj1kXHb27ugTWuQZhPD0DvjtgYC8t_pj+igqK7dNfh+WsUS4w@mail.gmail.com>
 <20201201220431.GA32072@gondor.apana.org.au> <CAMj1kXGO+kbZ+2VmUQKxLYos2nR5vqZKjengxPxPjSXudG-zLw@mail.gmail.com>
 <20201201221628.GA32130@gondor.apana.org.au> <CAMj1kXFrLiHfv1S1AM=5pc1J9gWwZVuoGvmFoTT0-+oREoojTA@mail.gmail.com>
 <20201201231158.GA32274@gondor.apana.org.au>
In-Reply-To: <20201201231158.GA32274@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 10 Dec 2020 01:18:12 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHwD5ktJTUrh8sndMY7P0kSFhgkGT66YJN1-ONUaU05-g@mail.gmail.com>
Message-ID: <CAMj1kXHwD5ktJTUrh8sndMY7P0kSFhgkGT66YJN1-ONUaU05-g@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Steve deRosier <derosier@cal-sierra.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 2 Dec 2020 at 00:12, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Dec 01, 2020 at 11:27:52PM +0100, Ard Biesheuvel wrote:
> >
> > > The problem is that the degradation would come at the worst time,
> > > when the system is loaded.  IOW when you get an interrupt during
> > > your TX path and get RX traffic that's when you'll take the fallback
> > > path.
> >
> > I can see how in the general case, this is something you would prefer
> > to avoid. However, on SMP x86_64 systems that implement AES-NI (which
> > runs at ~1 cycle per byte), I don't see this as a real problem for
> > this driver.
>
> AES-NI is 1 cycle per byte but the fallback is not.
>

One thing I realized just now is that in the current situation, all
the synchronous skciphers already degrade like this.

I.e., in Ben's case, without the special ccm implementation, ccm(aes)
will resolve to ccm(ctr(aesni),cbcmac(aesni)), which is instantiated
as a sync skcipher using the ctr and ccm/cbcmac templates built on top
of the AES-NI cipher (not skcipher).  This cipher will also fall back
to suboptimal scalar code if the SIMD is in use in process context.



> > What we could do is expose both versions, where the async version has
> > a slightly higher priority, so that all users that do support the
> > async interface will get it, and the wifi stack can use the sync
> > interface instead.
>
> No we've already tried this with IPsec and it doesn't work.  That's
> why the async path exists in aesni.
>
> Wireless is no different to IPsec in this respect.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
