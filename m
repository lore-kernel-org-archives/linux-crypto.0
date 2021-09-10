Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0447EC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 15:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB39B611EF
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 15:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbhIJP7D (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Sep 2021 11:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234521AbhIJP7C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Sep 2021 11:59:02 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59529C061574
        for <linux-crypto@vger.kernel.org>; Fri, 10 Sep 2021 08:57:51 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id d5so1667535pjx.2
        for <linux-crypto@vger.kernel.org>; Fri, 10 Sep 2021 08:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UTvvtVHrteGd251XFXm9mIN5SHrRU/KHRwCwVrW4feY=;
        b=hohEQy17MsjTHcQJTVbTa/vRat7+54H2eRrIm4Ri+iGofqjKsUZmb4RfyELBYWWjXg
         PeB6l/Bb2HQoP2+5Paui5YW+BfoCvtKMrO4TuoAp1hB0A/VEb1dfgkVb9S6jocCyp0aQ
         H/IeFG8VmJuR4RuuowUGBzlGtn/uZvFa63G6OUiZiKu4vLXyrjp73zTwapIIiOqs+Ym3
         ZmKMxaVHcyjGRt07osLFp13Brr2slMu+Y5Gldlg3SfemlHX4EXJIB/yDCYxVtS3ft31r
         aXNWrBeS3jlEccpt0K+bcRrT0CN+4Ugvug5oYtbfULDfOQqqfbzhtXOnEAoftiWzAB80
         YyjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UTvvtVHrteGd251XFXm9mIN5SHrRU/KHRwCwVrW4feY=;
        b=h/tQU592amkquz5d1pF97JNZzZ5PT1PvKUpgcvqP8EbwOFriNwarpH8+UnzBxfFKbn
         NyfxpuS1Kdr1kvJq+wQ8EceSAAu4nkvgiLmr7n4kGpahkvi8qrqcUU5XPl53ErBlv1+D
         9OesONSqjwdoPaPyN6sBBTnW+feFWhgvLABYEIOsManzIf7uL52kiNX9nHd87amix+Dc
         WYwAOrlea8kRe9+2/tmemBGyPHVXEsV554+UNZSbvah9OB6Xe29WtUaKmRH+AyiScVxR
         cJo4x3H2pqRj234PndVonp0OivKzoZVmrZyGWSpn8MOZvfjHkWgMJJO1qrdiYeDWDlrd
         08Gw==
X-Gm-Message-State: AOAM531r7Hfz7dH2kqbbPkPCYgz5jO9j7UeTksLiLH4M67KYe9qcg+nW
        EyAbusBf/DUoJspvMOJR+28=
X-Google-Smtp-Source: ABdhPJzT0i8JBl6LFZ9Yyd1FUTGAr4Sl9aclKFMBie7KVPbHNnHamK9QoL/ruUlmeTWiDYU5wptqwA==
X-Received: by 2002:a17:90b:164f:: with SMTP id il15mr10543956pjb.114.1631289470674;
        Fri, 10 Sep 2021 08:57:50 -0700 (PDT)
Received: from fedora ([2405:201:6008:6dd4:bc91:662d:ff8b:2008])
        by smtp.gmail.com with ESMTPSA id t13sm5321497pjg.25.2021.09.10.08.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 08:57:50 -0700 (PDT)
Date:   Fri, 10 Sep 2021 21:27:46 +0530
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [bug report] crypto: aesni - xts_crypt() return if walk.nbytes
 is 0
Message-ID: <YTuAerH3S78Xf1Jc@fedora>
References: <20210908125440.GA6147@kili>
 <YTt/uJjgy4jTr+GL@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTt/uJjgy4jTr+GL@fedora>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 10, 2021 at 09:24:37PM +0530, Shreyansh Chouhan wrote:
> Hi Dan,
> 
> Sorry for the delay in the response.
> 
> On Wed, Sep 08, 2021 at 03:54:40PM +0300, Dan Carpenter wrote:
> > Hello Shreyansh Chouhan,
> > 
> > The patch 72ff2bf04db2: "crypto: aesni - xts_crypt() return if
> > walk.nbytes is 0" from Aug 22, 2021, leads to the following
> > Smatch static checker warning:
> > 
> > 	arch/x86/crypto/aesni-intel_glue.c:915 xts_crypt()
> > 	warn: possible missing kernel_fpu_end()
> > 
> > arch/x86/crypto/aesni-intel_glue.c
> >     839 static int xts_crypt(struct skcipher_request *req, bool encrypt)
> >     840 {
> >     841         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> >     842         struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
> >     843         int tail = req->cryptlen % AES_BLOCK_SIZE;
> >     844         struct skcipher_request subreq;
> >     845         struct skcipher_walk walk;
> >     846         int err;
> >     847 
> >     848         if (req->cryptlen < AES_BLOCK_SIZE)
> >     849                 return -EINVAL;
> >     850 
> >     851         err = skcipher_walk_virt(&walk, req, false);
> >     852         if (!walk.nbytes)
> >     853                 return err;
> > 
> > The patch adds this check for "walk.nbytes == 0".
> > 
> >     854 
> >     855         if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
> >                                          ^^^^^^^^^^^^^^^^^^^^^^^^
> > But Smatch says that "walk.nbytes" can be set to zero inside this
> > if statement.
> > 
> 
> Indeed that is so, I missed it the first time around.
> 
> >     856                 int blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
> >     857 
> >     858                 skcipher_walk_abort(&walk);
> >     859 
> >     860                 skcipher_request_set_tfm(&subreq, tfm);
> >     861                 skcipher_request_set_callback(&subreq,
> >     862                                               skcipher_request_flags(req),
> >     863                                               NULL, NULL);
> >     864                 skcipher_request_set_crypt(&subreq, req->src, req->dst,
> >     865                                            blocks * AES_BLOCK_SIZE, req->iv);
> >     866                 req = &subreq;
> >     867 
> >     868                 err = skcipher_walk_virt(&walk, req, false);
> >     869                 if (err)
> >     870                         return err;
> 
> We can replace the above if (err) check with another if
> (!walk.nbytes) check.
> 
> >     871         } else {
> >     872                 tail = 0;
> >     873         }
> >     874 
> >     875         kernel_fpu_begin();
> >     876 
> >     877         /* calculate first value of T */
> >     878         aesni_enc(aes_ctx(ctx->raw_tweak_ctx), walk.iv, walk.iv);
> >     879 
> > 
> > Leading to not entering this loop and so we don't restore kernel_fpu_end().
> > 
> > So maybe the "if (walk.nbytes == 0)" check should be moved to right
> > before the call to kernel_fpu_begin()?
> > 
> 
> Instead of moving the first walk.nbytes check, I think we can have two if
> (!walk.nbytes) checks. There was a discussion between Herbert Xu and Ard
> Biesheuvel, and Herbert wrote in his email that most skcipher walkers are
> not supposed to explicitly check on the err value, and should instead
> terminate the loop whenever walk.nbytes is set to 0.
> 
> Here is a link to that discussion:
> 
> https://lore.kernel.org/linux-crypto/20210820125315.GB28484@gondor.apana.org.au/
> 

I can send in a patch that replaces the if (err) check with an if
(!walk.nbytes) check if that is fine with you.

> >     880         while (walk.nbytes > 0) {
> >     881                 int nbytes = walk.nbytes;
> >     882 
> >     883                 if (nbytes < walk.total)
> >     884                         nbytes &= ~(AES_BLOCK_SIZE - 1);
> >     885 
> >     886                 if (encrypt)
> >     887                         aesni_xts_encrypt(aes_ctx(ctx->raw_crypt_ctx),
> >     888                                           walk.dst.virt.addr, walk.src.virt.addr,
> >     889                                           nbytes, walk.iv);
> >     890                 else
> >     891                         aesni_xts_decrypt(aes_ctx(ctx->raw_crypt_ctx),
> >     892                                           walk.dst.virt.addr, walk.src.virt.addr,
> >     893                                           nbytes, walk.iv);
> >     894                 kernel_fpu_end();
> >     895 
> >     896                 err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
> >     897 
> >     898                 if (walk.nbytes > 0)
> >     899                         kernel_fpu_begin();
> >     900         }
> >     901 
> >     902         if (unlikely(tail > 0 && !err)) {
> >     903                 struct scatterlist sg_src[2], sg_dst[2];
> >     904                 struct scatterlist *src, *dst;
> >     905 
> >     906                 dst = src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
> >     907                 if (req->dst != req->src)
> >     908                         dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
> >     909 
> >     910                 skcipher_request_set_crypt(req, src, dst, AES_BLOCK_SIZE + tail,
> >     911                                            req->iv);
> >     912 
> >     913                 err = skcipher_walk_virt(&walk, &subreq, false);
> >     914                 if (err)
> > --> 915                         return err;
> >     916 
> >     917                 kernel_fpu_begin();
> >     918                 if (encrypt)
> >     919                         aesni_xts_encrypt(aes_ctx(ctx->raw_crypt_ctx),
> >     920                                           walk.dst.virt.addr, walk.src.virt.addr,
> >     921                                           walk.nbytes, walk.iv);
> >     922                 else
> >     923                         aesni_xts_decrypt(aes_ctx(ctx->raw_crypt_ctx),
> >     924                                           walk.dst.virt.addr, walk.src.virt.addr,
> >     925                                           walk.nbytes, walk.iv);
> >     926                 kernel_fpu_end();
> >     927 
> >     928                 err = skcipher_walk_done(&walk, 0);
> >     929         }
> >     930         return err;
> >     931 }
> > 
> > regards,
> > dan carpenter

Rehards,
Shreyansh Chouhan
