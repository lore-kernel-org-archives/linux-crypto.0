Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E3EC433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 05:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1F96206C2
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 05:18:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w5qmuoq9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfHMFSK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Aug 2019 01:18:10 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39828 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfHMFSK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Aug 2019 01:18:10 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so16405754wra.6
        for <linux-crypto@vger.kernel.org>; Mon, 12 Aug 2019 22:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=vjknMuAeSc0x7oeuMDtq2tLSIl2orQ+1iduGgKWbGiw=;
        b=w5qmuoq9X3Ml79Oe1T1zepUjvQjsv5b3F4f3sRbDxivdoqN+9fmOkhtVxNVieqI/V0
         1UwDPWvUG7SLBcRYLtyKb5wdQ6jb2GAkmuCqCks4MLYK/Nht/6Yxrqzr5ugKIz7Jk2X0
         J3H8XX512BzYf9tbFQhBoOz1DxSRardaf5QQPj3bYPEd6Q8q28AV24jQy+Th02Mt4Hb5
         oSBrKROm9BjZy1kuqABp6BKAHYiQWwZSwCb2ERMycX5krB8CBagv6coSo2nB6bAJKlJc
         UxY6mxBtdJdWdgBWzIbiy51QIrnyTWxqrXwrmrzenSgkfWTlRJ5guihgG8C5I2lfnSeA
         JuBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=vjknMuAeSc0x7oeuMDtq2tLSIl2orQ+1iduGgKWbGiw=;
        b=h+1U6mRuKxzdr8/XPW5RvvxR9Xy3beEUlg56tqZ3hPvGOhho8+fqiYbBhqTO7dC1G/
         gR4astMmGC32ab/AaRumDsfbzgQQMUpiXMBP3sx/9vv1DTLNuNVzR7elbOl+YrkrTR6P
         kYsrBcHI6+e2ATPpKqmmwhztz01kTkU2dS54uhiu8SF3OX1/Jc8FamDqgj+VPW8f9BM8
         H2QKQKlgaLsGVWpTTRTuuQtu4HVwCHDyEMzMDRrtxjKEHZ5EhQKNi/0Bngtd/VIc0Nl6
         9clk6JmLOi5qcQjEEBTBhBcOLCGAwX2MLZ/X0pGv8V4SbA23opd1ctgrIBPT1DnpiC9B
         YfMg==
X-Gm-Message-State: APjAAAX9/Hy4ZbE223xL/RhQEprBuVKOUgiYdCVEo2RtXJBcjmkkXsmM
        Jd6IuGCLPU/tM0ZKo89t2ChWHRzW+O75zcsIx4+8Sg==
X-Google-Smtp-Source: APXvYqyT1D3REzaL959a3ymyuxK4owGKfnAIBTa58BY2l3RptzUHdepEU1bThGxSjSVPCPLqjkiSL+3E6lYeF4pkbOM=
X-Received: by 2002:a5d:6b07:: with SMTP id v7mr33607676wrw.169.1565673487792;
 Mon, 12 Aug 2019 22:18:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190812145324.27090-1-ard.biesheuvel@linaro.org>
 <20190812145324.27090-2-ard.biesheuvel@linaro.org> <20190812193849.GA131059@gmail.com>
In-Reply-To: <20190812193849.GA131059@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 13 Aug 2019 08:17:56 +0300
Message-ID: <CAKv+Gu-Nk0tMST32d3cwuiwGmZmXgKRDd2h9BuW-iPeoqSN5tA@mail.gmail.com>
Subject: Re: [PATCH v10 1/7] crypto: essiv - create wrapper template for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 12 Aug 2019 at 22:38, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Aug 12, 2019 at 05:53:18PM +0300, Ard Biesheuvel wrote:
> > +     switch (type) {
> > +     case CRYPTO_ALG_TYPE_BLKCIPHER:
> > +             skcipher_inst = kzalloc(sizeof(*skcipher_inst) +
> > +                                     sizeof(*ictx), GFP_KERNEL);
> > +             if (!skcipher_inst)
> > +                     return -ENOMEM;
> > +             inst = skcipher_crypto_instance(skcipher_inst);
> > +             base = &skcipher_inst->alg.base;
> > +             ictx = crypto_instance_ctx(inst);
> > +
> > +             /* Block cipher, e.g. "cbc(aes)" */
> > +             crypto_set_skcipher_spawn(&ictx->u.skcipher_spawn, inst);
> > +             err = crypto_grab_skcipher(&ictx->u.skcipher_spawn,
> > +                                        inner_cipher_name, 0,
> > +                                        crypto_requires_sync(algt->type,
> > +                                                             algt->mask));
> > +             if (err)
> > +                     goto out_free_inst;
>
> This should say "Symmetric cipher", not "Block cipher".
>
> > +
> > +     if (!parse_cipher_name(essiv_cipher_name, block_base->cra_name)) {
> > +             pr_warn("Failed to parse ESSIV cipher name from skcipher cra_name\n");
> > +             goto out_drop_skcipher;
> > +     }
>
> This is missing:
>
>                 err = -EINVAL;
>
> > +     if (type == CRYPTO_ALG_TYPE_BLKCIPHER) {
> > +             skcipher_inst->alg.setkey       = essiv_skcipher_setkey;
> > +             skcipher_inst->alg.encrypt      = essiv_skcipher_encrypt;
> > +             skcipher_inst->alg.decrypt      = essiv_skcipher_decrypt;
> > +             skcipher_inst->alg.init         = essiv_skcipher_init_tfm;
> > +             skcipher_inst->alg.exit         = essiv_skcipher_exit_tfm;
> > +
> > +             skcipher_inst->alg.min_keysize  = crypto_skcipher_alg_min_keysize(skcipher_alg);
> > +             skcipher_inst->alg.max_keysize  = crypto_skcipher_alg_max_keysize(skcipher_alg);
> > +             skcipher_inst->alg.ivsize       = crypto_skcipher_alg_ivsize(skcipher_alg);
> > +             skcipher_inst->alg.chunksize    = crypto_skcipher_alg_chunksize(skcipher_alg);
> > +             skcipher_inst->alg.walksize     = crypto_skcipher_alg_walksize(skcipher_alg);
> > +
> > +             skcipher_inst->free             = essiv_skcipher_free_instance;
> > +
> > +             err = skcipher_register_instance(tmpl, skcipher_inst);
> > +     } else {
> > +             aead_inst->alg.setkey           = essiv_aead_setkey;
> > +             aead_inst->alg.setauthsize      = essiv_aead_setauthsize;
> > +             aead_inst->alg.encrypt          = essiv_aead_encrypt;
> > +             aead_inst->alg.decrypt          = essiv_aead_decrypt;
> > +             aead_inst->alg.init             = essiv_aead_init_tfm;
> > +             aead_inst->alg.exit             = essiv_aead_exit_tfm;
> > +
> > +             aead_inst->alg.ivsize           = crypto_aead_alg_ivsize(aead_alg);
> > +             aead_inst->alg.maxauthsize      = crypto_aead_alg_maxauthsize(aead_alg);
> > +             aead_inst->alg.chunksize        = crypto_aead_alg_chunksize(aead_alg);
> > +
> > +             aead_inst->free                 = essiv_aead_free_instance;
> > +
> > +             err = aead_register_instance(tmpl, aead_inst);
> > +     }
>
> 'ivsize' is already in a variable, so could use
>
>                 skcipher_inst->alg.ivsize       = ivsize;
>
>         and
>                 aead_inst->alg.ivsize           = ivsize;
>

Thanks Eric. These will all be fixed in the next respin.
