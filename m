Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDE1C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 01:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356190AbiDFBID (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573368AbiDES6w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Apr 2022 14:58:52 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3DFCD338
        for <linux-crypto@vger.kernel.org>; Tue,  5 Apr 2022 11:56:53 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id h11so257736ljb.2
        for <linux-crypto@vger.kernel.org>; Tue, 05 Apr 2022 11:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zSvDe2wXRWjVXLEeBb9YX8FvDd3b9Nj5l9utIPFSSwc=;
        b=IhyRdaotisLwt7fVHkbbAVd8yCn1BLRomcM+qu6u/xZ9Xx0SPc1HY9AXMeDo4HAAai
         FhFmInf2Zf/ZWw3z04p7+qcFnWcYMtYX98wJI4MgIr1B6eHBp3DkPGzyfpnXPEHlSbO3
         x5sj/rqZaZEOH2Zel5umautUuhgGoXRKYUfPk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zSvDe2wXRWjVXLEeBb9YX8FvDd3b9Nj5l9utIPFSSwc=;
        b=uSBi7raUW9N166gjjLZVd8K6uluCGJ3BJDnB7ufJqcpsv/3+BPvCQD0oSGup21BRDZ
         tG7xlA2VvsEYzDqG2EIkJg59MTABGp0U4mnoXBc3ny7Uz1bKAA89UMapLZwmy+ULfQqk
         c3X3pO2WZjksUL1IvFEI3pcuzVz0UxAAZisNqConb6LrI8WjMN9IpcTYxJAc0wz0wAH3
         FgtXKDzvCZmJXZchRn++XMtGHXdKIz8PGooMoJto4nMmoEP5kBQIOoQ7UFOw+wjilDL8
         s8kkHXVleJ/rNT6nCA6csE4ydnpv911iXSWdB7lDo9CFShlmp7XWgVTxb3IFblj2St9q
         fAXg==
X-Gm-Message-State: AOAM530ABC3/05Wv1S3bCp6DVtL2p1AffQHkpmNAMl2kFFZ4D07QRv1D
        19m5nw/D4X95/3sxi3GWMUD+CSXzwowaNd/it4s=
X-Google-Smtp-Source: ABdhPJyrkgFeZsXMswMv6duiEyKPB/ojU62cIWH6gXkB4ogVibRWL3i8cCI7yNdz8GpxAH4D2DDzcg==
X-Received: by 2002:a05:651c:179f:b0:24b:1406:5f55 with SMTP id bn31-20020a05651c179f00b0024b14065f55mr2990509ljb.361.1649185011462;
        Tue, 05 Apr 2022 11:56:51 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id l20-20020a056512111400b0044aba8206ccsm1585608lfg.253.2022.04.05.11.56.50
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 11:56:50 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id b43so209507ljr.10
        for <linux-crypto@vger.kernel.org>; Tue, 05 Apr 2022 11:56:50 -0700 (PDT)
X-Received: by 2002:a2e:8e23:0:b0:24b:14f6:d71d with SMTP id
 r3-20020a2e8e23000000b0024b14f6d71dmr3094398ljk.443.1649185009914; Tue, 05
 Apr 2022 11:56:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220405140906.222350-1-Jason@zx2c4.com> <CAHk-=wjFSsa7ZTFOiDCpZbwQsCKdAo3KFetSpGCjusqjjcb2XA@mail.gmail.com>
 <CAHmME9pPG2cgyfi6gV4NONXEc86Kw8_ejpOQUqcoaf3Mq1=Cfw@mail.gmail.com>
In-Reply-To: <CAHmME9pPG2cgyfi6gV4NONXEc86Kw8_ejpOQUqcoaf3Mq1=Cfw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 5 Apr 2022 11:56:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wib4v7epabkEZmk5ZsJhHBX5UiVCwT9BWyeWrOwMrKkrA@mail.gmail.com>
Message-ID: <CAHk-=wib4v7epabkEZmk5ZsJhHBX5UiVCwT9BWyeWrOwMrKkrA@mail.gmail.com>
Subject: Re: [PATCH] random: opportunistically initialize on /dev/urandom reads
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 5, 2022 at 11:31 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> It sounds like your suggestion would be to make that:
>
>   while (!crng_ready()) {
>     int ret;
>
>     try_to_generate_entropy();
>     if (nodelay && !crng_ready()) {
>       warn(...);
>       return -EBUSY;
>     }
>     ret = wait_event_interruptible_timeout(crng_init_wait, crng_ready(), HZ);
>     if (ret)
>       return ret > 0 ? 0 : ret;
>   }

Yes. Except I'd almost warn for the "ret < 0" case too, since almost
nobody seems to check it.

But hey, maybe callers that are interrupted by a signal check for that
separately. I guess it's _possible_.

             Linus
