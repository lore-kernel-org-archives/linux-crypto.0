Return-Path: <SRS0=sRio=6G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DEFCC55185
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 19:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0312320767
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 19:35:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SmMEoWFm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgDVTf1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Apr 2020 15:35:27 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:51183 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726398AbgDVTf0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Apr 2020 15:35:26 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 4da5aa45;
        Wed, 22 Apr 2020 19:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=G14/T8eEI9TeQPnPJ5D0ORWfR+4=; b=SmMEoW
        Fmf8RU8JIiKbBUmEZwRnnNXQvw29LJc/OTni7TAQ8UhqgT4VYHNHkhOuGfvzC8rl
        6ie63Yd75cc/Qb8JyFSAq+R8tmxtjjlFG5rGymabsXeFeVLZD3xjXcRoti9lH1yn
        BECMW0uWF4lv9Qs4mX4feUK768vGN1toYB45OOpZv+7YbiOqP0MLpCebR1bv2fJD
        5kn3Hhuwu+p0+soDCglxzfVgFWKSQokOi3pB5mgjWCnfaHTurjFUCZocZ1eoGX1H
        e6sPI3u+of35ds4g/s3/pFy3Nkfmpi9EsEfNhjlYFdKYIutg3uVHEZfRsRWG5nGE
        vviy99rKd/h8jKHQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8d1ff259 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 22 Apr 2020 19:24:28 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id 19so3726651ioz.10;
        Wed, 22 Apr 2020 12:35:22 -0700 (PDT)
X-Gm-Message-State: AGi0PuaO2HejiyjDx/S94XoAU1uHa0bU5Rw/cTxQVjZkKSHL556Tkmcp
        e1R25jGyCb42hlfCJ/ql7DIfK2EvnL4Koqctig0=
X-Google-Smtp-Source: APiQypL2qB5DofVQgXXv6QKARA53LC626NO1xiEHbze/zLzg7cbkMpOefRL/3Ao32x5vWZC+1Ar6lyQswEf9tp3pE+Y=
X-Received: by 2002:a05:6638:4e:: with SMTP id a14mr21577jap.108.1587584121233;
 Wed, 22 Apr 2020 12:35:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200420075711.2385190-1-Jason@zx2c4.com> <20200422040415.GA2881@sol.localdomain>
 <CAMj1kXGRNCEkTFPGM03h1N+HtOiLVMcm89UJYMZcuWjyFAp5Ag@mail.gmail.com> <20200422112831.5352gcpo42jgz2dj@linutronix.de>
In-Reply-To: <20200422112831.5352gcpo42jgz2dj@linutronix.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 22 Apr 2020 13:35:10 -0600
X-Gmail-Original-Message-ID: <CAHmME9ojNM1LUbbzD7uyZ3O5KWpT16urfsp=YMpx7LX0U=5bBA@mail.gmail.com>
Message-ID: <CAHmME9ojNM1LUbbzD7uyZ3O5KWpT16urfsp=YMpx7LX0U=5bBA@mail.gmail.com>
Subject: Re: [PATCH crypto-stable] crypto: arch/lib - limit simd usage to
 PAGE_SIZE chunks
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-rt-users@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 22, 2020 at 5:28 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2020-04-22 09:23:34 [+0200], Ard Biesheuvel wrote:
> > My memory is a bit fuzzy here. I remember talking to the linux-rt guys
> > about what delay is actually acceptable, which was a lot higher than I
> > had thought based on their initial reports about scheduling blackouts
> > on arm64 due to preemption remaining disabled for too long. I intended
> > to revisit this with more accurate bounds but then I apparently
> > forgot.
> >
> > So SIMD chacha20 and SIMD poly1305 both run in <5 cycles per bytes,
> > both on x86 and ARM. If we take 20 microseconds as a ballpark upper
> > bound for how long preemption may be disabled, that gives us ~4000
> > bytes of ChaCha20 or Poly1305 on a hypothetical 1 GHz core.
> >
> > So I think 4 KB is indeed a reasonable quantum of work here. Only
> > PAGE_SIZE is not necessarily equal to 4 KB on arm64, so we should use
> > SZ_4K instead.
> >
> > *However*, at the time, the report was triggered by the fact that we
> > were keeping SIMD enabled across calls into the scatterwalk API, which
> > may call kmalloc()/kfree() etc. There is no need for that anymore, now
> > that the FPU begin/end routines all have been optimized to restore the
> > userland SIMD state lazily.
>
> The 20usec sound reasonable. The other concern was memory allocation
> within the preempt-disable section. If this is no longer the case,
> perfect.

Cool, thanks for the confirmation. I'll get a v2 of this patch out the door.
