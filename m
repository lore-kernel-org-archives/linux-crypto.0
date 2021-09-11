Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 385B1C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Sep 2021 16:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B67861213
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Sep 2021 16:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhIKQY3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Sep 2021 12:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhIKQY3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Sep 2021 12:24:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF28261213
        for <linux-crypto@vger.kernel.org>; Sat, 11 Sep 2021 16:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631377396;
        bh=VqOaBCERbpWI9vajqJfGNcE4pvyCh1YLIghqkwHKzlQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HlqH0ukwEcZibon7gKqEfXB22+C0Cn+WBOLGQ/uVaPVovbrlcXyzVfWek8zje0rPd
         Cuzhr/CazsOFlvdCt6K1DD0PhC/Eub3ym64fGglfKN8Whl+uh7R1/OEQzufqP9GWnQ
         3lcXIsgnqDPF7jZENS/RrOnvvtxwIztPN8fhz42NgGwcIw01gjrWs8XLUbW/LWXDkw
         UH7Qxq6cTbNi/wAi5bEC6mqEg5Y0GMKliH2l6WG1c+YJjKRasqDcWwgy9CnFEQSTh1
         PnJL5d2U8aOy0HWY1VMHN3SnKVDkMIWIlHWY0Ka2uG2+Jygrnk8fn0oWbTNu+kGZ8y
         oEYmXmWBvTeLQ==
Received: by mail-oo1-f54.google.com with SMTP id k18-20020a4abd92000000b002915ed21fb8so1756296oop.11
        for <linux-crypto@vger.kernel.org>; Sat, 11 Sep 2021 09:23:16 -0700 (PDT)
X-Gm-Message-State: AOAM5302xcez0Tt9xEks9Rpspl7OOzyuQWYi/Fs6IXt46zmb+i78KSiF
        Wp+dA5MJY9GUJ1d8LJzig3oY2z05ypfiX1InPgU=
X-Google-Smtp-Source: ABdhPJwdhsHBXASHMSdjjbwPNUT1pyfO9yWX0rCoEUG0RUSv0E1PxZtmDp0+0CrcjRaLAOf4KJJZZtaYNtCs0ADxFc0=
X-Received: by 2002:a4a:c904:: with SMTP id v4mr2746691ooq.26.1631377396131;
 Sat, 11 Sep 2021 09:23:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210908125440.GA6147@kili> <YTt/uJjgy4jTr+GL@fedora>
 <YTuAerH3S78Xf1Jc@fedora> <20210911073232.GS1935@kadam>
In-Reply-To: <20210911073232.GS1935@kadam>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 11 Sep 2021 18:23:04 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGg_oQQ5qo5Tkq1K=62uWL-1S54VHeQ1BzXTWn81AhfSw@mail.gmail.com>
Message-ID: <CAMj1kXGg_oQQ5qo5Tkq1K=62uWL-1S54VHeQ1BzXTWn81AhfSw@mail.gmail.com>
Subject: Re: [bug report] crypto: aesni - xts_crypt() return if walk.nbytes is 0
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 11 Sept 2021 at 09:32, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Fri, Sep 10, 2021 at 09:27:46PM +0530, Shreyansh Chouhan wrote:
> > On Fri, Sep 10, 2021 at 09:24:37PM +0530, Shreyansh Chouhan wrote:
> > > Hi Dan,
> > >
> > > Sorry for the delay in the response.
> > >
> > > On Wed, Sep 08, 2021 at 03:54:40PM +0300, Dan Carpenter wrote:
> > > > Hello Shreyansh Chouhan,
> > > >
> > > > The patch 72ff2bf04db2: "crypto: aesni - xts_crypt() return if
> > > > walk.nbytes is 0" from Aug 22, 2021, leads to the following
> > > > Smatch static checker warning:
> > > >
> > > >   arch/x86/crypto/aesni-intel_glue.c:915 xts_crypt()
> > > >   warn: possible missing kernel_fpu_end()
> > > >
> > > > arch/x86/crypto/aesni-intel_glue.c
> > > >     839 static int xts_crypt(struct skcipher_request *req, bool encrypt)
> > > >     840 {
> > > >     841         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> > > >     842         struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
> > > >     843         int tail = req->cryptlen % AES_BLOCK_SIZE;
> > > >     844         struct skcipher_request subreq;
> > > >     845         struct skcipher_walk walk;
> > > >     846         int err;
> > > >     847
> > > >     848         if (req->cryptlen < AES_BLOCK_SIZE)
> > > >     849                 return -EINVAL;
> > > >     850
> > > >     851         err = skcipher_walk_virt(&walk, req, false);
> > > >     852         if (!walk.nbytes)
> > > >     853                 return err;
> > > >
> > > > The patch adds this check for "walk.nbytes == 0".
> > > >
> > > >     854
> > > >     855         if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
> > > >                                          ^^^^^^^^^^^^^^^^^^^^^^^^
> > > > But Smatch says that "walk.nbytes" can be set to zero inside this
> > > > if statement.
> > > >
> > >
> > > Indeed that is so, I missed it the first time around.
> > >
> > > >     856                 int blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
> > > >     857
> > > >     858                 skcipher_walk_abort(&walk);
> > > >     859
> > > >     860                 skcipher_request_set_tfm(&subreq, tfm);
> > > >     861                 skcipher_request_set_callback(&subreq,
> > > >     862                                               skcipher_request_flags(req),
> > > >     863                                               NULL, NULL);
> > > >     864                 skcipher_request_set_crypt(&subreq, req->src, req->dst,
> > > >     865                                            blocks * AES_BLOCK_SIZE, req->iv);
> > > >     866                 req = &subreq;
> > > >     867
> > > >     868                 err = skcipher_walk_virt(&walk, req, false);
> > > >     869                 if (err)
> > > >     870                         return err;
> > >
> > > We can replace the above if (err) check with another if
> > > (!walk.nbytes) check.
> > >
> > > >     871         } else {
> > > >     872                 tail = 0;
> > > >     873         }
> > > >     874
> > > >     875         kernel_fpu_begin();
> > > >     876
> > > >     877         /* calculate first value of T */
> > > >     878         aesni_enc(aes_ctx(ctx->raw_tweak_ctx), walk.iv, walk.iv);
> > > >     879
> > > >
> > > > Leading to not entering this loop and so we don't restore kernel_fpu_end().
> > > >
> > > > So maybe the "if (walk.nbytes == 0)" check should be moved to right
> > > > before the call to kernel_fpu_begin()?
> > > >
> > >
> > > Instead of moving the first walk.nbytes check, I think we can have two if
> > > (!walk.nbytes) checks. There was a discussion between Herbert Xu and Ard
> > > Biesheuvel, and Herbert wrote in his email that most skcipher walkers are
> > > not supposed to explicitly check on the err value, and should instead
> > > terminate the loop whenever walk.nbytes is set to 0.
> > >
> > > Here is a link to that discussion:
> > >
> > > https://lore.kernel.org/linux-crypto/20210820125315.GB28484@gondor.apana.org.au/
> > >
> >
> > I can send in a patch that replaces the if (err) check with an if
> > (!walk.nbytes) check if that is fine with you.
> >
>
> Yes, please!
>

Ehm, how would that patch be any different from the one that you sent
2+ weeks ago and which was already merged by Herbert and pulled by
Linus?

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=72ff2bf04db2a48840df93a461b7115900f46c05
