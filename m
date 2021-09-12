Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA031C433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Sep 2021 05:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B868F61051
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Sep 2021 05:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhILFD7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Sep 2021 01:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhILFD6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Sep 2021 01:03:58 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AF0C061574
        for <linux-crypto@vger.kernel.org>; Sat, 11 Sep 2021 22:02:45 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id w19-20020a17090aaf9300b00191e6d10a19so4199525pjq.1
        for <linux-crypto@vger.kernel.org>; Sat, 11 Sep 2021 22:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e0GuwURpQZear0LEdMS3FgduwclkDlTEZUwrMQGSmcI=;
        b=dhbZuaHyISF6sg7FjUJmUroRbRSuNbDd4wKJ7EP1BCpVDYexzgf1jcS1qi1B0SdcJu
         hb+wzBbESgNwl+bk4jO+sD0bQIMIaPARDliEWpFO2so0BWsKnGr4AHe7QvgfOk5wZRLW
         HSN7xLiPM/L+GAQusE/vrw45QfUqbrKFtdlB92uUpKdLou6HAakVEhV7t1QyL43klbV0
         CtLd506YFR85nacWfl9WBUNDINqYiXyMH/EUmF2g0AuVg3wQ/J42Nn5P9xZGzHDfeRIl
         gGW8Nmrd09/xT34WW5DOQSxQCU5p7kdA8dFYp6pGHyWpPPNrE0qhUC71RHkmlRhfzEtA
         27Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e0GuwURpQZear0LEdMS3FgduwclkDlTEZUwrMQGSmcI=;
        b=OyeTnL0xMTrHL+rzNcmI2Y7OPBjFmC96Nn/1z9U079cFZLKP3VkDlrQSNSLGK+jM0j
         HQGB+eLLGYC6xvg1kexugomKxutdhOXhXVAUlAP6Mb9Jomp8dG6XLSWAnIsr6RV03aaC
         8C5egeN5fL0v23kWFxNnVq0SAgquWIYYuHwcj1/lOEFiqZDmRMjz9IMHB2klXKtHIoZI
         P7oTcClP5XcIts3OZicbwthLxeAovOfK8i8VexJj6NcbmA4V/52PudvwqqdxSQqJ9eOZ
         53vqbWNbNmPxcBNqdQC3twKEIONahiG3evbDAUQuBjy4/dS/PEbVA+R8n/9gNCU23ZD8
         FQlw==
X-Gm-Message-State: AOAM5333s2HF6D/YyQ/bAuCaOMR1PeR8ucvjaYoXyEoAj5fFlRwTuXzn
        4DffPKcfYcOFSN6UGK3RMSvv9ldYlWw/IA==
X-Google-Smtp-Source: ABdhPJy1io71dDFhaBl4qYztHYxuwokOrjixVsbwoO57pMHhgly9mr/0yFs0ktErHNHjbE/QAzbvEw==
X-Received: by 2002:a17:902:680d:b0:13a:503f:f381 with SMTP id h13-20020a170902680d00b0013a503ff381mr4915506plk.30.1631422964701;
        Sat, 11 Sep 2021 22:02:44 -0700 (PDT)
Received: from fedora ([2405:201:6008:6f15:d26f:133e:cd11:90dd])
        by smtp.gmail.com with ESMTPSA id 77sm3105959pfz.118.2021.09.11.22.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 22:02:44 -0700 (PDT)
Date:   Sun, 12 Sep 2021 10:32:40 +0530
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [bug report] crypto: aesni - xts_crypt() return if walk.nbytes
 is 0
Message-ID: <YT2J8BOAXYY2lOIT@fedora>
References: <20210908125440.GA6147@kili>
 <YTt/uJjgy4jTr+GL@fedora>
 <YTuAerH3S78Xf1Jc@fedora>
 <20210911073232.GS1935@kadam>
 <CAMj1kXGg_oQQ5qo5Tkq1K=62uWL-1S54VHeQ1BzXTWn81AhfSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGg_oQQ5qo5Tkq1K=62uWL-1S54VHeQ1BzXTWn81AhfSw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Sep 11, 2021 at 06:23:04PM +0200, Ard Biesheuvel wrote:
