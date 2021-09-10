Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B165C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 15:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B8FA610C8
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 15:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhIJPzt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Sep 2021 11:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbhIJPzs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Sep 2021 11:55:48 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6CEC061574
        for <linux-crypto@vger.kernel.org>; Fri, 10 Sep 2021 08:54:37 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id dw14so759266pjb.1
        for <linux-crypto@vger.kernel.org>; Fri, 10 Sep 2021 08:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=idsgB4HBLuucPyGPGkGWF3H82fOlUOyVYsM8hqMpxuE=;
        b=CfEqVr3+Lpn71kFRhMGlK6eiShkvPs8fVKbHrCM5MKDEHuA5xqx7teFKu5LM1mEnlM
         mh6KfLpTInZpSPR0SVvS6sN/2mVX2w02rl7cyfx5fP5UE+MsIYrxz7aAQXt6e1z+BYfv
         yT2+wM3riI0pbe5yTHRaqHpL+WF1XXkljc6sO5oMnBsehF+ET1EuzRq+CBZIoJ4iT5J2
         bJc2d1ii8EmZ6ed/R6M4nezc+4XMHl5iJ6e2ysCB21uP2IVUuNWiiB+pt7DxUzvH6YaZ
         cvB9PuBzfnB5QRfnvPeCtbqDbjbI8sy2bSttG2TNCnJCUWgohcF71qfrVRdCCcdtdL3/
         pMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=idsgB4HBLuucPyGPGkGWF3H82fOlUOyVYsM8hqMpxuE=;
        b=VdTWBNcVKKexxSITH5mQhW6sIo7FBGuSE7mP5JDPnd68YKhuTNVG5BIsjbMtW6oEhN
         b+VY41dr/GeWjNyTj28txD9hoZhkb4WpIaU1JPj+qi/LZxPCgEA3mpBAJx43XFWO9eZZ
         00bs48iNqQ1HOyp7Sqz++Qb2gP10XrvtsyRuFHHgRa5HCkwgb6KAZBFrK2LbQeH/JIZR
         QRUWpA7COGxn0NkhcdwfcF7DLu2HwqrnRNzt7mBTIX7r83ogIIk/OSB7AGU3egtzTW+W
         9ONf6Xp2QCf/fGIv/AFg/0Ldh3bz79zXg6UWn0EKm69aZ3oW0wcsSHMebbpYgjdWxa57
         ELJQ==
X-Gm-Message-State: AOAM531aPLNNMCbE0ErYaH/h0TYXWysyaq3Y2kK464V4EAG55C8sEhUD
        be9sMrCUaL6xeKPNBxZ5vBE=
X-Google-Smtp-Source: ABdhPJwRjbYSMTG47TGAgsfZGt05d5Iv9ftX9Zjj3rbKTyzDiHgmxmQZdn1+C+7C1xBjbxantJswjg==
X-Received: by 2002:a17:902:7c05:b0:13b:6673:b370 with SMTP id x5-20020a1709027c0500b0013b6673b370mr3004214pll.52.1631289276699;
        Fri, 10 Sep 2021 08:54:36 -0700 (PDT)
Received: from fedora ([2405:201:6008:6dd4:bc91:662d:ff8b:2008])
        by smtp.gmail.com with ESMTPSA id cq8sm5179001pjb.31.2021.09.10.08.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 08:54:36 -0700 (PDT)
Date:   Fri, 10 Sep 2021 21:24:32 +0530
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [bug report] crypto: aesni - xts_crypt() return if walk.nbytes
 is 0
Message-ID: <YTt/uJjgy4jTr+GL@fedora>
References: <20210908125440.GA6147@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908125440.GA6147@kili>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Dan,

Sorry for the delay in the response.

