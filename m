Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E16C31E50
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 14:11:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5098206B7
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 14:11:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfFQOLD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 10:11:03 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36956 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfFQOLD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 10:11:03 -0400
Received: by mail-qk1-f195.google.com with SMTP id d15so6234032qkl.4;
        Mon, 17 Jun 2019 07:11:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SHlicgj5jJS/0b/2UM+41wnaHIVMnE9CKknJ2bXTQck=;
        b=ZZB6gvJIdX7HQLhTZk8FE3lse0JrUZtgKdHccGlsIijlysMOgTpMnBCjJ44osE2Wlz
         1R72w4V5k//Foy6n5A+1V+fcsvbcz8MA6/TacM5t+XsFlkbpEake1Qree0IB1hRDKYuM
         +mreJjhvfFe7dqvFS1K2Oi8MX/ozpsODbMFIFUUyW8OfR4FtzqQYTDY3iLmmN5xYqmY5
         QjPvkmd93+YdrQ4RB7l7mbtgScQq9tjGGvLRWOCi7KGS0vFnOsO+ffFOultPZ/4oXRc7
         ci0xGNRv6GUNzig+AdywH1BdZEViI9kND6bXwq+lBDVQDx3+fdTrBkk9qD42T6ov4oZo
         O58Q==
X-Gm-Message-State: APjAAAV4fq9IHUQPyjjxlrZN2odPxvz3yaT1Kwc2/gcUD3Xa/XdXEjpN
        whnKvUJYKVI6OhzxZD03R2+7Bvyx1zbHEMSPK3k=
X-Google-Smtp-Source: APXvYqz/zY9xPk2Jh05D8FoFALFOwZkRORfl1anNOl7AeYnHfAe4CMrSl7w7RmCl48n0kgwku7lRbyglucqe9iA2hqo=
X-Received: by 2002:a05:620a:10b2:: with SMTP id h18mr23908385qkk.14.1560780662046;
 Mon, 17 Jun 2019 07:11:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190617132343.2678836-1-arnd@arndb.de> <20190617140435.qjzcouaqzepaicf4@gondor.apana.org.au>
In-Reply-To: <20190617140435.qjzcouaqzepaicf4@gondor.apana.org.au>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 17 Jun 2019 16:10:44 +0200
Message-ID: <CAK8P3a07Vcqs+6Rs2Ckq_itWfGKUv+_pdgdis9eSujCGHQgFkQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: testmgr - reduce stack usage in fuzzers
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 17, 2019 at 4:04 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Jun 17, 2019 at 03:23:02PM +0200, Arnd Bergmann wrote:
> > On arm32, we get warnings about high stack usage in some of the functions:
> >
> > crypto/testmgr.c:2269:12: error: stack frame size of 1032 bytes in function 'alg_test_aead' [-Werror,-Wframe-larger-than=]
> > static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
> >            ^
> > crypto/testmgr.c:1693:12: error: stack frame size of 1312 bytes in function '__alg_test_hash' [-Werror,-Wframe-larger-than=]
> > static int __alg_test_hash(const struct hash_testvec *vecs,
> >            ^
> >
> > On of the larger objects on the stack here is struct testvec_config, so
> > change that to dynamic allocation.
> >
> > Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against their generic implementation")
> > Fixes: d435e10e67be ("crypto: testmgr - fuzz skciphers against their generic implementation")
> > Fixes: 9a8a6b3f0950 ("crypto: testmgr - fuzz hashes against their generic implementation")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > I only compile-tested this, and it's not completely trivial, so please
> > review carefully.
>
> These structures are not meant to be that big.  I suspect something
> has gone awry with the recent security conversions.
>
> Kees?

I should have mentioned above that this happened with clang but not gcc.

We used to not be able to test with clang and KASAN. I had done some of
those tests in the past, but that was before Kees' nice cleanup, so the
potential stack overflow would already happen but not detected by the
compiler.

Both gcc and clang add a redzone around each stack variable that gets
passed into an 'extern' variable. The difference here is that with clang, the
size of that redzone is proportional to the size of the object, while with gcc
it is constant.

In most cases, this ends up in favor of clang (concerning the stack
warning size limit) because most variables are small, but here we have
a large stack object (two objects for the hash fuzzing) with a large redzone.

         Arnd
