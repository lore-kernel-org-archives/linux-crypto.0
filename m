Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFEA3C32792
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 21:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B816C205C9
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 21:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732473AbfI3VIk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 17:08:40 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40085 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732460AbfI3VIk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 17:08:40 -0400
Received: by mail-qt1-f196.google.com with SMTP id f7so18895418qtq.7;
        Mon, 30 Sep 2019 14:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TXd66Ux67DUD83Cxi/B96CIS7DW3JJGOpW6P7nrNIfY=;
        b=Xo9tMhA607aHD6YjBbjjefMTMex1kMb4E3j1HWB0qYjUm+BVROscNHNDt8GpHSPuZD
         GGsqfKzW4WAXl/irlZ7mXxl09Gs4eGXfWVGnd2S+1dVssRFViR5o+qMbYCgjTNEtqtnh
         sPbsMCp3ldYpB4i5q4+l19vFpSiNWAsJ5XKhACtBSs5FLPfE6zscSeVDeZjscswidFyn
         EnpL9ZLSYuZweVp6FDBwT41ZyH9gua6+ynPC0pz4Aw3BzRxpBvYIqsd56HI/S+9MNUvV
         eFNSRGhiC/0kr7Cu8RPnY/OhI5XMhLqzMXeHi09LTR4vca+vufIrYL++C9hm8xPf/Cb3
         lVOQ==
X-Gm-Message-State: APjAAAVfF+iWAIRWbbh9Jg+6cyDTj7ydLveF6YMmtruGHLjVTrfuuVuS
        q09M7yo/egmk7pHn/H2ANhzxOkTnIbvL37nywa7aYsDy6nU=
X-Google-Smtp-Source: APXvYqyv9hVI/3ia+VYvKfauMlajJpx0zE+oAiYNhkz17y2Yqa6FPzLPwf5HaGbquYkI3mnwm9gJkBCtqCGoKYoEKmg=
X-Received: by 2002:ac8:342a:: with SMTP id u39mr26502728qtb.7.1569874309586;
 Mon, 30 Sep 2019 13:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190930121520.1388317-1-arnd@arndb.de> <20190930121520.1388317-2-arnd@arndb.de>
 <CH2PR20MB2968B7855D241C747BEB68B9CA820@CH2PR20MB2968.namprd20.prod.outlook.com>
In-Reply-To: <CH2PR20MB2968B7855D241C747BEB68B9CA820@CH2PR20MB2968.namprd20.prod.outlook.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 30 Sep 2019 22:11:33 +0200
Message-ID: <CAK8P3a0PeocENP6c=ENVrq2X8x-vinM6qhPRDDi_WEf6y73AOQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] crypto: inside-secure - Reduce stack usage
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 30, 2019 at 9:04 PM Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:

> > Alternatively, it should be possible to shrink these allocations
> > as the extra buffers appear to be largely unnecessary, but doing
> > this would be a much more invasive change.
> >
> Actually, for HMAC-SHA512 you DO need all that buffer space.
> You could shrink it to 2 * ctx->state_sz but then your simple indexing
> is no longer going to fly. Not sure if that would be worth the effort.

Stack allocations can no longer be dynamically sized in the kernel,
so that would not work.

What I noticed though is that the largest part of safexcel_ahash_export_state
is used in the 'cache' member, and this is apparently only referenced inside of
safexcel_hmac_init_iv, which you call twice. If that cache can be allocated
only once, you save SHA512_BLOCK_SIZE bytes in one of the two paths.

> I don't like the part where you dynamically allocate the cryto_aes_ctx
> though, I think that was not necessary considering its a lot smaller.

I count 484 bytes for it, which is really large.

> And it conflicts with another change I have waiting that gets rid of
> aes_expandkey and that struct alltogether (since it was really just
> abused to do a key size check, which was very wasteful since the
> function actually generates all roundkeys we don't need at all ...)

Right, this is what I noticed there. With 480 of the 484 bytes gone,
you are well below the warning limit even without the other change.

       Arnd