On Wed, Sep 08, 2021 at 03:54:40PM +0300, Dan Carpenter wrote:
> Hello Shreyansh Chouhan,
> 
> The patch 72ff2bf04db2: "crypto: aesni - xts_crypt() return if
> walk.nbytes is 0" from Aug 22, 2021, leads to the following
> Smatch static checker warning:
> 
> 	arch/x86/crypto/aesni-intel_glue.c:915 xts_crypt()
> 	warn: possible missing kernel_fpu_end()
> 
> arch/x86/crypto/aesni-intel_glue.c
>     839 static int xts_crypt(struct skcipher_request *req, bool encrypt)
>     840 {
>     841         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>     842         struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
>     843         int tail = req->cryptlen % AES_BLOCK_SIZE;
>     844         struct skcipher_request subreq;
>     845         struct skcipher_walk walk;
>     846         int err;
>     847 
>     848         if (req->cryptlen < AES_BLOCK_SIZE)
>     849                 return -EINVAL;
>     850 
>     851         err = skcipher_walk_virt(&walk, req, false);
>     852         if (!walk.nbytes)
>     853                 return err;
> 
> The patch adds this check for "walk.nbytes == 0".
> 
>     854 
>     855         if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
>                                          ^^^^^^^^^^^^^^^^^^^^^^^^
> But Smatch says that "walk.nbytes" can be set to zero inside this
> if statement.
> 

Indeed that is so, I missed it the first time around.

>     856                 int blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
>     857 
>     858                 skcipher_walk_abort(&walk);
>     859 
>     860                 skcipher_request_set_tfm(&subreq, tfm);
>     861                 skcipher_request_set_callback(&subreq,
>     862                                               skcipher_request_flags(req),
>     863                                               NULL, NULL);
>     864                 skcipher_request_set_crypt(&subreq, req->src, req->dst,
>     865                                            blocks * AES_BLOCK_SIZE, req->iv);
>     866                 req = &subreq;
>     867 
>     868                 err = skcipher_walk_virt(&walk, req, false);
>     869                 if (err)
>     870                         return err;

We can replace the above if (err) check with another if
(!walk.nbytes) check.

>     871         } else {
>     872                 tail = 0;
>     873         }
>     874 
>     875         kernel_fpu_begin();
>     876 
>     877         /* calculate first value of T */
>     878         aesni_enc(aes_ctx(ctx->raw_tweak_ctx), walk.iv, walk.iv);
>     879 
> 
> Leading to not entering this loop and so we don't restore kernel_fpu_end().
> 
> So maybe the "if (walk.nbytes == 0)" check should be moved to right
> before the call to kernel_fpu_begin()?
> 

Instead of moving the first walk.nbytes check, I think we can have two if
(!walk.nbytes) checks. There was a discussion between Herbert Xu and Ard
Biesheuvel, and Herbert wrote in his email that most skcipher walkers are
not supposed to explicitly check on the err value, and should instead
terminate the loop whenever walk.nbytes is set to 0.

Here is a link to that discussion:

https://lore.kernel.org/linux-crypto/20210820125315.GB28484@gondor.apana.org.au/

>     880         while (walk.nbytes > 0) {
>     881                 int nbytes = walk.nbytes;
>     882 
>     883                 if (nbytes < walk.total)
>     884                         nbytes &= ~(AES_BLOCK_SIZE - 1);
>     885 
>     886                 if (encrypt)
>     887                         aesni_xts_encrypt(aes_ctx(ctx->raw_crypt_ctx),
>     888                                           walk.dst.virt.addr, walk.src.virt.addr,
>     889                                           nbytes, walk.iv);
>     890                 else
>     891                         aesni_xts_decrypt(aes_ctx(ctx->raw_crypt_ctx),
>     892                                           walk.dst.virt.addr, walk.src.virt.addr,
>     893                                           nbytes, walk.iv);
>     894                 kernel_fpu_end();
>     895 
>     896                 err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
>     897 
>     898                 if (walk.nbytes > 0)
>     899                         kernel_fpu_begin();
>     900         }
>     901 
>     902         if (unlikely(tail > 0 && !err)) {
>     903                 struct scatterlist sg_src[2], sg_dst[2];
>     904                 struct scatterlist *src, *dst;
>     905 
>     906                 dst = src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
>     907                 if (req->dst != req->src)
>     908                         dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
>     909 
>     910                 skcipher_request_set_crypt(req, src, dst, AES_BLOCK_SIZE + tail,
>     911                                            req->iv);
>     912 
>     913                 err = skcipher_walk_virt(&walk, &subreq, false);
>     914                 if (err)
> --> 915                         return err;
>     916 
>     917                 kernel_fpu_begin();
>     918                 if (encrypt)
>     919                         aesni_xts_encrypt(aes_ctx(ctx->raw_crypt_ctx),
>     920                                           walk.dst.virt.addr, walk.src.virt.addr,
>     921                                           walk.nbytes, walk.iv);
>     922                 else
>     923                         aesni_xts_decrypt(aes_ctx(ctx->raw_crypt_ctx),
>     924                                           walk.dst.virt.addr, walk.src.virt.addr,
>     925                                           walk.nbytes, walk.iv);
>     926                 kernel_fpu_end();
>     927 
>     928                 err = skcipher_walk_done(&walk, 0);
>     929         }
>     930         return err;
>     931 }
> 
> regards,
> dan carpenter
