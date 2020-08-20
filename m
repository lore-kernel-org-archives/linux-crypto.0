Return-Path: <SRS0=QJ87=B6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFD7C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 07:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F4E3208B3
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 07:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597908816;
	bh=XqKBxGqhMX950fOm0Qaum51sMZGfoL9cxLC2217zNFo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=iLnHSF4iRcecEzs5E3tTCqP+YN73ytRMqeG9zWkkYPc/dGW5tFszgHFMNBNgyPOfU
	 AmuwTC6psdyQtuCgiJQf/Bc/S/HpaAEzU2kYgWaVgLcqZGZLxvFndWSIM2rsp/FcUJ
	 JlEFFbt5htoZPDjbbh5HGgem/3zXomoGdvgKWy7s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgHTHdf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 03:33:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbgHTHde (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 03:33:34 -0400
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACFB1208B3
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2020 07:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597908813;
        bh=XqKBxGqhMX950fOm0Qaum51sMZGfoL9cxLC2217zNFo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Zu2V6Ko8ixvMDG4KQa8DxlLqnjmr/fBbgGBquu+mlfuWf04U17emPf0A9awfsFtbK
         I0Oel7psXkcB4kLklQIw55I4ocVEjpHmGU5D/B4TlBzWTkrwJdRLziWrTSTq9pNEC6
         TOBJgLWrc9q/B/pOQ6wHV+twlqCgvoAPswMDJ4e4=
Received: by mail-oi1-f170.google.com with SMTP id h3so1104717oie.11
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2020 00:33:33 -0700 (PDT)
X-Gm-Message-State: AOAM531rit0FMwLYyTmyD9/cBYiUbgHs4u7VePCuYj6S7K9K5bfaEb02
        lrLuI8iSIqyk/Alzh8uispX38tRz3YIxeYVavzw=
X-Google-Smtp-Source: ABdhPJww7OafIZuKhlXS8IpcKNBGKdTab75bY+C81IvMJAvWrQgUmcODQsqSE/WbqtI0E7oMJyQu3+L9p/2MwVAC7JQ=
X-Received: by 2002:aca:d8c5:: with SMTP id p188mr950442oig.47.1597908813077;
 Thu, 20 Aug 2020 00:33:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200818221550.GA27421@gondor.apana.org.au> <20200818222719.GA27622@gondor.apana.org.au>
 <bee1a9ce-25d1-2520-5f6a-3966bfa501d2@candelatech.com> <20200818223359.GA27712@gondor.apana.org.au>
 <8b248ef3-d4c7-43fd-6ae4-1c3381597579@candelatech.com> <CAMj1kXFaQsCw_7x8NKNHfMfEC=NdWCxd7V6S3VnAFdOg+-Letg@mail.gmail.com>
 <20200820070142.GA21343@gondor.apana.org.au> <CAMj1kXEdkQUZ_d33N5T5_ELyqRomBKF8Nn+gquo7nrVBMMP-gA@mail.gmail.com>
 <20200820070645.GA21395@gondor.apana.org.au> <CAMj1kXE6QDxjNKSpzTrxe+QU0DF9CYp-W7bGe1AyFzYHOJQ41Q@mail.gmail.com>
 <20200820072910.GA21631@gondor.apana.org.au>
In-Reply-To: <20200820072910.GA21631@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 20 Aug 2020 09:33:21 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFR2SSdE7oi6YKsWG1OvpXpo+584XSiMCSL0V-ysOMc5A@mail.gmail.com>
Message-ID: <CAMj1kXFR2SSdE7oi6YKsWG1OvpXpo+584XSiMCSL0V-ysOMc5A@mail.gmail.com>
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

On Thu, 20 Aug 2020 at 09:29, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 20, 2020 at 09:19:16AM +0200, Ard Biesheuvel wrote:
> >
> > Actually, I'm not so sure that they will be so much worse. The
> > expensive FPU preserve/restore occurs for every 16 bytes of data
> > processed by the AES cipher, which I'd estimate to take ~10 cycles per
> > byte for an unaccelerated implementation. But table based AES should
> > be avoided, especially for MAC algorithms where the plaintext may be
> > known to an attacker who is after the key.
>
> On my machine the performance difference on a 1472-byte request
> between SIMD and generic is 2161 vs. 7558 (cycles).

Sure. But your machine does not have the pathological FPU
preserve/restore performance.

> >
> > However, the CCMP handling is invoked from softirq context or from
> > task context, and so SIMD is generally available unless the softirq
> > happens to be taken over the back of a hardirq that interrupted a task
> > running in the kernel that was using the SIMD already. IOW, this
> > happens so rarely in practice that I would not expect it to be
> > noticeable in the performance stats.
>
> What if the same machine was doing TLS/IPsec sends at full throttle?
> That would be exactly the wrong time to slow down softirqs four-fold,
> no?
>

Fair point.

> > My v2 attempt at cbcmac(aesni) implements an ahash, but a synchronous
> > one. This means we can amortize the FPU preserve/restore over the
> > entire scatterlist, instead of relying on the ahash walk to present
> > the data in virtually mapped chunks.
> >
> > I'd still like to explore this approach, but I simply haven't had the
> > spare cycles to spend on this.
>
> I don't have an issue your patch per se.  But please make it so that
> it has the async path like everything else.  Also wireless uses shash
> so it can't use an ahash anyway even if it is sync.
>

The mac80211 CCMP code uses a synchronous ccm aead, which gets backed
by a skcipher+ahash combo by the ccm template. So a synchronous ahash
is fine for this particular case.
