Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910D2C433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Apr 2022 02:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiDECt4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Apr 2022 22:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiDECtm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Apr 2022 22:49:42 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C813256E5
        for <linux-crypto@vger.kernel.org>; Mon,  4 Apr 2022 18:56:07 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id y32so5333994lfa.6
        for <linux-crypto@vger.kernel.org>; Mon, 04 Apr 2022 18:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cRMKHMEeY9+RKsGGifttcYB8078b1P2NNUuN3rXNHsA=;
        b=LlZFviyzsfP62rQJSDGGCX3c9ZzlqUhIw0Grkn+0VsM5rBKFmnTsvaGr6mPFYw/tj6
         ZBlT4zeTLpFbNjJFxipLzirk3SZnQBkKZztZrogl8TdhoIqBfNsmEHMQAwoLN4wDBSb1
         RX6dA3jOFOe37TqV8nAumLk8bTAHjDZcvlCQ7IG1JaltWKxP8ngirmIA6lxxLG8A2Jz+
         A/eJ43HBVW5k9XKtbxoZealcoZb77DOHQc72k2eDNR0zVMPrdx6whfcxtnwjka6gcAen
         A1ItInfmns7dDfPE74B3SyF17i4AKPzOoaFKdp52yNvyaChvEdHGjckkPvPTrw3IIDYA
         fxoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cRMKHMEeY9+RKsGGifttcYB8078b1P2NNUuN3rXNHsA=;
        b=fy7Nh8VjWSti+hV+3yp0rlKH8rg6107knL8WvM2GQKyA4nuVrdYXVmg9x6+iLJ0jvE
         I094FIghrlyqtSlx4aZ59lapJhPRVcga53HzVmwsLV7/68FR8wNKSrOB5A5BQPUgjtLc
         lTNX9O3KNke0S1TqSKkhYjy5luszx/j3Glk0so/VUzcqAY4p2uUz8WK0fuZ4I7B7Z8KM
         G9/sq2xHOLpP5rR7PvhqI6RswCJz2L75oDEs53YayICwLDc05tiKrCfMkXxYxOvLrsWd
         IMNam1MFH+uU0ct3agpjCkIEsO8vP/xwYfWp1wQx5hImb34Av/qc+XqfmUAYZ2dsWsHM
         ///g==
X-Gm-Message-State: AOAM5304TSnYc9+kPPgXFYGD83finctPKaCWN2n5LxTG9cw4Y5xmkhn/
        Bv5uCalkwLif0y8IsgFOzjG3pNNz2Cqfuzl0EEKPmCJDkfg=
X-Google-Smtp-Source: ABdhPJwP68brfn2rAlyZj8ifciA/yGBj3dOA1XzN+z0hIDf8y32OrKqN3zR2RIoCsOMVm7zYU2M/MhPE2Upm9zNrwX4=
X-Received: by 2002:a05:6512:1153:b0:44a:3b47:4f88 with SMTP id
 m19-20020a056512115300b0044a3b474f88mr852181lfg.447.1649123765408; Mon, 04
 Apr 2022 18:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220315230035.3792663-1-nhuck@google.com> <20220315230035.3792663-8-nhuck@google.com>
 <YjvLZkjW2ts8qDfr@sol.localdomain>
In-Reply-To: <YjvLZkjW2ts8qDfr@sol.localdomain>
From:   Nathan Huckleberry <nhuck@google.com>
Date:   Mon, 4 Apr 2022 20:55:54 -0500
Message-ID: <CAJkfWY7gU7ZfziTmUbRKkWH4yLW6mQ3MrWZ6-UQW=EfBG0FtXg@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] crypto: arm64/polyval: Add PMULL accelerated
 implementation of POLYVAL
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 23, 2022 at 8:37 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Mar 15, 2022 at 11:00:34PM +0000, Nathan Huckleberry wrote:
> > Add hardware accelerated version of POLYVAL for ARM64 CPUs with
> > Crypto Extension support.
>
> Nit: It's "Crypto Extensions", not "Crypto Extension".
>
> > +config CRYPTO_POLYVAL_ARM64_CE
> > +     tristate "POLYVAL using ARMv8 Crypto Extensions (for HCTR2)"
> > +     depends on KERNEL_MODE_NEON
> > +     select CRYPTO_CRYPTD
> > +     select CRYPTO_HASH
> > +     select CRYPTO_POLYVAL
>
> CRYPTO_POLYVAL selects CRYPTO_HASH already, so there's no need to select it
> here.
>
> > +/*
> > + * Perform polynomial evaluation as specified by POLYVAL.  This computes:
> > + *   h^n * accumulator + h^n * m_0 + ... + h^1 * m_{n-1}
> > + * where n=nblocks, h is the hash key, and m_i are the message blocks.
> > + *
> > + * x0 - pointer to message blocks
> > + * x1 - pointer to precomputed key powers h^8 ... h^1
> > + * x2 - number of blocks to hash
> > + * x3 - pointer to accumulator
> > + *
> > + * void pmull_polyval_update(const u8 *in, const struct polyval_ctx *ctx,
> > + *                        size_t nblocks, u8 *accumulator);
> > + */
> > +SYM_FUNC_START(pmull_polyval_update)
> > +     adr             TMP, .Lgstar
> > +     ld1             {GSTAR.2d}, [TMP]
> > +     ld1             {SUM.16b}, [x3]
> > +     ands            PARTIAL_LEFT, BLOCKS_LEFT, #7
> > +     beq             .LskipPartial
> > +     partial_stride
> > +.LskipPartial:
> > +     subs            BLOCKS_LEFT, BLOCKS_LEFT, #NUM_PRECOMPUTE_POWERS
> > +     blt             .LstrideLoopExit
> > +     ld1             {KEY8.16b, KEY7.16b, KEY6.16b, KEY5.16b}, [x1], #64
> > +     ld1             {KEY4.16b, KEY3.16b, KEY2.16b, KEY1.16b}, [x1], #64
> > +     full_stride 0
> > +     subs            BLOCKS_LEFT, BLOCKS_LEFT, #NUM_PRECOMPUTE_POWERS
> > +     blt             .LstrideLoopExitReduce
> > +.LstrideLoop:
> > +     full_stride 1
> > +     subs            BLOCKS_LEFT, BLOCKS_LEFT, #NUM_PRECOMPUTE_POWERS
> > +     bge             .LstrideLoop
> > +.LstrideLoopExitReduce:
> > +     montgomery_reduction
> > +     mov             SUM.16b, PH.16b
> > +.LstrideLoopExit:
> > +     st1             {SUM.16b}, [x3]
> > +     ret
> > +SYM_FUNC_END(pmull_polyval_update)
>
> Is there a reason why partial_stride is done first in the arm64 implementation,
> but last in the x86 implementation?  It would be nice if the implementations
> worked the same way.  Probably last would be better?  What is the advantage of
> doing it first?

It was so I could return early without loading keys into registers,
since I only need them if there's
a full stride. I was able to rewrite it in the same way that the x86
implementation works.
>
> Besides that, many of the comments I made on the x86 implementation apply to the
> arm64 implementation too.
>
> - Eric
