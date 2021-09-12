Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4653C433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Sep 2021 06:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75CE561076
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Sep 2021 06:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhILGqu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Sep 2021 02:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhILGqt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Sep 2021 02:46:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27BCC61076
        for <linux-crypto@vger.kernel.org>; Sun, 12 Sep 2021 06:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631429136;
        bh=t8JCM2hcLo4uV6LKqr8v2Q69dOsOZEON+XpsKgWA7Uc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ro62EyYnMwwBZKw9pbB+eLbCQaxTFuPMUsRg2nxoaOJeDEtFLC3thVHnearQ33fqW
         Qs6jwmTtCCFKai4Wxyc1k5s+EBi68XTfXuJCnmheRWjyLul3YWWgYzAc8zPFk27cmi
         ExWlSQ4qj8LEe3DAZbBYH2l8P7eNDif+OjMLOmMjL7YIacTRWmZQi4DnRh4GCg3UoQ
         On5KKdbVGsm6EEv4LXiOqKRxi56B4uAu68yoUL3e/8dR5AHjqIcgvddzI7c62hGQ1Z
         YN+7ygENDPbXkjLf3sRQRA2bFVd76TRSr8AUqek5tfowKcaPPIKPn0ok4BAHtnbdcX
         fnOXDdf9Uyv8Q==
Received: by mail-oi1-f175.google.com with SMTP id 6so9555353oiy.8
        for <linux-crypto@vger.kernel.org>; Sat, 11 Sep 2021 23:45:36 -0700 (PDT)
X-Gm-Message-State: AOAM53012TwKh/qCLFULq4vgVGUXeiBUx+tXMKvB/hwdQ2ipl21A6TJo
        vzjc2TyCyxemDkuytpitzyB0yLnrz4o0HNpt6sY=
X-Google-Smtp-Source: ABdhPJx0ZRfQO7TwZnRjgcy5MkH6op+aFYjg2jtUrF5zprLQCVVgKr5RCni7pt/uVcPZtWRjRv89UsB2LQVbHdA6GHk=
X-Received: by 2002:aca:eb97:: with SMTP id j145mr3808204oih.33.1631429135510;
 Sat, 11 Sep 2021 23:45:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210908125440.GA6147@kili> <YTt/uJjgy4jTr+GL@fedora>
 <YTuAerH3S78Xf1Jc@fedora> <20210911073232.GS1935@kadam> <CAMj1kXGg_oQQ5qo5Tkq1K=62uWL-1S54VHeQ1BzXTWn81AhfSw@mail.gmail.com>
 <YT2J8BOAXYY2lOIT@fedora>