> On Sat, 11 Sept 2021 at 09:32, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >
> > On Fri, Sep 10, 2021 at 09:27:46PM +0530, Shreyansh Chouhan wrote:
> > > On Fri, Sep 10, 2021 at 09:24:37PM +0530, Shreyansh Chouhan wrote:
> > > > Hi Dan,
> > > >
> > > > Sorry for the delay in the response.
> > > >
> > > > On Wed, Sep 08, 2021 at 03:54:40PM +0300, Dan Carpenter wrote:
> > > > > Hello Shreyansh Chouhan,
> > > > >
> > > > > The patch 72ff2bf04db2: "crypto: aesni - xts_crypt() return if
> > > > > walk.nbytes is 0" from Aug 22, 2021, leads to the following
> > > > > Smatch static checker warning:
> > > > >
> > > > >   arch/x86/crypto/aesni-intel_glue.c:915 xts_crypt()
> > > > >   warn: possible missing kernel_fpu_end()
> > > > >
> > > > > arch/x86/crypto/aesni-intel_glue.c
> > > > >     839 static int xts_crypt(struct skcipher_request *req, bool encrypt)
> > > > >     840 {
> > > > >     841         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> > > > >     842         struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
> > > > >     843         int tail = req->cryptlen % AES_BLOCK_SIZE;
> > > > >     844         struct skcipher_request subreq;
> > > > >     845         struct skcipher_walk walk;
> > > > >     846         int err;
> > > > >     847
> > > > >     848         if (req->cryptlen < AES_BLOCK_SIZE)
> > > > >     849                 return -EINVAL;
> > > > >     850
> > > > >     851         err = skcipher_walk_virt(&walk, req, false);
> > > > >     852         if (!walk.nbytes)
> > > > >     853                 return err;
> > > > >
> > > > > The patch adds this check for "walk.nbytes == 0".
> > > > >
> > > > >     854
> > > > >     855         if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
> > > > >                                          ^^^^^^^^^^^^^^^^^^^^^^^^
> > > > > But Smatch says that "walk.nbytes" can be set to zero inside this
> > > > > if statement.
> > > > >
> > > >
> > > > Indeed that is so, I missed it the first time around.
> > > >
> > > > >     856                 int blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
> > > > >     857
> > > > >     858                 skcipher_walk_abort(&walk);
> > > > >     859
> > > > >     860                 skcipher_request_set_tfm(&subreq, tfm);
> > > > >     861                 skcipher_request_set_callback(&subreq,
> > > > >     862                                               skcipher_request_flags(req),
> > > > >     863                                               NULL, NULL);
> > > > >     864                 skcipher_request_set_crypt(&subreq, req->src, req->dst,
> > > > >     865                                            blocks * AES_BLOCK_SIZE, req->iv);
> > > > >     866                 req = &subreq;
> > > > >     867
> > > > >     868                 err = skcipher_walk_virt(&walk, req, false);
> > > > >     869                 if (err)
> > > > >     870                         return err;
> > > >
> > > > We can replace the above if (err) check with another if
> > > > (!walk.nbytes) check.
> > > >
> > > > >     871         } else {
> > > > >     872                 tail = 0;
> > > > >     873         }
> > > > >     874
> > > > >     875         kernel_fpu_begin();
> > > > >     876
> > > > >     877         /* calculate first value of T */
> > > > >     878         aesni_enc(aes_ctx(ctx->raw_tweak_ctx), walk.iv, walk.iv);
> > > > >     879
> > > > >
> > > > > Leading to not entering this loop and so we don't restore kernel_fpu_end().
> > > > >
> > > > > So maybe the "if (walk.nbytes == 0)" check should be moved to right
> > > > > before the call to kernel_fpu_begin()?
> > > > >
> > > >
> > > > Instead of moving the first walk.nbytes check, I think we can have two if
> > > > (!walk.nbytes) checks. There was a discussion between Herbert Xu and Ard
> > > > Biesheuvel, and Herbert wrote in his email that most skcipher walkers are
> > > > not supposed to explicitly check on the err value, and should instead
> > > > terminate the loop whenever walk.nbytes is set to 0.
> > > >
> > > > Here is a link to that discussion:
> > > >
> > > > https://lore.kernel.org/linux-crypto/20210820125315.GB28484@gondor.apana.org.au/
> > > >
> > >
> > > I can send in a patch that replaces the if (err) check with an if
> > > (!walk.nbytes) check if that is fine with you.
> > >
> >
> > Yes, please!
> >
> 
> Ehm, how would that patch be any different from the one that you sent
> 2+ weeks ago and which was already merged by Herbert and pulled by
> Linus?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=72ff2bf04db2a48840df93a461b7115900f46c05

The previous patch that I sent adds a walk.nbytes after the
skcipher_walk_virt() call at line 851[1] in the code. There is another
call to skcipher_walk_virt() before we call kernel_fpu_begin(), at line
868[2], this patch adds a walk.nbytes check after that function call.

Regards,
Shreyansh Chouhan

--
[1] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/arch/x86/crypto/aesni-intel_glue.c#n851
[2] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/arch/x86/crypto/aesni-intel_glue.c#n868
