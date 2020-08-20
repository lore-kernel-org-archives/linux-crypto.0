Return-Path: <SRS0=QJ87=B6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A171C433E3
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 06:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15B1320738
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 06:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597906710;
	bh=qNpjDzbrt/tJ/wXdPPXLYMt12gi24zaZu0I7xpPjxMw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=R8knH1j0e+Q07KMoQGNVxzXSMblCyxsT/NABTgEbky/cE1T8UTB625zd6Juz7nBgF
	 KFDlkAeS4Ol9y8FCF9jq9VZgz53K8wkM2o+U7WG6icAvoqzxBTmJRkHYD/uW/HC2Fs
	 29nvrvlatn9x8M6koBga9Jj+d5q8F1AGOhrq5zeU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgHTG63 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 02:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbgHTG62 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 02:58:28 -0400
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DCA620738
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2020 06:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597906707;
        bh=qNpjDzbrt/tJ/wXdPPXLYMt12gi24zaZu0I7xpPjxMw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TM3JW/+AIfAa1AJurWFcmCr47L1tqsGvnZu96rxQiD1aBTYOy9vX8W7C+HYhyazI9
         KGKrMbPb8vmRqOhw8s424bum7sclwoQc+KeI4KYP+nXSzV8Us7Fr18aEWMRa1ICGVu
         NObm48OQIxGLxfXTKLpnLwSuLM3x+CD8N/Hq8dG0=
Received: by mail-oo1-f47.google.com with SMTP id j16so191881ooc.7
        for <linux-crypto@vger.kernel.org>; Wed, 19 Aug 2020 23:58:27 -0700 (PDT)
X-Gm-Message-State: AOAM5309jmpZYmHr84QhZVioFvk2YAYklgwE1N6+eM3ojNERdiGuRay0
        2g/POzvENTgOWdwLdA35B6tZOy5Og7+2cmOS9Q8=
X-Google-Smtp-Source: ABdhPJxUACMssyiwN2VC6kC/E/g7lBNreeUjfyrByGdGqzVg7RP3qgHrbWWAWh1gTZREm99ZEVaxR0Ce30wMdGuXYTY=
X-Received: by 2002:a4a:da4c:: with SMTP id f12mr1344592oou.41.1597906706848;
 Wed, 19 Aug 2020 23:58:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200802090616.1328-1-ardb@kernel.org> <20200818082410.GA24497@gondor.apana.org.au>
 <CAMj1kXFOZJFUR0N+6i2O4XGZ462Mcs8pq7y_MYScfLf-Tfy3QQ@mail.gmail.com>
 <20200818135128.GA25652@gondor.apana.org.au> <2aad9569-877e-4398-88ef-e40d9bbf7656@candelatech.com>
 <20200818140532.GA25807@gondor.apana.org.au> <be188471-b75f-d2e2-d657-265a1cd9831b@candelatech.com>
 <20200818221550.GA27421@gondor.apana.org.au> <20200818222719.GA27622@gondor.apana.org.au>
 <bee1a9ce-25d1-2520-5f6a-3966bfa501d2@candelatech.com> <20200818223359.GA27712@gondor.apana.org.au>
 <8b248ef3-d4c7-43fd-6ae4-1c3381597579@candelatech.com>
In-Reply-To: <8b248ef3-d4c7-43fd-6ae4-1c3381597579@candelatech.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 20 Aug 2020 08:58:15 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFaQsCw_7x8NKNHfMfEC=NdWCxd7V6S3VnAFdOg+-Letg@mail.gmail.com>
Message-ID: <CAMj1kXFaQsCw_7x8NKNHfMfEC=NdWCxd7V6S3VnAFdOg+-Letg@mail.gmail.com>
Subject: Re: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
To:     Ben Greear <greearb@candelatech.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 19 Aug 2020 at 00:39, Ben Greear <greearb@candelatech.com> wrote:
>
> On 8/18/20 3:33 PM, Herbert Xu wrote:
> > On Tue, Aug 18, 2020 at 03:31:10PM -0700, Ben Greear wrote:
> >>
> >> I don't think it has been discussed recently, but mac80211 is already
> >> a complicated beast, so if this added any significant complexity
> >> it might not be worth it.
> >
> > Any bulk data path should be using the async interface, otherwise
> > performance will seriously suffer should SIMD be unavailable.  I
> > think someone should look at converting wireless to async like IPsec.
>
> Most users in most cases are using hw crypt, so that is likely why
> it hasn't gotten a huge amount of effort to optimize the software
> crypt path.
>

As I understand it, it is highly unusual for these code paths to be
exercised in the first place. All mac80211 hardware anyone still cares
about supports CCMP offload, and so only in special cases like Ben's
do we need the software implementation. Also, in Ben's case, it is on
a hot path whereas obsolete hardware that does not implement CCMP
offload does not support anything over 11g speeds to begin with.

Then, there is the additional issue where the FPU preserve/restore
appears to be disproportionately expensive on the actual SoC in
question.

My preferred approach for cbcmac(aes-ni) would be to mirror the arm64
exactly, which means going through the data only a single time, and
interleave the CTR and CBCMAC operations at the AES round level. My
cbcmac ahash approach (v2) is plan B as far as I am concerned, but it
turns out to be flawed and I haven't had time to look into this.

But if we look at the actual issue at hand, we might also look into
amortizing the FPU preserve/restore over multiple invocations of a
cipher. I proposed a patch a while ago that makes cipher an internal
crypto API abstraction, and we could easily add pre/post hooks that
preserve/restore the FPU in this case, in which case we would not need
any changes at higher levels.


> If someone wants to give this async api a try for mac80211, I can
> test, and I can sponsor the work, but I don't have time to try
> to implement it myself.
>
> Thanks,
> Ben
>
> >
> >> Truth is though, I know very little about what changes would be
> >> needed to make it do async decrypt, so maybe it would be a simple
> >> matter?
> >
> > IPsec was actually quite straightforward.
> >
> > Cheers,
> >
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
