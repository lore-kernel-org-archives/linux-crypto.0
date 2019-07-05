Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 700DAC5B57D
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 06:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 400DD218BB
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 06:32:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mdY+FRbf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfGEGcW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 02:32:22 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35348 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbfGEGcW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 02:32:22 -0400
Received: by mail-wr1-f68.google.com with SMTP id y4so50777wrm.2
        for <linux-crypto@vger.kernel.org>; Thu, 04 Jul 2019 23:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ovsHUna91hEc0tSDDPGIwh4AWoKdmf0FnMPYL9dLv6w=;
        b=mdY+FRbfsdqRqYPNOtfUlf7FXQtpeXltB2OgJdlnN1tKhoHvyjiEkWrNQI+CqpUoIx
         O+sosMBjjJIQs0wkN4aL3vLMDGTgatrLzsYOfLwpoN7V4V5Ys1VX7OsBxija0v8dDSbB
         A7c74jcFMT5FxS5zv10CXJyerpfcNH6L+bhyziDmBNO1fWZi3rJT9KObqJXre7K5tZK6
         LR0Tp2B1rRPUX2PyPoyey+gbLahcR6lrITAc2rqte3aGU4oIIE8KHaqxSdbONCZydLiE
         J619uAj0r52PO2FMLBvE/3L6scNOfZ6Ia+xVCFJCGCDvoI4KvcDLkBhfPks+9IyLqjnp
         4BTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ovsHUna91hEc0tSDDPGIwh4AWoKdmf0FnMPYL9dLv6w=;
        b=hI4GkaY3w4dFQ7DTv1wLm6cjsPcka7zGbReJIv2/LvSQfGJwwoNtIZpGw9s2T+dgH7
         PBZThy0kO7XfbmI0CoqBCalT3c7q6dvL0QusqEaj5KQIs4WF2fsdtVovkUPvyKLz7K35
         G4MlyAmJGwnzJlwPhSE8rmKTC3gVAD6LFIHM92nVPCA6S5imJyVngjopHnm7Qkl1oeij
         0mhhXCGv0VMYtQpNcYAp6BfaDRlyLgybDqkKgqqLash6L8VZTKzrqXo/ix6K0OnhiePY
         C8Yur7BK+5BF2odMt7uu4/umxdVTx+pz3Hx4nc7vLWyqrX6I8Zti3eCB2Xa09ZrYwUOn
         ZVWQ==
X-Gm-Message-State: APjAAAWKeJ/2xzveV2CUsidW/8tKXWlXj0YyayfSuz0K0MBlyIv+IrI+
        IYEqqwjyRqawCiI6EuUjNme5CmFgbSl4jvoxpPG/Gg==
X-Google-Smtp-Source: APXvYqwETauqYCtkBKoF5CX6TqitunjyLTSGH36GNl2j7u0g2rRUYRBc90s2zTuCFyzOn0sWZK36urPzzL+5c97kpK8=
X-Received: by 2002:a5d:6b07:: with SMTP id v7mr2202654wrw.169.1562308339870;
 Thu, 04 Jul 2019 23:32:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190704131033.9919-1-gmazyland@gmail.com> <20190704131033.9919-3-gmazyland@gmail.com>
 <7a8d13ee-2d3f-5357-48c6-37f56d7eff07@gmail.com> <CAKv+Gu_c+OpOwrr0dSM=j=HiDpfM4sarq6u=6AXrU8jwLaEr-w@mail.gmail.com>
 <CAKv+Gu8a6cBQYsbYs8CDyGbhHx0E=+1SU7afqoy9Cs+K8PMfqA@mail.gmail.com>
 <4286b8f6-03b5-a8b4-4db2-35dda954e518@gmail.com> <CAKv+Gu_Nesqtz-xs0LkHYZ6HXrKkbJjq8dKL6Cnrk9ZsQ=T3jg@mail.gmail.com>
 <20190705030827.k6f7hnhxjsoxdj6b@gondor.apana.org.au>
In-Reply-To: <20190705030827.k6f7hnhxjsoxdj6b@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 5 Jul 2019 08:32:03 +0200
Message-ID: <CAKv+Gu-Nye8TF68bZ=fKzU-SBpW7nx3F8ECcZjLjKD_TTbtsmw@mail.gmail.com>
Subject: Re: [PATCH 3/3] dm-crypt: Implement eboiv - encrypted byte-offset
 initialization vector.
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Milan Broz <gmazyland@gmail.com>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 5 Jul 2019 at 05:08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jul 04, 2019 at 08:11:46PM +0200, Ard Biesheuvel wrote:
> >
> > To be clear, making the cipher API internal only is something that I
> > am proposing but hasn't been widely discussed yet. So if you make a
> > good argument why it is a terrible idea, I'm sure it will be taken
> > into account.
> >
> > The main issue is that the cipher API is suboptimal if you process
> > many blocks in sequence, since SIMD implementations will not be able
> > to amortize the cost of kernel_fpu_begin()/end(). This is something
> > that we might be able to fix in other ways (and a SIMD get/put
> > interface has already been proposed which looks suitable for this as
> > well) but that would still involve an API change for something that
> > isn't the correct abstraction in the first place in many cases. (There
> > are multiple implementations of ccm(aes) using cipher_encrypt_one() in
> > a loop, for instance, and these are not able to benefit from, e.g,
> > the accelerated implementation that I created for arm64, since it open
> > codes the CCM operations)
>
> I agree with what you guys have concluded so far.  But I do have
> something I want to say about eboiv's implementation itself.
>
> AFAICS this is using the same key as the actual data.  So why
> don't you combine it with the actual data when encrypting/decrypting?
>
> That is, add a block at the front of the actual data containing
> the little-endian byte offset and then use an IV of zero.
>

That would only work for encryption.
