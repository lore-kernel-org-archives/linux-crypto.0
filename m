Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B0DC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 00:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 692ED6103C
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 00:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238035AbhIWA45 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Sep 2021 20:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237852AbhIWA44 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Sep 2021 20:56:56 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EFBC061574;
        Wed, 22 Sep 2021 17:55:25 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x7so2859317edd.6;
        Wed, 22 Sep 2021 17:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4NPU/ZVpuhfsq8j4kWcPthoCwQtSjQlJkLhZqLNa7WA=;
        b=Cb9EPH1Qt1jr1w9lMJ7uOJHRz2cY2mMb6moezHp6svacqI+SyDgHLmm3bGXkH/4SkS
         fk5o2ub72tL7rqPDxxJSG93AeE61SxhvogvTWIjtX/ZVE0eyVhFiXC/0QFiIPziza5xe
         XA9iqHGjm2vNgdbbyC4c0MwuvzO98MAy/KkM+y4sro1pkdNJgonNyg6GGnEyUw8tSQWf
         BQsmQLTiqt0uKNIVyDy1uda4K1gMEyeYkhb8TvpWdTtWb6YRyGdREPaLYW+jfMUO7++N
         SV3eQeJ/dLnByQ7GDFjJ3eSLO6IkVSnJRDOvu/zGWsVbVcvcbnanFSRU9NtagYs3JGP3
         XSTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4NPU/ZVpuhfsq8j4kWcPthoCwQtSjQlJkLhZqLNa7WA=;
        b=iwX7L1P9sjM2nWCffBBt7uf2/tcW7x8idktMROiWjQvTFlhmv3Dx9qbOPOb1wpv+P0
         72teXknJhtVCE1EGf223mGpMdRPH7uWo89ivm9twxJQ6VQbMlbdUEJmI1Mq01GQNgsvF
         a4ytJWxwDSdNlbTS2h11l82C6DYN1AFMsXn0dhcRpzSor6/2IT+LAYuNf9vd462AniDa
         6Z4QXogbeT8zvW/fYoYp+N6nXHTB2UPrQo3fmw+sc+G8jPbz77czmJ6rC43yqNJyTUyI
         ssgdlzbPI7ZH1OARytdKtfjdPzLmaMl9RQaHSGxgnRe5Jrx3fZ4fRHLxZA7tMLYBlCRi
         z4NQ==
X-Gm-Message-State: AOAM531lAAsDCbV3Z8aSw8oQjy83+9bpkUTq4o+FigdeJMDwIFEJivKS
        mQydn5NCQcPn/7blZoZ6ClZFNKvb0HqA062WZ+c=
X-Google-Smtp-Source: ABdhPJxlAuJ/7eKxf3n3hw5XfXfcjTDvtlZrE6PHEAXIoz1CrajrEeIKkIfEFrKu3tP/f+g7puJocrrxA3UvQ2BhaXg=
X-Received: by 2002:a17:906:7250:: with SMTP id n16mr2146828ejk.147.1632358524398;
 Wed, 22 Sep 2021 17:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210803063149.2821093-1-mudongliangabcd@gmail.com>
 <20210812100437.GA5055@gondor.apana.org.au> <CAD-N9QWGgBBddi5kwTNANKVVdWaQRwagMHvaH592B5GDALpBrg@mail.gmail.com>
 <20210812102954.GA5569@gondor.apana.org.au> <CAD-N9QU6r-yLBvJUpV+xy4pgOFnrtquBymthG7k5ddHt20APzg@mail.gmail.com>
 <20210812104318.GA5780@gondor.apana.org.au> <CAD-N9QVz3W1E0D4i9iVTpkHVaB_Y9u1_HK2VW+FoQKJ9H8krrA@mail.gmail.com>
In-Reply-To: <CAD-N9QVz3W1E0D4i9iVTpkHVaB_Y9u1_HK2VW+FoQKJ9H8krrA@mail.gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Thu, 23 Sep 2021 08:54:58 +0800
Message-ID: <CAD-N9QUu0QPdMtijoRKSzfq1EKa-VYgPy5r4+EkGG8swpQo8Fg@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: sun8i-ce: fix multiple memory leaks in sun8i_ce_hash_run
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Eric Biggers <ebiggers@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 16, 2021 at 9:21 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> On Thu, Aug 12, 2021 at 6:43 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Thu, Aug 12, 2021 at 06:40:20PM +0800, Dongliang Mu wrote:
> > >
> > > I agree with you and would like to modify "return 0" to "return err"
> > > in the next version.  Even if the parent function does not care about
> > > the return value, it is still necessary to keep the right return
> > > value.
> >
> > Well if the parent is ignoring the error then returning the error
> > there obviously isn't going to help.
>
> If so, do I still need to change my current patch?

Any update on this thread?

>
> Dongliang Mu
>
> >
> > Cheers,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
