Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A55C433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Dec 2020 08:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 815FB22D57
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Dec 2020 08:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbgLVIBq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Dec 2020 03:01:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgLVIBq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Dec 2020 03:01:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 812B223124
        for <linux-crypto@vger.kernel.org>; Tue, 22 Dec 2020 08:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608624065;
        bh=0FsKA0IyYoGVlNP/nXzavrXUhAKYPzOZ5KTfWlvUDq4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cucnEYEYoWanmUOG+IaBurd3QoimTbfw4HdaWrJB9Ox7mH6eYxagQWrxDWcDzkDQv
         nmooIuUA9lM4pQZhPyCq4xvhPk+TbZ7OZSLb1Mh0lurUvOyAey0xJUekAILXcZV3UJ
         807hPLxG4Nkhh1R2o7EvWAyabREsBOwnMkWDShV1593AlPL0LJ5eNCYERHuoR5DaZk
         CfaD8JviVk3SlDJ2g5GJgfpd0esXHWo8SBHrAgDe2uLpGA/bfz+Cc7iejPxMwY2gPP
         vJryXaTwgw2rIvyoHC6RLeHRqr2maRQBmgJ/BC45wfpeShBPzfvTvtu/5OIKgKMCXt
         6glnFC55R16Ow==
Received: by mail-ot1-f46.google.com with SMTP id 11so11165729oty.9
        for <linux-crypto@vger.kernel.org>; Tue, 22 Dec 2020 00:01:05 -0800 (PST)
X-Gm-Message-State: AOAM530DFgditIp1nlrCShL8ChSzTlmV5LpyiLdMOlT3ywtntQa+Y7X/
        a6A+y9Yaw5cwm4EXVYGwP3HRLauJnYKcUl3JK7E=
X-Google-Smtp-Source: ABdhPJwqQKJpf9go6w6x0TW04zmncMv5oExPzDkfxsrpblPflx4jjXvgq0Ia1jlOgS2bEzLrF2DKdKsW1biri2M2ZGk=
X-Received: by 2002:a05:6830:1c24:: with SMTP id f4mr14521215ote.108.1608624064910;
 Tue, 22 Dec 2020 00:01:04 -0800 (PST)
MIME-Version: 1.0
References: <20201212091700.11776-1-ardb@kernel.org> <X+EbNj3HPZZ5ar1d@sol.localdomain>
In-Reply-To: <X+EbNj3HPZZ5ar1d@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 22 Dec 2020 09:00:54 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGUF-VxH6dYgvMqqnHmyOvbApfnbH=qNQqB7uxQh3jxkw@mail.gmail.com>
Message-ID: <CAMj1kXGUF-VxH6dYgvMqqnHmyOvbApfnbH=qNQqB7uxQh3jxkw@mail.gmail.com>
Subject: Re: [PATCH 0/4] crypto: gcm-aes-ni cleanups
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 21 Dec 2020 at 23:01, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Hi Ard,
>
> On Sat, Dec 12, 2020 at 10:16:56AM +0100, Ard Biesheuvel wrote:
> > Clean up some issues and peculiarities in the gcm(aes-ni) driver.
> >
> > Cc: Eric Biggers <ebiggers@google.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> >
> > Ard Biesheuvel (4):
> >   crypto: x86/gcm-aes-ni - prevent misaligned IV buffers on the stack
> >   crypto: x86/gcm-aes-ni - drop unused asm prototypes
> >   crypto: x86/gcm-aes-ni - clean up mapping of associated data
> >   crypto: x86/gcm-aes-ni - refactor scatterlist processing
> >
> >  arch/x86/crypto/aesni-intel_glue.c | 238 ++++++--------------
> >  1 file changed, 74 insertions(+), 164 deletions(-)
> >
>
> I get the following with this series applied:
>
> BUG: sleeping function called from invalid context at mm/page_alloc.c:4934
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 426, name: cryptomgr_test
> no locks held by cryptomgr_test/426.
> CPU: 0 PID: 426 Comm: cryptomgr_test Not tainted 5.10.0-12509-g8cc543a98aac #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.14.0-1 04/01/2014
> Call Trace:
>  show_stack+0x3d/0x3f arch/x86/kernel/dumpstack.c:318
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0xa4/0xd9 lib/dump_stack.c:120
>  ___might_sleep.cold+0x186/0x1b5 kernel/sched/core.c:7911
>  __might_sleep+0xa1/0x1a0 kernel/sched/core.c:7865
>  prepare_alloc_pages mm/page_alloc.c:4934 [inline]
>  __alloc_pages_nodemask+0x46f/0x6b0 mm/page_alloc.c:4978
>  alloc_pages_current+0x139/0x240 mm/mempolicy.c:2267
>  alloc_pages include/linux/gfp.h:547 [inline]
>  __get_free_pages+0x10/0xa0 mm/page_alloc.c:5031
>  skcipher_walk_next+0x736/0xd30 crypto/skcipher.c:370
>  skcipher_walk_first+0xc5/0x110 crypto/skcipher.c:445
>  skcipher_walk_aead_common+0x7f2/0xbe0 crypto/skcipher.c:544
>  skcipher_walk_aead_encrypt+0x6d/0xa0 crypto/skcipher.c:557
>  gcmaes_crypt_by_sg+0x3e2/0x740 arch/x86/crypto/aesni-intel_glue.c:655
>  gcmaes_encrypt+0xd2/0x260 arch/x86/crypto/aesni-intel_glue.c:694
>  helper_rfc4106_encrypt+0x213/0x4d0 arch/x86/crypto/aesni-intel_glue.c:755
>  crypto_aead_encrypt+0xf1/0x160 crypto/aead.c:94
...


Thanks for spotting that. Turns out the scatterwalk map/unmap of the
assoc data was keeping preemption disabled. I'll fix this in v2.
