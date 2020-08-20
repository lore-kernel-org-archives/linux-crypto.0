Return-Path: <SRS0=QJ87=B6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC17BC433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 07:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC50721744
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 07:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597910219;
	bh=sMf+y+wctmuYbwLMEwLEBLkAV15W+edOEYiissjZ2ec=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=teXoIyfbtJgLQelODCR7zO8chvH1v6ItQTXPi6PR4Phu1PuJ7O9y8epJB86GcLSO+
	 uzOhQYWBZKBYQdfu3cdPbojmV6+mJU5JWcQtrQIS1mocLCGL6WrRb8Iidu3fcqg6sa
	 2QpckEMlNxQrKenaYY3JHC8mYt+1nPzDcqUxJEvA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgHTH46 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 03:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgHTH4x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 03:56:53 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 740A32076E
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2020 07:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597910212;
        bh=sMf+y+wctmuYbwLMEwLEBLkAV15W+edOEYiissjZ2ec=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dDsjCbj6K9wgYsK1MplIvsdPkLKgkwI2gq7MnIQ44m5bb/OS56r8KuHtdfnSky4Mb
         iUp2dnf1HdM5m7+wcdZ9UxzjbfOC/ih0eahoPhXLB24KuJPdd/6si6PX+8BxlHL4N3
         cbBVykvI+iHt8G63GCe0J83lbpz3zYt/jI/KwXRs=
Received: by mail-oi1-f174.google.com with SMTP id h3so1127670oie.11
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2020 00:56:52 -0700 (PDT)
X-Gm-Message-State: AOAM532WFSssjyWhG5K7E+ihgsCk5vaebyOlH3d2qXQAhHEt9bmYZltZ
        64JtARplz8N1UKTyixisLwkeaDCx/OKyEJMAfYs=
X-Google-Smtp-Source: ABdhPJzVab+/X2m2WavXxiatLDh1YiGlwvW7/tS4OPG5aaEVYdR99oCqgpR1nwh/dCLdoME0U5o4IQ2RkBRsHG9PxIg=
X-Received: by 2002:a05:6808:b37:: with SMTP id t23mr1093938oij.174.1597910211786;
 Thu, 20 Aug 2020 00:56:51 -0700 (PDT)
MIME-Version: 1.0
References: <8b248ef3-d4c7-43fd-6ae4-1c3381597579@candelatech.com>
 <CAMj1kXFaQsCw_7x8NKNHfMfEC=NdWCxd7V6S3VnAFdOg+-Letg@mail.gmail.com>
 <20200820070142.GA21343@gondor.apana.org.au> <CAMj1kXEdkQUZ_d33N5T5_ELyqRomBKF8Nn+gquo7nrVBMMP-gA@mail.gmail.com>
 <20200820070645.GA21395@gondor.apana.org.au> <CAMj1kXE6QDxjNKSpzTrxe+QU0DF9CYp-W7bGe1AyFzYHOJQ41Q@mail.gmail.com>
 <20200820072910.GA21631@gondor.apana.org.au> <CAMj1kXFR2SSdE7oi6YKsWG1OvpXpo+584XSiMCSL0V-ysOMc5A@mail.gmail.com>
 <20200820074414.GA21848@gondor.apana.org.au> <CAMj1kXHAo8LzKZd9cuwhZzP3ikYr1Bd_zjrnBRDrAU8M=92RWQ@mail.gmail.com>
 <20200820075353.GA21901@gondor.apana.org.au>
In-Reply-To: <20200820075353.GA21901@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 20 Aug 2020 09:56:40 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGjPbscU=vzZwoX7gxuELgTYWk+wR3Z7vKk9RwKdhv1TQ@mail.gmail.com>
Message-ID: <CAMj1kXGjPbscU=vzZwoX7gxuELgTYWk+wR3Z7vKk9RwKdhv1TQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ben Greear <greearb@candelatech.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 20 Aug 2020 at 09:54, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 20, 2020 at 09:48:02AM +0200, Ard Biesheuvel wrote:
> >
> > > Or are you saying on Ben's machine cbc-aesni would have worse
> > > performance vs. aes-generic?
> > >
> >
> > Yes, given the pathological overhead of FPU preserve/restore for every
> > block of 16 bytes processed by the cbcmac wrapper.
>
> I'm sceptical.  Do we have numbers showing this? You can get them
> from tcrypt with my patch:
>
>         https://patchwork.kernel.org/patch/11701343/
>
> Just do
>
>         modprobe tcrypt mode=400 alg='cmac(aes-aesni)' klen=16
>         modprobe tcrypt mode=400 alg='cmac(aes-generic)' klen=16
>
> > cmac() is not really relevant for performance, afaict. Only cbcmac()
> > is used for bulk data.
>
> Sure but it's trivial to extend my cmac patch to support cbcmac.
>


Sure.

Ben, care to have a go at the above on your hardware? It would help us
get to the bottom of this issue.