In-Reply-To: <YT2J8BOAXYY2lOIT@fedora>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 12 Sep 2021 08:45:24 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHfXHc5K0sjt7_HM0=jAb9sHPqN_36KyfE6uDCnG6Sa9Q@mail.gmail.com>
Message-ID: <CAMj1kXHfXHc5K0sjt7_HM0=jAb9sHPqN_36KyfE6uDCnG6Sa9Q@mail.gmail.com>
Subject: Re: [bug report] crypto: aesni - xts_crypt() return if walk.nbytes is 0
To:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 12 Sept 2021 at 07:02, Shreyansh Chouhan
<chouhan.shreyansh630@gmail.com> wrote:
>
> On Sat, Sep 11, 2021 at 06:23:04PM +0200, Ard Biesheuvel wrote:
> > On Sat, 11 Sept 2021 at 09:32, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > >
> > > On Fri, Sep 10, 2021 at 09:27:46PM +0530, Shreyansh Chouhan wrote:
> > > > On Fri, Sep 10, 2021 at 09:24:37PM +0530, Shreyansh Chouhan wrote:
> > > > > Hi Dan,
> > > > >
> > > > > Sorry for the delay in the response.
> > > > >
> > > > > On Wed, Sep 08, 2021 at 03:54:40PM +0300, Dan Carpenter wrote:
> > > > > > Hello Shreyansh Chouhan,
> > > > > >
> > > > > > The patch 72ff2bf04db2: "crypto: aesni - xts_crypt() return if
> > > > > > walk.nbytes is 0" from Aug 22, 2021, leads to the following
> > > > > > Smatch static checker warning:
> > > > > >
> > > > > >   arch/x86/crypto/aesni-intel_glue.c:915 xts_crypt()
> > > > > >   warn: possible missing kernel_fpu_end()
> > > > > >
> > > > > > arch/x86/crypto/aesni-intel_glue.c
> > > > > >     839 static int xts_crypt(struct skcipher_request *req, bool encrypt)
> > > > > >     840 {
> > > > > >     841         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> > > > > >     842         struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
> > > > > >     843         int tail = req->cryptlen % AES_BLOCK_SIZE;
> > > > > >     844         struct skcipher_request subreq;
> > > > > >     845         struct skcipher_walk walk;
> > > > > >     846         int err;
> > > > > >     847
> > > > > >     848         if (req->cryptlen < AES_BLOCK_SIZE)
> > > > > >     849                 return -EINVAL;
> > > > > >     850
> > > > > >     851         err = skcipher_walk_virt(&walk, req, false);
> > > > > >     852         if (!walk.nbytes)
> > > > > >     853                 return err;
> > > > > >
> > > > > > The patch adds this check for "walk.nbytes == 0".
> > > > > >
> > > > > >     854
> > > > > >     855         if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
> > > > > >                                          ^^^^^^^^^^^^^^^^^^^^^^^^
> > > > > > But Smatch says that "walk.nbytes" can be set to zero inside this
> > > > > > if statement.
> > > > > >
> > > > >
> > > > > Indeed that is so, I missed it the first time around.
> > > > >
> > > > > >     856                 int blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
> > > > > >     857
> > > > > >     858                 skcipher_walk_abort(&walk);
> > > > > >     859
> > > > > >     860                 skcipher_request_set_tfm(&subreq, tfm);
> > > > > >     861                 skcipher_request_set_callback(&subreq,
> > > > > >     862                                               skcipher_request_flags(req),
> > > > > >     863                                               NULL, NULL);
> > > > > >     864                 skcipher_request_set_crypt(&subreq, req->src, req->dst,
> > > > > >     865                                            blocks * AES_BLOCK_SIZE, req->iv);
> > > > > >     866                 req = &subreq;
> > > > > >     867
> > > > > >     868                 err = skcipher_walk_virt(&walk, req, false);
> > > > > >     869                 if (err)
> > > > > >     870                         return err;
> > > > >
> > > > > We can replace the above if (err) check with another if
> > > > > (!walk.nbytes) check.
> > > > >
> > > > > >     871         } else {
> > > > > >     872                 tail = 0;
> > > > > >     873         }
> > > > > >     874
> > > > > >     875         kernel_fpu_begin();
> > > > > >     876
> > > > > >     877         /* calculate first value of T */
> > > > > >     878         aesni_enc(aes_ctx(ctx->raw_tweak_ctx), walk.iv, walk.iv);
> > > > > >     879
> > > > > >
> > > > > > Leading to not entering this loop and so we don't restore kernel_fpu_end().
> > > > > >
> > > > > > So maybe the "if (walk.nbytes == 0)" check should be moved to right
> > > > > > before the call to kernel_fpu_begin()?
> > > > > >
> > > > >
> > > > > Instead of moving the first walk.nbytes check, I think we can have two if
> > > > > (!walk.nbytes) checks. There was a discussion between Herbert Xu and Ard
> > > > > Biesheuvel, and Herbert wrote in his email that most skcipher walkers are
> > > > > not supposed to explicitly check on the err value, and should instead
> > > > > terminate the loop whenever walk.nbytes is set to 0.
> > > > >
> > > > > Here is a link to that discussion:
> > > > >
> > > > > https://lore.kernel.org/linux-crypto/20210820125315.GB28484@gondor.apana.org.au/
> > > > >
> > > >
> > > > I can send in a patch that replaces the if (err) check with an if
> > > > (!walk.nbytes) check if that is fine with you.
> > > >
> > >
> > > Yes, please!
> > >
> >
> > Ehm, how would that patch be any different from the one that you sent
> > 2+ weeks ago and which was already merged by Herbert and pulled by
> > Linus?
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=72ff2bf04db2a48840df93a461b7115900f46c05
>
> The previous patch that I sent adds a walk.nbytes after the
> skcipher_walk_virt() call at line 851[1] in the code. There is another
> call to skcipher_walk_virt() before we call kernel_fpu_begin(), at line
> 868[2], this patch adds a walk.nbytes check after that function call.
>

Ah, ok. Thanks for pointing that out.

So while the first occurrence can actually be triggered by fuzzing
(even though having zero length inputs does not make sense for a
skcipher invocation), this second occurrence can only be triggered if
the request changes size under our feet, i.e., from >0 to 0.

I'll leave it up to Herbert to decide if we want to make this change
anyway, but IMO, we don't need it.
